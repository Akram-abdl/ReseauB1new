# TP 2

## 4. Configuration réseau d'une machine CentOS

🌞 Déterminer la liste de vos cartes réseau, les informations qui y sont liées, et la fonction de chacune.
* allez faites moi un p'tit tableau markdown, du style :

Name | IP | MAC | Fonction
--- | --- | --- | ---
`enp0s3` | `10.0.2.2` | `08:00:27:d3:7d:e5` | Carte Nat
| enp0s8 | 10.2.1.3/24  | 08:00:27:3e:28:0f | Carte réseau privé (accès Host-Only) |

---
Name | IP | MAC | Fonction
--- | --- | --- | ---
`lo` | `127.0.0.1` | `00:00:00:00:00:00` | Loopback

---

🌞 [Changer la configuration de la carte réseau Host-Only](../../cours/memo/linux_centos_network.md#définir-une-ip-statique)
* changer vers une autre IP statique
* prouver que l'IP a bien changé

**Procédure :**

* sudo nano ifcfg-enp0s8
* IPPADR: 10.2.1.5
* on ouvre un terminal sur le pc hote et on ping 10.2.1.5
* Le ping a bien marché

## 5. Appréhension de quelques commandes

🌞 faites un scan `nmap` du réseau host-only
* déterminer l'adresse IP des machines trouvées
* vous devriez trouver votre PC hôte (au moins). Vérifiez avec une commande sur votre PC hôte que c'est la même MAC que dans le scan `nmap`

**Procédure :**
```
[akram@patron ~]$ nmap -sP 10.2.1.0/24

Starting Nmap 6.40 ( http://nmap.org ) at 2020-02-27 15:29 CET

Nmap scan report for 10.2.1.1

Host is up (0.0059s latency).

Nmap scan report for 10.2.1.5

Host is up (0.00046s latency).

Nmap done: 256 IP addresses (2 hosts up) scanned in 2.93 seconds
```
***
```
[akram@patron ~]$ sudo nmap -sP 10.2.1.0/24 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "$3;}' |
sort

10.2.1.1 => 0A:00:27:00:00:15

10.2.1.5
```
***
```
PS C:\Users\akram> ipconfig /all

Carte Ethernet VirtualBox Host-Only Network #2 :

   Suffixe DNS propre à la connexion. . . :

   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter #2

   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-15

   DHCP activé. . . . . . . . . . . . . . : Non

   Configuration automatique activée. . . : Oui

   Adresse IPv6 de liaison locale. . . . .: fe80::657d:99eb:c4b7:633b%21(préféré)
   
   Adresse IPv4. . . . . . . . . . . . . .: 10.2.1.1(préféré)
   
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
```
***
```
🌞 Utiliser `ss` pour lister les ports TCP et UDP en écoute sur la machine
* déterminer quel programme écoute sur chacun de ces ports

[akram@patron ~]$ sudo ss -ltunp

[sudo] password for akram:
Netid  State      Recv-Q Send-Q            Local Address:Port                           Peer Address:Port
udp    UNCONN     0      0                             *:68                                        *:*                   users:(("dhclient",pid=3038,fd=6))
tcp    LISTEN     0      128                           *:22                                        *:*                   users:(("sshd",pid=3264,fd=3))
tcp    LISTEN     0      100                   127.0.0.1:25                                        *:*                   users:(("master",pid=3506,fd=13))
tcp    LISTEN     0      128                          :::22                                       :::*                   users:(("sshd",pid=3264,fd=4))
tcp    LISTEN     0      100                         ::1:25                                       :::*                   users:(("master",pid=3506,fd=14))
```

# II. Notion de ports

## 1. SSH

```
tcp    LISTEN     0      128                           *:22                                        *:*                   users:(("sshd",pid=3264,fd=3))

On écoute sur le port 22 et l'ip est celle rentrée lors de la connexion donc 10.2.1.5
```
***

## 2. Firewall

### A. SSH

* il faut modifier le fichier `/etc/ssh/sshd_config`
  * trouver la ligne qui indique le port sur lequel écoute le serveur SSH
  * modifier la ligne pour écouter sur un autre port de votre choix
    * valeur entre 1024 et 65535 :)

Lors d'un ss -ltnup on voit bien que on écoute sur le port 1500

Sur
PS C:\Users\akram> ssh akram@10.2.1.5 -p 1500
ssh: connect to host 10.2.1.5 port 1500: Connection timed out
Bloqué par le firewall

Donc on utilise 

🌞 [Ouvrir le port correspondant du firewall](../../cours/memo/linux_centos_network.md#interagir-avec-le-firewall)
```
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --reload


PS C:\Users\akram> ssh akram@10.2.1.5 -p 1500
akram@10.2.1.5's password:
Last login: Thu Feb 27 16:55:31 2020
Last login: Thu Feb 27 16:55:31 2020
```

### B. Netcat

🌞 Comme dans le précédent TP, on va faire un ptit chat. La VM sera le serveur, le PC sera le client.

* dans un premier terminal sur la VM
  * lancer un serveur `netcat` dans un terminal (commande `nc -l`)
  * le serveur doit écouter sur le port de votre choix (toujours avec 1024 < PORT < 65535), en TCP
  * il faudra autoriser ce port dans le firewall
* dans un deuxième terminal sur l'hôte
  * se connecter au serveur `netcat` (commande `nc`)
* dans un troisième terminal sur la VM
  * utiliser `ss` pour visualiser la connexion `netcat` en cours

***

```
[akram@patron ~]$ sudo firewall-cmd --add-port=31337/tcp --permanent
[akram@patron ~]$ sudo firewall-cmd --reload
[akram@patron ~]$ nc -l


PS C:\Users\akram\Desktop\netcat-win32-1.11\netcat-1.11> .\nc.exe 10.2.1.5 31337
```

***

```


[akram@patron ~]$ sudo firewall-cmd --add-port=1600/tcp --permanent
[sudo] password for akram:
success
[akram@patron ~]$ nc -l
^C
[akram@patron ~]$ sudo firewall-cmd --reload
^[[A^[[Bsuccess
[akram@patron ~]$ nc -l

PS C:\Users\akram\Desktop\netcat-win32-1.11\netcat-1.11> .\nc.exe 192.168.56.1 1600

[akram@patron ~]$ sudo ss -tnup
tcp    ESTAB      0      0                     10.0.2.15:60216                          192.168.56.1:1600                users:(("nc",pid=4092,fd=3))
```

## 3. Wireshark

🌞 Essayez de mettre en évidence
* le fait que le contenu des messages envoyés avec `netcat` est visible dans Wireshark
* les trois messages d'établissement de la connexion
  * peu importe qui est client et qui est serveur une fois la connexion établie
  * mais au moment de l'établissement de la connexion, il y a trois messages particuliers qui sont échangés
  * ces trois messages ont pour source le client



## III. Routage statique

### 2. Configuration du routage
#### A. PC1

* PC2 a PC1

```
C:\Windows\system32>ping 10.2.2.1

Envoi d’une requête 'Ping'  10.2.2.1 avec 32 octets de données :
Réponse de 10.2.2.1 : octets=32 temps=3 ms TTL=127
Réponse de 10.2.2.1 : octets=32 temps=1 ms TTL=127
Réponse de 10.2.2.1 : octets=32 temps=1 ms TTL=127
Réponse de 10.2.2.1 : octets=32 temps=2 ms TTL=127

Statistiques Ping pour 10.2.2.1:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 3ms, Moyenne = 1ms
```
#### B. PC2

* PC1 à PC2

```
C:\WINDOWS\system32>ping 10.2.1.1

Envoi d’une requête 'Ping'  10.2.1.1 avec 32 octets de données :
Réponse de 10.2.1.1 : octets=32 temps=1 ms TTL=127
Réponse de 10.2.1.1 : octets=32 temps=2 ms TTL=127

Statistiques Ping pour 10.2.1.1:
    Paquets : envoyés = 2, reçus = 2, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 2ms, Moyenne = 1ms
```
#### C. VM1

```
ip route add 10.2.2.0/24 via 10.2.1.1 dev enp0s8
```

* PC2 a VM1 
```
[akram@localhost ~]$ ping 10.2.2.1
PING 10.2.2.1 (10.2.2.1) 56(84) bytes of data.
64 bytes from 10.2.2.1: icmp_seq=1 ttl=126 time=1.88 ms
64 bytes from 10.2.2.1: icmp_seq=2 ttl=126 time=1.98 ms
64 bytes from 10.2.2.1: icmp_seq=3 ttl=126 time=2.78 ms
^X^C
--- 10.2.2.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2018ms
rtt min/avg/max/mdev = 1.889/2.222/2.789/0.404 ms
```
#### D. VM2

* PC1 a VM2
```
[akram@patron ~]$ ping 10.2.1.1
PING 10.2.1.1 (10.2.1.1) 56(84) bytes of data.
64 bytes from 10.2.1.1: icmp_seq=1 ttl=126 time=2.01 ms
64 bytes from 10.2.1.1: icmp_seq=2 ttl=126 time=2.56 ms
64 bytes from 10.2.1.1: icmp_seq=3 ttl=126 time=3.22 ms
64 bytes from 10.2.1.1: icmp_seq=4 ttl=126 time=2.84 ms
64 bytes from 10.2.1.1: icmp_seq=5 ttl=126 time=2.57 ms
^C
--- 10.2.1.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4009ms
rtt min/avg/max/mdev = 2.015/2.644/3.229/0.398 ms
```

#### E. El gran final

* VM1 a VM2
```
[akram@patron ~]$ ping 10.2.1.2
PING 10.2.1.2 (10.2.1.2) 56(84) bytes of data.
64 bytes from 10.2.1.2: icmp_seq=1 ttl=62 time=1.75 ms
64 bytes from 10.2.1.2: icmp_seq=2 ttl=62 time=2.37 ms
64 bytes from 10.2.1.2: icmp_seq=3 ttl=62 time=2.78 ms
64 bytes from 10.2.1.2: icmp_seq=4 ttl=62 time=3.02 ms
64 bytes from 10.2.1.2: icmp_seq=5 ttl=62 time=2.26 ms
^C
--- 10.2.1.2 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4011ms
rtt min/avg/max/mdev = 1.906/2.469/3.023/0.397 ms
```

* VM2 a VM1
```
[akram@patron ~]$ ping 10.2.2.2
PING 10.2.2.2 (10.2.2.2) 56(84) bytes of data.
64 bytes from 10.2.2.2: icmp_seq=1 ttl=62 time=1.85 ms
64 bytes from 10.2.2.2: icmp_seq=2 ttl=62 time=3.16 ms
64 bytes from 10.2.2.2: icmp_seq=3 ttl=62 time=3.54 ms
^C
--- 10.2.2.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2007ms
rtt min/avg/max/mdev = 1.828/2.855/3.544/0.702 ms
```

### 3. Configuration des noms de domaine

* Fichier host

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.2.1.10   vm1.tp2.b1
10.2.3.10   vm3.tp2.b1                                                                                               
```

* Ping domaines sah quel plaisir

```
[akram@patron]$ ping vm1.tp2.b1
PING vm1.tp2.b1 (10.2.1.10) 56(84) bytes of data.
64 bytes from vm1.tp2.b1 (10.2.1.10): icmp_seq=1 ttl=62 time=2.04 ms
64 bytes from vm1.tp2.b1 (10.2.1.10): icmp_seq=2 ttl=62 time=2.08 ms
64 bytes from vm1.tp2.b1 (10.2.1.10): icmp_seq=3 ttl=62 time=2.24 ms
64 bytes from vm1.tp2.b1 (10.2.1.10): icmp_seq=4 ttl=62 time=2.89 ms
^C
--- vm1.tp2.b1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 2.044/2.314/2.891/0.341 ms

[akram@patron]$ ping vm3.tp2.b1
PING vm3.tp2.b1 (10.2.3.10) 56(84) bytes of data.
64 bytes from vm3.tp2.b1 (10.2.3.10): icmp_seq=1 ttl=62 time=1.92 ms
64 bytes from vm3.tp2.b1 (10.2.3.10): icmp_seq=2 ttl=62 time=2.02 ms
64 bytes from vm3.tp2.b1 (10.2.3.10): icmp_seq=3 ttl=62 time=2.07 ms
64 bytes from vm3.tp2.b1 (10.2.3.10): icmp_seq=4 ttl=62 time=2.14 ms
^C
--- vm3.tp2.b1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 1.929/2.043/2.140/0.077 ms
```

* Traceroute domaine

```
[akram@patron]$ traceroute vm1.tp2.b1
traceroute to vm1.tp2.b1 (10.2.1.10), 30 hops max, 60 byte packets
 1  10.2.2.2 (10.2.2.2)  0.213 ms * *
 2  * * *
 3  vm1.tp2.b1 (10.2.1.10)  1.659 ms !X  1.566 ms !X  1.542 ms !X
 
[akram@patron]$ traceroute vm3.tp2.b1
traceroute to vm3.tp2.b1 (10.2.3.10), 30 hops max, 60 byte packets
 1  10.2.2.2 (10.2.2.2)  0.327 ms * *
 2  * * *
 3  vm3.tp2.b1 (10.2.3.10)  1.692 ms !X  1.528 ms !X  2.884 ms !X
```

* Netcat
```
[akram@patron]$ nc -l 22000
jgroeigo
slt
f
ez
```
```
[akram@patron ~]$ nc vm2.tp2.b1 22000
jgroeigo
slt
f
ez
```