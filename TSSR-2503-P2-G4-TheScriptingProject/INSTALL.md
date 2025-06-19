## Bienvenue sur le guide d'installation.

### 1) Introduction

Ce document décrit les prérequis et instructions nécessaires pour l’installation et la préparation des environnements Windows et Linux afin d'exécuter correctement les scripts d'administration. Les éléments ci-dessous vous permettrons de faire fonctionner les scripts conformément à l'utilisation standard.

### 2) Partie Windows 

**Système cible :**

* Windows Server 2012 / Windows 10

**Prérequis techniques :**
* Accès administrateur sur la machine Windows

* PowerShell 5.1 minimum (présent nativement sur Windows 10 et 2012)

* Activation de l’exécution de scripts (Set-ExecutionPolicy RemoteSigned ou Bypass)

* Accès réseau pour administrer d'autres machines si besoin

**Dépendances :**

* Aucune dépendance externe

**Installation du script :**

* Copier le fichier .ps1 sur la machine cible

* Lancer PowerShell en tant qu’administrateur

### 3) Partie Linux

**Système cible :**

* Debian Server et Ubuntu Client

**Prérequis techniques :**

* Accès administrateur (sudo) sur les machines

* Présence de bash, sudo, ssh, useradd, usermod, etc

* Accès SSH entre client et serveur

**Dépendances :**

* Paquets standards (openssh-client/openssh-server)
Vous pouvez lancer les commandes ci dessous pour le mettre en place.

1. Sur le serveur Linux

Installer OpenSSH Server
_sudo apt update_
_sudo apt install openssh-server_

Vérifier que le service SSH tourne
_sudo systemctl status ssh_
➔ Si ce n'est pas actif :
_sudo systemctl enable ssh_
_sudo systemctl start ssh_

2. Sur le client Linux

Installer OpenSSH Client
(en général déjà installé, mais sinon) :
_sudo apt update_
_sudo apt install openssh-client_

3. Générer une clé SSH sur le client

Commande sur le client :
_ssh-keygen_
Appuyer sur Entrée plusieurs fois (chemin et mot de passe par défaut ou personnalisés).

Cela crée deux fichiers :
_Clé privée : ~/.ssh/id_rsa_
_Clé publique : ~/.ssh/id_rsa.pub_

4. Envoyer la clé publique au serveur

Depuis le client, pour copier la clé publique vers le serveur :
_ssh-copy-id user@adresse_ip_du_serveur_

user = nom d'utilisateur sur le serveur
adresse_ip_du_serveur = IP ou nom DNS du serveur

➔ Cela ajoute la clé dans le fichier ~/.ssh/authorized_keys du serveur.


**Installation du script :**

* Copier le fichier .sh sur la machine Linux

* Donner les droits d’exécution : chmod +x script.sh

* Lancer le script avec ./script.sh

### 4) F.A.Q

**Quelques questions pratiques :**

Q : Le script ne se lance pas sous Windows ?
A : Vérifiez que l’exécution des scripts est autorisée avec Set-ExecutionPolicy RemoteSigned.

Q : La journalisation ne s'effectue pas sur windows serveur
A : Le fichier log se trouve dans system32/LogFiles, qui un dossier de haute priorité. Vous devez lancer le script en mode "Administrateur".

Q : Le script Linux dit "permission denied" ?
A : Vérifiez que vous avez fait chmod +x script.sh et que vous êtes bien en sudo si besoin.
