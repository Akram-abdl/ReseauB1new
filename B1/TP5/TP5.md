# TP 5 - Une "vraie" topologie ?

## I. Toplogie 1 - intro VLAN

### 2. Setup clients

##### 🌞 Tout ce beau monde doit se ping

* les admins se joignent entre eux

```
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.713 ms
84 bytes from 10.5.10.12 icmp_seq=2 ttl=64 time=1.367 ms
84 bytes from 10.5.10.12 icmp_seq=3 ttl=64 time=0.881 ms
84 bytes from 10.5.10.12 icmp_seq=4 ttl=64 time=1.060 ms
84 bytes from 10.5.10.12 icmp_seq=5 ttl=64 time=0.832 ms
```

* les guests se joignent entre eux

```
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=1.084 ms
84 bytes from 10.5.20.12 icmp_seq=2 ttl=64 time=0.895 ms
84 bytes from 10.5.20.12 icmp_seq=3 ttl=64 time=1.557 ms
84 bytes from 10.5.20.12 icmp_seq=4 ttl=64 time=1.019 ms
84 bytes from 10.5.20.12 icmp_seq=5 ttl=64 time=1.489 ms
```

### 3. Setup VLANs

##### 🌞 Mettez en place les VLANs sur vos switches


* les ports vers les clients (admins et guests) sont en access

```
IOU1#show vlan brief

VLAN Name Status Ports
```

```
1 default active Et0/1, Et0/2, Et0/3, Et1/1
Et1/2, Et1/3, Et2/1, Et2/2
Et2/3, Et3/0, Et3/1, Et3/2
Et3/3
10 admins active Et1/0
20 guest active Et2/0
1002 fddi-default act/unsup
1003 token-ring-default act/unsup
1004 fddinet-default act/unsup
1005 trnet-default act/unsup
```

```
IOU2#show vlan brief

VLAN Name Status Ports
```

```
1 default active Et0/1, Et0/2, Et0/3, Et1/1
Et1/2, Et1/3, Et2/1, Et2/2
Et2/3, Et3/0, Et3/1, Et3/2
Et3/3
10 admins active Et1/0
20 guests active Et2/0
1002 fddi-default act/unsup
1003 token-ring-default act/unsup
1004 fddinet-default act/unsup
1005 trnet-default act/unsup

les ports qui relient deux switches sont en trunk

IOU1#show interface trunk

Port Mode Encapsulation Status Native vlan
Et0/0 on 802.1q trunking 1

Port Vlans allowed on trunk
Et0/0 1-4094

Port Vlans allowed and active in management domain
Et0/0 1,10,20

Port Vlans in spanning tree forwarding state and not pruned
Et0/0 1,10,20
```

```
IOU2#show int trunk

Port Mode Encapsulation Status Native vlan
Et0/0 on 802.1q trunking 1

Port Vlans allowed on trunk
Et0/0 1-4094

Port Vlans allowed and active in management domain
Et0/0 1,10,20

Port Vlans in spanning tree forwarding state and not pruned
Et0/0 1,10,20
```

##### 🌞 Vérifier que:

* les guests peuvent toujours se ping, idem pour les admins

```

guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.326 ms
84 bytes from 10.5.20.12 icmp_seq=2 ttl=64 time=4.196 ms
84 bytes from 10.5.20.12 icmp_seq=3 ttl=64 time=0.494 ms
84 bytes from 10.5.20.12 icmp_seq=4 ttl=64 time=0.461 ms
84 bytes from 10.5.20.12 icmp_seq=5 ttl=64 time=0.434 ms

admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.286 ms
84 bytes from 10.5.10.12 icmp_seq=2 ttl=64 time=0.460 ms
84 bytes from 10.5.10.12 icmp_seq=3 ttl=64 time=0.543 ms
84 bytes from 10.5.10.12 icmp_seq=4 ttl=64 time=0.431 ms
84 bytes from 10.5.10.12 icmp_seq=5 ttl=64 time=0.402 ms

```

* montrer que si un des guests change d'IP vers une IP du réseau admins, il ne peut PAS joindre les autres admins

```
guest1> ip 10.5.10.13
Checking for duplicate address...
PC1 : 10.5.10.13 255.255.255.0

guest1> ping 10.5.10.11
host (10.5.10.11) not reachable
```

## II. Topologie 2 - VLAN, sous-interface, NAT

### 2. Adressage

##### 🌞 Vérifier que:

* les guests peuvent ping les autres guests

```

guest3> ping 10.5.20.11
84 bytes from 10.5.20.11 icmp_seq=1 ttl=64 time=0.412 ms
84 bytes from 10.5.20.11 icmp_seq=2 ttl=64 time=0.816 ms
84 bytes from 10.5.20.11 icmp_seq=3 ttl=64 time=0.550 ms
84 bytes from 10.5.20.11 icmp_seq=4 ttl=64 time=0.664 ms
84 bytes from 10.5.20.11 icmp_seq=5 ttl=64 time=0.572 ms

```

* les admins peuvent ping les autres admins

```

admin3> ping 10.5.10.11
84 bytes from 10.5.10.11 icmp_seq=1 ttl=64 time=0.557 ms
84 bytes from 10.5.10.11 icmp_seq=2 ttl=64 time=0.661 ms
84 bytes from 10.5.10.11 icmp_seq=3 ttl=64 time=0.592 ms
84 bytes from 10.5.10.11 icmp_seq=4 ttl=64 time=0.653 ms
84 bytes from 10.5.10.11 icmp_seq=5 ttl=64 time=2.635 ms

```

### 3. VLAN

##### 🌞 Configurez les VLANs sur l'ensemble des switches

```

conf t

(config)# vlan 10
(config-vlan)# name admins
(config-vlan)# exit

(config)# vlan 20
(config-vlan)# name guests
(config-vlan)# exit

(config)# interface ethernet <interface lié aux guests et admins>
(config-if)# switchport mode access
(config-if)# switchport access vlan <10 pour admins et 20 pour guests>
(config-if)# exit

```

##### 🌞 Vérifier et prouver qu'un guest qui prend un IP du réseau admins ne peut joindre aucune machine.


```

guest3> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest3> ping 10.5.10.11
host (10.5.10.11) not reachable

guest2> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest2> ping 10.5.10.11
host (10.5.10.11) not reachable

guest1> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest1> ping 10.5.10.11
host (10.5.10.11) not reachable

```

##### 🌞 Configurez les sous-interfaces de votre routeur

```

conf t
(config)# interface fastEthernet1/0.10
(config-subif)# encapsulation dot1Q 10
(config-subif)# ip address 10.5.10.254 255.255.255.0
(config-subif)# exit
(config)# interface fastEthernet1/0.20
(config-subif)# encapsulation dot1Q 20
(config-subif)# ip address 10.5.20.254 255.255.255.0
(config-subif)# exit
(config)# interface fastEthernet1/0
(config)# no shut
(config-if)# exit

```

##### 🌞 Vérifier que les clients et les guests peuvent maintenant ping leur passerelle respective

```

guest2> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=20.151 ms
84 bytes from 10.5.20.254 icmp_seq=2 ttl=255 time=6.848 ms
84 bytes from 10.5.20.254 icmp_seq=3 ttl=255 time=5.083 ms
84 bytes from 10.5.20.254 icmp_seq=4 ttl=255 time=6.994 ms
84 bytes from 10.5.20.254 icmp_seq=5 ttl=255 time=8.788 ms

guest2> ip 10.5.10.15
Checking for duplicate address...
PC1 : 10.5.10.15 255.255.255.0

guest2> ping 10.5.10.254
host (10.5.10.254) not reachable

guest2> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=9.838 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=6.406 ms
84 bytes from 10.5.10.254 icmp_seq=3 ttl=255 time=5.883 ms
84 bytes from 10.5.10.254 icmp_seq=4 ttl=255 time=6.261 ms
84 bytes from 10.5.10.254 icmp_seq=5 ttl=255 time=4.203 ms

admin2> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=8.590 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=4.564 ms
84 bytes from 10.5.10.254 icmp_seq=3 ttl=255 time=9.321 ms
84 bytes from 10.5.10.254 icmp_seq=4 ttl=255 time=12.958 ms
84 bytes from 10.5.10.254 icmp_seq=5 ttl=255 time=4.413 ms

admin3> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=9.727 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=9.450 ms
84 bytes from 10.5.10.254 icmp_seq=3 ttl=255 time=6.069 ms
84 bytes from 10.5.10.254 icmp_seq=4 ttl=255 time=5.355 ms
84 bytes from 10.5.10.254 icmp_seq=5 ttl=255 time=5.888 ms

guest3> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=9.926 ms
84 bytes from 10.5.20.254 icmp_seq=2 ttl=255 time=3.739 ms
84 bytes from 10.5.20.254 icmp_seq=3 ttl=255 time=6.489 ms
84 bytes from 10.5.20.254 icmp_seq=4 ttl=255 time=7.445 ms
84 bytes from 10.5.20.254 icmp_seq=5 ttl=255 time=6.099 ms

admin1> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=9.651 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=4.455 ms
84 bytes from 10.5.10.254 icmp_seq=3 ttl=255 time=8.231 ms
84 bytes from 10.5.10.254 icmp_seq=4 ttl=255 time=9.521 ms
84 bytes from 10.5.10.254 icmp_seq=5 ttl=255 time=13.511 ms

guest1> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=8.972 ms
84 bytes from 10.5.20.254 icmp_seq=2 ttl=255 time=5.524 ms
84 bytes from 10.5.20.254 icmp_seq=3 ttl=255 time=8.387 ms
84 bytes from 10.5.20.254 icmp_seq=4 ttl=255 time=9.761 ms
84 bytes from 10.5.20.254 icmp_seq=5 ttl=255 time=12.590 ms

```

##### 🌞 Configurer un source NAT sur le routeur (comme au TP4)

* Interfaces "externes" :

```

(config)# interface fastEthernet 0/0
(config-if)# ip nat outside

(config)#interface fastethernet 0/0
(config-if)#ip address dhcp
```

* Interfaces "internes" :

```
(config)# interface fastEthernet 1/0.10 (.20 plus tard)
(config-if)# ip nat inside

(config)# access-list 1 permit any

(config)# ip nat inside source list 1 interface fastEthernet 0/0 overload
```


##### 🌞 Vérifier que les clients et les admins peuvent joindre Internet

```

admin1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=74.500 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=24.302 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=51 time=40.425 ms
84 bytes from 8.8.8.8 icmp_seq=4 ttl=51 time=24.952 ms
84 bytes from 8.8.8.8 icmp_seq=5 ttl=51 time=33.208 ms

admin2> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=39.483 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=23.372 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=51 time=34.849 ms
84 bytes from 8.8.8.8 icmp_seq=4 ttl=51 time=26.078 ms
84 bytes from 8.8.8.8 icmp_seq=5 ttl=51 time=23.941 ms

admin3> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=30.373 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=34.255 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=51 time=35.843 ms
84 bytes from 8.8.8.8 icmp_seq=4 ttl=51 time=27.199 ms
84 bytes from 8.8.8.8 icmp_seq=5 ttl=51 time=41.959 ms

guest1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=30.073 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=37.486 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=51 time=25.195 ms
84 bytes from 8.8.8.8 icmp_seq=4 ttl=51 time=34.001 ms
84 bytes from 8.8.8.8 icmp_seq=5 ttl=51 time=32.531 ms

guest2> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=25.083 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=31.136 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=51 time=22.926 ms
84 bytes from 8.8.8.8 icmp_seq=4 ttl=51 time=22.142 ms
84 bytes from 8.8.8.8 icmp_seq=5 ttl=51 time=23.502 ms

guest3> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=51 time=29.951 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=51 time=42.513 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=51 time=35.978 ms
84 bytes from 8.8.8.8 icmp_seq=4 ttl=51 time=24.019 ms
84 bytes from 8.8.8.8 icmp_seq=5 ttl=51 time=27.551 ms

```