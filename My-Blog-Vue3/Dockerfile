# ========== Stage 1: Build Vue app ==========
FROM node:20-alpine AS builder

WORKDIR /app

ENV npm_config_audit=false \
    npm_config_fund=false \
    npm_config_registry=https://registry.npmmirror.com

COPY package*.json ./
RUN npm install --include=dev --ignore-scripts || true
RUN npm install -D vite@^5.0.0 @vitejs/plugin-vue@^5.0.0 typescript@^5.9.3 vue-tsc@^3.2.4 rollup-plugin-visualizer@^6.0.5 unplugin-auto-import@^0.17.0 unplugin-vue-components@^0.25.0 --ignore-scripts

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
