#!/bin/bash
# Akram
# 13/10/2020

yum install -y wget

wget -O gitea https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-amd64
chmod +x gitea

yum install -y git
yum install -y epel-release
yum update -y
yum install -y supervisor

firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

adduser git -m

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

export GITEA_WORK_DIR=/var/lib/gitea/
cp gitea /usr/local/bin/gitea


echo "[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/gitea.service

systemctl enable gitea
systemctl start gitea

echo "[program:gitea]
directory=/home/git/go/src/github.com/go-gitea/gitea/
command=/home/git/go/src/github.com/go-gitea/gitea/gitea web
autostart=true
autorestart=true
startsecs=10
stdout_logfile=/var/log/gitea/stdout.log
stdout_logfile_maxbytes=1MB
stdout_logfile_backups=10
stdout_capture_maxbytes=1MB
stderr_logfile=/var/log/gitea/stderr.log
stderr_logfile_maxbytes=1MB
stderr_logfile_backups=10
stderr_capture_maxbytes=1MB
user = git
environment = HOME=\"/home/git\", USER=\"git\"
" >> /etc/supervisord.conf

sudo systemctl start supervisord
sudo systemctl enable supervisord

echo "192.168.1.11 node1.tp4.gitea gitea
192.168.1.12 node1.tp4.mariadb mariadb
192.168.1.13 node1.tp4.nginx nginx
192.168.1.14 node1.tp4.nfs nfs
" >> /etc/hosts