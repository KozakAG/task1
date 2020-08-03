#!/bin/bash

install_app(){
	sudo yum update -y
	sudo yum install wget -y
	wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
	sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
	sudo yum-config-manager --enable mysql57-community
	sudo yum install mysql-community-server -y
	sudo setenforce 0
	sudo service mysqld start
	}
update_db(){
mariadb -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF
}


create_db(){
	mysql -u root <<-EOF
	CREATE DATABASE dtapi2;
	CREATE USER 'user'@'%' IDENTIFIED BY '112233344';
	GRANT ALL PRIVILEGES ON dtapi2.* TO 'user'@'%';
	FLUSH PRIVILEGES;
	EOF


	wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
	mysql -u root dtapi < ./dtapi_full.sql
	sudo systemctl restart mysqld
	sudo chmod 666 /etc/my.cnf
	sudo echo "bind-address=192.168.63.15" >>/etc/my.cnf
	sudo chmod 644 /etc/my.cnf
}

install_app
update_db
create_db

