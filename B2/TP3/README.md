# TP3 : systemd

Le but ici c'est d'explorer un peu systemd. 

systemd est un outil qui a été très largement adopté au sein des distributions GNU/Linux les plus répandues (Debian, RedHat, Arch, etc.). systemd occupe plusieurs fonctions :
* système d'init
* gestion de services
* embarque plusieurs applications très proche du noyau et nécessaires au bon fonctionnement du système
  * comme par exemple la gestion de la date et de l'heure, ou encore la gestion des périphériques
* PID 1


# I. Services systemd

## 1. Intro

🌞 Utilisez la ligne de commande pour sortir les infos suivantes :

* afficher le nombre de services systemd dispos sur la machine
```bash
systemctl list-unit-files -t service | grep .service | wc -l
```
* afficher le nombre de services systemd actifs ("running") sur la machine
```bash
systemctl -t service --state=running | wc -l
```
* afficher le nombre de services systemd qui ont échoué ("failed") ou qui sont inactifs ("exited") sur la machine
```bash
systemctl -t service --state=failed,exited | wc -l
```
* afficher la liste des services systemd qui démarrent automatiquement au boot ("enabled")
```bash
systemctl list-unit-files -t service --state=enabled
```

## 2. Analyse d'un service

🌞 Etudiez le service `nginx.service`
* déterminer le path de l'unité nginx.service
```bash
systemctl status nginx
  Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
```

* afficher son contenu et expliquer les lignes qui comportent :

* ExecStart
```bash
ExecStart=/usr/sbin/nginx
```


Le chemin du processus qui est lancé lorsque l'utilsateur entre "nginx" dans son terminal

* ExecStartPre
```bash
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -
```


Commandes éxècutée  avant le ExecStart
* PIDFile
```bash
PIDFile=/run/nginx.pid
```

Le fichier où est stocké le PID de nginx
* Type
```bash
Type=forking
```

Le type forking permet de signaler que le processus tourne toujours aux autres processus

* ExecReload
```bash
ExecReload=/bin/kill -s HUP $MAINPID
```


Signal envoyé lorsqu'on tape systemctl restart nginx

* Description

```bash
Description=The nginx HTTP and reverse proxy server
```


Description du service

* After

```bash
After=network.target remote-fs.target nss-lookup.target
```
Nginx se lancera après que ces services soit lancées

🌞 **|CLI|** Listez tous les services qui contiennent la ligne `WantedBy=multi-user.target`


```
grep -rnw /usr/lib/systemd/system /etc/systemd/system /run/systemd/system /usr/lib/systemd/system -e 'WantedBy=multi-user.target'
```



## 3. Création d'un service

#### A. Serveur web
* la commande pour lancer le serveur web est 
  * `python3 -m http.server <PORT>`


Pour lancer le server on crée l'unité de service de cette façon:

```bash
[root@node ~]# cat /etc/systemd/system/server.service
[Unit]
Description=Ouverture d'un serveur sur un port definis

[Service]
User=server
Environment="PORT=8080"
ExecStartPre=+/usr/sbin/firewalld-cmd --add-port=${PORT}/tcp --permanent
ExecStart=/usr/bin/python3 -m http.server ${PORT}
ExecStop=+/usr/sbin/firewalld-cmd --remove-port=${PORT} --permanent
TimeoutStopSec=1200
[root@node ~]#
[root@node ~]# systemctl start server.service
[root@node ~]# systemctl is-active server.service
active
[root@node ~]# systemctl status server.service
● server.service - Ouverture d'un serveur sur un port definis
   Loaded: loaded (/etc/systemd/system/server.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-10-07 08:28:54 UTC; 51s ago
 Main PID: 2768 (python3)
   CGroup: /system.slice/server.service
           └─2768 /usr/bin/python3 -m http.server 8080

Oct 07 08:28:54 node systemd[1]: Started Ouverture d'un serveur sur un port definis.
[root@node ~]#
```
🌞 Lancer le service

* prouver qu'il est en cours de fonctionnement pour systemd

```bash
[vagrant@node ~]$ sudo systemctl status server
? server.service - Ouverture d'un serveur sur un port definis
Loaded: loaded (/etc/systemd/system/server.service; static; vendor preset: disabled)
Active: active (running) since Mon 2020-10-05 11:11:05 UTC; 3s ago
Main PID: 4687 (python3)
CGroup: /system.slice/server.service
        ?? 4689 /usr/bin/python3 -m http.server 8080
```
* faites en sorte que le service s'allume au démarrage de la machine

```
[vagrant@node ~]$ sudo systemctl enable server
```

* prouver que le serveur web est bien fonctionnel
```
[vagrant@node ~]$ curl localhost:8080
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href="bin/">bin@</a></li>
<li><a href="boot/">boot/</a></li>
<li><a href="dev/">dev/</a></li>
[...]
```

# II. Autres features
## 1. Gestion de boot

🌞 Utilisez `systemd-analyze plot` pour récupérer une diagramme du boot, au format SVG
* il est possible de rediriger l'output de cette commande pour créer un fichier `.svg`
  * un `.svg` ça peut se lire avec un navigateur
* déterminer les 3 **services** les plus lents à démarrer
  
swapfile.swap (1.356s)

dev-sda1.device (1.215s)

postfix.service (1.171s)


## 2. Gestion de l'heure

🌞 Utilisez la commande `timedatectl`
```bash
[vagrant@node ~]$ timedatectl
               Local time: Wed 2020-10-07 10:17:12 UTC
           Universal time: Wed 2020-10-07 10:17:12 UTC
                 RTC time: Wed 2020-10-07 10:17:11
                Time zone: UTC (UTC, +0000)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

* déterminer votre fuseau horaire

```bash
Time zone: UTC (UTC, +0000)
```

* déterminer si vous êtes synchronisés avec un serveur NTP

```bash
NTP service: active
```

* changer le fuseau horaire

```bash
timedatectl set-timezone Europe/Paris
```

🌞 Utilisez hostnamectl

```
[vagrant@node ~]$ hostnamectl
   Static hostname: node
         Icon name: computer-vm
           Chassis: vm
        Machine ID: b0a5769bf2629f4bafcda09d4b952791
           Boot ID: 3b0c83d2f5484a3c997cbbcd74bac1ae
    Virtualization: oracle
  Operating System: CentOS Linux 8 (Core)
       CPE OS Name: cpe:/o:centos:centos:8
            Kernel: Linux 4.18.0-80.el8.x86_64
      Architecture: x86-64
```

* déterminer votre hostname actuel

```bash
Static hostname: node
```
* changer votre hostname

```bash
hostnamectl set-hostname node.tp3.b2
```

