# Contributing to OpenMind

First off — **thank you** for taking the time to contribute! 🎉

OpenMind is an open-source project and every contribution matters: bug fixes, new features, documentation improvements, design feedback, or just starring the repo. All are welcome and appreciated.

This document will guide you through the contribution process from start to finish.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)
- [Community](#community)

---

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing. We are committed to making this a welcoming, inclusive community for everyone.

---

## Getting Started

### Prerequisites

- Git
- A modern web browser (Chrome/Firefox/Edge/Safari)
- A text editor (VS Code recommended)
- An [Anthropic API key](https://console.anthropic.com) for testing (optional — demo mode works without one)

### Setting Up Your Development Environment

```bash
# 1. Fork the repository on GitHub
#    Click the "Fork" button at https://github.com/openmind-ai/openmind

# 2. Clone your fork
git clone https://github.com/YOUR-USERNAME/openmind.git
cd openmind

# 3. Add the upstream remote
git remote add upstream https://github.com/openmind-ai/openmind.git

# 4. Open the project
#    Option A: Open directly in browser
open index.html

#    Option B: Serve locally (recommended — avoids CORS issues)
npx serve .
# → http://localhost:3000

#    Option C: VS Code Live Server
#    Install the "Live Server" extension, right-click index.html → Open with Live Server
```

### Keeping Your Fork Up to Date

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## How Can I Contribute?

### 🐛 Reporting Bugs

Before submitting a bug report, please:
1. **Search existing issues** — your bug may already be reported
2. **Test on the latest version** — the bug may already be fixed
3. **Try in a different browser** — confirm it's not browser-specific

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md) and include:
- A clear, descriptive title
- Steps to reproduce the problem
- Expected vs actual behavior
- Screenshots if applicable
- Browser and OS information

### 💡 Suggesting Features

Feature requests are welcome! Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md).

Before submitting:
- Check the [roadmap](README.md#roadmap) — it may already be planned
- Search existing issues and [discussions](https://github.com/openmind-ai/openmind/discussions)

A great feature request includes:
- **Problem statement** — what problem does this solve?
- **Proposed solution** — how should it work?
- **Alternatives considered** — what other approaches did you consider?
- **Mockups** — if it's a UI change, sketches help a lot

### 📝 Improving Documentation

Documentation improvements are extremely valuable. This includes:
- Fixing typos and grammar
- Clarifying confusing sections
- Adding missing documentation
- Translating docs to other languages

Documentation lives in the `docs/` directory and in source file JSDoc comments.

### 🔌 Building Plugins

Adding new plugins is one of the best ways to contribute. See the [Plugin Development Guide](docs/guides/plugins.md) for a complete walkthrough.

Good plugin ideas:
- Language translation
- Grammar/spell check
- Weather/news lookup
- Calendar integration
- Custom prompt templates
- Diagram generation

### 💻 Writing Code

Check the [open issues](https://github.com/openmind-ai/openmind/issues) — especially ones labeled:
- `good first issue` — great for newcomers
- `help wanted` — we especially want community help here
- `bug` — confirmed bugs ready to fix
- `enhancement` — approved feature additions

---

## Development Workflow

### Branch Naming Convention

```
feat/short-description         # New features
fix/short-description          # Bug fixes
docs/short-description         # Documentation only
refactor/short-description     # Code refactoring
test/short-description         # Test additions
chore/short-description        # Maintenance tasks
```

Examples:
```
feat/streaming-responses
fix/session-persistence-bug
docs/self-hosting-guide
refactor/api-client-cleanup
```

### Typical Contribution Flow

```bash
# 1. Sync with upstream
git fetch upstream
git checkout main
git merge upstream/main

# 2. Create your branch
git checkout -b feat/my-awesome-feature

# 3. Make your changes
# ... write code, write tests, update docs ...

# 4. Test your changes thoroughly
#    - Manual testing in the browser
#    - Test in multiple browsers if UI changes
#    - Test with real API key AND demo mode

# 5. Stage and commit
git add .
git commit -m "feat: add awesome new feature"

# 6. Push to your fork
git push origin feat/my-awesome-feature

# 7. Open a Pull Request on GitHub
#    Use the PR template — fill in all sections
```

---

## Coding Standards

### JavaScript

We use modern ES2020+ JavaScript. No build step required.

```javascript
// ✅ Good: ES modules, async/await, const/let
import { SessionManager } from './session.js';

export async function loadSession(id) {
  const session = await SessionManager.get(id);
  return session ?? null;
}

// ❌ Avoid: var, callbacks, CommonJS require
var session = require('./session');
SessionManager.get(id, function(err, session) { ... });
```

**Key rules:**
- Use `const` by default, `let` when rebinding is needed, never `var`
- Use `async/await` over raw Promises
- Use template literals over string concatenation
- Use optional chaining (`?.`) and nullish coalescing (`??`)
- Keep functions small and single-purpose (< 40 lines ideally)
- Add JSDoc comments to all exported functions

### JSDoc Comments

```javascript
/**
 * Sends a message to the Claude API and returns the response.
 *
 * @param {string} content - The user message content
 * @param {Object} options - Optional overrides
 * @param {string} [options.model] - Model ID override
 * @param {number} [options.temperature] - Temperature override (0-1)
 * @returns {Promise<string>} The assistant's response text
 * @throws {APIError} If the API call fails
 *
 * @example
 * const response = await sendMessage('Hello!', { temperature: 0.5 });
 */
export async function sendMessage(content, options = {}) { ... }
```

### CSS / Styling

- Use CSS custom properties (variables) for all colors, spacing, and typography
- Follow the existing naming convention: `--om-{category}-{variant}`
- Mobile-first responsive design
- No external CSS frameworks (keep it dependency-free)

```css
/* ✅ Good: uses design tokens */
.message-bubble {
  background: var(--om-surface-raised);
  border: 1px solid var(--om-border-default);
  color: var(--om-text-primary);
  padding: var(--om-space-3) var(--om-space-4);
}

/* ❌ Avoid: hardcoded values */
.message-bubble {
  background: #0c1220;
  border: 1px solid #1e2d45;
  color: #c8d8ee;
  padding: 12px 16px;
}
```

### HTML

- Use semantic HTML5 elements
- Always include ARIA attributes for accessibility
- Keep markup clean and minimal — let CSS and JS do the heavy lifting

```html
<!-- ✅ Good: semantic, accessible -->
<button
  class="send-btn"
  aria-label="Send message"
  aria-disabled="false"
  id="send-btn"
>
  Send
</button>

<!-- ❌ Avoid: div soup -->
<div class="send-btn" onclick="send()">Send</div>
```

### File Organization

- One module per file
- Index files for clean re-exports
- Co-locate tests with source files: `session.js` → `session.test.js`
- Keep files under 300 lines — split if larger

---

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/). This powers our automated changelog and versioning.

### Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `style` | Formatting, missing semicolons, etc (no logic change) |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvements |
| `test` | Adding or correcting tests |
| `chore` | Build process or auxiliary tool changes |
| `revert` | Reverts a previous commit |

### Examples

```bash
# Good examples
git commit -m "feat(plugins): add web search plugin"
git commit -m "fix(session): resolve persistence bug on Firefox"
git commit -m "docs(api): document streaming response format"
git commit -m "feat(ui)!: redesign sidebar — BREAKING CHANGE: sidebar API changed"

# Breaking changes: add ! after scope and BREAKING CHANGE in footer
git commit -m "feat(api)!: change plugin registration API

BREAKING CHANGE: PluginRegistry.add() renamed to PluginRegistry.register()"
```

### Scope Values

`core`, `api`, `ui`, `plugins`, `memory`, `session`, `docs`, `build`, `ci`

---

## Pull Request Process

### Before Opening a PR

- [ ] Your branch is based on the latest `main`
- [ ] Code follows the style guidelines
- [ ] You've tested your changes manually
- [ ] You've added/updated documentation if needed
- [ ] Commit messages follow the Conventional Commits spec
- [ ] Your PR addresses a single concern (don't bundle unrelated changes)

### PR Title

Follow the same Conventional Commits format as commit messages:
```
feat(plugins): add language translation plugin
fix(session): correct date formatting in session list
docs: add Docker Compose example
```

### PR Description

Use the [PR template](.github/PULL_REQUEST_TEMPLATE.md). Fill in:
- **What does this PR do?** — clear summary
- **Why is this needed?** — links to relevant issues
- **How was it tested?** — manual test steps
- **Screenshots** — for any UI changes

### Review Process

1. A maintainer will review within 48–72 hours
2. Address review feedback by pushing new commits to your branch
3. Once approved, a maintainer will merge using **squash merge**
4. Your PR branch will be deleted after merge

### What We Look For

- ✅ Clean, readable code
- ✅ Appropriate error handling
- ✅ No regressions in existing functionality
- ✅ Consistent with the project's style and architecture
- ✅ Documentation updated where necessary
- ✅ No unnecessary dependencies added

---

## Issue Guidelines

### Labels

| Label | Description |
|-------|-------------|
| `bug` | Confirmed bug |
| `enhancement` | New feature or improvement |
| `good first issue` | Great for newcomers |
| `help wanted` | Community help especially desired |
| `documentation` | Documentation improvements |
| `question` | Further information requested |
| `wontfix` | We've decided not to address this |
| `duplicate` | Duplicate of another issue |
| `in progress` | Currently being worked on |

### Claiming an Issue

Before starting work on an issue:
1. Comment on it: "I'd like to work on this"
2. Wait for a maintainer to assign it to you (usually within 24h)
3. If no response after 3 days, feel free to start anyway and mention it in the PR

If you pick up an issue but can no longer work on it, please comment so others can take over.

---

## Community

- 💬 **Discord**: [discord.gg/openmind](https://discord.gg/openmind) — realtime chat
- 🗣️ **GitHub Discussions**: [Discussions](https://github.com/openmind-ai/openmind/discussions) — feature ideas, Q&A
- 🐦 **Twitter**: [@OpenMindAI](https://twitter.com/OpenMindAI) — announcements

---

## Recognition

Contributors are:
- Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Credited in release notes
- Given the `contributor` role in Discord

**Thank you for making OpenMind better! 🚀**
