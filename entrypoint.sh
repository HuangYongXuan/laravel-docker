#!/usr/bin/env bash
chmod 777 /usr/sbin/entrypoint.sh
php-fpm
sh /usr/sbin/nginx -g daemon off;