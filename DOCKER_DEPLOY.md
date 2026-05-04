# Docker Compose Deployment

This repository now supports a full Docker Compose deployment:

- `mysql`: MySQL 8.0 with persistent data volume.
- `backend`: Go API service built from `My-Blog-Go/Dockerfile`.
- `frontend`: Vue app built with Node and served by Nginx.
- Nginx serves the Vue SPA and proxies `/api` to `backend:8000`.
- `docker/mysql/init-schema.sh` imports `My-Blog-Go/database/schema.sql` on the first MySQL volume initialization.

## Step-by-step checklist

1. Create the Docker environment file.

   ```powershell
   Copy-Item .env.docker.example .env
   ```

2. Edit `.env`.

   Required production changes:

   - `MYSQL_ROOT_PASSWORD`
   - `MYSQL_APP_PASSWORD`
   - `JWT_SECRET`
   - `VITE_WEB_URL`
   - `VITE_SITE_URL`
   - `SITE_URL`
   - `CORS_ALLOWED_ORIGINS`

   If port `80` is already in use, set `FRONTEND_PORT=8080` and also set `VITE_WEB_URL`, `VITE_SITE_URL`, `SITE_URL`, and `CORS_ALLOWED_ORIGINS` to the same public address.

3. Build and start all services.

   ```powershell
   docker compose up -d --build
   ```

4. Check container status.

   ```powershell
   docker compose ps
   ```

5. Watch logs if a service is not healthy.

   ```powershell
   docker compose logs -f mysql
   docker compose logs -f backend
   docker compose logs -f frontend
   ```

6. Open the site.

   - Default: `http://localhost`
   - If `FRONTEND_PORT=8080`: `http://localhost:8080`

## Important notes

- Do not copy the old root `.env.example` directly for Docker deployment. Use `.env.docker.example`, because Compose creates a dedicated MySQL application user.
- The SQL file in `docker-entrypoint-initdb.d` only runs when the `mysql_data` volume is first created. If you need to reinitialize the database, stop the stack and remove the volume:

  ```powershell
  docker compose down -v
  ```

- Frontend variables beginning with `VITE_` are build-time values. After changing them, rebuild the frontend:

  ```powershell
  docker compose up -d --build frontend
  ```

- For production behind HTTPS, terminate TLS in a reverse proxy or CDN in front of the `frontend` container, then set all public URLs in `.env` to the HTTPS domain.
