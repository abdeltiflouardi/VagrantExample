#!/bin/sh
 
sudo sed -i s/SELINUX=.*/SELINUX=disabled/g /etc/selinux/config

sudo cp /vagrant/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

####################
# Install packages #
####################
sudo wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/e/
sudo rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-*.rpm

sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

sudo yum update -y

sudo yum install --enablerepo=remi,remi-php56 -y \
         httpd wget nano lynx mongodb-org mongodb-org-server mod_ssl \
         php php-devel php-fpm php-cli php-pear php-pdo php-mysqlnd php-common php-gd php-intl php-xml php-process php php-mcrypt* php-mbstring php-mysql \
         php-pecl-xdebug php-pecl-apcu php-pecl-memcached php-pecl-memcache php-pecl-mongo php-pecl-redis php-pecl-sqlite php-opcache \
         mariadb-server redis

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
