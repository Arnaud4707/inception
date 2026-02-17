#!/bin/sh

# stop the script if there is a fail
set -e

# Secrets
if [ -f /run/secrets/db_password ]; then
  WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
fi
if [ -f /run/secrets/wp_admin_password ]; then
  WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
fi
if [ -f /run/secrets/wp_second_user_password ]; then
  WORDPRESS_SECOND_USER_PASSWORD=$(cat /run/secrets/wp_second_user_password)
fi

: "${WORDPRESS_DB_HOST:?Need WORDPRESS_DB_HOST}"
: "${WORDPRESS_DB_NAME:?Need WORDPRESS_DB_NAME}"
: "${WORDPRESS_DB_USER:?Need WORDPRESS_DB_USER}"
: "${WORDPRESS_ADMIN_USER:?Need WORDPRESS_ADMIN_USER}"
: "${WORDPRESS_ADMIN_EMAIL:?Need WORDPRESS_ADMIN_EMAIL}"
: "${WORDPRESS_SITE_TITLE:?Need WORDPRESS_SITE_TITLE}"
: "${WORDPRESS_URL:?Need WORDPRESS_URL}"

# Wait for DB
_db_host() { echo "$WORDPRESS_DB_HOST" | awk -F: '{print $1}'; }
_db_port() { echo "$WORDPRESS_DB_HOST" | awk -F: '{ if (NF>1) print $2; else print 3306 }'; }
DB_HOST=$(_db_host)
DB_PORT=$(_db_port)
i=0
until php -r "exit((int)!(mysqli_connect('${DB_HOST}', '${WORDPRESS_DB_USER}', '${WORDPRESS_DB_PASSWORD}', '${WORDPRESS_DB_NAME}', ${DB_PORT})));"; do
  i=$((i+1))
  if [ $i -gt 30 ]; then
    echo "Error: timed out waiting for database at ${DB_HOST}:${DB_PORT}"
    exit 1
  fi
  sleep 2
done

# Download WordPress if empty
if [ ! -f ./index.php ]; then
  wp core download --allow-root
fi

# Create wp-config.php if absent
if [ ! -f ./wp-config.php ]; then
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbprefix="${WORDPRESS_TABLE_PREFIX:-wp_}" \
    --skip-check \
    --allow-root
fi

# Install WordPress if not install
if ! wp core is-installed --allow-root; then
  wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_SITE_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
  
  wp option update comment_whitelist 0 --allow-root
  wp option update comment_moderation 1 --allow-root

fi

# Create second user
if [ -n "$WORDPRESS_SECOND_USER" ] && [ -n "$WORDPRESS_SECOND_USER_EMAIL" ]; then
  if ! wp user get "$WORDPRESS_SECOND_USER" --allow-root >/dev/null 2>&1; then
    wp user create "$WORDPRESS_SECOND_USER" "$WORDPRESS_SECOND_USER_EMAIL" \
      --role="$WORDPRESS_SECOND_USER_ROLE" \
      --user_pass="$WORDPRESS_SECOND_USER_PASSWORD" \
      --allow-root
  fi
fi

# Permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

exec "$@"
