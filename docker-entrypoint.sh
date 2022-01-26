#!/bin/sh

echo "Version: APP_NAME"

echo "Updating app version in code"
ROOT_DIR=/usr/share/nginx/html
for file in $ROOT_DIR/static/js/app.*.js* $ROOT_DIR/index.html $ROOT_DIR/precache-manifest*.js;
do
  echo "Processing $file ...";

  sed -i "s|__APP_NAME|APP_NAME|g" $file
done

echo 'Starting nginx...'
nginx -g 'daemon off;'