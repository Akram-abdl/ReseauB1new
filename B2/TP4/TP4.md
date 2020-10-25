# TP4 : Déploiement multi-noeud

## 0. Prerequisites

On repackage une box CentOS7 en installant tout les packages nécessaires et en désactivant selinux.

### Liste des h�tes

| Name                | IP           | Rôle           |
| ----------------    | ------------ | -----------    |
| `node1.tp4.gitea`   | 192.168.1.11 | Gitea          |
| `node1.tp4.mariadb` | 192.168.1.12 | Base de données|
| `node1.tp4.nginx`   | 192.168.1.13 | NGINX          |
| `node1.tp4.nfs`     | 192.168.1.14 | Serveur NFS    |