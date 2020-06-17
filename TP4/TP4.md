# TP4

## I. Topologie 1 : simple


##### 🌞 Configurer la machine CentOS7 :



* définition d'une IP statique : 
```
enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:3c:13:72 brd ff:ff:ff:ff:ff:ff
    inet 10.4.1.11/24 brd 10.4.1.255 scope global noprefixroute enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe3c:1372/64 scope link
       valid_lft forever preferred_lft forever
```

* définition d'un nom d'hôte :

```
[root@admin1 ~]# hostname
admin1.b1.tp4
```

###### router1

##### 🌞 Configurer le routeur :
```
définition d'une IP statique:
"conf t"  
"interface fastethernet 0/0"
"ip address 10.4.1.254 255.255.255.0" "ip
"no shut"
"interface fastethernet 0/1" "ip address 10.4.2.254 255.255.255.0" 
"no shut"
copy running-config startup-config.

définition d'un nom : doucle click sur le nom

copy running-config startup-config
```
##### 🌞 Configurer le VPCS :
```
définition d'une IP statique : "ip address 10.4.2.11 255.255.255.0" puis save.

définition d'un nom (depuis l'interface de GNS3) doucle click sur le nom et le changer.
```
##### 🌞 Vérifier et PROUVER que :

```
guest1 peut joindre le routeur : "ping 10.4.2.254" à partir de guest1 :

guest1> ping 10.4.2.254
84 bytes from 10.4.2.254 icmp_seq=1 ttl=255 time=42.807 ms
84 bytes from 10.4.2.254 icmp_seq=2 ttl=255 time=3.514 ms
84 bytes from 10.4.2.254 icmp_seq=3 ttl=255 time=5.139 ms
84 bytes from 10.4.2.254 icmp_seq=4 ttl=255 time=2.162 ms
84 bytes from 10.4.2.254 icmp_seq=5 ttl=255 time=6.788 ms

admin1 peut joindre le routeur : "ping 10.4.1.254" à partir de admin1 :

[root@admin1 ~]# ping 10.4.1.254
PING 10.4.1.254 (10.4.1.254) 56(84) bytes of data.
64 bytes from 10.4.1.254: icmp_seq=1 ttl=255 time=19.5 ms
64 bytes from 10.4.1.254: icmp_seq=2 ttl=255 time=5.22 ms
64 bytes from 10.4.1.254: icmp_seq=3 ttl=255 time=3.95 ms
64 bytes from 10.4.1.254: icmp_seq=4 ttl=255 time=13.0 ms
64 bytes from 10.4.1.254: icmp_seq=5 ttl=255 time=4.88 ms
^C
--- 10.4.1.254 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4010ms
rtt min/avg/max/mdev = 3.951/9.344/19.570/6.076 ms

router1 peut joindre les deux autres machines : "ping 10.4.1.11" et "ping 10.4.2.11" à partir du routeur :

R1#ping 10.4.1.11

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.4.1.11, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 32/37/48 ms

R1#ping 10.4.2.11

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.4.2.11, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 32/35/40 ms

vérifier la table ARP de router1:

R1#show arp
Protocol Address Age (min) Hardware Addr Type Interface
Internet 10.4.1.11 22 0800.279d.1907 ARPA FastEthernet0/0
Internet 10.4.2.11 32 0050.7966.6800 ARPA FastEthernet1/0
Internet 192.168.122.1 2 5254.0098.65cc ARPA FastEthernet2/0
Internet 192.168.122.169 - cc03.04f3.0020 ARPA FastEthernet2/0
Internet 10.4.1.254 - cc03.04f3.0000 ARPA FastEthernet0/0
Internet 10.4.2.254 - cc03.04f3.0010 ARPA FastEthernet1/0

s'assurer que les adresses MAC sont les bonnes (en les affichant directement depuis guest1 et admin1) :

3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
link/ether 08:00:27:9d:19:07 brd ff:ff:ff:ff:ff:ff
inet 10.4.1.11/24 brd 10.4.1.255 scope global noprefixroute enp0s8
valid_lft forever preferred_lft forever
inet6 fe80::a00:27ff:fe9d:1907/64 scope link
valid_lft forever preferred_lft forever
```
###### guest1
```

NAME IP/MASK GATEWAY MAC LPORT RHOST:PO RT
guest1 10.4.2.11/24 10.4.2.254 00:50:79:66:68:00 20020 127.0.0. 1:20021
fe80::250:79ff:fe66:6800/64

nano /etc/sysconfig/network-scripts/route-enp0s8 -> 10.4.2.0 via 10.4.1.254 dev enp0s8

```
##### 🌞 Vérifier et PROUVER que :
```
guest1 peut joindre le admin1 et réciproquement :

[root@admin1 ~]# ping 10.4.2.11
PING 10.4.2.11 (10.4.2.11) 56(84) bytes of data.
64 bytes from 10.4.2.11: icmp_seq=1 ttl=63 time=3023 ms
64 bytes from 10.4.2.11: icmp_seq=2 ttl=63 time=2021 ms
64 bytes from 10.4.2.11: icmp_seq=3 ttl=63 time=1020 ms
64 bytes from 10.4.2.11: icmp_seq=4 ttl=63 time=20.3 ms
64 bytes from 10.4.2.11: icmp_seq=5 ttl=63 time=12.6 ms
^C
--- 10.4.2.11 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 12.617/1219.705/3023.086/1168.796 ms, pipe 4

guest1> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=13.735 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=21.426 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=13.914 ms
84 bytes from 10.4.1.11 icmp_seq=4 ttl=63 time=14.436 ms
84 bytes from 10.4.1.11 icmp_seq=5 ttl=63 time=11.912 ms

les paquets transitent par router :

[root@admin1 ~]# traceroute 10.4.2.11
traceroute to 10.4.2.11 (10.4.2.11), 30 hops max, 60 byte packets
1 10.4.1.254 (10.4.1.254) 3.305 ms 3.018 ms 2.938 ms
2 10.4.2.11 (10.4.2.11) 3014.341 ms 6008.520 ms 9019.433 ms

guest1> trace 10.4.1.11
trace to 10.4.1.11, 8 hops max, press Ctrl+C to stop
1 10.4.2.254 14.023 ms 9.986 ms 8.931 ms
2 \*10.4.1.11 18.268 ms (ICMP type:3, code:10, Host administratively prohibited)
```

## II. Topologie 2 : dumb switches

### 2. Mise en place

#### C. Vérification


##### 🌞 Vérifier et PROUVER que :

```
[root@admin1 ~]# ping 10.4.2.11
PING 10.4.2.11 (10.4.2.11) 56(84) bytes of data.
64 bytes from 10.4.2.11: icmp_seq=1 ttl=63 time=6784 ms
64 bytes from 10.4.2.11: icmp_seq=2 ttl=63 time=5781 ms
64 bytes from 10.4.2.11: icmp_seq=3 ttl=63 time=4779 ms
64 bytes from 10.4.2.11: icmp_seq=4 ttl=63 time=3778 ms
64 bytes from 10.4.2.11: icmp_seq=5 ttl=63 time=2775 ms
64 bytes from 10.4.2.11: icmp_seq=6 ttl=63 time=1776 ms
64 bytes from 10.4.2.11: icmp_seq=7 ttl=63 time=773 ms
64 bytes from 10.4.2.11: icmp_seq=8 ttl=63 time=21.3 ms

guest1> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=20.722 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=16.304 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=19.218 ms
84 bytes from 10.4.1.11 icmp_seq=4 ttl=63 time=14.395 ms
84 bytes from 10.4.1.11 icmp_seq=5 ttl=63 time=11.801 ms


[root@admin1 ~]# traceroute 10.4.2.11
traceroute to 10.4.2.11 (10.4.2.11), 30 hops max, 60 byte packets
1 10.4.1.254 (10.4.1.254) 18.778 ms 18.473 ms 19.160 ms
2 10.4.2.11 (10.4.2.11) 3025.382 ms 6031.526 ms 9035.709 ms

guest1> trace 10.4.1.11
trace to 10.4.1.11, 8 hops max, press Ctrl+C to stop
1 10.4.2.254 5.188 ms 8.476 ms 9.688 ms
2 \*10.4.1.11 18.296 ms (ICMP type:3, code:10, Host administratively prohibited)
```
## III. Topologie 3 : adding nodes and NAT

### 1. Présentation de la topo

#### B. VPCS

##### 🌞 Configurer les VPCS


* guest 2

```
guest2> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=19.982 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=20.729 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=17.022 ms
84 bytes from 10.4.1.11 icmp_seq=4 ttl=63 time=14.839 ms
84 bytes from 10.4.1.11 icmp_seq=5 ttl=63 time=17.218 ms

guest2>
```

* guest 3

```
guest3> ping 10.4.1.11
10.4.1.11 icmp_seq=1 timeout
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=15.801 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=14.810 ms
84 bytes from 10.4.1.11 icmp_seq=4 ttl=63 time=16.165 ms
84 bytes from 10.4.1.11 icmp_seq=5 ttl=63 time=14.775 ms

guest3>
```

#### C. Accès WAN

##### 🌞 Configurer le routeur



 IP en DHCP 

```
conf t
interface fastethernet 2/0
ip address dhcp
```

```
R1#show ip int br
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            10.4.1.254      YES NVRAM  up                    up
FastEthernet1/0            10.4.2.254      YES NVRAM  up                    up
FastEthernet2/0            192.168.122.184 YES DHCP   up                    up
NVI0
```


Accès NAT réussi :




🌞 Vérifier et PROUVER que :

→ le routeur a un accès WAN (internet)

```
R1#ping 8.8.8.8

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 8.8.8.8, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 64/67/72 ms
R1#
```

→ tous les clients du réseau ont de la résolution de noms grâce au serveur DNS configuré

 - Guest 1
```
guest1> ping google.fr
google.fr resolved to 172.217.18.195
84 bytes from 172.217.18.195 icmp_seq=1 ttl=54 time=30.613 ms
84 bytes from 172.217.18.195 icmp_seq=2 ttl=54 time=31.889 ms
84 bytes from 172.217.18.195 icmp_seq=3 ttl=54 time=27.483 ms
84 bytes from 172.217.18.195 icmp_seq=4 ttl=54 time=26.526 ms
^C
guest1>
```

 - Guest 2

```
guest2> ping google.fr
google.fr resolved to 172.217.18.195
84 bytes from 172.217.18.195 icmp_seq=1 ttl=54 time=29.851 ms
84 bytes from 172.217.18.195 icmp_seq=2 ttl=54 time=24.773 ms
84 bytes from 172.217.18.195 icmp_seq=3 ttl=54 time=29.918 ms
84 bytes from 172.217.18.195 icmp_seq=4 ttl=54 time=26.500 ms
^C
guest2>
```

 - Guest 3

```
guest3> ping google.fr
google.fr resolved to 172.217.18.195
84 bytes from 172.217.18.195 icmp_seq=1 ttl=54 time=31.705 ms
84 bytes from 172.217.18.195 icmp_seq=2 ttl=54 time=28.843 ms
84 bytes from 172.217.18.195 icmp_seq=3 ttl=54 time=23.639 ms
84 bytes from 172.217.18.195 icmp_seq=4 ttl=54 time=21.626 ms
^C
guest3>
```