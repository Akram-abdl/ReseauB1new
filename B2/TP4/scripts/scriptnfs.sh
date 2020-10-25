#!/bin/bash
# Akram
# 13/10/2020

yum install -y nfs-utils

mkdir /srv/folder1
chmod -R 755 /srv/folder1
chown nfsnobody:nfsnobody /srv/folder1/

echo "/srv/folder1 192.168.1.11(rw,sync)" >> /etc/exports

systemctl enable nfs-server
systemctl restart nfs-server

echo "192.168.1.11 node1.tp4.gitea gitea
192.168.1.12 node1.tp4.mariadb mariadb
192.168.1.13 node1.tp4.nginx nginx
192.168.1.14 node1.tp4.nfs nfs
" >> /etc/hosts
