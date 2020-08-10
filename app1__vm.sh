#!/bin/bash


sudo apt update -y
sudo apt install mc -y
sudo apt install nano -y
sudo apt install wget -y
 sudo apt install git -y

sudo wget https://github.com/koseven/koseven/archive/master.zip
	sudo mkdir -p /var/www/dtapi
	sudo mkdir -p /var/www/dtapi/api
	
	unzip master.zip
	sudo mv -f ./koseven-master/* /var/www/dtapi/api
	
	
	git clone https://github.com/yurkovskiy/dtapi
	
	sudo cp ./dtapi/.htaccess /var/www/dtapi/api/.htaccess