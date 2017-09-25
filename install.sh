#!/bin/bash

sudo apt-get update -y

#安裝mysql，配置root密碼
echo "開始安裝mysql"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql

#建立資料庫
echo "建立資料庫"
mysql -uroot -proot -e "create database bbuddydev;"

#新增帳號：nert | dbs3cr3t；賦予權限
echo "建立使用者，賦予權限"
mysql -uroot -proot -e "create user 'nerd'@'localhost' identified by 'dbs3cr3t';"
mysql -uroot -proot -e "grant all privileges on bbuddydev.* to 'nerd'@'localhost';"
mysql -uroot -proot -e "show grants for 'nerd'@'localhost';"

#安裝tomcat 8.5.x
#先裝java
sudo apt-get install default-jdk -y
echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-i386/jre" >> /etc/environment
source /etc/environment

sudo groupadd tomcat
sudo useradd -g tomcat -d/opt/tomcat tomcat
wget http://apache.stu.edu.tw/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz
sudo mkdir /var/lib/tomcat
sudo tar xvzf apache-tomcat-8.5.20.tar.gz -C /var/lib/tomcat --strip-component=1

echo "CATALINA_HOME=/var/lib/tomcat" >> /etc/environment
source /etc/environment

#設置tomcat權限
cd /var/lib/tomcat
sudo chgrp -R tomcat conf
sudo chmod g+rwx conf
sudo chmod g+r conf/*
sudo chown -R tomcat $CATALINA_HOME/
cd ~

#安裝unzip及gradle
sudo apt-get install unzip -y
wget https://services.gradle.org/distributions/gradle-2.13-bin.zip
sudo unzip gradle-2.13-bin.zip -d /opt/gradle
echo "PATH=$PATH:/opt/gradle/gradle-2.13/bin/" >> /etc/environment
source /etc/environment

#裝git並且拉最新的code
sudo apt-get install git -y
git clone --depth=1 https://bitbucket.org/chaifeng/bbuddy.git

#建war
cd bbuddy
gradle war


#建完的war檔複製到webapps路徑，檔案名稱改為ROOT.war
sudo rm $CATALINA_HOME/webapps/ROOT -rf
sudo cp build/libs/bbuddy-HEAD.war $CATALINA_HOME/webapps/ROOT.war
sudo chown -R tomcat $CATALINA_HOME/webapps/ROOT.war

#啟動tomcat
sudo -u tomcat $CATALINA_HOME/bin/startup.sh
