## Multi‑stage Dockerfile for the frontend application
# ---------- Stage 1: Build ----------
FROM node:22-alpine AS builder

# Use a non‑root user for building (node user exists in the image)
USER node
WORKDIR /app

# Copy only package manifests first for layer caching
COPY --chown=node:node package.json ./

# Install dependencies (including dev dependencies for building)
RUN npm install

# Copy the rest of the source code
COPY --chown=node:node . ./

# Build the production assets
RUN npm run build

# ---------- Stage 2: Runtime ----------
FROM node:22-alpine AS runtime

# Use non-root user (node)
USER node
WORKDIR /app

# Copy built application from builder stage
COPY --from=builder /app /app

# Expose the dev server port
EXPOSE 3000

# Default command to start the app
CMD ["npm", "run", "dev"]
