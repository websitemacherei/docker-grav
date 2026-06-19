# grav cms docker

a complete docker image for grav cms. Get it on [Docker Hub](https://hub.docker.com/r/websitemacherei/grav).

```
docker pull websitemacherei/grav
```


## Features

* All important PHP extensions preinstalled
* IMagick with webp and HEIC
* Html 5 Boilerplate Nginx Configuration [h5bp/server-configs-nginx](https://github.com/h5bp/server-configs-nginx)
* Entrypoint script installs grav

## Usage

Folling `docker-compose.yml` demonstrates usage:

```yml

services:
  grav:

    # pulls dockerhub image, specify image version with websitemacherei/grav:x.y.z
    image: websitemacherei/grav:latest
    
    environment:
      # set the grav version to download
      # will download admin plugin as well
      - GRAV_VERSION=1.7.7
  
    volumes:
      - ./web/user:/var/www/html/user
      - ./../ssh_plugin_deployment:/var/www/ssh
      - ./web/.htaccess:/var/www/html/.htaccess
      - ./web/setup.php:/var/www/html/setup.php
    
```
