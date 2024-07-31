FROM php:8.3.6-apache

USER root 

# Configuration
ENV TZ=Europe/Berlin
ENV GRAV_VERSION=1.7.46

# PHP Setup
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN printf '[PHP]\nmemory_limit = 512M\n' >> /usr/local/etc/php/conf.d/dockerfile-php.ini
RUN printf 'post_max_size = 64M\n' >> /usr/local/etc/php/conf.d/dockerfile-php.ini
RUN printf 'upload_max_filesize = 64M\n' >> /usr/local/etc/php/conf.d/dockerfile-php.ini
RUN printf 'max_execution_time = 300\n' >> /usr/local/etc/php/conf.d/dockerfile-php.ini

# Timzone Setup
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "Europe/Berlin"\n' > /usr/local/etc/php/conf.d/tzone.

RUN apt-get update -y && apt-get install -y libyaml-dev libpng-dev libjpeg-dev zlib1g-dev libzip-dev git dos2unix locales locales-all cron sudo libmagickwand-dev
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install gd
RUN mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    cd /usr/src/php/ext/imagick; \
    chmod +x configure-cflags.sh; \
    ./configure-cflags.sh --prefix=/usr/local/ImageMagick-7.1.0-60 \
        --with-heic=yes \
        --with-jpeg=yes \
        --with-png=yes \
        --with-tiff=yes \
        --with-webp=yes; \
    docker-php-ext-install imagick;
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN a2enmod expires
RUN a2enmod headers
RUN a2enmod rewrite
RUN pecl install yaml && echo "extension=yaml.so" > /usr/local/etc/php/conf.d/ext-yaml.ini && docker-php-ext-enable yaml

# User
RUN usermod -u 1000 www-data
RUN echo 'www-data ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Cron
RUN echo '* * * * * www-data cd /var/www/html;/usr/local/bin/php bin/grav scheduler 1>> /var/www/cron.log 2>&1' >> /etc/crontab
RUN echo '* * * * * www-data date >> /var/www/crontest.txt' >> /etc/crontab

# Grav
RUN git config --global --add safe.directory /var/www/html
RUN git clone https://github.com/getgrav/grav.git /var/www/html
RUN cd /var/www/html
RUN git fetch --all --tags
RUN git checkout tags/$GRAV_VERSION

# Entrypoint
ADD entrypoint.sh /var/www/entrypoint.sh
RUN dos2unix /var/www/entrypoint.sh

# Permissions
RUN chmod +x /var/www/entrypoint.sh
RUN chown -R www-data:www-data /var/www

# Start Everything
USER www-data
RUN sudo service cron start

ENTRYPOINT ["/var/www/entrypoint.sh"]
CMD ["apache2-foreground"]
EXPOSE 80