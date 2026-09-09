FROM debian:bookworm

# Install Nginx and OpenSSL
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl procps

# Create the folder for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=achowdhu.42.fr/UID=achowdhu"

# Copy the custom configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Give appropriate permissions to the web root
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

# Start Nginx in the foreground so the container doesn't immediately close
CMD ["nginx", "-g", "daemon off;"]
