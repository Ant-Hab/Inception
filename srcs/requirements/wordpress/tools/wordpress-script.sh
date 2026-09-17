#!/bin/sh
set -e

# Check if wp-config.php exists; if not, install WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
	echo "WordPress not found. Waiting for MariaDB to initialize..."

	# Wait until MariaDB is ready to accept connections
	until mariadb-admin ping \
		-h mariadb \
		-u"$WORDPRESS_DATABASE_USER" \
		-p"$WORDPRESS_DATABASE_USER_PASSWORD" \
		--silent
	do
		sleep 2
	done

	# Download WordPress core files
	wp core download --allow-root

	# Create wp-config.php
	wp config create \
		--dbname="$WORDPRESS_DATABASE_NAME" \
		--dbuser="$WORDPRESS_DATABASE_USER" \
		--dbpass="$WORDPRESS_DATABASE_USER_PASSWORD" \
		--dbhost=mariadb \
		--allow-root

	# Install WordPress
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="Inception 42" \
		--admin_user="$WORDPRESS_ADMIN" \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_EMAIL" \
		--allow-root

	# Create the regular user required by the subject
	wp user create \
		"$WORDPRESS_USER" \
		"$WORDPRESS_USER_EMAIL" \
		--role=author \
		--user_pass="$WORDPRESS_USER_PASSWORD" \
		--allow-root

	echo "WordPress installed successfully!"
else
	echo "WordPress is already installed."
fi

# Start PHP-FPM in the foreground
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm83 -F
