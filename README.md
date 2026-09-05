# MODX + MiniShop3 Docker

Automated MODX CMS + MiniShop3 deployment from source in Docker containers.

## Features

- **Automatic installation** — no browser wizard required
- **Ready-to-use environment** — Nginx + PHP-FPM + MySQL + phpMyAdmin
- **Reproducibility** — single command deploys identical environment
- **Git-based installation** — fresh code from GitHub repositories
- **MiniShop3 included** — pdoTools, VueTools, MiniShop3 built from source

## Services

| Service | Port | Description |
|---------|------|-------------|
| nginx | 8080 | Web server |
| php-fpm | — | PHP 8.2 |
| mysql | 3306 | Database |
| pma | 8090 | phpMyAdmin |

## Quick Start

### ⚠️ IMPORTANT: Create www folder beforehand

**You must create an empty `www` folder before starting:**

```bash
mkdir www
```

If you skip this step, Docker will create it as root and PHP won't be able to write files.

### Installation

1. Copy `.env.sample` to `.env`:
   ```bash
   cp .env.sample .env
   ```

2. Edit `.env` if needed (passwords, MODX version, etc.)

3. Create empty `www` folder:
   ```bash
   mkdir www
   ```

4. Start containers:
   ```bash
   docker-compose up -d
   ```

5. Wait for installation to complete (watch logs):
   ```bash
   docker-compose logs -f php-fpm
   ```

6. Open:
   - Site: http://localhost:8080
   - Admin panel: http://localhost:8080/manager/
   - phpMyAdmin: http://localhost:8090

## Configuration (.env)

| Variable | Description | Default |
|----------|-------------|---------|
| PUID/PGID | User UID/GID | 1000 |
| MODX_GIT_BRANCH | MODX version | v3.0.5-pl |
| MYSQL_PASSWORD | Database password | modx |
| MODX_ADMIN_USER | Admin login | admin |
| MODX_ADMIN_PASSWORD | Admin password | admin123 |

## Installed Packages

Built from source (GitHub):
- **pdoTools** — fast snippets library with Fenom
- **VueTools** — Vue 3 + PrimeVue for admin interface
- **MiniShop3** — e-commerce solution for MODX 3

## Known Issues

- **www directory permissions**: If the `www` directory does not exist when the container is created, Docker will mount it as root. The PHP process will not be able to create files in it. You must create the `www` directory beforehand with the correct user permissions.
- **Empty www directory required**: You cannot create a non-empty `www` directory beforehand, as the git clone operation will fail if the directory is not empty. Ensure the directory exists but is empty before starting the container.
- **First build takes time**: Building packages from source requires downloading npm dependencies and compiling Vue components. First run may take 5-10 minutes.
