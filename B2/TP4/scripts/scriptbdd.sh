#!/bin/bash
# Akram
# 13/10/2020

yum install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload

mysql --user=root <<_EOF_
  UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  FLUSH PRIVILEGES;
_EOF_

sed -i '/symbolic-links=/a bind-adresse=192.168.1.12' /etc/my.cnf

mysql -u root -proot -e "SET old_passwords=0;CREATE USER 'gitea'@'192.168.1.11' IDENTIFIED BY 'gitea';CREATE DATABASE giteadb CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';GRANT ALL PRIVILEGES ON giteadb.* TO 'gitea'@'192.168.1.11';FLUSH PRIVILEGES;"


echo "192.168.1.11 node1.tp4.gitea gitea
192.168.1.12 node1.tp4.mariadb mariadb
192.168.1.13 node1.tp4.nginx nginx
192.168.1.14 node1.tp4.nfs nfs
" >> /etc/hosts

