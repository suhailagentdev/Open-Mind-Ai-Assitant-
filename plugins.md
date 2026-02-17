# Plugin API Reference

OpenMind has a lightweight plugin system that lets you extend the assistant's capabilities without touching the core codebase.

---

## Table of Contents

- [Plugin Structure](#plugin-structure)
- [Plugin Lifecycle](#plugin-lifecycle)
- [Context API](#context-api)
- [Hooks](#hooks)
- [Commands](#commands)
- [Events](#events)
- [Built-in Plugins](#built-in-plugins)
- [Publishing Plugins](#publishing-plugins)
- [Examples](#examples)

---

## Plugin Structure

A plugin is a JavaScript ES module that exports a default object conforming to the `PluginDefinition` interface:

```typescript
interface PluginDefinition {
  // Required
  id: string;           // Unique identifier, e.g. 'my-plugin'
  name: string;         // Display name, e.g. 'My Plugin'
  version: string;      // Semver, e.g. '1.0.0'
  description: string;  // Short description shown in the UI

  // Optional metadata
  author?: string;
  homepage?: string;
  icon?: string;        // Emoji or URL to 16x16 icon

  // Lifecycle hooks
  onEnable?(context: PluginContext): void | Promise<void>;
  onDisable?(context: PluginContext): void | Promise<void>;

  // Message hooks
  beforeSend?(message: Message, context: PluginContext): Message | Promise<Message>;
  afterReceive?(message: Message, context: PluginContext): Message | Promise<Message>;

  // System context
  getSystemContext?(): string | Promise<string>;
}
```

### Minimal Plugin

```javascript
// my-plugin.js
export default {
  id: 'my-plugin',
  name: 'My Plugin',
  version: '1.0.0',
  description: 'Does something useful',

  onEnable(ctx) {
    console.log('My plugin enabled!');
  },

  onDisable(ctx) {
    console.log('My plugin disabled!');
  }
};
```

---

## Plugin Lifecycle

```
User enables plugin
       │
       ▼
  onEnable(ctx)        ← Set up resources, register commands
       │
       ▼
  [Plugin active]
  ┌─────────────────────────────────────┐
  │  Each message sent:                 │
  │    beforeSend(msg, ctx)  ← modify   │
  │    [API call]                       │
  │    afterReceive(msg, ctx) ← modify  │
  └─────────────────────────────────────┘
       │
  User disables plugin
       │
       ▼
  onDisable(ctx)       ← Clean up resources, unregister commands
```

---

## Context API

The `PluginContext` object is passed to all lifecycle hooks. It provides:

### `context.chat`

```javascript
// Send a message programmatically
context.chat.sendMessage('Hello from plugin!');

// Get current conversation history
const history = context.chat.getHistory();
// Returns: Array<{ role: 'user'|'assistant', content: string, timestamp: number }>

// Append a message to the chat UI (without sending to API)
context.chat.appendMessage({
  role: 'assistant',
  content: 'Plugin result: ...',
  timestamp: Date.now()
});

// Get the current input value
const input = context.chat.getInput();

// Set the input value
context.chat.setInput('pre-filled text');
```

### `context.commands`

```javascript
// Register a slash command
context.commands.register('/search', async (args) => {
  const results = await mySearch(args);
  return `Search results for "${args}":\n${results}`;
});

// Unregister a command
context.commands.unregister('/search');

// List registered commands
const cmds = context.commands.list();
```

### `context.memory`

```javascript
// Add to the persistent memory store
context.memory.add('User prefers dark themes');

// Get all memories
const memories = context.memory.getAll();

// Clear plugin-specific memories
context.memory.clearBySource('my-plugin');
```

### `context.config`

```javascript
// Get a config value (with optional default)
const apiKey = context.config.get('MY_PLUGIN_API_KEY', null);

// Set a config value (persisted to localStorage)
context.config.set('MY_PLUGIN_CACHE_TTL', 3600);

// Show a config prompt to the user
const key = await context.config.prompt(
  'Enter your API key for My Plugin:',
  { type: 'password', placeholder: 'abc123...' }
);
```

### `context.ui`

```javascript
// Show a toast notification
context.ui.toast('Search complete!', 'success'); // 'success' | 'error' | 'info'

// Show a modal dialog
const confirmed = await context.ui.confirm(
  'This will delete all cached data. Continue?'
);

// Add a button to the input toolbar
context.ui.addToolbarButton({
  id: 'my-btn',
  icon: '🔍',
  label: 'Search',
  onClick: () => context.chat.setInput('/search ')
});

// Remove a toolbar button
context.ui.removeToolbarButton('my-btn');
```

### `context.session`

```javascript
// Get the current session
const session = context.session.getCurrent();

// Get current model
const model = context.session.getModel();

// Get system prompt
const sysprompt = context.session.getSystemPrompt();
```

### `context.events`

```javascript
// Subscribe to events
const unsubscribe = context.events.on('message:sent', (msg) => {
  console.log('Message sent:', msg.content);
});

// Unsubscribe
unsubscribe();

// Emit a custom event
context.events.emit('my-plugin:result', { data: 'something' });
```

---

## Hooks

### `beforeSend(message, context)`

Called before a user message is sent to the API. Use this to:
- Modify the message content
- Add context to the message
- Cancel the send (return `null`)

```javascript
async beforeSend(message, ctx) {
  // Add today's date to every message
  return {
    ...message,
    content: `[Today: ${new Date().toLocaleDateString()}]\n\n${message.content}`
  };
}
```

### `afterReceive(message, context)`

Called after a response is received from the API. Use this to:
- Post-process the response
- Extract and store information
- Trigger side effects

```javascript
async afterReceive(message, ctx) {
  // Extract code blocks and log them
  const codeBlocks = message.content.match(/```[\s\S]*?```/g) || [];
  if (codeBlocks.length > 0) {
    ctx.ui.toast(`${codeBlocks.length} code block(s) in response`, 'info');
  }
  return message; // Return unchanged
}
```

### `getSystemContext()`

Return a string to append to the system prompt when the plugin is active:

```javascript
getSystemContext() {
  return `You have access to real-time web search via the /search command.
  When the user asks about current events or facts you're unsure about,
  suggest using /search to get up-to-date information.`;
}
```

---

## Commands

Slash commands are triggered when the user types `/commandname [args]` in the chat input.

```javascript
onEnable(ctx) {
  // Basic command
  ctx.commands.register('/hello', (args) => {
    return `Hello, ${args || 'World'}!`;
  });

  // Async command
  ctx.commands.register('/weather', async (city) => {
    if (!city) return 'Usage: /weather <city>';
    try {
      const data = await fetchWeather(city);
      return `Weather in ${city}: ${data.description}, ${data.temp}°C`;
    } catch (e) {
      return `Error fetching weather: ${e.message}`;
    }
  });
}
```

Command return values:
- `string` — displayed as an assistant message
- `null` / `undefined` — silently processed (no message shown)
- Throw an error — shown as an error toast

---

## Events

Subscribe to application events:

| Event | Payload | Description |
|-------|---------|-------------|
| `message:sent` | `{ content, role }` | User sent a message |
| `message:received` | `{ content, role }` | AI response received |
| `session:created` | `{ id, title }` | New session started |
| `session:switched` | `{ id }` | User switched session |
| `model:changed` | `{ model }` | Model changed |
| `plugin:enabled` | `{ id }` | A plugin was enabled |
| `plugin:disabled` | `{ id }` | A plugin was disabled |

---

## Built-in Plugins

### Web Search (`web-search`)

*Status: Stub — Full implementation in v1.1*

Adds a `/search <query>` command that performs web searches and injects results as context.

### Code Runner (`code-runner`)

*Status: Stub — Full implementation in v1.2*

Adds a **▶ Run** button to code blocks in responses. Executes JavaScript in a sandboxed iframe.

### Markdown (`markdown`)

*Status: Active*

Enables rich Markdown rendering in chat messages. Disable this to see raw Markdown text.

### Auto-Memory (`auto-memory`)

*Status: Stub — Full implementation in v1.1*

Automatically extracts and stores facts from conversations into the memory system.

### Export Tools (`export`)

*Status: Active*

Adds export options: JSON (current), with Markdown and PDF coming in v1.1.

---

## Publishing Plugins

Share your plugin with the community:

1. Create a GitHub repository named `openmind-plugin-{your-plugin-name}`
2. Add the topic `openmind-plugin` to your repository
3. Include a `plugin.json` manifest:

```json
{
  "id": "your-plugin-id",
  "name": "Your Plugin",
  "version": "1.0.0",
  "description": "What your plugin does",
  "author": "Your Name",
  "homepage": "https://github.com/you/openmind-plugin-your-plugin",
  "icon": "🔌",
  "main": "index.js",
  "openmind": ">=1.0.0"
}
```

4. Open a PR to add your plugin to the [Community Plugins list](../../PLUGINS.md)

---

## Examples

### Word Counter Plugin

```javascript
// examples/word-counter/index.js
export default {
  id: 'word-counter',
  name: 'Word Counter',
  version: '1.0.0',
  description: 'Shows word count for each response',
  icon: '🔢',

  onEnable(ctx) {
    this._ctx = ctx;
  },

  afterReceive(message, ctx) {
    const words = message.content.trim().split(/\s+/).length;
    const chars = message.content.length;
    ctx.ui.toast(`Response: ${words} words, ${chars} chars`, 'info');
    return message;
  }
};
```

### Timestamp Plugin

```javascript
// examples/timestamp/index.js
export default {
  id: 'timestamp',
  name: 'Timestamp',
  version: '1.0.0',
  description: 'Prepends current date/time to every message',

  beforeSend(message, ctx) {
    const ts = new Date().toLocaleString();
    return {
      ...message,
      content: `[${ts}]\n${message.content}`
    };
  }
};
```

### Note-Taking Plugin

```javascript
// examples/notes/index.js
const STORAGE_KEY = 'openmind-plugin-notes';

export default {
  id: 'notes',
  name: 'Notes',
  version: '1.0.0',
  description: 'Save and retrieve notes in chat',
  icon: '📓',

  onEnable(ctx) {
    ctx.commands.register('/note', (args) => this.addNote(args, ctx));
    ctx.commands.register('/notes', () => this.listNotes());
    ctx.commands.register('/clearnotes', () => this.clearNotes(ctx));
  },

  onDisable(ctx) {
    ctx.commands.unregister('/note');
    ctx.commands.unregister('/notes');
    ctx.commands.unregister('/clearnotes');
  },

  addNote(text, ctx) {
    if (!text) return 'Usage: /note <text>';
    const notes = this.getNotes();
    notes.push({ text, createdAt: Date.now() });
    localStorage.setItem(STORAGE_KEY, JSON.stringify(notes));
    ctx.memory.add(`Note: ${text}`);
    return `✅ Note saved: "${text}"`;
  },

  listNotes() {
    const notes = this.getNotes();
    if (notes.length === 0) return 'No notes yet. Use /note <text> to add one.';
    return notes.map((n, i) =>
      `${i + 1}. ${n.text} _(${new Date(n.createdAt).toLocaleDateString()})_`
    ).join('\n');
  },

  clearNotes(ctx) {
    localStorage.removeItem(STORAGE_KEY);
    return '🗑 All notes cleared.';
  },

  getNotes() {
    return JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
  }
};
```

---

## Plugin Development Tips

1. **Keep plugins focused** — one plugin, one responsibility
2. **Always clean up in `onDisable`** — unregister commands, remove toolbar buttons, clear timers
3. **Use `ctx.config` for user settings** — don't hardcode API keys or preferences
4. **Handle errors gracefully** — catch exceptions and show useful error messages
5. **Test in both real and demo modes** — some context may not be available in demo mode
6. **Respect privacy** — don't send user data to third-party servers without clear disclosure

---

*See the [Plugin Examples directory](../../examples/) for more complete examples.*
