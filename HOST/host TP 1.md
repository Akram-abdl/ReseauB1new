

## Host OS

🌞 Déterminer les principales informations de votre machine 

1.

* nom de la machine

```ps
PS C:\Windows\System32> .\HOSTNAME.EXE
DESKTOP-KNU6AKN
```

2.

* OS et version

```ps
PS C:\Windows\System32> Get-ComputerInfo  | select windowsversion

WindowsVersion
--------------
1809
```

3/4.

* architecture processeur (32-bit, 64-bit, ARM, etc)
* modèle du processeur

```ps
PS C:\Windows\System32> Get-WmiObject Win32_Processor


Caption           : Intel64 Family 6 Model 158 Stepping 9
DeviceID          : CPU0
Manufacturer      : GenuineIntel
MaxClockSpeed     : 2501
Name              : Intel(R) Core(TM) i5-7300HQ CPU @ 2.50GHz
SocketDesignation : U3E1
```


5.

* quantité RAM et modèle de la RAM

```ps
PS C:\Windows\System32> Get-WmiObject win32_physicalmemory
Manufacturer         : Samsung
MaxVoltage           : 1500
Speed                : 2400
ConfiguredClockSpeed : 2400
BankLabel            : BANK 0
Capacity             : 8589934592
```

## Devices

Travail sur les périphériques branchés à la machine = à la carte mère.


* la marque et le modèle :
  * de votre touchpad/trackpad
  * de vos enceintes intégrées
  * de votre disque dur principal

🌞 Trouver

* la marque et le modèle de votre processeur
  * identifier le nombre de processeurs, le nombre de coeur

```ps
PS C:\Windows\System32> WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors
DeviceID  NumberOfCores  NumberOfLogicalProcessors
CPU0      4              4
```

* si c'est un proc Intel, expliquer le nom du processeur (oui le nom veut dire quelque chose)

 Core i5 : Processeur puissant en dual ou quad core capable d’atteindre de bonnes fréquences (existe en version mobile et « bureaux »)

 HQ : processeurs très proche des MQ, mais avec une partie graphique intégrée (IGP) bien plus puissante, en l’occurrence, l’Iris Pro Graphics HD5200 (ce suffixe n’est présent que sur la génération Haswell).

🌞 Disque dur

* identifier les différentes partitions de votre/vos disque(s) dur(s)
* déterminer le système de fichier de chaque partition

```ps
PS C:\Windows\System32> wmic diskdrive get Name,model,size
Model                       Name                Size
SAMSUNG MZVLW128HEGR-000L2  \\.\PHYSICALDRIVE0  128034708480
ST1000LM035-1RK172          \\.\PHYSICALDRIVE1  1000202273280
```
```ps
PS C:\Windows\System32> Get-Volume

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining      Size
----------- ------------ -------------- --------- ------------ ----------------- -------------      ----
D           Games        NTFS           Fixed     Healthy      OK                    294.86 GB 930.91 GB
C                        NTFS           Fixed     Healthy      OK                     17.69 GB 119.24 GB
            Récupération NTFS           Fixed     Healthy      OK                    482.64 MB    499 MB

```

* expliquer la fonction de chaque partition

DISQUE D: Partition pour les jeux/ personnel
DISQUE C: Partition contenant les fichiers systèmes et certains programmes
BACKUP

## Network

🌞 Afficher la liste des cartes réseau de votre machine

* expliquer la fonction de chacune d'entre elles

```ps
PS C:\Windows\System32> ipconfig

Configuration IP de Windows


Carte Ethernet Ethernet :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . : home

Carte Ethernet VirtualBox Host-Only Network :

   Suffixe DNS propre à la connexion. . . :
   Adresse IPv6 de liaison locale. . . . .: fe80::40cd:34fb:2228:38df%11
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.56.1
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :

Carte Ethernet VirtualBox Host-Only Network #2 :

   Suffixe DNS propre à la connexion. . . :
   Adresse IPv6 de liaison locale. . . . .: fe80::3589:5fff:e26a:c68b%20
   Adresse IPv4. . . . . . . . . . . . . .: 10.3.1.1
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :

Carte Ethernet VirtualBox Host-Only Network #3 :

   Suffixe DNS propre à la connexion. . . :
   Adresse IPv6 de liaison locale. . . . .: fe80::eddb:fad:8579:aa%10
   Adresse IPv4. . . . . . . . . . . . . .: 10.3.2.1
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :

Carte réseau sans fil Connexion au réseau local* 1 :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :

Carte réseau sans fil Connexion au réseau local* 2 :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :

Carte Ethernet VMware Network Adapter VMnet1 :

   Suffixe DNS propre à la connexion. . . :
   Adresse IPv6 de liaison locale. . . . .: fe80::463:e324:afe4:f71b%15
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.113.1
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :

Carte Ethernet VMware Network Adapter VMnet8 :

   Suffixe DNS propre à la connexion. . . :
   Adresse IPv6 de liaison locale. . . . .: fe80::91ea:4ab9:1d72:a5d4%24
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.116.1
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :

Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . : home
   Adresse IPv6 de liaison locale. . . . .: fe80::cc20:f13c:213f:e73d%16
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.1.15
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . : 192.168.1.1
```

🌞 Lister tous les ports TCP et UDP en utilisation

* déterminer quel programme tourne derrière chacun des ports
* expliquer la fonction de chacun de ces programmes

```ps
PS C:\Windows\System32> Get-NetTCPConnection

LocalAddress                        LocalPort RemoteAddress                       RemotePort State       AppliedSetting
------------                        --------- -------------                       ---------- -----       --------------


0.0.0.0                             5017      0.0.0.0                             0          Bound
0.0.0.0                             5016      0.0.0.0                             0          Bound
0.0.0.0                             5015      0.0.0.0                             0          Bound
0.0.0.0                             5010      0.0.0.0                             0          Bound
0.0.0.0                             5008      0.0.0.0                             0          Bound
0.0.0.0                             4999      0.0.0.0                             0          Bound
0.0.0.0                             4949      0.0.0.0                             0          Bound
0.0.0.0                             4918      0.0.0.0                             0          Bound
0.0.0.0                             4841      0.0.0.0                             0          Bound
0.0.0.0                             4765      0.0.0.0                             0          Bound
0.0.0.0                             4746      0.0.0.0                             0          Bound
0.0.0.0                             4659      0.0.0.0                             0          Bound
0.0.0.0                             4531      0.0.0.0                             0          Bound
0.0.0.0                             4331      0.0.0.0                             0          Bound
0.0.0.0                             4109      0.0.0.0                             0          Bound
0.0.0.0                             4102      0.0.0.0                             0          Bound
0.0.0.0                             4045      0.0.0.0                             0          Bound
0.0.0.0                             4041      0.0.0.0                             0          Bound
0.0.0.0                             4030      0.0.0.0                             0          Bound
0.0.0.0                             4023      0.0.0.0                             0          Bound
0.0.0.0                             3875      0.0.0.0                             0          Bound
0.0.0.0                             3874      0.0.0.0                             0          Bound
0.0.0.0                             3873      0.0.0.0                             0          Bound
0.0.0.0                             3872      0.0.0.0                             0          Bound
0.0.0.0                             3870      0.0.0.0                             0          Bound
0.0.0.0                             3869      0.0.0.0                             0          Bound
0.0.0.0                             3689      0.0.0.0                             0          Bound
0.0.0.0                             3631      0.0.0.0                             0          Bound
0.0.0.0                             3499      0.0.0.0                             0          Bound
0.0.0.0                             3494      0.0.0.0                             0          Bound
0.0.0.0                             3487      0.0.0.0 
```

## Users

🌞 Déterminer la liste des utilisateurs de la machine

* la liste **complète** des utilisateurs de la machine (je vous vois les Windowsiens...)
* déterminer le nom de l'utilisateur qui est full admin sur la machine
  * il existe toujours un utilisateur particulier qui a le droit de tout faire sur la machine

```ps
PS C:\Windows\System32> net user

comptes d’utilisateurs de \\DESKTOP-KNU6AKN

-------------------------------------------------------------------------------
Administrateur           akram                    DefaultAccount
Invité                   WDAGUtilityAccount       YNOV01
YNOV02                   YNOV03                   YNOV04
YNOV05                   YNOV06                   YNOV07
YNOV08                   YNOV09                   YNOV10
YNOV11                   YNOV12                   YNOV13
YNOV14                   YNOV15                   YNOV16
YNOV17                   YNOV18                   YNOV19
YNOV20                   YNOVSQL201               YNOVSQL202
YNOVSQL203               YNOVSQL204               YNOVSQL205
YNOVSQL206               YNOVSQL207               YNOVSQL208
YNOVSQL209               YNOVSQL210               YNOVSQL211
YNOVSQL212               YNOVSQL213               YNOVSQL214
YNOVSQL215               YNOVSQL216               YNOVSQL217
YNOVSQL218               YNOVSQL219               YNOVSQL220
```

```ps
PS C:\Windows\System32> ps

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    340      21     9496      20044       0,47  22432   7 ApplicationFrameHost
    164      10     2748       5832       0,02    876   7 AppVShNotify
    157       8     1680       4512              8564   0 AppVShNotify
    406      21    74788      22544     572,34  14396   0 audiodg
    114       7     1552       4524       0,00    400   7 bash
    165       8     7004       6300       0,09  18428   7 bash
    454      41    62852      43000      28,41  11516   7 CefSharp.BrowserSubprocess
    587      37    32928      21996       0,52  12568   7 CefSharp.BrowserSubprocess
    532      34    54636      19920       0,53  22192   7 CefSharp.BrowserSubprocess
    397      43    59852      87104      11,70   1188   7 Code
    229      21    16064      23092       0,34   7252   7 Code
    680      29   191892     162776      43,55   7776   7 Code
    407      54    59204      62820      16,67   8712   7 Code
    402     101   155096     126788      20,69   9756   7 Code
    439      20    37280      20976       0,69  11604   7 Code
    226      17     7628       9276       0,05  12428   7 Code
    244      24    20692      21728       0,22  14080   7 Code
    240      21    15816      24740       0,53  15640   7 Code
    640      99   189204     198092     103,97  17876   7 Code
    965      54    52580      80948      30,06  18540   7 Code
    296      16    10620      12536       0,03    556   7 CodeHelper
    257      15     5356      12640       4,17   1404   7 conhost
    122       8     6524        336       0,05   2008   7 conhost
    150      12     7188       8476       0,39   3508   7 conhost
    145       9     6700        784              7316   0 conhost
    145       9     6700       1140              7416   0 conhost
    119       8     6524       4828       0,03   9012   7 conhost
    119       7     6432        680             12360   0 conhost
    119       7     6436        604             12368   0 conhost
    119       8     6520       5348       0,05  13348   7 conhost
    127       8     6472       1164             16020   0 conhost
    923      30     1888       1996               572   0 csrss
    883      28     2424       4240              5692   7 csrss
    480      17     6560      14060       4,67  11288   7 ctfmon
    472      20     9568       7044              3548   0 dasHost
     79       5      908        404              9092   0 dasHost
    487      26    13588      20180       6,52  16528   7 Discord
    793      46    36192      56444      35,81  16820   7 Discord
```



## Scripting

🌞 Utiliser un langage de scripting natif à votre OS
```ps
$nom = wmic DESKTOPMONITOR get systemName
$nom = $nom[2]
$ip = wmic NICCONFIG get IPAddress
$ip = $ip[8]
$os = wmic OS get SystemDirectory 
$os = $os[2]
$version_os = wmic OS get Version 
$version_os = $version_os[2]
$heure = wmic OS get LastBootUpTime
$heure = $heure[2]
$ajour = wmic OS get status
$ajour = $ajour[2]

function Volume {
    $os = Get-WmiObject Win32_logicaldisk
    foreach ($element in $os) {
        $stockage_utilise = [math]::Round($element.Size / 1000000000, 2)
        $stockage_libre = [math]::Round($element.FreeSpace / 1000000000, 2)
        Write-Output "Le stockage utilise de la machine est $stockage_utilise Go"
        Write-Output "Le stockage libre de la machine est $stockage_libre"
    }
}

function Ram {
    $os = Get-WmiObject Win32_OperatingSystem
    $RAM_utilise = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1000000, 2)
    $RAM_libre = [math]::Round((Get-WmiObject win32_operatingsystem).FreePhysicalMemory / 1000000, 2)
    Write-Output "La RAM utilise de la machine est $RAM_utilise Mo"
    Write-Output "La RAM libre de la machine est $RAM_libre Mo"
}

$utilisateur = Get-localuser

function Ping_Moyenne {
    $ping = Test-Connection -count 10 8.8.8.8
    $moyenne = ($ping | Measure-Object ResponseTime -average -maximum)
    $calcul = [math]::Round($moyenne.average, 2)
    Write-Output "Le temps moyenne vers 8.8.8.8 est $calcul"
}

echo "Le nom de la machine est $nom"
echo "L'adresse IP sur la machine est $ip"
echo "L'OS de la machine est $os"
echo "La version de l'OS de la machine est $version_os"
echo "L'heure d'allumage est $heure"
echo "L'os à jour $ajour" 
$(Volume)
$(RAM)
echo "Tous les utilisateurs sont $utilisateur"
$(Ping_Moyenne)
```


🌞 Créer un deuxième script qui permet, en fonction d'arguments qui lui sont passés :

```ps
function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}

function Do-WhatIWant {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Please enter action : Lock | Shutdown")]
        [string] $Action
        ,
        [Parameter(Mandatory = $true, HelpMessage = "Please enter a time")]
        [string] $Time
    )

    if (-Not (Is-Numeric($Time)) -or $Time -lt 0) {
        Write-Output "Wrong Time"
        Break Script
    }

    if ($Action -eq "Lock") {
        Start-Sleep -Seconds $Time
        rundll32.exe user32.dll, LockWorkStation
    }
    elseif ($Action -eq "Shutdown") {
        shutdown -s -t $Time

    }
    else {
        Write-Output "Wrong Action"
    }
}

Write-Output "Please enter action : Lock | Shutdown"
Write-Output "Please enter time : 0 or greater"

Do-WhatIWant
```


## Gestion de softs

🌞 Expliquer l'intérêt de l'utilisation d'un gestionnaire de paquets:

* Un gestionnaire de paquet permet d'installer des logiciels, de les désinstaller et de les mettre à jour en une seule commande. Tous ces paquets sont centralisés dans un seul dépôt ce qui permet de ne pas parcourir le web pour une seule installation. Tous les logiciels sont dépourvus de malwares. Les dépendances sont automatiquement installées.

🌞 Utiliser un gestionnaire de paquet propres à votre OS pour

```ps
PS C:\WINDOWS\system32> choco list -l
Chocolatey v0.10.15
chocolatey 0.10.15
1 packages installed.
```