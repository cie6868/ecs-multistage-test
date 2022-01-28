#!/bin/sh

echo "Version: ECS"

echo "Updating app version in code"
ROOT_DIR=/usr/share/nginx/html
for file in $ROOT_DIR/static/js/*.js* $ROOT_DIR/index.html;
do
  echo "Processing $file ...";

  sed -i "s|__APP_NAME|ECS|g" $file
done

echo 'Starting nginx...'
nginx -g 'daemon off;'