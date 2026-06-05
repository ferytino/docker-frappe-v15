#!/bin/bash

set -e

cd /home/ubuntu/frappe

if [ ! -f bench/Procfile ]; then
    echo "Initializing Bench..."
    bench init \
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

if [ ! -d apps/erp_customization ]; then
    bench get-app --branch master https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/ferytino/erp_customization.git
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
# ------------------------------------------------------------------
if [ ! -d sites/${SITE_NAME} ]; then
    bench new-site \
        ${SITE_NAME} \
        --db-host ${DB_HOST} \
        --db-root-username root \
        --db-root-password ${MYSQL_ROOT_PASSWORD} \
        --admin-password ${ADMIN_PASSWORD}

    bench --site ${SITE_NAME} enable-scheduler
    bench --site ${SITE_NAME} set-config developer_mode 1
    bench --site ${SITE_NAME} set-config maintenance_mode 0
    bench --site ${SITE_NAME} install-app erpnext
    bench --site ${SITE_NAME} install-app print_designer
    bench --site ${SITE_NAME} install-app erp_customization
fi
