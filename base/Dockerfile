FROM alpine:3.10

# bash promt modification
ENV PS1="\u@\w\$ "

RUN addgroup app && adduser -S -u 1000 -s /bin/bash app -G app

# grav requirements
RUN apk --no-cache add \
  php7 \
  php7-fpm \
  php7-curl \
  php7-ctype \
  php7-dom \
  php7-gd \
  php7-json \
  php7-mbstring \
  php7-openssl \
  php7-session \
  php7-simplexml \
  php7-xml \
  php7-zip \
  php7-pecl-apcu \
  php7-opcache \
  php7-pecl-yaml \
  php7-pecl-imagick \
  composer

# other binaries
RUN apk --no-cache add \
  nginx \
  supervisor \
  curl \
  bash \
  vim \
  nano \
  git \
  openssh-client \
  zip
  
# configuration files
ADD config/nginx /etc/nginx
ADD config/php/php-fpm.conf /etc/php7/php-fpm.d/www.conf
ADD config/php/php.ini /etc/php7/conf.d/90_custom.ini
ADD config/supervisord.conf /etc/supervisord.conf

# make sure files/folders needed by the processes are accessable when they run under the app user
RUN chown -R app.app /run && \
  chown -R app.app /var/lib/nginx && \
  chown -R app.app /var/tmp/nginx && \
  chown -R app.app /var/log/nginx

# setup document root
RUN mkdir -p /var/www/html
RUN chown -R app.app /var/www/html

# add install files for grav
COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

WORKDIR /var/www/html
VOLUME /var/www/html

# expose the port nginx is reachable on
EXPOSE 8080

# let supervisord start nginx & php-fpm
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]

# configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping