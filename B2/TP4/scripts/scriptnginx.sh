#!/bin/bash
# Akram
# 13/10/2020


yum install -y epel-release
yum install -y nginx
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload

echo "user nginx;
worker_processes 1;
error_log nginx_error.log;
pid /run/nginx.pid;
events {
    worker_connections 1024;
}
http {
    server {
        listen 80;
        server_name git.example.com;
        location / {
            proxy_pass http://192.168.1.11:3000;
        }
    }
}" > /etc/nginx/nginx.conf

systemctl start nginx
systemctl enable nginx

echo "192.168.1.11 node1.tp4.gitea gitea
192.168.1.12 node1.tp4.mariadb mariadb
192.168.1.13 node1.tp4.nginx nginx
192.168.1.14 node1.tp4.nfs nfs
" >> /etc/hosts

