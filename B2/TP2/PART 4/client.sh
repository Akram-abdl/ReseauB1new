#!/bin/bash
#Akram
#30/09/2020
#Configuration client nginx

echo "192.168.1.11 node1.tp2.b2" >> /etc/hosts
echo "192.168.1.12 node2.tp2.b2" >> /etc/hosts
useradd admin -m
usermod -aG wheel admin
