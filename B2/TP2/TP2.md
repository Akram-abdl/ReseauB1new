# TP2 : Déploiement automatisé

Au menu :
* réutilisation du [TP1](../1/)
* utilisation de [Vagrant](https://www.vagrantup.com/)
* premiers pas dans l'automatisation

# I. Déploiement simple

🌞 Créer un `Vagrantfile` qui :
* utilise la box `centos/7`
* crée une seule VM
  * 1Go RAM
  * ajout d'une IP statique `192.168.2.11/24`
  * définition d'un nom (interne à Vagrant)
  * définition d'un hostname 

* On modifie tout d'abord le vagrantfile:

```ruby
Vagrant.configure("2")do|config|
  config.vm.box="centos/7"

  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false

  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false 

  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.hostname = "node"

  config.vm.define "tp2" do |tp2|
    tp2.vm.network "private_network", ip: "192.168.2.11", netmask:"255.255.255.0"
    tp2.vm.provider "virtualbox" do |vb|
      vb.name = "TP2 VM"
      vb.memory = "1024"
    end
  end
end
```

* Ensuite on fait les commandes suivantes:
```bash
 vagrant up
Bringing machine 'tp2' up with 'virtualbox' provider...
==> tp2: Importing base box 'centos/7'...
```

```bash
PS D:\vagrantwork> vagrant ssh
[vagrant@node ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:4d:77:d3 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 86007sec preferred_lft 86007sec
    inet6 fe80::5054:ff:fe4d:77d3/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:06:dd:0c brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.11/24 brd 192.168.2.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe06:dd0c/64 scope link
       valid_lft forever preferred_lft forever

[vagrant@node ~]$ free
              total        used        free      shared  buff/cache   available
Mem:        1014764       86944      809004        6856      118816      793524
Swap:       2097148           0     2097148
[vagrant@node ~]$ hostname
node
```

🌞 Modifier le `Vagrantfile`
* la machine exécute un script shell au démarrage qui install le paquet `vim`
* ajout d'un deuxième disque de 5Go à la VM

#### On crée un fichier boot.sh avec le script:
```bash
#!/bin/bash
# Akram
# 29/09/2020
# Installation de vim

yum install vim -y
```
puis on tape les commandes suivantes :
```bash
vagrant reload tp2
vim -v
```

# II. Re-package

La démarche est la suivante :
* on allume une VM de base
* à l'intérieur de la VM, on effectue les modifications souhaitées
  * création de fichiers
  * ajout de paquets
  * config système
  * etc.
* on exit la VM, en la gardant allumée
* utilisation d'une commande `vagrant` pour créer une nouvelle box à partir de la VM existante
```bash
[vagrant@node ~]$ sudo systemctl start firewalld
[vagrant@node ~]$ sudo firewall-cmd --permanent --add-service=ssh
[vagrant@node ~]$ sudo systemctl restart 
[vagrant@node ~]$ sudo firewall-cmd --list-all
[vagrant@node ~]$ sudo setenforce 0
[vagrant@node ~]$ vim /etc/selinux/config
[vagrant@node ~]$ sudo !!
sudo vim /etc/selinux/config
[vagrant@node ~]$ sudo shutdown -r now
[vagrant@node ~]$ exit
logout
Connection to 127.0.0.1 closed.
PS D:\vagrantwork> vagrant package --output centos7-custom.box
==> tp2: Attempting graceful shutdown of VM...
==> tp2: Clearing any previously set forwarded ports...
==> tp2: Exporting VM...
==> tp2: Compressing package to: D:/vagrantwork/centos7-custom.box
PS D:\vagrantwork> vagrant box add centos-custom centos-custom.box
PS D:\vagrantwork> vagrant box add centos7-custom centos7-custom.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'centos7-custom' (v0) for provider:
    box: Unpacking necessary files from: file://D:/vagrantwork/centos7-custom.box
    box:
==> box: Successfully added box 'centos7-custom' (v0) for 'virtualbox'!
```

# III. Multi-node deployment

Il est possible de déployer et gérer plusieurs VMs en un seul `Vagrantfile`.


* Modification du Vagrantfile:
```ruby
Vagrant.configure("2")do|config|
    config.vm.box="b2-tp2-centos"

    # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
    config.vbguest.auto_update = false

    # Désactive les updates auto qui peuvent ralentir le lancement de la machine
    config.vm.box_check_update = false 

    # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.define "node1" do |node1|
        node1.vm.hostname = "node1.tp2.b2"
        node1.vm.network "private_network", ip: "192.168.2.21", netmask:"255.255.255.0"
        node1.vm.provider "virtualbox" do |vb|
          vb.memory = "1024"
        end
    end

    config.vm.define "node2" do |node2|
      node2.vm.hostname = "node2.tp2.b2"
      node2.vm.network "private_network", ip: "192.168.2.22", netmask:"255.255.255.0"
      node2.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
      end
    end
end
```
On rentre les commandes suivantes:
```bash
PS D:\vagrantwork> vagrant package --output b2-tp2-centos.box
==> tp2: Exporting VM...
==> tp2: Compressing package to: D:/vagrantwork/b2-tp2-centos.box
PS D:\vagrantwork> vagrant box add b2-tp2-centos b2-tp2-centos.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'b2-tp2-centos' (v0) for provider:
    box: Unpacking necessary files from: file://D:/vagrantwork/b2-tp2-centos.box
    box:
==> box: Successfully added box 'b2-tp2-centos' (v0) for 'virtualbox'!
PS D:\vagrantwork> vagrant status
Current machine states:

node1                     not created (virtualbox)
node2                     not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
PS D:\vagrantwork> vagrant up
PS D:\vagrantwork> vagrant status
Current machine states:

node1                     running (virtualbox)
node2                     running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

# IV. Automation here we (slowly) come

Cette dernière étape vise à automatiser la résolution du TP1 à l'aide de Vagrant et d'un peu de scripting.

* Tout d'abord on modifie Vagranfile en rajoutant le chemin vers les scripts:


```ruby
Vagrant.configure("2")do|config|
    config.vm.box="b2-tp2-centos"

    # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
    config.vbguest.auto_update = false

    # Désactive les updates auto qui peuvent ralentir le lancement de la machine
    config.vm.box_check_update = false 

    # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.define "node1" do |node1|
        node1.vm.hostname = "node1.tp2.b2"
        node1.vm.network "private_network", ip: "192.168.2.21", netmask:"255.255.255.0"
        node1.vm.provision "shell", path: "server.sh"
        node1.vm.provider "virtualbox" do |vb|
          vb.memory = "1024"
        end
    end

    config.vm.define "node2" do |node2|
      node2.vm.hostname = "node2.tp2.b2"
      node2.vm.network "private_network", ip: "192.168.2.22", netmask:"255.255.255.0"
      node2.vm.provision "shell", path: "client.sh"
      node2.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
      end
    end
end
```

* Puis on crée les scripts de setup des deux VMs (Disponible dans le dossier partie 4)

* On vagrant up et on vérifie si tout fonctionne bien:
```bash
[vagrant@node2 ~]$ curl -L https://node1.tp1.b2
<h1>Eh bah coucou site1</h1>
```
On peut donc voir que tout fonctionne bien
