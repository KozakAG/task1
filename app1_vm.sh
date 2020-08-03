#!/bin/bash

install_app(){

	sudo yum update -y
	sudo yum install mc -y
	sudo setenforce 0
	sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm
	sudo yum --enablerepo=remi-php72 install php php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd \
		 php-mcrypt php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd -y
	sudo yum-config-manager --enable remi-php72
	sudo yum install git -y
	sudo yum install httpd -y
	sudo systemctl enable httpd
	
	}

setup_server_app() {

	git clone https://github.com/avvppro/IF-108.git
	sudo mkdir IF-108/task1/dtester/dt-api/application/logs IF-108/task1/dtester/dt-api/application/cache
	sudo chmod 766 IF-108/task1/dtester/dt-api/application/logs
	sudo chmod 766 IF-108/task1/dtester/dt-api/application/cache
	sudo mv IF-108/task1/dtester /var/www
	sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled /var/log/httpd/dtester
	sudo su
	sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf

}

setup_virtual_host() {
	sudo cat <<_EOF > /etc/httpd/sites-available/dtester.conf
	<VirtualHost *:80>
		#    ServerName www.example.com
		#    ServerAlias example.com
		DocumentRoot /var/www/dtester
		ErrorLog /var/log/httpd/dtester/error.log
		CustomLog /var/log/httpd/dtester/requests.log combined
		<Directory /var/www/dtester/>
				AllowOverride All
		</Directory>
	</VirtualHost>
_EOF
	sudo mkdir /var/log/httpd/dtester
	sudo ln -s /etc/httpd/sites-available/dtester.conf /etc/httpd/sites-enabled/dtester.conf
	systemctl restart httpd
	}



install_app
setup_server_app
setup_virtual_host