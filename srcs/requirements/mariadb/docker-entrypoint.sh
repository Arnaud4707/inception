#!/bin/sh
set -e

DATADIR="/var/lib/mysql"

if [ -f /run/secrets/db_root_password ]; then
  MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

if [ -f /run/secrets/db_password ]; then
  MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

: "${MYSQL_ROOT_PASSWORD:?Need MYSQL_ROOT_PASSWORD}"
: "${MYSQL_DATABASE:?Need MYSQL_DATABASE}"
: "${MYSQL_USER:?Need MYSQL_USER}"
: "${MYSQL_PASSWORD:?Need MYSQL_PASSWORD}"

# Initialise maiadb
if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing MariaDB database..."

    mysql_install_db --user=mysql --datadir="$DATADIR"

    echo "Starting temporary MariaDB server..."
    mysqld --user=mysql --datadir="$DATADIR" --skip-networking &
    pid="$!"

    # Wait for  mysql to start
    until mysqladmin ping -u root --silent; do
        sleep 1
    done

    echo "Configuring database..."

    mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    echo "Shutting down temporary server..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    wait "$pid"

    echo "MariaDB initialization complete."
fi

echo "Starting MariaDB..."
exec mysqld \
  --user=mysql \
  --datadir="$DATADIR" \
  --bind-address=0.0.0.0 \
  --port=3306

