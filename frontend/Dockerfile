# Use lightweight Nginx image (Alpine is tiny (5MB))
FROM nginx:alpine

# Add labels to identify the image
LABEL maintainer="student@kubeverse.io"
LABEL version="1.0.0"
LABEL description="Student Grade Tracker Frontend"

# Install wget for health checks (lightweight tool)
RUN apk add --no-cache wget

# Copy the HTML page to Nginx's default web directory
COPY src/index.html /usr/share/nginx/html/index.html

# Copy custom Nginx config to conf.d (not overriding main config)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create required directories and set correct permissions for nginx user
RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx \
    && chown -R nginx:nginx /var/cache/nginx /var/run /var/log/nginx \
    && chown -R nginx:nginx /usr/share/nginx/html \
    && chmod -R 755 /var/cache/nginx /var/run /var/log/nginx

# Create PID file with correct ownership (fixes permission error)
RUN touch /run/nginx.pid && chown nginx:nginx /run/nginx.pid

# Switch to non-root user (security best practice)
USER nginx

# Tell Docker this container listens on port 80
EXPOSE 80

# Health check to monitor if container is healthy
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/healthz || exit 1