# grav cms docker

a complete docker image for grav cms with `php-fpm` and `nginx` handled over `supervisord`. Get it on [Docker Hub](https://hub.docker.com/r/websitemacherei/grav).

```
docker pull websitemacherei/grav
```


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

    # pulls dockerhub image, specify image version with websitemacherei/grav:x.y.z
    image: websitemacherei/grav:latest
    
    environment:
      # set the grav version to download
      # will download admin plugin as well
      - GRAV_VERSION=1.6.19
    
    # use alternate Dockerfile in project root
    #
    # Example Dockefile:
    #   FROM websitemacherei/grav:base-latest
    #   RUN apk --no-cache add htop
    #   USER app
    #
    # build: 
    #   context: .

    # logging rotation after 200 KB
    logging:
      options:
        max-size: "200k"
  
    volumes:
      # mount selectivly files in the web folder, like .htaccess or setup.php
      - ./web/.htaccess:/var/www/html/.htaccess
      # mount user folder into image
      - ./web/user:/var/www/html/user
      # mount your ssh key to download deps from user/.dpendencies file
      # - ~/.ssh:/home/app/.ssh
    
    ports:
      # forward port for local development
      - "8080:8080"
```

## Design decisions

* All logging to `stdout` and `stderr`, so logs available via `docker log`
* Nginx and FPM over supervisord
* Nginx `access_log` disabled globally
* Nginx `error_log` to `stderr`
* Nginx `error_log` disabled for `location ~ \.php$`, FPM will log it anyway
* Docker healthcheck on `/fpm-status` from localhost
* Grav cms will be installed when container's initial start
