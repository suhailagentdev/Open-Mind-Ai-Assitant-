# Changelog

All notable changes to OpenMind will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- File attachment support (images, PDFs, text files)
- Streaming response rendering
- Light theme option
- PWA manifest for installable app
- `/help` command in chat input

### Changed
- Improved mobile layout responsiveness
- Sidebar now collapsible on smaller screens

### Fixed
- Session titles not updating after first message

---

## [1.0.0] — 2025-02-17

### 🎉 Initial Release

This is the first public release of OpenMind — a fully open-source, privacy-first AI assistant frontend for the Anthropic Claude API.

#### Added

**Core Chat System**
- Full conversation management with session persistence
- Multi-session support — create, switch, and manage unlimited conversations
- Message copy, delete, and regeneration
- Rich Markdown rendering: headers, bold/italic, code blocks, lists, links, horizontal rules
- Thinking indicator with animated dots
- Session export to JSON
- Auto-scroll to latest message

**Model Support**
- Claude Sonnet 4.5 (`claude-sonnet-4-5-20250929`)
- Claude Haiku 4.5 (`claude-haiku-4-5-20251001`)
- Claude Opus 4.5 (`claude-opus-4-5-20251101`)
- One-click model switching in the topbar

**Privacy & Security**
- API key stored in `sessionStorage` only — never transmitted to our servers
- All conversation data stored locally in `localStorage`
- Zero telemetry or usage tracking
- Full client-side architecture — no backend required

**Plugin System**
- Plugin registry with enable/disable toggles
- Built-in plugins: Web Search (stub), Code Runner (stub), Markdown, Auto-Memory, Export Tools
- Plugin API for third-party extensions

**Memory System**
- Persistent user memories stored in `localStorage`
- Memories automatically injected as context in every API call
- Add, view, and delete memories from the sidebar

**Configuration**
- Temperature control (0.0 – 1.0)
- Max tokens (256 – 8192)
- Top P (0.1 – 1.0)
- Response format: Markdown / Plain Text / JSON
- Streaming toggle
- Auto-save sessions toggle

**Statistics Dashboard**
- Total messages, sessions, API calls
- Estimated token usage
- API call latency tracking (avg, fastest, slowest)
- Session usage bar chart

**UI/UX**
- Industrial terminal-meets-soft-intelligence aesthetic
- Three-column cockpit layout: sessions | chat | context
- Custom system prompt editor (per-session)
- Conversation info panel (message count, token estimate)
- Persistent status bar with clock and model info
- Toast notification system
- Keyboard shortcuts: `Enter` to send, `Shift+Enter` for newline, `Ctrl+K` new chat, `Ctrl+E` export
- Demo mode — full UI exploration without an API key

**Documentation**
- Comprehensive README with quickstart
- CONTRIBUTING guide
- CODE_OF_CONDUCT
- SECURITY policy
- Plugin API reference
- Architecture overview
- Self-hosting guide
- Getting started guide
- GitHub Actions CI/CD pipeline
- Issue and PR templates
- Docker support

---

## [0.9.0-beta] — 2025-02-01

### Added
- Beta release for community testing
- Core chat functionality
- Basic session management
- Claude API integration
- Minimal UI

### Known Issues (resolved in 1.0.0)
- Sessions did not persist across page reloads
- No markdown rendering
- No model switching
- Single-session only

---

## [0.1.0-alpha] — 2025-01-15

### Added
- Initial proof of concept
- Basic chat interface
- Claude API connection

---

[Unreleased]: https://github.com/openmind-ai/openmind/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/openmind-ai/openmind/compare/v0.9.0-beta...v1.0.0
[0.9.0-beta]: https://github.com/openmind-ai/openmind/compare/v0.1.0-alpha...v0.9.0-beta
[0.1.0-alpha]: https://github.com/openmind-ai/openmind/releases/tag/v0.1.0-alpha
