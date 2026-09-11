#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "==> Initializing MariaDB..."

	mariadb-install-db \
		--user=mysql \
		--datadir=/var/lib/mysql \
		--skip-test-db

	echo "==> Preparing initial database configuration..."

	cat > /run/mysqld/init.sql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WORDPRESS_DATABASE_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DATABASE_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WORDPRESS_DATABASE_NAME}\`.* TO '${WORDPRESS_DATABASE_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	chown mysql:mysql /run/mysqld/init.sql
	chmod 600 /run/mysqld/init.sql

	echo "==> Starting MariaDB for first initialization..."
	exec mariadbd \
		--defaults-file=/etc/my.cnf.d/mariadb_config \
		--user=mysql \
		--init-file=/run/mysqld/init.sql
fi

echo "==> Starting MariaDB..."

exec mariadbd \
	--defaults-file=/etc/my.cnf.d/mariadb_config \
	--user=mysql
