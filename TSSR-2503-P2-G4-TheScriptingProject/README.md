# TSSR-2503-P2-G4-TheScriptingProject


# Projet Scripting Bash / PowerShell

Bienvenue sur notre dépôt GitHub dédié à notre projet de scripting en Bash et PowerShell sur des VM Proxmox.

## 📢 Présentation du projet

Ce projet a pour objectif de développer et d'automatiser différentes tâches système à l'aide de scripts Bash et PowerShell.  
Il s'inscrit dans le cadre de notre formation et vise à renforcer nos compétences en scripting, gestion système et automatisation.   
Il est découpé en 4 sprints sur environ 4 semaines.

---

📋 Tâches principales
* Créer un script Bash.
* Créer un script PowerShell.
* Chaque script interagit avec des machines distantes pour :
* Exécuter des commandes d’administration.
* Récupérer des informations.
* Toutes les machines sont sur le même réseau.

📋 Tâches secondaires
* Développer un script Bash qui s'exécute sur un serveur Debian pour administrer des machines clientes Windows.
* Développer un script PowerShell qui s'exécute sur un serveur Windows Server pour administrer des machines clientes Ubuntu.

## 📜 Introduction

L'automatisation des tâches est essentielle dans l'administration système moderne.  
À travers ce projet, nous avons exploré les possibilités offertes par Bash et PowerShell pour répondre à divers besoins : gestion de fichiers, de permissions, création d'utilisateurs, surveillance système, etc.  
Nous sommes 3 pour faire ce projet, Eric, Bertrand et Alan.  
Nous avons été habitué à utiliser Virtual Box mais ce travail sera réaliser en terre inconnue : Proxmox !

---

## 👥 Membres du groupe par sprint

### 🏃 Sprint 1 (Semaine 1)

| Team | Rôles | Missions |
|:---------:|:---------:|:---------:|
|     Eric MARTIENNE      |    Product Owner       |     Faire le lien avec le client et vérifier la conformité de l’avancement du projet avec les besoins initiaux. Travail sur l’arborescence du script. Elaboration du pseudo-code      |
|    Bertrand GIRARDET       |       Technicien    |     Travail sur l’arborescence du script, mise en place des vm, elaboration du pseudo-code      |
|       Alan COEURJOLY    |     Scrum Master      |    Travail sur l’arborescence du script, mise en place des vm, elaboration du pseudo-code. Organisation des rendez-vous, vérification de l’avancement des tâches/sprint 1 par rapport au consigne       |

---

### 🏃 Sprint 2 (Semaine 2) 

| Team | Rôles | Missions |
|:---------:|:---------:|:---------:|
|     Eric MARTIENNE      |      Scrum Master     |   Script squelette. Scripts fonctions disque et répertoire. Vérifier les moyens matériels.  |
|      Bertrand GIRARDET     |  Product Owner         |    Scripts fonctions sécurité et réseaux, système et test scripts. Faire le lien avec le client et vérifier la conformité du projet.       |
|      Alan COEURJOLY     |      Technicien     |    Scripts fonctions utilisateurs et test script, création du trello, readme       |


---

### 🏃 Sprint 3 (Semaine 3) 

| Team | Rôles | Missions |
|:---------:|:---------:|:---------:|
|     Eric MARTIENNE      |     Technicien      |           |
|      Bertrand GIRARDET     |    Scrum Master     |      Coordination, protocole SSH, améliorations du script principal, démarage des fonctions réseaux et disques sur Powershell     |
|     Alan COEURJOLY      |    Product Owner    |      Liaisons avec le client, test réel proxmox, journalisation, améliorations du script principal, démarrage des fonctions utilisateurs sur Powershell     |


---

### 🏃 Sprint 4 (Semaine 4) 

| Team | Rôles | Missions |
|:---------:|:---------:|:---------:|
|      Eric MARTIENNE     |     Product Owner     |    Liaisons avec le client, squelette powershell , fonctions diverses     |
|      Bertrand GIRARDET     |           | fonctions Powershell réseaux, sécurité, systeme, mise en place du remote entre les VM Proxmox       |
|      Alan COEURJOLY     |   Scrum Master     |       Journalisation Powershell, fonctions gestion d'utilisateur, assemblage squelette fonction, test Proxmox     |


---

## ⚙️ Choix Techniques

| Caractéristiques machines | Windows 11 | Linux Ubuntu | Windows serveur 2022 | Debian 12 |
|----------------------------|------------|--------------|----------------------|-----------|
| ID                         | 646        | 647          | 648                  | 649       |
| Nom                        | G4-CLIWIN01| G4-CLILIN01  | G4-SRVWIN01          | G4-SRVLX01|
| Réseau IP                  | G4 LAN 172.16.40.20/24 | G4 LAN 172.16.40.30/24 | G4 LAN 172.16.40.5/24 | G4 LAN 172.16.40.10/24 |
| Compte                     | Wilder (dans le groupe admin local) | wilder (dans le groupe sudo) | Administrator | root |
| Mot de passe               | Azerty1*   | Azerty1*     | Azerty1*             | Azerty1*  |
| Langue                     | FR         | FR           | US                   | US        |


---

## 🧗 Difficultés rencontrées

### Sprint 1
- Organisation du travail.
- Elaboration d'un pseudo-code aussi important.
- Créer une arborescence fonctionnelle.

### Sprint 2
- Gestion des erreurs dans les scripts complexes.
- Découverte du logiciel Proxmox.
- Création de multiples fonctions.
- Difficultés à appeler les fonctions qui étaient dans d'autres fichiers

### Sprint 3
- Passer du Bash au Powershell
- Journalisation entre le serveur et le client (autorisation de suppression du fichier log à distance après un scp)
- Débogage chronophage
- Mise en place du SSH

### Sprint 4
- Traduction du script bash en Powershell
- Mise en place du invoke-command
- Journalisation entre le serveur et le client
- Charge de travail restant en dernière minute (débogage, journalisation, livrable et présentation)

---

## 💡 Solutions trouvées

### Sprint 1
- Utilisation des nombreuses ressources à notre disposition, cours, videos, client (très calé sur le sujet...)
- Organisation régulière de points d'équipe pour la synchronisation des tâches.
  
### Sprint 2
- Création d'un Trello pour avoir une vision sur l'ensemble du projet/script 1,2,3,4 ainsi que le suivi des réalisations de chaucun.
- Entraide avec d'autres groupes, choix de faire un gros script et non plusieurs fonctions appelées.

### Sprint 3
- Ressources web, cours, vidéos et IA pour la compréhension de PowerShell
- Concertation pour résoudre les problèmes, points réguliers
- Beaucoup d'essai/crash test sur proxmox pour le SSH et journalisation pour se rapprocher de la solution

### Sprint 4
- Concertation pour résoudre les problèmes, points réguliers
- Beaucoup d'essai/crash

---

## 📈 Améliorations possibles

- Ajouter des fonctions au script PowerShell
- Ajouter des fonctions au script Bash
- Plus de code couleur
- Journalisation mieux détaillée

---

Le mot de l'équipe 4 : Un script d’une telle ampleur, c'était une grande première pour nous ! Malgré les difficultés individuelles et collectives, nous avons su faire preuve de solidarité et de résilience pour mener ce projet à terme. Certes, il manque encore quelques fonctions, le script pourrait être plus élégant, et nous avons beaucoup compté les uns sur les autres dans la dernière ligne droite... Mais au-delà des imperfections, ces +3000 lignes de code représentent avant tout un immense chemin parcouru, des leçons précieuses tirées, des compétences renforcées et une bien meilleure maîtrise du langage script. C’est notre plus belle victoire ! 

> Merci de votre visite sur notre projet ! 🚀
