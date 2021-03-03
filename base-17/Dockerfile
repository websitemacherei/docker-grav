FROM alpine:3.13

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

# locales
ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache --virtual .locale-deps \
    $MUSL_LOCALE_DEPS \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
    && cd musl-locales-master \
    && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
    && cd .. && rm -r musl-locales-master \
    && cp /usr/share/i18n/locales/musl/de_DE.UTF-8 /usr/share/i18n/locales/musl/de_DE \
    && apk del .locale-deps

# set timezone Europe/Berlin
RUN apk add tzdata && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && apk del tzdata

# configuration files
ADD config/nginx /etc/nginx
ADD config/php/php-fpm.conf /etc/php7/php-fpm.d/www.conf
ADD config/php/php.ini /etc/php7/conf.d/90_custom.ini
ADD config/supervisord.conf /etc/supervisord.conf

# make sure files/folders needed by the processes are accessable when they run under the app user
RUN chown -R app.app /run  && \
    chown -R app.app /var/lib/nginx && \
    chown -R app.app /var/log/nginx

# setup document root
RUN mkdir -p /var/www/html/user/pages
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

USER app