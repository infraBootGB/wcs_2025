## Bienvenue sur le guide de l'utilisateur.

### 1) Introduction

Ce document décrit comment utiliser les scripts d'administration pour Windows et Linux. Il est recommandé de lire et respecter le guide d'installation avant d'aller plus loin dans ce guide.

### 2) Partie Windows 

**Exécution du script :**
* Ouvrir PowerShell en mode administrateur.

* Aller dans le dossier contenant le script.

* Lancer avec .\script_general.ps1.

**Menu principal du script :**

Le script fonctionne en arborescence de fonction.
On accède d'abord à un menu principal, dont chaque option mène à un sous-menu, lui-même menant à des fonctions permettant d'effectuer des actions ou d'afficher des informations.

Les 4 branches principales du scripts sont celles indiqués sur la photo ci-dessous.

![Menu_Principal](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Windows/Windows%20-%201Capture%20d'%C3%A9cran%20Menu_Principal.png)

Pour naviguer dans l'arborescence, il suffit de suivre les indications sur chaque partie et d'entrer les numéros correspondant à votre souhait.  Facile non ?

**Exemples d’utilisation rapide :**

Dans l'exemple ci-dessous, nous voulons ajouter un nouvel utilisateur.

Vous renterez dans ce cas :
Utilisateur=1 ==> Compte=1 ==> Creation de compte=1 
Une fois la fonction atteinte, vous pourrez créer l'utilisateur que vous souhaitez.
Photo d'illustration ci dessous.

![Arborescence] (https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Windows/Windows%20-%202Capture%20d'%C3%A9cran%20Deplacement_Arborescence.png)

Nous allons maintenant créer un nouvel utilisateur.
Dans notre exemple, ce sera Alban.

![Ajout_Alban](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Windows/Windows%20-%203Capture%20d'%C3%A9cran%20Ajout_utilisateur.png)

"Bienvenue dans l'équipe Alban ! Hein ? Tu ne viens plus ? Pas de soucis on va réctifier ca."

Si vous voulez supprimer un compte, il suffit de reprendre la meme arborescence :1,1,3 puis choisir l'utilisateur à supprimer et enfin suivre les indications de la fonction.

Illusatrations ci dessous.

![Arborescence_Suppression](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Windows/Windows%20-%204Capture%20d'%C3%A9cran%20Navigation_Suppression_Compte.png)

![Action_SuppressionAlban](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Windows/Windows%20-%205Capture%20d'%C3%A9cran%20Action_Suppression_Compte_Alban.png)

Voilà, avez ces informations vous avez les outils pour naviguer sur notre script d'administration windows !

### 3) Partie Linux

**Exécution du script :**

* Ouvrir un terminal.

* Aller dans le dossier contenant le script. cd /root/

* Lancer avec ./ScriptGlobal.sh

**Fonctionnalités principales :**

Ce script est conçu pour une utilisation à distance via SSH.

Avant toute interaction, il est nécessaire de fournir une de ces trois informations essentielles : l’adresse IP, le nom d’hôte de la machine cible, ou encore le nom de l’utilisateur distant (voir exemples ci-dessous).

![Capture_SSH](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Linux/Linux%20-%201Capture%20d'ecran%20SSH.png)


Une fois l’utilisateur identifié et le mot de passe saisi, vous accéderez à l’interface de navigation du script d’administration.

Le script Linux Bash fonctionne lui aussi en arborescence de fonction.
On accède d'abord à un menu principal, dont chaque option mène à un sous-menu, lui-même menant à des fonctions permettant d'effectuer des actions ou d'afficher des informations.

Les 4 branches principales du scripts sont celles indiqués sur la photo ci-dessous.

![Menu_Principal](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Linux/Linux%20-%202Menu_Principal.png)

**Exemples d’utilisation rapide :**

Le fonctionnement étant le même que sur Windows, nous allons vous montrer un exemple en image. Dans celui-ci, nous avons besoin de récupérer les informations réseaux de notre cible Ubuntu.

A partir du menu principal, il faudra indiquer :
Sécurité et Réseaux=3 ==> Réseaux=1 ==> La fonction s'exécute et donne les informations réseaux de la cible.
(Voir ci dessous)

![Demo_fonctionRéseau](https://github.com/WildCodeSchool/TSSR-2503-P2-G4-TheScriptingProject/blob/main/Ressources/Images_Linux/Linux%20-%203Fonction_Reseaux.png)

### 4) F.A.Q

**Quelques questions pratiques :**

Q : Comment voir les logs d'utilisation ?

A : 
Sous Windows : C:/Windows/system32/logfiles/**fichier_log**
Sous Linux : /var/log/script/**fichier_log**
