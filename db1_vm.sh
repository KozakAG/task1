#!/bin/bash

install_requirements() {
	sudo apt update
	sudo apt install mc -y
	}

setup_mysql() {
mysql -u root <<-EOF
#	UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';
	DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
	DELETE FROM mysql.user WHERE User='';
	DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
	FLUSH PRIVILEGES;
	EOF
	}

create_database() {
	sudo apt install mysql-server -y
	mysql -u root <<-EOF
	CREATE DATABASE dtapi;
	GRANT ALL ON dtapi.* TO 'dtapi'@'%' IDENTIFIED BY 'dtapi' WITH GRANT OPTION;
	FLUSH PRIVILEGES;
	EOF

	sed -i.bak '/bind-address/ s/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

	wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
	mysql -u root dtapi < ./dtapi_full.sql
	sudo systemctl restart mysql
}

	install_requirements
	setup_mysql
	create_database

