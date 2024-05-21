#!/bin/bash
# Set permissions for SSH Keys
cp -r /var/www/ssh /var/www/.ssh
chmod 400 /var/www/.ssh/config
chmod 400 /var/www/.ssh/id_rsa
chmod 400 /var/www/.ssh/id_rsa.pub
chmod 400 /var/www/.ssh/known_hosts
ls -la /var/www/.ssh
cd /var/www/html
bin/grav install
bin/gpm install git-sync -y
if [ -f "/var/www/html/user/config/plugins/git-sync.yaml" ]; then
    echo "$FILE exists."
    bin/plugin git-sync init
    git config --global pull.ff true
    bin/plugin git-sync sync
fi
sudo service cron start
/usr/local/bin/docker-php-entrypoint
/usr/local/bin/apache2-foreground