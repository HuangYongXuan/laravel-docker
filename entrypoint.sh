#!/usr/bin/env bash
chmod 777 /usr/sbin/entrypoint.sh
nohup php-fpm &
nohup /usr/sbin/nginx -g daemon off &