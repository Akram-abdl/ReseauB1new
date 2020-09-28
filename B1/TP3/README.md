Avant tout, je propose de commencer par un petit échauffement avec mon poto, Howard, danceur pro de génération en génération.
Prosternez-vous face à sa grandeur bande de mortel.
![](https://media2.giphy.com/media/1oE3Ee4299mmXN8OYb/source.gif)



# B1 Réseau 2019 - TP3

# TP 3 - Routage, ARP, Spéléologie réseau 


### 2 - Mise en place du lab


#### Indications

Mettez en place 3 machines virtuelles (sous CentOS7, version minimale, pas de GUI) :
* Serveur SSH fonctionnel qui écoute sur le port `7777/tcp` (voir [la section dédiée du TP2](../2/README.md#a-ssh))
* [Pare-feu activé et configuré](../../cours/memo/linux_centos_network.md#interagir-avec-le-firewall) pour autoriser le SSH
* [Nom de domaine configuré](../../cours/memo/linux_centos_network.md#changer-son-nom-de-domaine)
* [Fichiers `/etc/hosts`](../../cours/memo/linux_centos_network.md#editer-le-fichier-hosts) de toutes les machines configurés
* [Réseaux et adressage des machines](../../cours/memo/linux_centos_network.md#d%c3%a9finir-une-ip-statique)
* Désactivation de la carte NAT
  * **laissez-la activée dans VirtualBox et désactivez-la dans la VM directement**
  * désactivez-la immédiatement
    * commande `ifdown <INTERFACE_NAME>`
  * désactivation après reboot
    * clause `ONBOOT=no` dans le fichier `/etc/sysconfig/network-scripts/ifcfg-<INTERFACE_NAME>`

🌞 **Prouvez que chacun des points de la préparation de l'environnement ci-dessus ont été respectés** :

* Désactivation de la carte NAT
Carte nat désactivé sur les machines avec ifdown et ONBOOT=no et on vérifie.

```bash
[akram@client1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:95:42:2f brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:92:09:18 brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.11/24 brd 10.3.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe89:c8cf/64 scope link 
       valid_lft forever preferred_lft forever
```

* Serveur SSH fonctionnel qui écoute sur le port 7777/tcp

On vérifie le port ssh 7777 avec la commade ss -tulnp et le firewall : 

```bash
[akram@client1 ~]$ ss -tulnp
Netid State      Recv-Q Send-Q    Local Address:Port                   Peer Address:Port
tcp   LISTEN     0      100           127.0.0.1:25                                *:*
tcp   LISTEN     0      128                   *:7777                              *:*
tcp   LISTEN     0      100               [::1]:25                             [::]:*
tcp   LISTEN     0      128                [::]:7777                           [::]:*
```


```bash
[akram@client1 ~]$ sudo firewall-cmd --list-all
[sudo] password for akram: 
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s8
  sources: 
  services: dhcpv6-client ssh
  ports: 7777/tcp
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports:
  icmp-blocks: 
  rich rules:
```
* [Nom de domaine configuré]
* Le hostname :

```bash
[akram@client1 ~]$ hostname
client1.net1.tp3
```
* [Fichiers `/etc/hosts`]
* Modification du fichier hosts :

```bash
[akram@client1 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.3.1.11   tp3.b1 client1.net1.tp3
```

* Ping de 10.3.1.11 vers la VM : 

```bash
akram :: ~ » ping 10.3.1.11 -c 3
PING 10.3.1.11 (10.3.1.11) 56(84) bytes of data.
64 bytes from 10.3.1.11: icmp_seq=1 ttl=64 time=0.777 ms
64 bytes from 10.3.1.11: icmp_seq=2 ttl=64 time=0.746 ms
64 bytes from 10.3.1.11: icmp_seq=3 ttl=64 time=0.671 ms

--- 10.3.1.11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2020ms
rtt min/avg/max/mdev = 0.671/0.731/0.777/0.044 ms
```


##### Les fameux pings :

* Ping Client1 -> Routeur
```bash
[akram@client1 ~]$ ping 10.3.1.254 -c 3
PING 10.3.1.254 (10.3.1.254) 56(84) bytes of data.
64 bytes from 10.3.1.254: icmp_seq=1 ttl=64 time=1.33 ms
64 bytes from 10.3.1.254: icmp_seq=2 ttl=64 time=2.67 ms
64 bytes from 10.3.1.254: icmp_seq=3 ttl=64 time=1.25 ms

--- 10.3.1.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 1.253/1.753/2.678/0.656 ms
```

* Ping Routeur -> Client1

```bash
[akram@router ~]$ ping 10.3.1.11 -c 3
PING 10.3.1.11 (10.3.1.11) 56(84) bytes of data.
64 bytes from 10.3.1.11: icmp_seq=1 ttl=64 time=1.23 ms
64 bytes from 10.3.1.11: icmp_seq=2 ttl=64 time=1.36 ms
64 bytes from 10.3.1.11: icmp_seq=3 ttl=64 time=1.33 ms

--- 10.3.1.11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2012ms
rtt min/avg/max/mdev = 1.232/1.309/1.365/0.056 ms
```

* Ping Router -> Server1 

```bash
[akram@server1 ~]$ ping 10.3.2.254 -c 3
PING 10.3.2.254 (10.3.2.254) 56(84) bytes of data.
64 bytes from 10.3.2.254: icmp_seq=1 ttl=64 time=1.31 ms
64 bytes from 10.3.2.254: icmp_seq=2 ttl=64 time=2.46 ms
64 bytes from 10.3.2.254: icmp_seq=3 ttl=64 time=1.32 ms

--- 10.3.2.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2009ms
rtt min/avg/max/mdev = 1.314/1.701/2.466/0.541 ms
```

Ping Server1 -> Routeur 

```bash
[akram@router ~]$ ping 10.3.2.11 -c 3
PING 10.3.2.11 (10.3.2.11) 56(84) bytes of data.
64 bytes from 10.3.2.11: icmp_seq=1 ttl=64 time=1.44 ms
64 bytes from 10.3.2.11: icmp_seq=2 ttl=64 time=1.66 ms
64 bytes from 10.3.2.11: icmp_seq=3 ttl=64 time=1.50 ms

--- 10.3.2.11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2007ms
rtt min/avg/max/mdev = 1.441/1.537/1.667/0.095 ms
```


# I. Mise en place du routage

## 1. Configuration du routage sur `router`

🌞 **Effectuez cette commande sur la machine `router`.**

* IP forwarding activé ?

```bash
[akram@router ~]$ cat /proc/sys/net/ipv4/ip_forward
0
``` 

Le 0 veut dire que j'suis un peu une victime de la société voyez-vous donc faut activer tout ça sah quel plaisir:

```bash
[akram@router ~]$ sudo sysctl -w net.ipv4.ip_forward=1
net.ipv4.ip_forward = 1
```

Voilà on est là

## 2. Ajouter les routes statiques

On fait sudo ip route add 10.3.2.0/24 via 10.3.1.254 et on vérifie:

```bash
[akram@client1 ~]$ ip r s                                                 
10.3.1.0/24 dev enp0s8 proto kernel scope link src 10.3.1.11 metric 101 
10.3.2.0/24 via 10.3.1.254 dev enp0s8
```

Même principe pour server1

```bash
[akram@server1 ~]$ ip r s
10.3.1.0/24 via 10.3.2.254 dev enp0s8 
10.3.2.0/24 dev enp0s8 proto kernel scope link src 10.3.2.11 metric 101
```

Test avec `traceroute` : 

```bash
[akram@client1 ~]$ traceroute 10.3.2.11
traceroute to 10.3.2.11 (10.3.2.11), 30 hops max, 60 byte packets
 1  gateway (10.3.1.254)  2.140 ms  1.850 ms  1.745 ms
 2  gateway (10.3.1.254)  1.361 ms !X  0.863 ms !X  2.109 ms !X
```


```bash
[akram@server1 ~]$ ping 10.3.1.254 -c 3
PING 10.3.1.254 (10.3.1.254) 56(84) bytes of data.
64 bytes from 10.3.1.254: icmp_seq=1 ttl=64 time=2.93 ms
64 bytes from 10.3.1.254: icmp_seq=2 ttl=64 time=1.17 ms
64 bytes from 10.3.1.254: icmp_seq=3 ttl=64 time=1.46 ms

--- 10.3.1.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 1.171/1.854/2.930/0.771 ms
```

```bash
[akram@server1 ~]$ traceroute 10.3.1.11
traceroute to 10.3.1.11 (10.3.1.11), 30 hops max, 60 byte packets
 1  gateway (10.3.2.254)  1.122 ms  0.488 ms  0.823 ms
 2  gateway (10.3.2.254)  0.626 ms !X  0.980 ms !X  1.009 ms !X
```

## 3. Comprendre le routage

|             | MAC src       | MAC dst       | IP src       | IP dst       |
| ----------- | ------------- | ------------- | ------------ | ------------ |
| Dans `net1` (trame qui entre dans `router`) | 08:00:27:92:09:18 | 08:00:27:87:d0:62 | 10.3.1.11 | 10.3.2.11 |
| Dans `net2` (trame qui sort de `router`) | 08:00:27:58:82:5e | 08:00:27:25:d5:8e | 10.3.1.11 | 10.3.2.11 |


# II. ARP
## 1. Tables ARP
🌞 **Affichez la table ARP de chacun des machines et expliquez toutes les lignes**

* Client1 : 

```bash
[akram@client1 ~]$ ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:87:d0:62 STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:00 REACHABLE
```

10.3.1.254 = adresse du router
dev enp0s8 = nom de l'interface : enp0s8
08:00:27:87:d0:62 = MAC router
0a:00:27:00:00:00 =  MAC host-only



* Server1

```bash
[akram@server1 ~]$ ip neigh show 
10.3.2.254 dev enp0s8 lladdr 08:00:27:58:82:5e STALE
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:01 REACHABLE
```


10.3.2.254 = adresse du router
dev enp0s8 = Nom de l'interface réseau enp0s8
08:00:27:58:82:5e = MAC router
0a:00:27:00:00:01 = MAC host-only

* Router

```bash
[akram@router ~]$ ip neigh show  
10.3.1.11 dev enp0s8 lladdr 08:00:27:92:09:18 STALE
10.3.2.11 dev enp0s9 lladdr 08:00:27:25:d5:8e STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:00 REACHABLE
```

10.3.1.11 = adresse du client1
10.3.2.11 = adresse du server1
dev enp0s8 = Nom interface enp0s8
dev enp0s9 = Nom interface enp0s9


# 2. Requêtes ARP
## A. Table ARP 1

table ARP  client1 : 

```bash
[akram@client1 ~]$ sudo ip neigh flush all
[akram@client1 ~]$ ip neigh show          
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:00 REACHABLE
```
On a que le routeur

```bash
[akram@client1 ~]$ ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:87:d0:62 REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:00 REACHABLE
```

On voit que server1 est atteignable


### B. Table ARP 2

commande ping 10.3.2.11 -c 3

```bash
[akram@server1 ~]$ ip neigh show
10.3.2.254 dev enp0s8 lladdr 08:00:27:58:82:5e REACHABLE
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:01 REACHABLE
```

Client 1 atteignable


### C. `tcpdump` 1

```bash
6	1.686093	PcsCompu_92:14:91	Broadcast	ARP	42	Who has 10.3.1.254? Tell 10.3.1.11
```

client1 demande qui est 10.3.1.254 ? 

```bash
8	1.687148	PcsCompu_76:e0:78	PcsCompu_92:14:91	ARP	60	10.3.1.254 is at 08:00:27:87:d0:62
```

10.3.1.254 se trouve à 08:00:27:87:d0:62


### D. `tcpdump` 2

```bash
3	19.027394	PcsCompu_16:98:9d	Broadcast	ARP	60	Who has 10.3.2.11? Tell 10.3.2.254
```

On demande qui est 10.3.2.11

```bash
4	19.027453	PcsCompu_33:cd:4e	PcsCompu_16:98:9d	ARP	42	10.3.2.11 is at 08:00:27:25:d5:8e
```

`10.3.2.11` se trouve à 08:00:27:25:d5:8e

# III. Plus de `tcpdump`
## 1. TCP et UDP
### A. Warm-up


* commande nc -l -t -p 9999 sur le server1
* commande nc -t 10.3.2.11 9999 sur le client1

```bash
[akram@server1 ~]$ nc -l -t -p 9999
z
jfi        
sah quel bail
zgeg de mammouth
jsp comment on ecrit mammouth
```
la même avec UDP

```bash
[akram@server1 ~]$ nc -l -u -p 9999
z
jfi
sah quel bail
zgeg de mammouth
jsp comment on ecrit mammouth
```



### B. Analyse de trames
🌞 **UDP** :

ARP BROADCAST TYPE:

```bash
3	6.307766	10.3.1.11	10.3.2.11	TCP	74	33794 → 9999 [SYN] Seq=0 Win=29200 Len=0 MSS=1460 SACK_PERM=1 TSval=15407937 TSecr=0 WS=64

4	6.308231	10.3.2.11	10.3.1.11	TCP	74	9999 → 33794 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 MSS=1460 SACK_PERM=1 TSval=15403128 TSecr=15407937 WS=64

5	6.308565	10.3.1.11	10.3.2.11	TCP	66	33794 → 9999 [ACK] Seq=1 Ack=1 Win=29248 Len=0 TSval=15407946 TSecr=15403128
```


SYN = Je salue
SYN, ACK = Il salue, et confirme mon salut 
ACK = Je confirme son salut


```bash
6	7.991315	10.3.1.11	10.3.2.11	TCP	72	33794 → 9999 [PSH, ACK] Seq=1 Ack=1 Win=29248 Len=6 TSval=15409628 TSecr=15403128

7	7.992530	10.3.2.11	10.3.1.11	TCP	66	9999 → 33794 [ACK] Seq=1 Ack=7 Win=28992 Len=0 TSval=15404811 TSecr=15409628
```

- PSH = Envoie données


```bash
14	13.891859	10.3.2.11	10.3.1.11	TCP	66	9999 → 33794 [FIN, ACK] Seq=1 Ack=22 Win=28992 Len=0 TSval=15410710 TSecr=15412504

15	13.894175	10.3.1.11	10.3.2.11	TCP	66	33794 → 9999 [ACK] Seq=22 Ack=2 Win=29248 Len=0 TSval=15415532 TSecr=15410710
```

- FIN = Bah la fin



🌞 **UDP** :

```bash
3	4.130183	10.3.1.11	10.3.2.11	UDP	60	41261 → 9999 Len=5

4	4.988314	10.3.1.11	10.3.2.11	UDP	60	41261 → 9999 Len=5

5	5.906879	10.3.1.11	10.3.2.11	UDP	60	41261 → 9999 Len=4
```

Port 9999 et pas de ACK PSH et autres. On envoie sans suivre ni analyser.


## 2. SSH

🌞 Effectuez une connexion SSH depuis `client1` vers `server1`

```bash
[akram@client1 ~]$ ssh 10.3.2.11 -p 7777
```
* trouvez quel protocole utilise SSH : TCP ou UDP ?

tcpdump :

```bash
3	7.486489	10.3.1.11	10.3.2.11	TCP	74	41534 → 7777 [SYN] Seq=0 Win=29200 Len=0 MSS=1460 SACK_PERM=1 TSval=23895905 TSecr=0 WS=64

4	7.487919	10.3.2.11	10.3.1.11	TCP	74	7777 → 41534 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 MSS=1460 SACK_PERM=1 TSval=23891093 TSecr=23895905 WS=64

5	7.488387	10.3.1.11	10.3.2.11	TCP	66	41534 → 7777 [ACK] Seq=1 Ack=1 Win=29248 Len=0 TSval=23895913 TSecr=23891093
```

Méthode utilisées  = TCP
