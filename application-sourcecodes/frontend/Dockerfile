## Multi‑stage Dockerfile for the frontend application
# ---------- Stage 1: Build ----------
FROM node:22-alpine AS builder

WORKDIR /app

# Copy only package manifests first for layer caching
COPY package.json ./

# Install dependencies (including dev dependencies for building)
RUN npm install

# Copy the rest of the source code
COPY . ./

# Build the production assets
RUN npm run build

# ---------- Stage 2: Runtime ----------
FROM node:22-alpine AS runtime

WORKDIR /app

# Copy built application from builder stage
COPY --from=builder /app /app

# Fix permissions for the node user
RUN chown -R node:node /app

# Use non-root user (node)
USER node

# Expose the dev server port
EXPOSE 3000

# Default command to start the app
CMD ["npm", "run", "dev"]
