FROM debian:bookworm

# Install PHP, MySQL extensions, and tools like curl/wget
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php8.2 php-fpm php-mysql mariadb-client curl wget

# Download a specific stable release of WP-CLI to bypass 429 errors
RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar && \
    chmod +x wp-cli-2.11.0.phar && \
    mv wp-cli-2.11.0.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on port 9000 instead of a unix socket
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

# Create the PID directory for PHP-FPM
RUN mkdir -p /run/php

# Copy the setup script
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/tmp/setup.sh"]
