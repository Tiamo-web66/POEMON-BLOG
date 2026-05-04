# ========== Stage 1: Build Vue app ==========
FROM node:18-alpine AS builder

WORKDIR /app

ENV npm_config_audit=false \
    npm_config_fund=false \
    npm_config_registry=https://registry.npmmirror.com

RUN npm install -g npm@8.19.4

COPY package*.json ./
RUN npm ci --include=dev --ignore-scripts

COPY . .

ARG VITE_API_BASE_URL=/api
ARG VITE_WEB_URL=http://localhost
ARG VITE_SITE_URL=http://localhost

ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
ENV VITE_WEB_URL=${VITE_WEB_URL}
ENV VITE_SITE_URL=${VITE_SITE_URL}

RUN npm run build

# ========== Stage 2: Serve static files ==========
FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
