# Frappe Site Setup, Base App Installation, and App Retrieval

This guide explains how to create a new Frappe site, configure it for development, install base applications such as ERPNext and Print Designer, and retrieve custom Frappe applications from GitHub.

---

## 1. Create a New Site

Create a new Frappe site using the following command:

```bash
bench new-site \
    <site_name.localhost> \
    --db-host mariadb \
    --db-name <site_db_name> \
    --db-password <site_db_password> \
    --db-root-username root \
    --db-root-password <root_password> \
    --admin-password <frappe_administrator_password>
```

### Example

```bash
bench new-site \
    demo.localhost \
    --db-host mariadb \
    --db-name demo_db \
    --db-password my_db_password \
    --db-root-username root \
    --db-root-password root_password \
    --admin-password admin_password
```

---

## 2. Activate the Site

Set the newly created site as the active site:

```bash
bench use <site_name.localhost>
```

### Example

```bash
bench use demo.localhost
```

---

## 3. Configure the Site for Development

Enable the scheduler and configure development settings:

```bash
bench --site <site_name.localhost> enable-scheduler

bench --site <site_name.localhost> set-config developer_mode 1

bench --site <site_name.localhost> set-config maintenance_mode 0
```

---

## 4. Install Base Applications (Optional)

If ERPNext and Print Designer are already available in the `apps` directory, install them on the site.

### Install ERPNext

```bash
bench --site <site_name.localhost> install-app erpnext
```

### Install Print Designer

```bash
bench --site <site_name.localhost> install-app print_designer
```

### Example

```bash
bench --site demo.localhost install-app erpnext

bench --site demo.localhost install-app print_designer
```

---

## 5. Retrieve a Frappe Application from GitHub

Download a Frappe application from a Git repository:

```bash
bench get-app <frappe_app_name> --branch <branch_name> <github_url>
```

### Parameters

| Parameter           | Description                    |
| ------------------- | ------------------------------ |
| `<frappe_app_name>` | Name of the Frappe application |
| `<branch_name>`     | Git branch to retrieve         |
| `<github_url>`      | GitHub repository URL          |

### Example

```bash
bench get-app oscore_dummy \
    --branch main \
    https://git_user:ghp_xxxxxxxxxxxxxxxxxxxx@github.com/ferytino/oscore_dummy.git
```

Where:

* `oscore_dummy` = Frappe application name
* `main` = Git branch name
* `git_user` = Your GitHub username
* `ghp_xxxxxxxxxxxxxxxxxxxx` = Your GitHub Personal Access Token (PAT)

> **Security Note:** Avoid embedding Personal Access Tokens directly in scripts or documentation intended for public distribution.

---

## 6. Install the Custom Application

After downloading the application, install it on the site:

```bash
bench --site <site_name.localhost> install-app <frappe_app_name>
```

### Example

```bash
bench --site demo.localhost install-app oscore_dummy
```

---

## 7. Apply Database Migrations

Update the database schema and synchronize all installed applications:

```bash
bench --site <site_name.localhost> migrate
```

### Example

```bash
bench --site demo.localhost migrate
```

---

## 8. Start Frappe in Development Mode

Start all Frappe development services:

```bash
bench start
```

---

# Useful Commands

## List Installed Applications

```bash
bench --site <site_name.localhost> list-apps
```

## Show Available Sites

```bash
ls sites/
```

## Switch Active Site

```bash
bench use <site_name.localhost>
```

## Clear Cache

```bash
bench --site <site_name.localhost> clear-cache
```

## Restart Bench

```bash
bench restart
```

---

# Typical Development Workflow

```bash
# Create a site
bench new-site <site_name.localhost>

# Activate the site
bench use <site_name.localhost>

# Configure development settings
bench --site <site_name.localhost> enable-scheduler
bench --site <site_name.localhost> set-config developer_mode 1
bench --site <site_name.localhost> set-config maintenance_mode 0

# Retrieve custom applications
bench get-app <frappe_app_name> --branch <branch_name> <github_url>

# Install applications
bench --site <site_name.localhost> install-app <frappe_app_name>

# Apply database migrations
bench --site <site_name.localhost> migrate

# Application Fixture Exports
bench --site <site_name.localhost> export-fixtures --app <frappe_app_name>

# Start development services
bench start
```
