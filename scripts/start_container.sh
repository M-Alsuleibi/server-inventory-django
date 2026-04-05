#!/bin/bash
set -e

IMAGE_URI=$(python3 -c "import json; print(json.load(open('/app/deployment/imageDetail.json'))['ImageURI'])")

docker run --rm \
  -e FETCH_SECRETS=true \
  -e AWS_DEFAULT_REGION=us-east-1 \
  $IMAGE_URI \
  /app/venv/bin/python manage.py migrate --noinput

docker run -d \
  --name django-app \
  --restart unless-stopped \
  -p 80:80 \
  -e FETCH_SECRETS=true \
  -e AWS_DEFAULT_REGION=us-east-1 \
  $IMAGE_URI