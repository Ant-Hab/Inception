FROM alpine:3.23.5

RUN apk add --no-cache \
mariadb-client \
php83 \
php83-fpm \
php83-phar \
php83-curl \
php83-mysqli \
php83-iconv \
php83-json \
php83-mbstring \
php83-xml \
wget

RUN ln -s /usr/bin/php83 /usr/bin/php

RUN addgroup -S www-data 2>/dev/null || true \
&& adduser -S -D -H -s /sbin/nologin -G www-data www-data 2>/dev/null || true

RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
-O /usr/local/bin/wp \
&& chmod +x /usr/local/bin/wp

RUN printf 'memory_limit = 256M\nmax_execution_time = 120\n' \
>> /etc/php83/php.ini

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

RUN mkdir -p /var/www/html

COPY ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh
RUN chmod +x /usr/local/bin/wordpress-script.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["wordpress-script.sh"]
