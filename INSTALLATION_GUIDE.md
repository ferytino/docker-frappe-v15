# Ferytino v15 Image (ferytino:v15-image-r1) — Installation Steps

## Prerequisites

- Docker and Docker Compose installed on the host.
- `compose.yml` present in the project directory.
- `.env_example` and `install-erpnext.sh` available in the project folder.

## 1. Create project folders

Run these commands to create and enter your project directory:

```bash
mkdir <your-docker-project-directory>
cd <your-docker-project-directory>
```

Create the application and data folders:

```bash
mkdir -p frappe
mkdir -p data
mkdir -p data/mariadb
```

## 2. Pull and start the containers

Pull the prebuilt image:

```bash
docker pull ferytino:v15-image-r1
```

Start the containers in detached mode:

```bash
docker compose up -d
```

## 3. Install ERPNext inside the container

Copy `.env_example` to `.env`, then update all variables with your own values. If `.env` already exists, open it and confirm the settings are correct.

Make sure `install-erpnext.sh` is available in the project folder, then enter the Frappe container and run the installer:

```bash
cp .env_example .env
# edit .env as needed before continuing
docker compose exec frappe bash
bash install-erpnext.sh
```

> Note: Installation typically takes approximately 30 minutes on a host with 8 GB RAM.

## 4. Start and select the site

Change to the bench directory and select your site:

```bash
cd /home/ubuntu/frappe/bench
bench use dev_site1.localhost
```

Start the bench server:

```bash
bench start
```

Open your browser to:

- http://localhost:8000

If you use a different site name, replace `dev_site1.localhost` with your site name.

## 5. Initial setup

Complete the initial setup wizard in the browser and enable/configure:

- Frappe Framework
- ERPNext
- Print Designer

Log in as the `Administrator` user and begin using your ERPNext environment.

## Restart later

When you want to start the environment again, use these commands:

```bash
docker compose up -d
docker compose exec frappe bash
cd bench
bench use dev_site1.localhost  # optional: confirm the development site name
bench start
```

Then open your browser at:

```text
http://localhost:8000
```

## Troubleshooting & Notes

- Ensure required host ports (for example, 8000) are available and not blocked by firewalls.
- Check container status with `docker compose ps`.
- If containers fail to start, inspect logs with `docker compose logs` or `docker compose logs frappe`.

---

If you'd like, I can also add examples for common `docker compose` commands or convert this into a more detailed README section.
