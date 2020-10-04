#!/bin/bash
#Akram
#30/09/2020
#Configuration serveur

echo "192.168.1.11 node1.tp1.b2" | tee /etc/hosts
echo "192.168.1.12 node2.tp1.b2" | tee /etc/hosts

#création des utilisateurs
useradd admin -m
usermod -aG wheel admin
useradd server -M -s /sbin/nologin

#Création fichiers
mkdir /srv/site1
mkdir /srv/site2

echo '<h1>Eh bah coucou site1</h1>' | tee /srv/site1/index.html
echo '<h1>Eh bah coucou site2</h1>' | tee /srv/site2/index.html

chown server:server  /srv/site1 -R
chmod 740 /srv/site1 -R

chown server:server  /srv/site2 -R
chmod 740 /srv/site2 -R

#Configuration du firewalld
firewall-cmd --permanent --add-port="80/tcp"
firewall-cmd --permanent --add-port="443/tcp"
firewall-cmd --reload

#génération de clé + de certificats
touch node1.tp1.b2.key
chown admin:admin node1.tp1.b2.key
echo '-----BEGIN PRIVATE KEY-----
MIIEvQIBADwNBgkqhkiG9w2BAQEFAASCBKcwggSjAgEAAoIBAQCvHf/ovrNFVnHy
wMPsyh6QUjmbufFm3Xg7rjyS6GLZga/k+TtyQ3CnuGpRpfaMlCnAdkV55uOLlhgh
JrrGFddDGytdfbyIy5G6iDA58keGfTodtvhsgrw2RmEiBPjecolvMJQHgtZkobvk
xp+7z1VY0k2NrOyQmyHmzgmtwInSgqyyVHabNBUpFWHqLLFA84DxfgRIZcBf2FpC
wnwVIS5KpZkQmm+KgC62k6E2jfHfLP1lxZ1ZjgVMdtL5vrJlvTFN+rJEBQKMj6a5
07tBVukEVHuaxvn9C5fK/VfugrbvACgcBZIl5zZxKmgLvLC/aYT8zL34aQbaZGW
o28hbGQDAgMBAAECggEAd8IJaA86pHmY1c30b3ROcJ563T/Nkm51MkNXE5SvPVaO
hwXXHK54VYst0oYBQmR1JTT9EH/RL33HJKzK4HrBSxhCkN5TWC33jFxktsw1FAmB
/B5MSCBGihndw91bxNfX9YV9gkJO6rLxxHxwcs047dRsyy3uXnppNeHEBrp8xqQL
TynaGkHQ++ghSxs5VZL35ejXvIdDPRwTWT0xDDcJLaH8JacBL87DMww5L7T/ucnh
UAvtjFhplQqRoTJTTu2KeRDeP4qf77RZXjZacIS0fr84KJEmvz4swi+Bqt1FcgAN
yMWCeoVBPrF+fUKuRm6wRFDzJCjfZcVEMKw7cGN1qQKBgQDb1K72TBK7n5oRW508
dIJBEiGPzp6MXY1zqpfjeEGyqqZPLmfAFJ5vN106vgAFO5z7D769URE6WcetXkfN
nFS2aMRhld0YT8ZfSC4W24bbqRMrnDJd29lEOKc+NENpGGzPtMmDLg9GyE9svHNP
z4FUM5QxHLQfug55sKKtAsG0VQKBgQDL7fhcfkWtAwSgcQ+1OU8LTpKWnQarQ8tg
BWcWvturvOducQuMcqS73vgvcXcEb410kWlmwGjhshxWNftlBbh2A5MRfNQ415xB
/GPJUHAmYKeLQCO2jmQGfmIefY3vB/+bQItfkLlVeuxdCY/IkxNGUMvmvFEHwVQX
QNvx1r/O9wKBgGTX/CsgWreXT6YG0Oqax+Xx21ONBU5+3BTjfSnsULcVcZWBRDbp
PoTmcO4xmvDLmAfUATv3pF+QL/ln9qhrvrCu/ueFSBePAQFUq0/xBLxfo1uuG6zS
3aheFNqEPyhG/COMW6TBzGA8I7NN/9fs6PcnciPVdwvW3iqUyotzaEjBAoGBAI8r
AGQfGld+eO8SsQ5vr3imru8iSp5OOCevY1Jqp9oIAwpcPtlZWyGyRdc492+byVl/
BNpoVrmsy4wS1e10eK4RkFyEoJFPfZot0PhyimnHDZkLbIcrrDmK3OO/Dbg0i1S5
mZ98AUFrzSj8H3+XEb8Z1iylJzfm+hxhIojEVWC9AoGAPcMfYdECX3HvYmSmExR1
BBcTn+3bDhIW8MRdG8JIwlB+/2HGu88e4F87+eIuP/R1OQnDI3fMT52ybDCCmy9e
T9Fc2KItX5AJdUMfcMDWpTB8ez2I1XVPTO//laeTeps5Cl+PyEjdIwsYfn/lsiph
mcSJov0eRuZKNw2ydZSQHJc=
-----END PRIVATE KEY-----' | tee /home/admin/node1.tp1.b2.key


touch node1.tp1.b2.crt
chown admin:admin node1.tp1.b2.crt
echo '-----BEGIN CERTIFICATE-----
MIIDvzCCAqewAwIBAgIJAIdrqoOJUlQ7MA0GCSqGSIb3DQEBCwUAMHYxCzAJBgNV
BAYTAmZyMQ8wDQYDVQQIDAZGcmFuY2UxETAPBgNVBAcMCGJvcmRlYXV4MQ0wCwYD
VQQKDAR5bm92MQ4wDAYDVQQLDAVsaW51eDELMAkGA1UEAwwCdHAxFzAVBgkqhkiG
9w0BCQEWCG5vYWRyZXNzMB4XDTIwMTAwNDExMTIyN1oXDTIxMTAwNDExMTIyN1ow
djELMAkGA1UEBhMCZnIxDzANBgNVBAgMBkZyYW5jZTERMA8GA1UEBwwIYm9yZGVh
dXgxDTALBgNVBAoMBHlub3YxDjAMBgNVBAsMBWxpbnV4MQswCQYDVQQDDAJ0cDEX
MBUGCSqGSIb3DQEJARYwbm9hZHJlc3MwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQCvHf/ovrNFVnHywMPsyh6QUjmbufFm3Xg7rjyS6GLZga/k+TtyQ3Cn
uGpRpPaMlCnAdkV55uOLlhghJrrGFddDGytdfbyIy5G6iDA58keGfTodtvhsO0gR
mEiBPjecolvMJQHgtZkobvkFxp+7z1VY0k2NrOyQmyHmzgmtwInSgqyyVHxbNBUp
FWHqLLFA84DxfgRIZcBf2FpCwnwVIS5KpZkQmm+KgC62k6E2jfHfLP1lxZ1ZjgVM
dtL5vrJlvTFN+rJEBQKMj6a507tBVukEVHuaxvn9C5fK/Vfu2rgcQECgcBZIl5zZ
xKmgLvLC/aYT8zL34aQbaZGWo28hbGQDAgMBAAGjUDBOMB0GA1UdDgQWBBRUukcv
pT5xP3TtSnRyjVsE/2A9yDAfBgNVHSMEGDAWgBRUukcvpT5xP3TtSnRyjVsE/2A9
yDAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBlf1JRZlYYQouRNQCr
SrSpVlpRmWGIp0H0GhjZ2UH4wRAZlUdAlLOw/GA45w4xPje0DslJ3lQ5z9nyPbGy
MjBpl1JnOTstcuGJGW/OtFGN4Ho2cndJUZybzTNz9owgjm1jK63tRxmdpLZkibj4
2zxqVS7m2pexnDjSAPn/KPeP9E8Y9Jzzkn04/k80Sjk9n6pY6kobxe0hCQpcbjfy
V+tqWwZC5QpqVQVo3PDNwnqT08NDrsEo0MVO+niwK2wHWR4DLmXRFfgsjriGNCUk
OQzJmDGuym2Gg5zteWwjGW52KiSRsiBGHPrY5UgPHbaBhZwlW6mAUoYxvRJ90xfy
yYNV
-----END CERTIFICATE-----' | tee /home/admin/node1.tp1.b2.crt

chmod 400 node1.tp1.b2.crt
chmod 400 node1.tp1.b2.key

#configuration du serveur nginx

echo 'worker_processes 1;
error_log nginx_error.log;
pid /run/nginx.pid;
user server;
events {
	worker_connections 1024;
}

http {
	server {
		listen 80;
		server_name node1.tp1.b2;

		location / {
			return 301 /site1;
		}
		location /site1 {
			alias /srv/site1;
		}
		location /site2 {
			alias /srv/site2;
		}
	}
	server {
		listen 443 ssl;

		server_name node1.tp1.b2;
		ssl_certificate /home/admin/node1.tp1.b2.crt;
		ssl_certificate_key /home/admin/node1.tp1.b2.key;

                location / {
                        return 301 /site1;
                }
                location /site1 {
                        alias /srv/site1;
                }
                location /site2 {
                        alias /srv/site2;
                }
	
	}
}'| tee /etc/nginx/nginx.conf

systemctl start nginx
