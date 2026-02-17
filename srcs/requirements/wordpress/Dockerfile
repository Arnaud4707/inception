FROM alpine:3.22

RUN apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-pdo \
    php82-pdo_mysql \
    php82-gd \
    php82-mbstring \
    php82-ctype \
    php82-zip \
    php82-exif \
    php82-curl \
    php82-intl \
    php82-opcache \
    php82-session \
    php82-fileinfo \
    php82-json \
    php82-phar \
    curl \
    unzip \
    mysql-client

# Symbolic link php
RUN ln -s /usr/bin/php82 /usr/bin/php

# Add www-data
RUN getent group www-data || addgroup -g 82 -S www-data
RUN id www-data || adduser -u 82 -D -S -G www-data www-data

# Configuring PHP-FPM for listening TCP 9000
RUN sed -i 's|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|user = nobody|user = www-data|' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|group = nobody|group = www-data|' /etc/php82/php-fpm.d/www.conf

# Install WP-CLI
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

WORKDIR /var/www/html
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Copy entrypoint and php.ini
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY php.ini /etc/php82/conf.d/99-custom.ini
COPY phpinfo.php /var/www/html/phpinfo.php

EXPOSE 9000
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm82", "-F"]
