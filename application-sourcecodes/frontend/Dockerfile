## Multi-stage Dockerfile for the frontend application
# ---------- Stage 1: Build ----------
FROM node:22-alpine AS builder

WORKDIR /app

# Copy only package manifests first for layer caching
COPY package.json ./

# Install dependencies (including dev dependencies for building)
RUN npm install

# Copy the rest of the source code
COPY . ./

# Vite bakes env vars in at build time. Leave empty to call the API on the same
# origin (/api routed by the ingress); set for standalone runs, e.g. docker compose.
ARG VITE_API_URL=""
ENV VITE_API_URL=${VITE_API_URL}

# Build the production assets
RUN npm run build

# ---------- Stage 2: Runtime ----------
# Unprivileged nginx runs as a non-root user (uid 101)
FROM nginxinc/nginx-unprivileged:1.27-alpine AS runtime

ARG VITE_API_URL=""

COPY nginx.conf /etc/nginx/conf.d/default.conf
# Allow the browser to reach an external API origin when one is configured
RUN sed -i "s|__API_ORIGIN__|${VITE_API_URL}|" /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 3000
