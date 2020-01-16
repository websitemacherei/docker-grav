# grav cms docker

a complete docker image for grav cms with `php-fpm` and `nginx` handled over `supervisord`. 

## Features

* Nginx and PHP FPM in a single image handled via Supervisord
* All important PHP extensions preinstalled
* Html 5 Boilerplate Nginx Configuration [h5bp/server-configs-nginx](https://github.com/h5bp/server-configs-nginx)
* Entrypoint script installs grav

## Usage

Folling `docker-compose.yml` demonstrates usage:

```yml
version: '3'

services:
  grav:
    build: .
    logging:
      # set logging options
      options:
        max-size: "200k"
    environment:
      # default is latest
      - GRAV_VERSION=x.y.z 
    volumes:
      # mount your grav user dir
      - ./your_user_dir:/var/www/html/user 
      # mount ssh for cloning private git repositories
      - ~/.ssh:/home/app/.ssh 
    ports:
      - 8080:8080
```

## Design decisions

* All logging to `stdout` and `stderr`, so logs available via `docker log`
* Nginx and FPM over supervisord
* Nginx `access_log` disabled globally
* Nginx `error_log` to `stderr`
* Nginx `error_log` disabled for `location ~ \.php$`, FPM will log it anyway
* Docker healthcheck on `/fpm-status` from localhost
* Grav cms will be installed when container's initial start
