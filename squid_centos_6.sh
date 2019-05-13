#!/bin/bash
# <UDF name="squid_user" Label="Proxy Username" />
# <UDF name="squid_password" Label="Proxy Password" />
# Squid Proxy Server
# Author: admin@hostonnet.com
# Blog: https://blog.hostonnet.com
# Edits: Khaled AlHashem
# Site: https://knaved.com
# Version 0.1

squid_user=ck
squid_password=6021

yum -y install httpd-tools

cd /home/ck

wget http://www.squid-cache.org/Versions/v4/squid-4.7.tar.gz
tar -zxf squid-4.7.tar.gz
cd squid-4.7

./configure
make
make install

htpasswd -b -c /etc/squid/passwd $squid_user $squid_password

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
touch /etc/squid/blacklist.acl
wget -O /etc/squid/squid.conf  https://raw.githubusercontent.com/ckldev/squid/master/squid_centos.conf

iptables -I INPUT -p tcp --dport 5055 -j ACCEPT
#/sbin/iptables-save
/sbin/service iptables save

service squid restart
service squid enable
service squid status


