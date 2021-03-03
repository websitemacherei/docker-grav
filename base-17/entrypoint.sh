#!/bin/bash

GRAV_VERSION=${GRAV_VERSION:-latest}
DIR=${DIR:-"/var/www/html"}

# only if grav is not already installed
if [ ! -d "$DIR/system" ]; then

  # enable dotfile globbing
  shopt -s dotglob

  # download grav
  curl -o /tmp/grav-tmp.zip -SL https://getgrav.org/download/core/grav-admin/$GRAV_VERSION
  
  # unzip grav and delete
  unzip /tmp/grav-tmp.zip -d /tmp && mv /tmp/grav-admin/* $DIR && rm -rf /tmp/grav-admin && rm /tmp/grav-tmp.zip

  # install deps
  bin/grav install

fi

# finally start supervisor
supervisord

