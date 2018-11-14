#!/usr/bin/env bash
nohup php-fpm &
nohup /usr/sbin/nginx -g daemon off &