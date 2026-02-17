
FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql

# Copy entrypoint's script
COPY docker-entrypoint.sh /usr/local/bin/
COPY my.cnf /etc/my.cnf
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
