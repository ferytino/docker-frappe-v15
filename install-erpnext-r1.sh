#!/bin/bash

set -e

export MALLOC_ARENA_MAX=2

cd /home/ubuntu/frappe

if [ ! -f bench/Procfile ]; then
    echo "Initializing Bench..."
    bench --verbose init \
        --frappe-branch ${FRAPPE_BRANCH} \
        bench

fi

cd bench

# ------------------------------------------------------------------
# Environment Configuration
# ------------------------------------------------------------------
bench set-config -g db_host "${DB_HOST}"
bench set-config -g redis_cache "${REDIS_CACHE}"
bench set-config -g redis_queue "${REDIS_QUEUE}"
bench set-config -g redis_socketio "${REDIS_SOCKETIO}"

if [ ! -d apps/erpnext ]; then
    bench get-app --branch ${ERPNEXT_BRANCH} erpnext
fi

if [ ! -d apps/print_designer ]; then
    bench get-app print_designer
fi

# ------------------------------------------------------------------
# Wait for MariaDB
# ------------------------------------------------------------------
until mysql \
    -h "${DB_HOST}" \
    -u root \
    -p"${MYSQL_ROOT_PASSWORD}" \
    -e "SELECT 1" >/dev/null 2>&1
do
    echo "Waiting for MariaDB..."
    sleep 2
done

# ------------------------------------------------------------------
# Create Site
# Use a marker file instead of directory check — the directory is
# created before migrations complete, so a partial install would
# skip this entire block on re-run and leave a broken database.
# ------------------------------------------------------------------
MARKER="sites/${SITE_NAME}/.install_complete"

if [ ! -f "$MARKER" ]; then
    # Clean up any partial previous attempt and the MariaDB-init database
    if [ -d "sites/${SITE_NAME}" ]; then
        echo "Removing incomplete site from previous attempt..."
        rm -rf "sites/${SITE_NAME}"
    fi
    mysql -h "${DB_HOST}" -u root -p"${MYSQL_ROOT_PASSWORD}" \
        -e "DROP DATABASE IF EXISTS \`${MYSQL_DATABASE}\`;" 2>/dev/null || true

    bench new-site \
        ${SITE_NAME} \
        --db-host ${DB_HOST} \
        --db-name ${MYSQL_DATABASE} \
        --db-password ${MYSQL_PASSWORD} \
        --db-root-username root \
        --db-root-password ${MYSQL_ROOT_PASSWORD} \
        --admin-password ${ADMIN_PASSWORD}

    bench --site ${SITE_NAME} enable-scheduler
    bench --site ${SITE_NAME} set-config developer_mode 1
    bench --site ${SITE_NAME} set-config maintenance_mode 0
    bench --site ${SITE_NAME} install-app erpnext
    bench --site ${SITE_NAME} install-app print_designer

    touch "$MARKER"
    echo "Site installation complete."
else
    echo "Site already installed, running migrate to ensure up to date..."
    bench --site ${SITE_NAME} migrate
fi
