#!/bin/sh
set -e

echo "==> Setting up WordPress..."

cd /var/www/html

echo "==> Waiting for MariaDB..."

mariadb-admin ping \
	--protocol=tcp \
	--host=mariadb \
	-u "${WORDPRESS_DATABASE_USER}" \
	--password="${WORDPRESS_DATABASE_USER_PASSWORD}" \
	--wait=300

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "==> Installing WordPress..."

	wp core download \
		--allow-root \
		--path=/var/www/html

	wp config create \
		--dbname="${WORDPRESS_DATABASE_NAME}" \
		--dbuser="${WORDPRESS_DATABASE_USER}" \
		--dbpass="${WORDPRESS_DATABASE_USER_PASSWORD}" \
		--dbhost=mariadb \
		--allow-root \
		--path=/var/www/html

	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--allow-root \
		--skip-email \
		--path=/var/www/html

	wp user create \
		"${WORDPRESS_USER}" \
		"${WORDPRESS_USER_EMAIL}" \
		--role=subscriber \
		--user_pass="${WORDPRESS_USER_PASSWORD}" \
		--allow-root \
		--path=/var/www/html

	echo "==> WordPress installed successfully!"
else
	echo "==> WordPress is already installed."
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "==> Starting PHP-FPM..."

exec php-fpm83 -F
