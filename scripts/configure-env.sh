#!/bin/sh
# Generate srcs/.env and secrets/ files for a given login.
# Usage: ./scripts/configure-env.sh <login> [fixed_password]
#
# With no second argument every password is randomly generated.
# Pass one (e.g. "password") to use it for all of them — handy while developing,
# so credentials stay the same across reinstalls.

set -e

LOGIN="${1:-achowdhu}"
FIXED_PASS="${2:-}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/srcs/.env"
SECRETS_DIR="${ROOT}/secrets"

if [ -z "$1" ]; then
	echo "Usage: $0 <login> [fixed_password]"
	echo "Example: $0 achowdhu"
	echo "Example: $0 achowdhu password"
	exit 1
fi

mkdir -p "$SECRETS_DIR"

rand() {
	if [ -n "$FIXED_PASS" ]; then
		printf '%s' "$FIXED_PASS"
	elif command -v openssl >/dev/null 2>&1; then
		openssl rand -base64 24 | tr -d '/+=' | head -c 24
	else
		date +%s | sha256sum | head -c 24
	fi
}

DB_USER_PASS="$(rand)"
ROOT_PASS="$(rand)"
ADMIN_PASS="$(rand)"
USER_PASS="$(rand)"

cat > "${SECRETS_DIR}/db_password.txt" <<EOF
${DB_USER_PASS}
EOF

cat > "${SECRETS_DIR}/db_root_password.txt" <<EOF
${ROOT_PASS}
EOF

cat > "${SECRETS_DIR}/credentials.txt" <<EOF
WordPress admin (${LOGIN}): ${ADMIN_PASS}
WordPress user (${LOGIN}_user): ${USER_PASS}
MariaDB root: ${ROOT_PASS}
MariaDB app user (wp_db_user): ${DB_USER_PASS}
EOF

chmod 600 "${SECRETS_DIR}"/*.txt

cat > "$ENV_FILE" <<EOF
LOGIN=${LOGIN}
DOMAIN_NAME=${LOGIN}.42.fr
DATA_PATH=/home/${LOGIN}/data

WORDPRESS_TITLE=Inception
WORDPRESS_DATABASE_NAME=wordpress_db

WORDPRESS_DATABASE_USER=wp_db_user
WORDPRESS_DATABASE_USER_PASSWORD=${DB_USER_PASS}

WORDPRESS_ADMIN=${LOGIN}
WORDPRESS_ADMIN_PASSWORD=${ADMIN_PASS}
WORDPRESS_ADMIN_EMAIL=${LOGIN}@student.hive.fi

WORDPRESS_USER=${LOGIN}_user
WORDPRESS_USER_PASSWORD=${USER_PASS}
WORDPRESS_USER_EMAIL=${LOGIN}.user@student.hive.fi

MYSQL_ROOT_PASSWORD=${ROOT_PASS}
EOF

chmod 600 "$ENV_FILE"

echo "Created ${ENV_FILE}"
echo "Created secrets in ${SECRETS_DIR}/"
echo "Domain: ${LOGIN}.42.fr"
echo "Run: make LOGIN=${LOGIN}"
