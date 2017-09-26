#!/bin/bash

set -x -e -u -o pipefail

mysql=mysql-server\=5.7.19-0ubuntu0.16.04.1

dbuser=nerd
dbpass=dbs3cr3t
dbname=bbuddydev

jdkversion=2:1.8-56ubuntu2
tomcat_version=8.5.20
gradle_version=2.13

#開始安裝環境
sudo apt-get update -y

#安裝mysql，配置root密碼
echo "開始安裝mysql"
if apt-cache policy mysql-server | grep "Installed: (none)" ; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install "$mysql";
else
    echo mysql installed ! ;
fi

##建立資料庫
#echo "建立資料庫"
#mysql -uroot -e "create database $dbname;"
#
##新增帳號：nerd | dbs3cr3t；賦予權限
#echo "建立使用者，賦予權限"
#mysql -uroot -e "create user $dbuser@'localhost' identified by '$dbpass';"
#mysql -uroot -e "grant all privileges on $dbname.* to $dbuser@'localhost';"

#安裝tomcat 8.5.x
#先裝java8
sudo apt-get install default-jdk="$jdkversion" -y
echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-i386/jre" >> /etc/environment
source /etc/environment

wget http://apache.stu.edu.tw/tomcat/tomcat-8/v"$tomcat_version"/bin/apache-tomcat-"$tomcat_version".tar.gz
sudo mkdir /var/lib/tomcat
sudo tar xvzf apache-tomcat-"$tomcat_version".tar.gz -C /var/lib/tomcat --strip-component=1

echo "CATALINA_HOME=/var/lib/tomcat" >> /etc/environment
source /etc/environment

##安裝unzip及gradle
#sudo apt-get install unzip -y
#wget https://services.gradle.org/distributions/gradle-"$gradle_version"-bin.zip
#sudo unzip gradle-"$gradle_version"-bin.zip -d /opt/gradle
#echo "PATH=$PATH:/opt/gradle/gradle-$gradle_version/bin/" >> /etc/environment
#source /etc/environment
#
##安裝git
#sudo apt-get install git -y
#
##結束配置環境
#
##編譯程式
##拉最新的code
#git clone --depth=1 https://bitbucket.org/chaifeng/bbuddy.git
#
##建war
#cd bbuddy
#gradle war

#佈署
#結束tomcat
#sudo "$CATALINA_HOME"/bin/shutdown.sh

#建完的war檔複製到webapps路徑，檔案名稱改為ROOT.war
sudo rm "$CATALINA_HOME"/webapps/ROOT -rf
sudo cp /bbuddy/build/libs/bbuddy-HEAD.war "$CATALINA_HOME"/webapps/ROOT.war

#啟動tomcat
sudo "$CATALINA_HOME"/bin/startup.sh
