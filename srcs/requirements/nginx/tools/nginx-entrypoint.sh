#!/bin/sh
set -e

DOMAIN="${DOMAIN_NAME:-achowdhu.42.fr}"

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	echo "==> Generating SSL certificate for ${DOMAIN}..."

	openssl req -x509 -nodes -days 365 \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN}"
fi

exec nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
