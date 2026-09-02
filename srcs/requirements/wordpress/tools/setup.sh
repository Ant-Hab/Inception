#!/bin/bash

# Give MariaDB a few seconds to start up
sleep 10

# Check if wp-config.php exists; if not, install WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found. Installing..."

    # Download WordPress core files
    wp core download --allow-root

    # Create wp-config.php
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    # Install WordPress
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception 42" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Create the regular user required by the subject
    wp user create \
        $WP_USER \
        $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --allow-root

    echo "WordPress installed successfully!"
else
    echo "WordPress is already installed."
fi

# Start PHP-FPM in the foreground
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F
