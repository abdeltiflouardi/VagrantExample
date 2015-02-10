#!/bin/sh
 
sudo sed -i s/SELINUX=.*/SELINUX=disabled/g /etc/selinux/config

sudo cp /vagrant/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

sudo yum update -y

sudo yum install httpd wget nano php php-mcrypt* mongodb-org mongodb-org-server mod_ssl -y

sudo systemctl start httpd
sudo systemctl start mongod

sudo systemctl enable httpd
sudo chkconfig mongod on

sudo rm -f /etc/httpd/conf.d/welcome.conf
sudo rm -f /var/www/error/noindex.html

sudo cp /vagrant/files/dev.conf /etc/httpd/conf.d/dev.conf
sudo cp /vagrant/files/dev-ssl.conf /etc/httpd/conf.d/dev-ssl.conf

sudo bash -c  'echo -e "[DATE]\n//Notre Timezone\ndate.timezone = "GMT"\n\n"  >>  /etc/php.d/timezone.ini'
sudo bash -c  'echo -e "\nxdebug.max_nesting_level = 250\n"  >>  /etc/php.d/xdebug.ini'
