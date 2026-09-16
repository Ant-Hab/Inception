#!/bin/sh
set -e

# Create the MariaDB runtime directory
mkdir -p /run/mysqld

# Give MariaDB ownership of its runtime and data directories
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Check if MariaDB has already been initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "==> Initializing MariaDB..."

	# Initialize the MariaDB data directory
	mariadb-install-db \
		--user=mysql \
		--datadir=/var/lib/mysql \
		--skip-test-db

	echo "==> Preparing initial database configuration..."

	# Create the SQL commands for the initial MariaDB setup
	cat > /run/mysqld/init.sql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WORDPRESS_DATABASE_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DATABASE_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WORDPRESS_DATABASE_NAME}\`.* TO '${WORDPRESS_DATABASE_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	# Give MariaDB ownership of the initialization file
	chown mysql:mysql /run/mysqld/init.sql

	# Restrict access to the initialization file
	chmod 600 /run/mysqld/init.sql

	echo "==> Starting MariaDB for first initialization..."

	# Start MariaDB and run the initial SQL configuration
	exec mariadbd \
		--defaults-file=/etc/my.cnf.d/mariadb_config \
		--user=mysql \
		--init-file=/run/mysqld/init.sql
fi

echo "==> Starting MariaDB..."

# Start MariaDB using the custom configuration
exec mariadbd \
	--defaults-file=/etc/my.cnf.d/mariadb_config \
	--user=mysql
