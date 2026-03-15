FROM amazonlinux:2023 AS builder

RUN dnf install -y \
    python3-pip \
    gcc \
    python3-devel \
    httpd-devel \
    python3-setuptools \
    mariadb-connector-c-devel \
    && dnf clean all

COPY requirements.txt .
RUN pip3 install --no-warn-script-location mod_wsgi
RUN pip3 install --no-warn-script-location -r requirements.txt

FROM amazonlinux:2023

RUN dnf install -y \
    python3 \
    httpd \
    mariadb-connector-c \
    && dnf clean all

ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages:/usr/local/lib64/python3.9/site-packages

COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=builder /usr/local/lib64/python3.9/site-packages/ /usr/local/lib64/python3.9/site-packages/

WORKDIR /app
COPY . .

COPY wsgi.conf /etc/httpd/conf.d/wsgi.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]