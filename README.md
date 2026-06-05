# ferytino/frappe:v15-image-r1

Frappe Framework v15 Docker Image for ERPNext Development and Deployment.

## Features

* Ubuntu 24.04
* Python 3
* Node.js 18
* Yarn
* Frappe Bench 5.29.1
* MariaDB Client
* Redis Tools
* wkhtmltopdf

## Pull Image

```bash
docker pull ferytino/frappe:v15-image-r1
```

## Quick Test

Start an interactive shell:

```bash
docker run --rm -it ferytino/frappe:v15-image-r1 bash
```

Verify Bench installation:

```bash
bench --version
```

## ERPNext Installation

This image provides the Frappe runtime environment.

For ERPNext installation scripts, Docker Compose files, and setup guides, please visit:

https://github.com/ferytino/frappe-docker

## Included Bootstrap

The companion repository includes:

* bootstrap-erpnext.sh
* Docker Compose examples
* Linux setup guide
* Windows setup guide
* macOS setup guide

## License

MIT License

## Maintainer

Ferytino Maslianto

GitHub: https://github.com/ferytino
