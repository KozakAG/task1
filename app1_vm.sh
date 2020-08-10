#!/bin/bash

install_app(){

yum install -y mc
yum install yum-utils -y
yum install -y git
yum install -y wget
yum install -y unzip


yum install -y httpd
systemctl start  httpd
systemctl enable httpd

yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install -y epel-release
yum install -y php php-zip php-gd php-intl php-mbstring php-soap php-xmlrpc php-pgsql \
   php-opcache php-pecl-redis php-http php-pdo_mysql php-mysqli php73-php-fpm php73-php-gd \
   php73-php-mbstring php73-php-mysqlnd 

yum install -y libsemanage-python libselinux-python 
	
	}

ko7(){
	 /bin/wget https://github.com/koseven/koseven/archive/master.zip

	 mkdir /var/www/dtapi
	 mkdir /var/www/dtapi/api

	 unzip master.zip
	 mv -f ./koseven-master/* /var/www/dtapi/api

	 git clone https://github.com/yurkovskiy/dtapi

	 yes|cp -fr ./dtapi/* /var/www/dtapi/api

	 cp ./dtapi/.htaccess /var/www/dtapi/api/.htaccess

	 sed -i -e "s|'base_url'   => '/',|'base_url'   => '/api/',|g"  /var/www/dtapi/api/application/bootstrap.php
	sed -i -e "s|RewriteBase /|RewriteBase /api/|g"  /var/www/dtapi/api/.htaccess
	sed -i -e "s|PDO_MySQL|PDO|g"  /var/www/dtapi/api/application/config/database.php
	sed -i -e "s|localhost;dbname=dtapi2|192.168.63.10;dbname=dtapi|g"  /var/www/dtapi/api/application/config/database.php

	cp /var/www/dtapi/api/public/index.php /var/www/dtapi/api/index.php

	}

setup_virtual_host() {
cat <<EOF > /etc/httpd/conf.d/dtapi.conf
<VirtualHost *:80>
	DocumentRoot /var/www/dtapi
	ErrorLog /var/log/httpd/dtapi_error.log
	CustomLog /var/log/httpd/dtapi_requests.log combined
</VirtualHost>
EOF

	chown apache:apache /var/www/ -R
	chmod 777 -R /var/www/
	systemctl restart httpd
}



install_app
ko7
setup_virtual_host