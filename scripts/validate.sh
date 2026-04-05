#!/bin/bash
sleep 5
curl -f -s -o /dev/null http://localhost/login/
if [ $? -ne 0 ]; then
  echo "Health check failed"
  exit 1
fi
echo "Health check passed"