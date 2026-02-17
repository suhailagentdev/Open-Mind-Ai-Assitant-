# Architecture Overview

This document describes the high-level architecture of OpenMind — what the major components are, how they interact, and why key decisions were made.

---

## Philosophy

OpenMind is designed around three core principles:

1. **Privacy by architecture** — no backend means no data leakage by design
2. **Zero-dependency production** — no npm packages in the production build
3. **Hackability** — every layer is understandable and replaceable

---

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         BROWSER (Client Only)                        │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                     OpenMind Application                     │    │
│  │                                                               │    │
│  │   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │    │
│  │   │  UI Layer │  │  Core   │  │ Plugin   │  │ Storage  │  │    │
│  │   │ chat.js   │  │engine.js│  │registry  │  │ store.js │  │    │
│  │   │sidebar.js │  │session  │  │ plugins/ │  │localStorage│ │    │
│  │   │markdown.js│  │events.js│  │          │  │sessionStr│  │    │
│  │   └─────┬─────┘  └────┬────┘  └────┬─────┘  └──────────┘  │    │
│  │         │              │            │                         │    │
│  │         └──────────────┼────────────┘                        │    │
│  │                        │                                       │    │
│  │                ┌───────▼────────┐                             │    │
│  │                │   API Client   │                             │    │
│  │                │   client.js    │                             │    │
│  │                │  streaming.js  │                             │    │
│  │                └───────┬────────┘                             │    │
│  └────────────────────────┼────────────────────────────────────┘    │
│                            │ HTTPS                                     │
└────────────────────────────┼─────────────────────────────────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  api.anthropic.com   │
                  │   /v1/messages       │
                  └──────────────────────┘
```

There is **no OpenMind server**. The browser communicates directly with Anthropic's API.

---

## Module Breakdown

### `src/core/engine.js` — Application Bootstrap

The entry point and global state container.

**Responsibilities:**
- Initialize all subsystems on page load
- Hold global application state (current session, config, stats)
- Coordinate between modules via the event bus

**State:**
```javascript
{
  apiKey: string | null,      // From sessionStorage
  currentModel: string,       // Active Claude model
  sessions: Session[],        // All conversation sessions
  activeSession: Session | null,
  config: UserConfig,
  globalStats: Stats,
  plugins: Plugin[],
  memories: string[],
}
```

---

### `src/core/session.js` — Session Management

Manages conversation sessions — creation, loading, persistence, and deletion.

**Session data model:**
```javascript
{
  id: string,              // 'sess_' + timestamp
  title: string,           // Auto-generated from first message
  createdAt: number,       // Unix timestamp
  updatedAt: number,
  messages: Message[],
  systemPrompt: string,    // Per-session system prompt
  model: string,           // Model used for this session
}
```

**Persistence:** Sessions are serialized to JSON and stored in `localStorage` under the key `om_sessions`. Only the 50 most recent sessions are retained to manage storage limits.

---

### `src/api/client.js` — Claude API Client

Handles all communication with the Anthropic API.

**Key responsibilities:**
- Construct API request payloads
- Handle authentication headers
- Parse responses
- Error handling and retries (with exponential backoff)

**Request construction:**
```javascript
{
  model: string,
  max_tokens: number,
  temperature: number,
  top_p: number,
  system: string,     // System prompt + memory context
  messages: [         // Full conversation history
    { role: 'user', content: string },
    { role: 'assistant', content: string },
    ...
  ]
}
```

**Memory injection:** Memories are appended to the system prompt as:
```
[User memories: fact 1; fact 2; fact 3]
```

---

### `src/api/streaming.js` — SSE Streaming Handler

Handles Server-Sent Events (SSE) streaming from the API for real-time response rendering.

**Flow:**
1. Initiate `fetch()` with `stream: true`
2. Read `ReadableStream` from response body
3. Parse `text/event-stream` chunks
4. Extract `content_block_delta` events
5. Append delta text to the DOM in real time

```javascript
// Simplified streaming flow
const response = await fetch('/v1/messages', { body, method: 'POST' });
const reader = response.body.getReader();
const decoder = new TextDecoder();

while (true) {
  const { done, value } = await reader.read();
  if (done) break;

  const chunk = decoder.decode(value);
  const lines = chunk.split('\n');

  for (const line of lines) {
    if (line.startsWith('data: ')) {
      const data = JSON.parse(line.slice(6));
      if (data.type === 'content_block_delta') {
        appendToLastMessage(data.delta.text);
      }
    }
  }
}
```

---

### `src/ui/chat.js` — Chat Renderer

Renders conversation messages in the DOM.

**Key functions:**
- `appendMessage(role, content, timestamp)` — Add a message to the chat
- `appendThinking()` — Show the animated thinking indicator
- `renderContent(markdown)` — Convert Markdown to safe HTML
- `scrollToBottom()` — Auto-scroll to latest message

**Markdown rendering** is intentionally minimal — no external library dependencies. The renderer handles:
- Code blocks (``` ```) with language hint
- Inline code
- Bold and italic
- Headers (H1, H2, H3)
- Unordered and ordered lists
- Links
- Horizontal rules

Security note: All user content is HTML-escaped before rendering to prevent XSS.

---

### `src/plugins/registry.js` — Plugin Registry

Manages plugin registration, lifecycle, and hook dispatch.

```javascript
class PluginRegistry {
  static register(plugin: PluginDefinition): void
  static enable(id: string): Promise<void>
  static disable(id: string): Promise<void>
  static getAll(): PluginDefinition[]
  static getEnabled(): PluginDefinition[]

  // Called by the API client
  static async runBeforeSend(message): Promise<Message>
  static async runAfterReceive(message): Promise<Message>
  static getSystemContextAdditions(): string[]
}
```

Plugins are run in registration order. If a plugin throws in `beforeSend`, the send is cancelled and the error is shown to the user.

---

### `src/memory/store.js` — Memory System

Provides persistent key-value storage for user memories.

```javascript
class MemoryStore {
  static add(text: string, source?: string): void
  static getAll(): Memory[]
  static delete(id: string): void
  static clear(): void
  static toContextString(): string  // Returns formatted string for API
}
```

Memories are stored in `localStorage` under `om_memories`. They are injected into every API call as part of the system prompt.

---

### `src/utils/storage.js` — Storage Helpers

Thin wrappers around `localStorage` and `sessionStorage` with:
- JSON serialization/deserialization
- Error handling (storage quota exceeded)
- Namespaced keys (all keys prefixed with `om_`)

---

## Data Flow: Sending a Message

```
User types message + presses Enter
           │
           ▼
    [Input validation]
           │
           ▼
    PluginRegistry.runBeforeSend(message)
    ← plugins can modify or cancel
           │
           ▼
    Construct API request:
    - Add system prompt
    - Append memory context
    - Include full conversation history
           │
           ▼
    APIClient.send(request) → api.anthropic.com
           │
           ▼
    [If streaming]: decode SSE chunks → append to DOM
    [If not streaming]: parse full response
           │
           ▼
    PluginRegistry.runAfterReceive(response)
           │
           ▼
    Append to session history
    Update statistics
    Persist session to localStorage
           │
           ▼
    Render message in chat UI
```

---

## Storage Layout

```
sessionStorage:
  om_apikey          → string (Anthropic API key, cleared on tab close)

localStorage:
  om_sessions        → JSON array of Session objects (max 50)
  om_memories        → JSON array of Memory objects
  om_config          → JSON UserConfig object
  om_stats           → JSON Stats object
  om_plugins_state   → JSON map of pluginId → enabled boolean
```

---

## Security Architecture

### API Key Handling

The Anthropic API key is the most sensitive piece of data. Our handling:

1. **Input**: User enters key in a modal (type="password")
2. **Storage**: Stored in `sessionStorage.setItem('om_apikey', key)`
3. **Retrieval**: Read from sessionStorage before each API call
4. **Transmission**: Sent only to `api.anthropic.com` in the `x-api-key` header
5. **Clearing**: Automatically cleared when the browser tab closes (sessionStorage semantics)

The key is **never**:
- Written to `localStorage`
- Sent to any domain other than `api.anthropic.com`
- Logged to the console (even in debug mode)
- Included in exports

### XSS Prevention

All user-provided content is HTML-escaped using `escHtml()` before insertion into the DOM. The Markdown renderer processes escaped content, so no raw HTML from the AI response can execute.

```javascript
function escHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
```

---

## Performance Considerations

### No Build Step

OpenMind loads directly as plain HTML/CSS/JS files. This means:
- No webpack, rollup, or any bundler
- No transpilation
- Loads in <100ms on a fast connection

The downside is no tree-shaking or minification, but for a <200KB application, this is acceptable.

### Token Estimation

Token count is estimated as `characters / 4` — a rough approximation. This is used only for the UI display and does not affect API behavior. Accurate token counting would require loading a tokenizer library, which we've chosen not to do to maintain zero dependencies.

### localStorage Size Limits

localStorage is typically limited to 5–10MB. To stay within limits:
- Only the 50 most recent sessions are stored
- Sessions older than 30 days are pruned on startup
- Large sessions (>100 messages) trigger a warning

---

## Architecture Decision Records

Key decisions and their rationale are documented in [decisions.md](decisions.md).

Key decisions:
- **No backend** — privacy by design; can't leak data if there's no server
- **No npm dependencies in production** — reduces supply chain attack surface
- **sessionStorage for API key** — better security than localStorage (auto-cleared)
- **Custom Markdown renderer** — avoids pulling in marked.js or similar (100KB+)
- **localStorage for sessions** — simpler than IndexedDB, sufficient for our needs
