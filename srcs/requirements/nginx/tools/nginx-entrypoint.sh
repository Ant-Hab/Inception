#!/bin/sh
set -e

# Set the domain name or use the default 42.fr domain
DOMAIN="${DOMAIN_NAME:-achowdhu.42.fr}"

# Check if the SSL certificate does not already exist
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	echo "==> Generating SSL certificate for ${DOMAIN}..."

	# Generate a self-signed SSL certificate
	openssl req -x509 -nodes -days 365 \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN}"
fi

# Start Nginx in the foreground
exec nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
