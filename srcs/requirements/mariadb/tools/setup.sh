#!/bin/bash

# Check if the database already exists
if [ ! -d "/var/lib/mysql/${WORDPRESS_DATABASE_NAME}" ]; then
    service mariadb start
    sleep 3

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DATABASE_NAME}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${WORDPRESS_DATABASE_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_DATABASE_USER_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${WORDPRESS_DATABASE_NAME}\`.* TO \`${WORDPRESS_DATABASE_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

exec mysqld_safe
