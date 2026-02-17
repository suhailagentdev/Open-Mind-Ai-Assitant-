# Self-Hosting Guide

OpenMind is a static web application — there's no backend server, no database, and no server-side code. This makes it trivially easy to self-host on virtually any platform.

---

## Why Self-Host?

- **Full control** over the application and its updates
- **Custom domain** — run it at `ai.yourcompany.com`
- **Organization deployment** — share a single instance with your team
- **Air-gapped environments** — run completely offline (minus the Anthropic API calls)
- **Custom configuration** — bake in default system prompts, models, etc.

---

## Option 1: Any Web Server (Simplest)

Copy the files to any web server's document root:

```bash
# Clone the repo
git clone https://github.com/openmind-ai/openmind.git

# Serve with Python (built-in)
cd openmind
python3 -m http.server 8080
# → http://localhost:8080

# Serve with Node.js
npx serve . -p 8080
# → http://localhost:8080

# Copy to existing Nginx/Apache document root
cp -r openmind/* /var/www/html/openmind/
```

---

## Option 2: Docker

### Quick Start

```bash
docker run -d \
  --name openmind \
  -p 80:80 \
  --restart unless-stopped \
  ghcr.io/openmind-ai/openmind:latest
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  openmind:
    image: ghcr.io/openmind-ai/openmind:latest
    container_name: openmind
    ports:
      - "80:80"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 3
```

```bash
docker-compose up -d
```

### Build Your Own Docker Image

```dockerfile
# Dockerfile
FROM nginx:alpine

COPY . /usr/share/nginx/html/

# Recommended security headers
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost/ || exit 1
```

---

## Option 3: Nginx

### Basic Configuration

```nginx
# /etc/nginx/sites-available/openmind
server {
    listen 80;
    server_name ai.yourcompany.com;

    root /var/www/openmind;
    index index.html;

    # Serve static files
    location / {
        try_files $uri $uri/ /index.html;
        expires 1h;
        add_header Cache-Control "public";
    }

    # Security headers
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self'; connect-src 'self' https://api.anthropic.com; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com;" always;
}
```

### With HTTPS (Let's Encrypt)

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d ai.yourcompany.com

# Auto-renewal is set up automatically
```

```nginx
server {
    listen 443 ssl http2;
    server_name ai.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/ai.yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ai.yourcompany.com/privkey.pem;

    # Strong SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    root /var/www/openmind;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Content-Security-Policy "default-src 'self'; connect-src 'self' https://api.anthropic.com; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com;" always;
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name ai.yourcompany.com;
    return 301 https://$host$request_uri;
}
```

---

## Option 4: Apache

```apache
# /etc/apache2/sites-available/openmind.conf
<VirtualHost *:80>
    ServerName ai.yourcompany.com
    DocumentRoot /var/www/openmind

    <Directory /var/www/openmind>
        AllowOverride All
        Require all granted
    </Directory>

    # Rewrite for SPA
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ /index.html [L]

    # Security headers
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set Content-Security-Policy "default-src 'self'; connect-src 'self' https://api.anthropic.com; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com;"
</VirtualHost>
```

---

## Option 5: Cloud Platforms (1-Click)

### Cloudflare Pages

1. Fork the [OpenMind repository](https://github.com/openmind-ai/openmind)
2. Go to [Cloudflare Pages](https://pages.cloudflare.com)
3. Connect your GitHub account
4. Select your fork
5. **Build settings**: No build command, output directory = `/`
6. Deploy!

**Result**: Free hosting at `your-project.pages.dev` with a global CDN

### Netlify

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/openmind-ai/openmind)

Or manually:
1. Fork the repository
2. Connect to Netlify
3. No build command, publish directory = `/`

### Vercel

```bash
npm install -g vercel
git clone https://github.com/openmind-ai/openmind.git
cd openmind
vercel --prod
```

### GitHub Pages

Your fork of OpenMind is automatically deployed to GitHub Pages when you push to `main`. Enable it in **Settings → Pages → Source: GitHub Actions**.

Your instance will be live at: `https://YOUR-USERNAME.github.io/openmind`

---

## Customizing Your Deployment

### Pre-configuring a Default System Prompt

Edit `openmind.config.js`:

```javascript
export default {
  defaultSystemPrompt: `You are a helpful assistant for Acme Corp employees.
  You have knowledge of our internal tools and processes.
  Always respond in a professional, concise manner.`,

  ui: {
    welcomeMessage: 'Welcome to Acme AI Assistant'
  }
};
```

### Restricting to a Specific Model

```javascript
export default {
  defaultModel: 'claude-haiku-4-5-20251001',  // Use cheaper Haiku for cost control
  api: {
    allowedModels: ['claude-haiku-4-5-20251001'],  // Hide other model options
  }
};
```

### Disabling Features

```javascript
export default {
  features: {
    plugins: false,    // Hide plugin panel
    memory: false,     // Disable memory system
    export: false,     // Remove export button
    stats: false,      // Hide stats panel
  }
};
```

---

## Security Hardening

For production deployments, apply these additional measures:

### 1. Content Security Policy

The recommended CSP blocks all external resources except:
- Anthropic API (for AI calls)
- Google Fonts (for typography)

```
Content-Security-Policy:
  default-src 'self';
  connect-src 'self' https://api.anthropic.com;
  script-src 'self' 'unsafe-inline';
  style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
  font-src https://fonts.gstatic.com;
  img-src 'self' data:;
  object-src 'none';
  base-uri 'self';
```

If you want to self-host the fonts (eliminating the Google Fonts dependency):
```bash
# Download fonts
curl -o assets/fonts/JetBrainsMono.woff2 "https://..."
curl -o assets/fonts/Syne.woff2 "https://..."
```

Then update the font-src to `'self'` only.

### 2. HTTP Strict Transport Security

```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

### 3. Rate Limiting (Nginx)

If sharing with a team, consider rate limiting to prevent API key abuse:

```nginx
limit_req_zone $binary_remote_addr zone=openmind:10m rate=30r/m;

location / {
    limit_req zone=openmind burst=10 nodelay;
    # ... rest of config
}
```

---

## Monitoring

OpenMind is a static app with no server-side logging. To monitor usage:

- **Cloudflare Analytics** — free, privacy-respecting page view analytics
- **Nginx access logs** — see `access.log` for request patterns
- **Uptime monitoring** — use UptimeRobot or similar to alert on downtime

---

## Updating

```bash
# Pull latest changes from upstream
git remote add upstream https://github.com/openmind-ai/openmind.git
git fetch upstream
git merge upstream/main

# Re-deploy (varies by platform)
# Cloudflare/Netlify/Vercel: auto-deploys on git push
# Docker: docker pull ghcr.io/openmind-ai/openmind:latest && docker-compose restart
# Nginx/Apache: git pull in document root
```

Subscribe to [GitHub releases](https://github.com/openmind-ai/openmind/releases) to be notified of new versions.

---

## Troubleshooting

### "API blocked by CORS"

OpenMind is designed to call the Anthropic API directly from the browser using the `anthropic-dangerous-direct-browser-access: true` header. If you're seeing CORS errors:

1. Ensure you're serving over HTTPS (not HTTP) for production
2. Check your CSP headers aren't blocking `api.anthropic.com`
3. Don't proxy the API calls through your server — this defeats the privacy model

### "localStorage not available"

This happens in some iframe contexts (e.g., inside certain CMS systems). Serve OpenMind as a standalone page, not in an iframe.

### Fonts not loading

If Google Fonts are blocked in your environment, update the font imports to use system fonts:

```css
/* In index.html, replace the Google Fonts import with: */
:root {
  --font-display: 'Trebuchet MS', sans-serif;
  --font-mono: 'Consolas', 'Courier New', monospace;
  --font-body: 'Segoe UI', sans-serif;
}
```
