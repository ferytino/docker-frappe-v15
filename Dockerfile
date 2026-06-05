FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# System packages
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        wget \
        nano \
        sudo \
        cron \
        supervisor \
        build-essential \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        libssl-dev \
        libffi-dev \
        libmariadb-dev \
        libmariadb-dev-compat \
        pkg-config \
        mariadb-client \
        redis-server \
        redis-tools \
        xvfb \
        libfontconfig1 \
        wkhtmltopdf && \
    rm -rf /var/lib/apt/lists/*

# Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Yarn
RUN npm install -g yarn

# docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Ubuntu user
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#RUN useradd -u 1000 -m -s /bin/bash coworker && \
#    echo "coworker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/ubuntu/frappe && \
    chown -R ubuntu:ubuntu /home/ubuntu

USER ubuntu

WORKDIR /home/ubuntu

RUN python3 -m venv /home/ubuntu/venv

ENV PATH="/home/ubuntu/venv/bin:${PATH}"

# Bench
RUN pip install --upgrade pip wheel setuptools && \
    pip install click==8.1.7 && \
    pip install frappe-bench==5.29.1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["bash"]