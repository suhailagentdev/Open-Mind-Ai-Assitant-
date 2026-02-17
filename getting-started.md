# Getting Started with OpenMind

Welcome to OpenMind! This guide will get you up and running in under 5 minutes.

---

## Prerequisites

- A modern web browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- An Anthropic API key — [get one free at console.anthropic.com](https://console.anthropic.com)

That's it. No Node.js, no Python, no databases, no Docker (unless you want it).

---

## Step 1: Get Your Anthropic API Key

1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in
3. Navigate to **API Keys** in the left sidebar
4. Click **Create Key**
5. Name it (e.g., "OpenMind") and copy the key — it starts with `sk-ant-`

> ⚠️ **Keep your API key secret.** Treat it like a password. OpenMind stores it only in your browser's sessionStorage — it's never sent to any server other than Anthropic's official API.

**Set a usage limit** (recommended): In the Anthropic Console, go to **Billing → Usage Limits** and set a monthly cap to prevent unexpected charges.

---

## Step 2: Open OpenMind

### Quickest: Use the hosted version
Open [https://openmind-ai.github.io/openmind](https://openmind-ai.github.io/openmind) in your browser.

### Run locally
```bash
git clone https://github.com/openmind-ai/openmind.git
cd openmind
open index.html     # macOS
# or
start index.html    # Windows
# or
xdg-open index.html # Linux
```

---

## Step 3: Enter Your API Key

When OpenMind opens, you'll see the API key setup modal:

1. Paste your `sk-ant-...` key into the input field
2. Click **Connect & Launch**
3. Done! The status indicator in the top-right will turn green.

> **Want to try without an API key?** Click **Demo Mode** to explore the interface with simulated responses.

---

## Step 4: Start Your First Conversation

1. The welcome screen shows 4 suggestion cards — click one to auto-fill the input
2. Or type your own message in the input box at the bottom
3. Press **Enter** (or click the ➤ button) to send
4. Watch OpenMind respond!

### Your first few prompts to try:

```
Explain how HTTPS works in simple terms

Write a Python function that checks if a string is a palindrome

What's the difference between TCP and UDP?

Help me write a professional email declining a job offer
```

---

## Step 5: Explore the Interface

### Left Sidebar — Sessions & Plugins

**Sessions list**: Each conversation is a session. They're saved automatically in your browser's localStorage.
- Click **+ NEW CONVERSATION** to start a fresh chat
- Click any session in the list to load it
- Sessions show title, date, and message count

**Plugins panel**: Toggle built-in plugins on/off. More plugins coming in v1.1.

### Center — Chat Area

The main conversation view. Key things to know:
- Hover over any message to reveal **Copy**, **Regenerate**, and **Delete** actions
- The topbar lets you switch between **Sonnet**, **Haiku**, and **Opus** models
- **Sonnet** is the best default for most tasks
- **Haiku** is fastest and cheapest
- **Opus** is most powerful for complex reasoning

### Right Sidebar — Context, Memory, Config, Stats

**Context tab:**
- Edit the **System Prompt** to change how the AI behaves
- See the current conversation's message count and estimated token usage

**Memory tab:**
- Add persistent facts that are injected into every conversation
- Example: `My name is Alex. I prefer Python over JavaScript. I work in fintech.`

**Config tab:**
- **Temperature**: Higher = more creative, lower = more precise (default: 0.7)
- **Max Tokens**: Maximum length of responses (default: 2048)
- **Top P**: Nucleus sampling (default: 0.95, rarely needs changing)

**Stats tab:**
- Track your usage across sessions
- Monitor API call latency

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Enter` | Send message |
| `Shift + Enter` | New line in message |
| `Ctrl/Cmd + K` | New conversation |
| `Ctrl/Cmd + E` | Export current chat |

---

## Tips & Tricks

### Get Better Responses with System Prompts

The system prompt tells the AI how to behave. Try these:

```
# For coding help
You are an expert software engineer. When writing code, always include comments,
handle edge cases, and explain your reasoning. Prefer modern, idiomatic solutions.
Use Python 3.11+ features when writing Python.

# For writing help  
You are a professional editor and writing coach. Help me improve clarity,
concision, and impact. Point out weak phrases and suggest stronger alternatives.
Be direct and specific.

# For learning
You are a patient tutor. Explain concepts using analogies and real-world examples.
After explaining, ask a question to check my understanding. Build on what I know.
```

### Use Memory for Persistent Context

Instead of re-explaining yourself every session, add key facts to Memory:
- "I'm a senior developer with 10 years of experience in Python and AWS"
- "My company uses React and TypeScript for all frontend work"
- "I prefer concise answers without excessive caveats"

### Export Your Conversations

Click the 💾 button in the topbar to download your current session as JSON. You can use this to:
- Back up important conversations
- Share with colleagues
- Import into other tools

---

## Next Steps

- [Self-Hosting Guide](self-hosting.md) — run OpenMind on your own server
- [Plugin Development](plugins.md) — build your own plugins
- [API Reference](../api/README.md) — explore the JavaScript API
- [Customization Guide](customization.md) — themes and configuration

---

## Troubleshooting

### "Invalid API key" error
- Make sure the key starts with `sk-ant-`
- Check that the key hasn't been revoked at console.anthropic.com
- Ensure you have billing set up (free tier requires a payment method)

### Responses are slow
- Try switching to **Haiku** model for faster responses
- Check your internet connection
- Large context (many messages) increases latency — start a new session

### Session history disappeared
- Sessions are stored in `localStorage` — clearing browser data will remove them
- Export important sessions regularly using the 💾 button
- Private/Incognito mode doesn't persist localStorage

### The app looks broken in my browser
- OpenMind requires a modern browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- Try disabling browser extensions, especially ad blockers and privacy extensions
- Hard refresh: `Ctrl+Shift+R` (Windows) / `Cmd+Shift+R` (Mac)

---

**Still stuck?** Open an issue on [GitHub](https://github.com/openmind-ai/openmind/issues) or join our [Discord](https://discord.gg/openmind).
