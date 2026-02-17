# OpenMind — Docker Image
# Serves the static OpenMind app using Nginx Alpine

FROM nginx:1.25-alpine

LABEL org.opencontainers.image.title="OpenMind"
LABEL org.opencontainers.image.description="Open-source AI assistant for Claude API"
LABEL org.opencontainers.image.url="https://github.com/openmind-ai/openmind"
LABEL org.opencontainers.image.source="https://github.com/openmind-ai/openmind"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="OpenMind Contributors"

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy application files
COPY index.html /usr/share/nginx/html/
COPY src/ /usr/share/nginx/html/src/
COPY assets/ /usr/share/nginx/html/assets/
COPY docs/ /usr/share/nginx/html/docs/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create non-root user for nginx worker
RUN addgroup -g 101 -S nginx-worker && \
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx-worker nginx-worker

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
