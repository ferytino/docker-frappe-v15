#!/bin/bash
set -e

WORKSPACE_PATH=${WORKSPACE_PATH:-/home/ubuntu/frappe}

if [ ! -d "$WORKSPACE_PATH" ]; then
    echo "$WORKSPACE_PATH volume not mounted"
    exit 1
fi

cd "$WORKSPACE_PATH"

if [ -f bench/sites/common_site_config.json ]; then

    cd bench

    bench set-config -g db_host "${DB_HOST}" || true
    bench set-config -g redis_cache "${REDIS_CACHE}" || true
    bench set-config -g redis_queue "${REDIS_QUEUE}" || true
    bench set-config -g redis_socketio "${REDIS_SOCKETIO}" || true

fi

exec "$@"