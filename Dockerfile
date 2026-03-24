FROM amazonlinux:2023 AS base

RUN dnf install -y \
    python3.13 \
    httpd \
    && dnf clean all


FROM base AS builder

RUN dnf install -y \
    python3.13-pip \
    python3.13-devel \
    python3.13-setuptools \
    gcc \
    httpd-devel \
    pkgconfig \
    openssl-devel \
    && dnf clean all

RUN rpm -Uhv https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm \
    && dnf install -y \
       mysql-community-devel \
       mysql-community-libs \
    && dnf clean all

RUN python3.13 -m venv /app/venv

COPY requirements.txt .
RUN /app/venv/bin/pip install mod_wsgi
RUN /app/venv/bin/pip install -r requirements.txt


FROM base AS app

RUN useradd -r -s /sbin/nologin appuser

COPY --from=builder /app/venv /app/venv
COPY --from=builder /usr/lib64/mysql/ /usr/lib64/mysql/
RUN echo "/usr/lib64/mysql" > /etc/ld.so.conf.d/mysql.conf && ldconfig
WORKDIR /app
COPY . .

RUN SECRET_KEY=dummy \
    DB_NAME=dummy \
    DB_USER=dummy \
    DB_PASSWORD=dummy \
    DB_HOST=dummy \
    DB_PORT=3306 \
    /app/venv/bin/python manage.py collectstatic --noinput

COPY entrypoint.sh /entrypoint.sh
COPY apache_config.sh /apache_config.sh
RUN chmod +x /entrypoint.sh /apache_config.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]