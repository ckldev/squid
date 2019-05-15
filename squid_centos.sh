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

yum -y install squid httpd-tools

htpasswd -b -c /etc/squid/passwd $squid_user $squid_password

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
touch /etc/squid/blacklist.acl
wget -O /etc/squid/squid.conf  https://raw.githubusercontent.com/ckldev/squid/master/squid_centos.conf

firewall-cmd --zone=public --add-port=5055/tcp --permanent
firewall-cmd --reload

systemctl restart squid
systemctl enable squid
systemctl status squid
#update-rc.d squid defaults
