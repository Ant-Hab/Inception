#!/bin/bash

# Start the service temporarily to create the database and users
service mariadb start
sleep 3

# Create the database and user using the variables from the .env file
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Shut down the temporary service
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MariaDB safely in the foreground so the container stays running
exec mysqld_safe
