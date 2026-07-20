# Stage 1: Builder 
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first (for caching)
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm install

# Copy the source code
COPY src/ ./src/

# Stage 2: Production 
FROM node:20-alpine AS production

# Add labels to identify the image
LABEL maintainer="student@kubeverse.io"
LABEL version="1.0.1"

# Upgrade all system packages 
RUN apk update && apk upgrade --no-cache

# Install wget for health checks
RUN apk add --no-cache wget

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ONLY production dependencies 
RUN npm install --production && npm cache clean --force

# Copy source code from builder stage
COPY --from=builder /app/src ./src

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port 3000
EXPOSE 3000

# Health check to monitor if app is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Start the application
CMD ["node", "src/server.js"]