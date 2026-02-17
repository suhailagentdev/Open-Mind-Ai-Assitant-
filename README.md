<div align="center">

<img src="https://github.com/suhailagentdev/Open-Mind-Ai-Assitant-/blob/main/Open%20Mind%20Ai%20Assistant.png?raw=true" alt="OpenMind Logo" width="80" height="80" />

# OpenMind

### Open Source AI Assistant — Powered by Claude

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/openmind-ai/openmind/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![GitHub Stars](https://img.shields.io/github/stars/openmind-ai/openmind?style=social)](https://github.com/openmind-ai/openmind/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/openmind-ai/openmind)](https://github.com/openmind-ai/openmind/issues)
[![Discord](https://img.shields.io/badge/Discord-join%20chat-5865F2)](https://discord.gg/openmind)
[![Build Status](https://img.shields.io/github/actions/workflow/status/openmind-ai/openmind/ci.yml)](https://github.com/openmind-ai/openmind/actions)

**A fully open-source, privacy-first AI assistant frontend for the Anthropic Claude API.**  
Your API key stays in your browser. Your data stays yours. Forever.

[**Live Demo**](https://openmind-ai.github.io/openmind) · [**Documentation**](docs/) · [**Report Bug**](.github/ISSUE_TEMPLATE/bug_report.md) · [**Request Feature**](.github/ISSUE_TEMPLATE/feature_request.md)

---

![OpenMind Screenshot](https://github.com/suhailagentdev/Open-Mind-Ai-Assitant-/blob/main/Screenshot%20(2).png?raw=true)

</div>

---

## ✨ Why OpenMind?

Most AI chat frontends are:
- **Closed source** — you can't audit what they do with your data
- **Cloud-hosted** — your conversations are stored on someone else's server
- **Subscription-locked** — pay monthly or lose access to your history

OpenMind is different:

| Feature | OpenMind | Commercial Alternatives |
|--------|----------|------------------------|
| Source code auditable | ✅ | ❌ |
| API key stored locally | ✅ | ❌ |
| Conversation data stays local | ✅ | ❌ |
| Self-hostable | ✅ | ❌ |
| Plugin system | ✅ | Limited |
| Multi-model switching | ✅ | Limited |
| Free forever | ✅ (bring your key) | ❌ |

---

## 🚀 Quick Start

### Option 1: Use the Live Web App (Easiest)
```
https://openmind-ai.github.io/openmind
```
Open in any modern browser → Enter your Anthropic API key → Start chatting.

### Option 2: Run Locally
```bash
# Clone the repository
git clone https://github.com/openmind-ai/openmind.git
cd openmind

# No build step needed — open directly in browser
open index.html

# OR serve with any static file server
npx serve .
# → http://localhost:3000
```

### Option 3: Docker
```bash
docker pull ghcr.io/openmind-ai/openmind:latest
docker run -p 8080:80 ghcr.io/openmind-ai/openmind:latest
# → http://localhost:8080
```

### Option 4: npm / Node.js
```bash
npm install -g openmind-ai
openmind serve
# → http://localhost:3000
```

---

## 📋 Prerequisites

- A modern web browser (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- An [Anthropic API key](https://console.anthropic.com) (free tier available)
- That's it — no backend, no database, no server required

---

## 🎯 Features

### Core Chat
- 💬 **Full conversation management** — create, switch, and persist multiple sessions
- 🔄 **Model switching** — Claude Opus 4.5, Sonnet 4.5, Haiku 4.5 in one click
- 📝 **Rich Markdown rendering** — code blocks, tables, headers, lists, links
- ⚡ **Streaming responses** — see output as it's generated
- 🔁 **Message regeneration** — re-run any response with one click
- 📤 **Export conversations** — download as JSON, Markdown, or PDF

### Privacy & Security
- 🔑 **Local API key storage** — stored in `sessionStorage`, never transmitted to our servers
- 🏠 **Fully self-hostable** — deploy on your own infrastructure
- 🔍 **Open source** — every line of code is auditable
- 🚫 **No telemetry** — we collect zero usage data

### Customization
- 🧩 **Plugin system** — extend with Web Search, Code Runner, and more
- 🧠 **Persistent memory** — store user facts injected as context
- ⚙️ **Fine-grained config** — temperature, top-p, max tokens, response format
- 💬 **Custom system prompts** — per-session or global defaults
- 🎨 **Theme system** — dark/light and custom color schemes *(coming v1.1)*

### Developer Tools
- 📊 **Usage statistics** — token counts, latency, call history
- 🐛 **Debug mode** — inspect raw API requests/responses
- 🔌 **Plugin API** — build your own plugins in <50 lines of JS

---

## 📁 Project Structure

```
openmind/
├── index.html                  # Main application entry point
├── README.md                   # This file
├── CONTRIBUTING.md             # How to contribute
├── CODE_OF_CONDUCT.md          # Community standards
├── CHANGELOG.md                # Version history
├── LICENSE                     # MIT License
├── SECURITY.md                 # Security policy
│
├── src/                        # Source modules
│   ├── core/
│   │   ├── engine.js           # Application bootstrap & state
│   │   ├── session.js          # Session management
│   │   └── events.js           # Event bus
│   ├── api/
│   │   ├── client.js           # Claude API client
│   │   ├── streaming.js        # SSE streaming handler
│   │   └── models.js           # Model definitions
│   ├── ui/
│   │   ├── chat.js             # Chat rendering
│   │   ├── sidebar.js          # Sidebar components
│   │   └── markdown.js         # Markdown renderer
│   ├── plugins/
│   │   ├── registry.js         # Plugin registry
│   │   ├── web-search.js       # Web search plugin
│   │   └── code-runner.js      # Code execution plugin
│   ├── memory/
│   │   └── store.js            # Persistent memory system
│   └── utils/
│       ├── storage.js          # localStorage/sessionStorage helpers
│       └── export.js           # Export utilities
│
├── docs/                       # Documentation
│   ├── api/
│   │   ├── README.md           # API overview
│   │   ├── client.md           # API client reference
│   │   └── plugins.md          # Plugin API reference
│   ├── guides/
│   │   ├── getting-started.md  # Quickstart guide
│   │   ├── self-hosting.md     # Self-hosting guide
│   │   ├── plugins.md          # Building plugins
│   │   └── customization.md    # Theming & customization
│   └── architecture/
│       ├── overview.md         # System architecture
│       └── decisions.md        # Architecture Decision Records
│
├── tests/                      # Test suite
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── examples/                   # Example configurations
│   ├── custom-system-prompt/
│   ├── minimal-setup/
│   └── docker-compose/
│
├── scripts/                    # Build & utility scripts
│   ├── build.sh
│   ├── release.sh
│   └── docker-build.sh
│
├── assets/                     # Static assets
│   ├── logo.svg
│   └── screenshot.png
│
└── .github/                    # GitHub configuration
    ├── workflows/
    │   ├── ci.yml              # CI pipeline
    │   ├── release.yml         # Release automation
    │   └── pages.yml           # GitHub Pages deploy
    ├── ISSUE_TEMPLATE/
    │   ├── bug_report.md
    │   └── feature_request.md
    └── PULL_REQUEST_TEMPLATE.md
```

---

## 🔌 Plugin System

OpenMind has a lightweight plugin architecture. Build your own plugin in under 50 lines:

```javascript
// examples/my-plugin/index.js
export default {
  id: 'my-plugin',
  name: 'My Plugin',
  version: '1.0.0',
  description: 'Does something awesome',

  // Called when plugin is enabled
  onEnable(context) {
    context.registerCommand('/mycommand', this.handleCommand.bind(this));
    context.addSystemContext('I have access to a custom tool.');
  },

  // Called before each message is sent
  async beforeSend(message, context) {
    // Modify message or add context
    return message;
  },

  // Handle /mycommand
  async handleCommand(args, context) {
    return `Result: ${args}`;
  },

  // Called when plugin is disabled
  onDisable(context) {
    context.unregisterCommand('/mycommand');
  }
};
```

Register your plugin:
```javascript
import { PluginRegistry } from './src/plugins/registry.js';
import MyPlugin from './examples/my-plugin/index.js';

PluginRegistry.register(MyPlugin);
```

See [Plugin API Reference](docs/api/plugins.md) for the full API.

---

## 🔧 Configuration

OpenMind can be configured via a `openmind.config.js` file at the project root:

```javascript
// openmind.config.js
export default {
  // Default model to use
  defaultModel: 'claude-sonnet-4-5-20250929',

  // Default system prompt
  defaultSystemPrompt: 'You are a helpful AI assistant.',

  // UI settings
  ui: {
    theme: 'dark',          // 'dark' | 'light' | 'auto'
    fontSize: 14,
    showSidebar: true,
    showStats: true,
  },

  // API settings
  api: {
    baseUrl: 'https://api.anthropic.com',
    version: '2023-06-01',
    defaultTemperature: 0.7,
    defaultMaxTokens: 2048,
  },

  // Feature flags
  features: {
    streaming: true,
    memory: true,
    plugins: true,
    export: true,
  },

  // Plugins to load by default
  plugins: ['web-search', 'code-runner', 'markdown'],
};
```

---

## 🌐 Self-Hosting

### Nginx
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/openmind;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### Docker Compose
```yaml
# examples/docker-compose/docker-compose.yml
version: '3.8'
services:
  openmind:
    image: ghcr.io/openmind-ai/openmind:latest
    ports:
      - "80:80"
    restart: unless-stopped
```

### Cloudflare Pages / Netlify / Vercel
OpenMind is a static site — deploy by connecting your fork to any of these platforms. No build step required.

See [Self-Hosting Guide](docs/guides/self-hosting.md) for full instructions.

---

## 🤝 Contributing

We love contributions! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a PR.

**Good first issues:**  
[![Good First Issues](https://img.shields.io/github/issues/openmind-ai/openmind/good%20first%20issue)](https://github.com/openmind-ai/openmind/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

Quick contribution guide:
```bash
# 1. Fork and clone
git clone https://github.com/YOUR-USERNAME/openmind.git
cd openmind

# 2. Create a feature branch
git checkout -b feat/my-awesome-feature

# 3. Make your changes
# ... edit files ...

# 4. Test your changes
open index.html

# 5. Commit using conventional commits
git commit -m "feat: add awesome new feature"

# 6. Push and open a PR
git push origin feat/my-awesome-feature
```

---

## 📊 Roadmap

See [CHANGELOG.md](CHANGELOG.md) for what's already shipped.

| Version | Focus | Status |
|---------|-------|--------|
| **v1.0** | Core chat, sessions, memory, plugins | ✅ Released |
| **v1.1** | Streaming responses, file attachments, themes | 🔄 In Progress |
| **v1.2** | Mobile-responsive UI, PWA support | 📅 Planned |
| **v1.3** | Web search plugin, code execution sandbox | 📅 Planned |
| **v2.0** | Multi-provider support (OpenAI, Gemini, local LLMs) | 💭 Research |

Vote on features in [GitHub Discussions](https://github.com/openmind-ai/openmind/discussions).

---

## 🛡️ Security

Found a security vulnerability? **Please do not open a public issue.**

See [SECURITY.md](SECURITY.md) for our responsible disclosure policy.

---

## 📜 License

OpenMind is released under the **MIT License**. See [LICENSE](LICENSE) for full text.

```
MIT License — Copyright (c) 2025 OpenMind Contributors
```

You are free to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of this software for any purpose, including commercial use.

---

## 🙏 Acknowledgements

- [Anthropic](https://anthropic.com) for the Claude API
- [OpenClaw](https://github.com/pjsdream/OpenClaw) for inspiring the open-source philosophy
- All [contributors](https://github.com/openmind-ai/openmind/graphs/contributors) who have helped build OpenMind

---

<div align="center">

**[⭐ Star this repo](https://github.com/openmind-ai/openmind) if OpenMind is useful to you!**

Made with ❤️ by the open-source community

</div>
