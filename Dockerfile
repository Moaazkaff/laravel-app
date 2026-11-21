FROM php:8.3-apache

USER root

WORKDIR /var/www/html

COPY . /var/www/html/

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j"$(nproc)" \
        gd \
        pdo_mysql \
        mysqli \
        zip \
        bcmath \
        pcntl \
        opcache \
    && rm -rf /var/lib/apt/lists/*

# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 
# 
# RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" 
# 
# RUN php composer-setup.php 
# 
# RUN php -r "unlink('composer-setup.php');"
# 
# RUN mv composer.phar /usr/local/bin/composer

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install Laravel dependencies
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader

COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache \
    && a2enmod rewrite


USER www-data
