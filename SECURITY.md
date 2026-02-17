# Security Policy

## Overview

OpenMind is a client-side web application that communicates directly with the Anthropic Claude API from your browser. We take security seriously and appreciate responsible disclosure of vulnerabilities.

---

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x.x   | ✅ Active support |
| 0.9.x   | ⚠️ Security fixes only |
| < 0.9   | ❌ No longer supported |

---

## Architecture Security Model

Understanding OpenMind's architecture is important for evaluating its security properties:

### What OpenMind Does NOT Do

- ❌ We do **not** have a backend server — there is no OpenMind server that your data touches
- ❌ We do **not** store your API key on any server — it lives only in your browser's `sessionStorage`
- ❌ We do **not** collect analytics, telemetry, or usage data
- ❌ We do **not** transmit your conversations anywhere except directly to Anthropic's API
- ❌ We do **not** use cookies or third-party tracking

### What OpenMind Does

- ✅ Your API key is stored in `sessionStorage` — cleared when you close the browser tab
- ✅ Conversation history is stored in `localStorage` — stays on your device
- ✅ API calls go directly from your browser to `api.anthropic.com` — no proxy
- ✅ The app is a static HTML/CSS/JS file — no server-side code

### Threat Model

| Threat | Risk | Mitigation |
|--------|------|-----------|
| API key theft via XSS | Medium | sessionStorage, CSP headers on self-hosted deployments |
| Malicious plugin injection | Medium | Plugin code review requirement |
| localStorage data exposure | Low | Data is non-sensitive; API key not stored there |
| Man-in-the-middle | Low | All API calls use HTTPS/TLS |
| Supply chain attack | Low | No npm dependencies in production build |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, use one of these channels:

### Option 1: GitHub Private Security Advisory (Preferred)
1. Go to [https://github.com/openmind-ai/openmind/security/advisories](https://github.com/openmind-ai/openmind/security/advisories)
2. Click "New draft security advisory"
3. Fill in the details

### Option 2: Email
Send details to: **security@openmind-ai.dev**

Please encrypt sensitive details using our PGP key:
```
Key ID: 0xABCD1234
Fingerprint: XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
```
*(PGP key available at https://openmind-ai.dev/.well-known/pgp-key.txt)*

---

## What to Include in Your Report

A good vulnerability report includes:

1. **Type of vulnerability** (XSS, CSRF, data exposure, etc.)
2. **Affected component** (which file/function/feature)
3. **Steps to reproduce** — a minimal, working proof of concept
4. **Impact** — what can an attacker do?
5. **Suggested fix** (optional but appreciated)
6. **Your contact information** for follow-up

---

## Response Timeline

| Stage | Timeline |
|-------|----------|
| Acknowledgment | Within 48 hours |
| Initial assessment | Within 5 business days |
| Status update | Weekly until resolved |
| Patch release | Within 30 days for critical, 90 days for others |
| Public disclosure | After patch is released |

---

## Disclosure Policy

We follow **coordinated vulnerability disclosure**:

1. You report the vulnerability privately
2. We confirm, investigate, and develop a fix
3. We release a patched version
4. We credit you in the release notes (unless you prefer to remain anonymous)
5. You may publicly disclose after the patch is available

We ask that you:
- Give us reasonable time to fix the issue before disclosure
- Not exploit the vulnerability beyond what's needed to demonstrate it
- Not disclose to others until after we've released a fix

---

## Security Best Practices for Users

When using OpenMind:

- **API Key**: Your Anthropic API key is sensitive. Treat it like a password. Never share it.
- **Self-hosting**: If self-hosting, configure HTTPS and appropriate Content Security Policy headers
- **Plugins**: Only install plugins from sources you trust
- **Public devices**: API keys are cleared on tab close (sessionStorage), but close the tab when done on shared devices
- **Browser extensions**: Be cautious of browser extensions that can access all page data — they could read your API key from sessionStorage

---

## Known Security Considerations

### API Key in sessionStorage

The Anthropic API key is stored in `sessionStorage`. This means:
- **Pro**: Cleared when the tab/browser closes — not persistent
- **Con**: Accessible to any JavaScript running on the page (including browser extensions)

For maximum security in sensitive environments, consider:
- Using a restricted API key with billing limits set at Anthropic's console
- Running OpenMind in a dedicated browser profile with no extensions
- Clearing the session manually after use

### Content Security Policy

When self-hosting, we recommend adding these HTTP headers:

```
Content-Security-Policy: default-src 'self'; connect-src 'self' https://api.anthropic.com; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com;
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Referrer-Policy: strict-origin-when-cross-origin
```

---

## Hall of Fame

We recognize security researchers who responsibly disclose vulnerabilities:

*No reports received yet — be the first!*

---

## License

This security policy is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
