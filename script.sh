#!/bin/sh
 
sudo sed -i s/SELINUX=.*/SELINUX=disabled/g /etc/selinux/config

sudo cp /vagrant/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

####################
# Install packages #
####################
sudo yum update -y

sudo yum install -y \
         httpd wget nano lynx mongodb-org mongodb-org-server mod_ssl \
         php  php-fpm php-cli php-common php-gd php-intl php-xml php-process php-pecl-xdebug php-pecl-apcu php php-mcrypt* php-mbstring php-mysql \
         mariadb-server

sudo wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/e/
sudo rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-*.rpm

sudo yum install -y redis

###################
# Manage Services #
###################
sudo systemctl start httpd
sudo systemctl start mongod
sudo systemctl start mariadb.service
sudo systemctl start redis.service

sudo systemctl enable redis.service
sudo systemctl enable mariadb.service
sudo systemctl enable httpd.service
sudo chkconfig mongod on

##########
# APACHE #
##########
sudo rm -f /etc/httpd/conf.d/welcome.conf
sudo rm -f /var/www/error/noindex.html

sudo cp /vagrant/files/httpd.conf /etc/httpd/conf/httpd.conf
sudo cp /vagrant/files/dev.conf /etc/httpd/conf.d/dev.conf
sudo cp /vagrant/files/dev-ssl.conf /etc/httpd/conf.d/dev-ssl.conf

#######
# PHP #
#######
sudo bash -c 'echo -e "[DATE]\n//Notre Timezone\ndate.timezone = "GMT"\n\n"  >>  /etc/php.d/timezone.ini'
sudo bash -c 'echo -e "\nxdebug.max_nesting_level = 250\n"  >>  /etc/php.d/xdebug.ini'

###########
# MARIADB #
###########
sudo mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

##########
# SYSTEM #
##########
sudo bash -c 'echo "192.168.1.200 dev" >> /etc/hosts'
