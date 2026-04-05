#!/bin/bash
docker stop django-app 2>/dev/null || true
docker rm django-app 2>/dev/null || true