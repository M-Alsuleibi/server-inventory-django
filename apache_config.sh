#!/bin/bash

PROCESSES=2
THREADS=5
PORT=80
HOST=0.0.0.0
WSGI_MODULE=server_inventory/wsgi.py
STATIC_URL=/static/
STATIC_ROOT=/app/staticfiles/

exec mod_wsgi-express start-server \
    --host $HOST \
    --port $PORT \
    --processes $PROCESSES \
    --threads $THREADS \
    --user appuser \
    --group appuser \
    --url-alias $STATIC_URL $STATIC_ROOT \
    $WSGI_MODULE