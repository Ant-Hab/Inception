FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server

COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# Allow remote connections by changing the bind-address
RUN sed -i 's/bind-address/bind-address = 0.0.0.0 #/i' /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306

ENTRYPOINT ["/tmp/setup.sh"]
