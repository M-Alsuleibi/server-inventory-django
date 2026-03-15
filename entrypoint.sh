#!/bin/bash
python3 manage.py collectstatic --noinput
python3 manage.py migrate --noinput

# echo "Creating superuser if not exists..."
# python3 manage.py shell -c "
# from django.contrib.auth import get_user_model
# User = get_user_model()
# if not User.objects.filter(username='${DJANGO_SUPERUSER_USERNAME}').exists():
#     User.objects.create_superuser('${DJANGO_SUPERUSER_USERNAME}', '${DJANGO_SUPERUSER_EMAIL}', '${DJANGO_SUPERUSER_PASSWORD}')
#     print('Superuser created.')
# else:
#     print('Superuser already exists, skipping.')
# "
# docker compose exec web python3 manage.py createsuperuser

exec httpd -D FOREGROUND