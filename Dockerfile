FROM amazonlinux:2023 AS base

RUN dnf install -y \
    python3.13 \
    httpd \
    && dnf clean all

ENV PATH=/app/venv/bin:$PATH

FROM base AS builder

RUN dnf install -y \
    python3.13-pip \
    python3.13-devel \
    python3.13-setuptools \
    gcc \
    httpd-devel \
    pkgconfig \
    openssl-devel \
    && dnf install -y https://repo.mysql.com/mysql84-community-release-el9-3.noarch.rpm \
    && sed -i 's/\$releasever/9/g' /etc/yum.repos.d/mysql*.repo \
    && dnf install -y mysql-community-devel \
    && dnf clean all

RUN python3.13 -m venv /app/venv

COPY requirements.txt .
RUN pip install mod_wsgi
RUN pip install -r requirements.txt

FROM base AS runtime

RUN dnf install -y https://repo.mysql.com/mysql84-community-release-el9-3.noarch.rpm \
    && sed -i 's/\$releasever/9/g' /etc/yum.repos.d/mysql*.repo \
    && dnf install -y mysql-community-libs \
    && dnf clean all

RUN useradd -r -s /sbin/nologin appuser

COPY --from=builder /app/venv /app/venv

WORKDIR /app
COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]