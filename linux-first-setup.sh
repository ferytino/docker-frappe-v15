#!/bin/bash

set -e

mkdir -p frappe
mkdir -p data/mariadb

chown -R ferytino:ferytino frappe
chown -R ferytino:ferytino data
chown -R ferytino:ferytino data/mariadb

chmod 775 frappe
chmod 775 data
chmod 775 data/mariadb

echo "Linux Workspace initialized."
echo "UID/GID mapping expected via compose.yml"