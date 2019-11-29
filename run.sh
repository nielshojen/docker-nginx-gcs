#!/bin/sh

sed -i "s/proxy_cache_path.*/proxy_cache_path \/cache levels=1:2 keys_zone=gcs:1024m max_size=${CACHE_MAX_SIZE} inactive=${CACHE_INACTIVE} use_temp_path=off;/" /etc/nginx/conf.d/proxy.conf

chown -R nginx:root /cache 

nginx

/usr/bin/gcs-helper
