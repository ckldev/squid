#!/bin/bash
# <UDF name="squid_user" Label="Proxy Username" />
# <UDF name="squid_password" Label="Proxy Password" />
# Squid Proxy Server
# Author: admin@hostonnet.com
# Blog: https://blog.hostonnet.com
# Edits: Khaled AlHashem
# Site: https://knaved.com
# Version 0.1

# for auto setup dual interface [eth0 & eth1]

squid_user=ck
squid_password=6021

yum -y install squid httpd-tools wget openssl

htpasswd -b -c /etc/squid/passwd $squid_user $squid_password

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
touch /etc/squid/blacklist.acl
wget --no-check-certificate --no-cache --no-cookies -O /etc/squid/squid.conf  https://raw.githubusercontent.com/ckldev/squid/master/squid_centos.conf

ETH0_IP=$(ip addr show eth0 | grep -m 1 -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o [0-9].*)
ETH1_IP=$(ip addr show eth1 | grep -m 1 -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o [0-9].*)
echo "
http_port ${ETH0_IP//[$'\t\r\n']}:5056 name=5056
acl port5056 myportname 5056
http_access allow port5056
tcp_outgoing_address ${ETH0_IP//[$'\t\r\n']} port5056
http_port ${ETH0_IP//[$'\t\r\n']}:5057 name=5057
acl port5057 myportname 5057
http_access allow port5057
tcp_outgoing_address ${ETH1_IP//[$'\t\r\n']} port5057
" >> /etc/squid/squid.conf

firewall-cmd --zone=public --add-port=5055/tcp --permanent
firewall-cmd --zone=public --add-port=5056/tcp --permanent
firewall-cmd --zone=public --add-port=5057/tcp --permanent
firewall-cmd --reload

squid -k parse

systemctl restart squid
systemctl enable squid
systemctl status squid
#update-rc.d squid defaults
