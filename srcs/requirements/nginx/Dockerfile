FROM alpine:3.23.5

RUN apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./tools/nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh
RUN chmod +x /usr/local/bin/nginx-entrypoint.sh

RUN mkdir -p /var/www/html \
&& addgroup -S www-data 2>/dev/null || true \
&& adduser -S -D -H -s /sbin/nologin -G www-data www-data 2>/dev/null || true \
&& chown -R www-data:www-data /var/www/html

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/nginx-entrypoint.sh"]
