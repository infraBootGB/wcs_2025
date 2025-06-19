#############################################################################################
####                                                                                    #####
####                                  LOGS/JOURNALISATION                               #####
####                                                                                    #####
#############################################################################################

# Fonction log_evt
function log_evt {
    param(
        [string]$message
    )
    
    # Crée un timestamp avec l'année (2 chiffres), le mois et le jour
    $timestamp = Get-Date -Format "yyyy-MM-dd"
    $logMessage = "$timestamp - $message"

    # Spécifie le chemin du fichier log
    $logFile = "C:\Windows\System32\LogFiles\log_files-$timestamp.txt"

    # Si le fichier n'existe pas, crée-le
    if (-Not (Test-Path $logFile)) {
        New-Item -Path $logFile -ItemType File
    }

    # Ajoute le message dans le fichier log
    $logMessage | Out-File -Append -FilePath $logFile

    # Optionnel : affiche aussi dans la console pour le suivi immédiat
    Write-Host $logMessage
}



#############################################################################################
####                                                                                    #####
####                          FONCTIONS GESTION DES UTILISATEURS                        #####
####                                                                                    #####
#############################################################################################


# AJOUT D'UTILISATEUR
function Nouvel_Utilisateur {
    log_evt "Début de la fonction nouvel utilisateur"
  # Affichage des comptes existants
        Write-Host "Comptes existants :" -ForegroundColor Yellow
        net user

    while ($true) {
        $user = Read-Host "Merci d'indiquer le nom d'utilisateur"
        # Vérification si l'utilisateur a bien été saisi
        if ([string]::IsNullOrEmpty($user)) {
            Write-Host "Merci d'entrer un nom d'utilisateur valide"
            continue
        }

        # Vérification si l'utilisateur existe déjà
        try {
            $userExists = Get-LocalUser -Name $user -ErrorAction Stop
            Write-Host "L'utilisateur $user existe déjà." -ForegroundColor Red
            log_evt "L'utilisateur $user existe déjà."
            continue
        }
        catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
            # L'utilisateur n'existe pas, on peut continuer
            break
        }
    }
    
    # Tentative de création de l'utilisateur
    try {
        New-LocalUser -Name $user -NoPassword
        Write-Host "L'utilisateur $user a été créé avec succès !" -ForegroundColor Green
        log_evt "L'utilisateur $user a été créé avec succès !"
        log_evt "Fin de la fonction ajout d'un utilisateur"
    }
    catch {
        Write-Host "Erreur lors de la création de l'utilisateur: $_"
        log_evt "Erreur lors de la création de l'utilisateur: $_"
    }
}


# GESTION DE MOT DE PASSE
# Affiche les derniers comptes et permet de changer un mot de passe
function Nouveau_Mdp {
    log_evt "Début de la fonction modification du mot de passe"
    # Affichage des comptes existants
        Write-Host "Comptes existants :" -ForegroundColor Yellow
        net user

    while ($true) {

        # On demande le nom utilisateur
        $user = Read-Host "Merci d'indiquer le nom d'utilisateur."
            log_evt "Choix de l'utilisateur $user"

        # Vérification si le champ est vide
        if ([string]::IsNullOrWhiteSpace($user)) {
            Write-Host "Merci d'entrer un nom d'utilisateur valide."
            log_evt "Utilisateur invalide"
            continue
        }

        # Vérification si l'utilisateur existe, on continue
        try {
            Get-LocalUser -Name $user -ErrorAction Stop
        }
        catch {
            # L'utilisateur n'existe pas, erreur
            Write-Host "L'utilisateur $user n'existe pas."
            continue
            log_evt "Utilisateur inconnu"
        }

        # On demande le nouveau mot de passe
        $newmdp = Read-Host "Merci d'indiquer le nouveau mot de passe"
            log_evt "Choix du mot de passe"

        if ([string]::IsNullOrWhiteSpace($newmdp)) {
            Write-Host "Merci d'entrer un mot de passe valide."
            continue
        }

        # Changement du mot de passe
        try {
            net user $user $newmdp
            Write-Host "Le mot de passe de $user a bien été modifié." -ForegroundColor Green
            log_evt "Le mot de passe de $user a bien été modifié"
            break
        }
        catch {
            Write-Host "Erreur lors de la modification du mot de passe : $_" -ForegroundColor Red
            log_evt "Erreur lors de la modification du mot de passe"
            continue
        }
    }
    log_evt "Fin de la fonction modification du mot de passe"
}



# FONCTION SUPPRESSION_COMPTE

function Suppression_Compte {
    # Affichage des comptes existants
    Write-Host "Comptes existants :"
    net user
    
    log_evt "Début de la fonction suppression de compte"
    while ($true) {
        $user = Read-Host "Merci d'indiquer un nom d'utilisateur à supprimer"

        if ([string]::IsNullOrWhiteSpace($user)) {
            Write-Host "Nom d'utilisateur invalide" -ForegroundColor Red
            log_evt "Nom d'utilisateur invalide"
            continue
        }

        # Vérification si l'utilisateur existe
        try {
            Get-LocalUser -Name $user -ErrorAction Stop
        }
        catch {
            Write-Host "L'utilisateur $user n'existe pas." -ForegroundColor Red
            log_evt "L'utilisateur $user n'existe pas."
            continue
        }

        # Demande de confirmation de suppression du compte
        $choix = Read-Host "Êtes-vous sûr de vouloir supprimer le compte $user ? Oui / Non"

        switch ($choix.ToLower()) {
            "oui" {
                try {
                    Remove-LocalUser -Name $user
                    Write-Host "L'utilisateur $user a bien été supprimé." -ForegroundColor Green
                    log_evt "L'utilisateur $user a bien été supprimé."
                }
                catch {
                    Write-Host "Erreur lors de la suppression de l'utilisateur $user." -ForegroundColor Red
                    log_evt "Erreur lors de la suppression de l'utilisateur $user."
                }
                break
            }
            "non" {
                Write-Host "Suppression de $user annulée." -ForegroundColor Yellow
                log_evt "Suppression de $user annulée."
                break
            }
            default {
                Write-Host "Réponse invalide, merci de répondre Oui ou Non." -ForegroundColor Red
            }
        }
        log_evt "Fin de la fonction suppression de compte"
        break #On sort de la fonction après avoir supprimé un utilisateur
    }
}

# FONCTION ACTIVATION_DESACTIVATION_COMPTE

function Activation_Desactivation_Compte {
    # Affichage des comptes existants
    Write-Host "Comptes existants :" -ForegroundColor Yellow
    net user

    log_evt "Début de la fonction activation ou désactivation d'un utilisateur"
    while ($true) {
        $user = Read-Host "Merci d'indiquer un nom d'utilisateur"

        if ([string]::IsNullOrWhiteSpace($user)) {
            Write-Host "Nom d'utilisateur invalide" -ForegroundColor Red
            continue
        }

        # Vérification si l'utilisateur existe
        try {
            Get-LocalUser -Name $user -ErrorAction Stop
        }
        catch {
            Write-Host "L'utilisateur $user n'existe pas." -ForegroundColor Red
            continue
        }

        # Si utilisateur existe, on sort de la boucle
        break
    }

    # Menu de choix Activation/Désactivation
    Write-Host "Que voulez-vous faire ?" -ForegroundColor Cyan
    Write-Host "1) Activer l'utilisateur"
    Write-Host "2) Désactiver l'utilisateur"
    log_evt "Menu de choix Activation/Désactivation"
    $choix = Read-Host "Entrez votre choix (1 ou 2)"

    switch ($choix) {
        "1" {
            log_evt "Activation"
            try {
                Enable-LocalUser -Name $user
                Write-Host "L'utilisateur $user a bien été activé." -ForegroundColor Green
                log_evt "L'utilisateur $user a bien été activé."
            }
            catch {
                Write-Host "Erreur lors de l'activation de l'utilisateur $user : $($_.Exception.Message)" -ForegroundColor Red
                log_evt "Erreur lors de l'activation de l'utilisateur $user"
            }
        }
        "2" {
             log_evt "Désactivation"
            try {
                Disable-LocalUser -Name $user
                Write-Host "L'utilisateur $user a bien été désactivé." -ForegroundColor Yellow
                log_evt "L'utilisateur $user a bien été désactivé."
            }
            catch {
                Write-Host "Erreur lors de la désactivation de l'utilisateur $user : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        Default {
            Write-Host "Réponse invalide, merci de répondre 1 ou 2." -ForegroundColor Red
        }
    }
    log_evt "Fin de la fonction activation ou désactivation d'un utilisateur"
}


# FONCTION ADDADMIN_GROUP
function Addadmin_Group  {
    # Affichage des comptes existants
        Write-Host "Comptes existants :" -ForegroundColor Yellow
        net user
        log_evt "Lancement de la fonction ajout dans un groupe administrateur."
while ($true) {
        $user = Read-Host "Merci d'indiquer un nom d'utilisateur."

        if ([string]::IsNullOrWhiteSpace($user)) {
            Write-Host "Nom d'utilisateur invalide." 
            continue
        }

        # Vérification si l'utilisateur existe
        try {
            $userExists = Get-LocalUser -Name $user -ErrorAction Stop
        }
        catch {
            Write-Host "L'utilisateur $user n'existe pas." -ForegroundColor Red
            log_evt "L'utilisateur $user n'existe pas."
            continue
        }

        # Si utilisateur valide, sortir de la boucle
        break
    }

$choix = read-Host "Vous avez choisi d'ajouter le compte $user au groupe administrateur, êtes-vous sûr ? Oui / Non" -ForegroundColor Cyan

switch ($choix.ToLower()) {

"Oui" {
    try { Add-LocalGroupMember -Group "Administrateurs" -Member $user
    Write-Host "L'utilisateur $user a bien été ajouté au groupe administrateur." -ForegroundColor Green
    log_evt "L'utilisateur $user a bien été ajouté au groupe administrateur." 
    }

    catch { Write-Host "Erreur lors de l'ajout de $user au groupe administrateur." -ForegroundColor Red
    log_evt "Erreur lors de l'ajout de $user au groupe administrateur."
    } 
        break
}

"Non" { Write-Host "Retour au menu gestion des utilisateurs."
        log_evt "Retour au menu gestion des utilisateurs."
        break
}
Default { Write-Host "Réponse invalide, merci de répondre Oui ou Non."

}    
}
}

#FONCTION AJOUT GROUPE LOCAL
function Addlocalgroup {
    log_evt "Début de la fonction ajout dans un groupe local."
        Write-Host "Comptes existants :" -ForegroundColor Yellow
        net user
        # Saisie utilisateur
        do {
            $user = Read-Host "Merci d'indiquer un nom d'utilisateur"
            if ([string]::IsNullOrWhiteSpace($user)) {
                Write-Host "Nom d'utilisateur invalide." -ForegroundColor Red
                log_evt "Message erreur nom d'utilisateur invalide."
                continue
            }
            try {
                Get-LocalUser -Name $user -ErrorAction Stop
                # Afficher les informations de l'utilisateur pour confirmation
                Get-LocalUser -Name $user | Format-Table Name, Enabled, Description
                break
            }
            catch {
                Write-Host "L'utilisateur $user n'existe pas." -ForegroundColor Red
                log_evt "Message d'erreur $user n'existe pas."
            }
        } while ($true)
        # Saisie groupe
        do {
            $group = Read-Host "Merci d'indiquer le nom du groupe local"
            if ([string]::IsNullOrWhiteSpace($group)) {
                Write-Host "Nom de groupe invalide." -ForegroundColor Red
                continue
            }
            try {
                Get-LocalGroup -Name $group -ErrorAction Stop
                $groupeExiste = $true
                break
            }
            catch {
                $groupeExiste = $false
                # Vérifier si le nom est utilisé par un utilisateur
                try {
                    Get-LocalUser -Name $group -ErrorAction Stop
                    Write-Host "Le nom '$group' est déjà utilisé comme compte utilisateur. Veuillez choisir un autre nom." -ForegroundColor Red
                    continue
                }
                catch {
                    # Le nom n'est pas utilisé par un utilisateur, c'est bon
                    break
                }
            }
        } while ($true)
        
        # Gestion création groupe si nécessaire
        if (-not $groupeExiste) {
            $choix = Read-Host "Le groupe $group n'existe pas. Voulez-vous le créer ? (Oui/Non)" 
    
            if ($choix.ToLower() -eq "oui") {
                try {
                    New-LocalGroup -Name $group -ErrorAction Stop
                    Write-Host "Le groupe $group a été créé." -ForegroundColor Green
                    $groupeExiste = $true
                    log_evt "Création d'un nouveau groupe local "$group"."
                }
                catch {
                    Write-Host "Erreur : impossible de créer le groupe $group : $($_.Exception.Message)" -ForegroundColor Red
                    log_evt "Création du groupe "$group" a échoué."
                    return
      
                }
            }
            elseif ($choix.ToLower() -eq "non") {
                Write-Host "Retour au menu gestion des utilisateurs." -ForegroundColor Yellow
                return
                log_evt "Retour au menu gestion des utilisateurs."
            }
            else {
                Write-Host "Réponse invalide. Abandon de l'opération." -ForegroundColor Red
                return
                log_evt "Réponse invalide. Abandon de l'opération."
            }
        }
        
        # Ajout de l'utilisateur au groupe uniquement si le groupe existe
        if ($groupeExiste) {
            try {
                Add-LocalGroupMember -Group $group -Member $user -ErrorAction Stop
                Write-Host "L'utilisateur $user a été ajouté au groupe $group avec succès." -ForegroundColor Green
            log_evt "L'utilisateur $user a été ajouté au groupe $group avec succès."
            }
            catch {
                Write-Host "Erreur : impossible d'ajouter $user au groupe $group : $($_.Exception.Message)" -ForegroundColor Red
            log_evt "Erreur : impossible d'ajouter $user au groupe $group."
            }
        }
        log_evt "Fin de la fonction ajout dans un groupe local."

    }


#FONCTION EXCLUSION GROUPE LOCAL
function Exclusion_Group_Local {
    log_evt "Début de la fonction Exclusion d'un groupe local"

    while ($true) {
        $user = Read-Host "Merci d'indiquer un nom d'utilisateur à exclure" -ForegroundColor Cyan

        if ([string]::IsNullOrWhiteSpace($user)) {
            Write-Host "Nom d'utilisateur invalide." -ForegroundColor Red
            continue
        }

        # Vérification si l'utilisateur existe
        try {
            Get-LocalUser -Name $user -ErrorAction Stop
        }
        catch {
            Write-Host "L'utilisateur $user n'existe pas." -ForegroundColor Red
            log_evt "L'utilisateur $user n'existe pas."
            continue
        }

        # Utilisateur valide -> on sort de la boucle
        break
    }

    $group = Read-Host "Merci d'indiquer le nom du groupe local"

    if ([string]::IsNullOrWhiteSpace($group)) {
        Write-Host "Merci d'entrer un nom de groupe valide." -ForegroundColor Red
        return
    }

    # Vérification si le groupe existe
    try {
        Get-LocalGroup -Name $group -ErrorAction Stop

        # Si groupe existe, retirer l'utilisateur
        try {
            Remove-LocalGroupMember -Group $group -Member $user
            Write-Host "L'utilisateur $user a été exclu du groupe $group avec succès." -ForegroundColor Green
            log_evt "L'utilisateur $user a été exclu du groupe $group avec succès."
        }
        catch {
            Write-Host "Erreur lors de l'exclusion de $user du groupe $group : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Le groupe $group n'existe pas." -ForegroundColor Red
        log_evt "Le groupe $group n'existe pas."
    }
    log_evt "FIn de la fonction exclusion d'un groupe local"
}

#GROUPE D'APPARTENANCE
function Groupe_Appartenance {
Write-Host "Fonction en développement"
}

#FONCTION DROITS_ACCES
function Droits_Acces {
    log_evt "Début de la fonction droits d'accès"
    # Demande de la cible (fichier ou dossier)
    $cible = Read-Host "Merci d'indiquer le chemin du fichier ou du dossier"

    # Vérification de l'existence du fichier ou dossier
    if (-not (Test-Path $cible)) {
        Write-Host "Erreur : le fichier ou dossier $cible n'existe pas." -ForegroundColor Red
        return
    }

    # Demande du nom d'utilisateur
    $user = Read-Host "Merci d'indiquer le nom d'utilisateur"

    # Vérification saisie utilisateur
    if ([string]::IsNullOrWhiteSpace($user)) {
        Write-Host "Erreur : nom d'utilisateur invalide." -ForegroundColor Red
        return
    }

    # Vérification de l'existence de l'utilisateur
    try {
        $userExists = Get-LocalUser -Name $user -ErrorAction Stop
    }
    catch {
        Write-Host "Erreur : l'utilisateur $user n'existe pas." -ForegroundColor Red
        return
    }

    # Si tout est OK : modification des droits
    try {
        # Donne un droit en FullControl (contrôle total) pour l'utilisateur sur le fichier/dossier
        $acl = Get-Acl $cible
        $permission = "$user","FullControl","Allow"
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
        $acl.SetAccessRule($accessRule)
        Set-Acl -Path $cible -AclObject $acl

        Write-Host "Les droits d'accès pour $user sur $cible ont été modifiés avec succès." -ForegroundColor Green
        log_evt "Les droits d'accès pour $user sur $cible ont été modifiés avec succès."
    }
    catch {
        Write-Host "Erreur lors de la modification des droits d'accès : $($_.Exception.Message)" -ForegroundColor Red
    }
    log_evt "Fin de la fonction droits d'accès"
}


#FONCTION LAST_CONNEXION
function Last-Connexion {
    
    $user = Read-Host "Merci d'indiquer le nom d'utilisateur" 
    
    if ([string]::IsNullOrEmpty($user)) {
        Write-Host "Merci d'indiquer un nom d'utilisateur valide"
        return
    }
    
    try {
        $userExists = Get-LocalUser -Name $user -ErrorAction Stop 
    }
    catch {
        Write-Host "L'utilisateur n'existe pas" -ForegroundColor Red
        log_evt "L'utilisateur n'existe pas"
        return
    }
    
    # Si l'utilisateur existe
    try { 
        Get-History $user -ForegroundColor Green
        log_evt "Récupération de l'historique de $user"
    }
    catch {
        Write-Host "Erreur lors de la commande, retour au menu gestion utilisateur"
    }
}

#DERNIERE MODIFICATION DU MDP
function mdp_history {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#LISTE DES SESSIONS OUVERTES PAR L'UTILISATEUR
function last_sessions {
Write-Host "Fonction en développement" -ForegroundColor Red
}
#HISTORIQUE DES COMMANDES EXECUTEES PAR L'UTILISATEUR
function last_command {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#############################################################################################
####                                                                                    #####
####                          FONCTIONS DISQUES ET REPERTOIRES                          #####
####                                                                                    #####
#############################################################################################

function Informations_Disques {
log_evt "Début de la fonction"
$toto = "1"
while ($toto -eq "1") {

    Clear-Host
    #menu disque
    
    
    $disks = Get-Disk
    $nb_partitons = Get-Partition
    
    
    #nb de disques
    
    $nb_disques = (Get-Disk | Select-Object -ExpandProperty Number | Measure-Object).count
    
    
    #pour chaque disk :
    #nb de partitions
    #taille de la partition
    #file system
    #nom du disque
    $toto = "0"
    
    if ($nb_disques -eq 0) {
    
        Write-Host "Aucun disque détecté"
        log_evt "Aucun disque détécté"
    
    } else {
    
        Write-Host""
        Write-Host""
        Write-host "Nombre de disques détéctés : $nb_disques" 
        log_evt "Nombre de disques détéctés : $nb_disques" 
        Write-Host""
    }
    
    
    #boucle sur les disques
    
    foreach ( $disk in $disks ) {
    
    
    #nom des disques
    
    $nom = $disk.FriendlyName
    
    Write-Host""
    Write-Host "Nom de disque : $nom "
    log_evt "Nom de disque : $nom"
    Write-Host""
    
    #partitions
      $nb_partitions = Get-Partition -DiskNumber $disk.Number
    
      $total_partitions = $nb_partitions.count
    
    Write-Host""
    Write-Host "Nombre de partitions : $total_partitions "
    log_evt "Nombre de partitions : $total_partitions "
    Write-Host""
    
    }
    
    
    
    
     #boucle paritions
    
     foreach ($nb_partition in $nb_partitions) {
    
     $volume = Get-Volume -Partition $nb_partition
     $file_system = ($volume.FileSystem)
    
     $taille = $nb_partition.Size
     $espace_libre= $volume.SizeRemaining
    
     Write-Host "Partition $($nb_partitions.number) :  "
     log_evt "Partition $($nb_partitions.number)"
     Write-Host " Taille : $taille "
     log_evt " Taille : $taille "
     Write-Host "Espace libre : $espace_libre"
     log_evt "Espace libre : $espace_libre"
     Write-Host " Système de fichiers : $file_system"
     log_evt " Système de fichiers : $file_system"
     Write-Host""
     Write-Host""
    
     # liste des lecteurs montés
    
    
    
     }
            write-host "Liste De volumes montés  : "
           Get-Volume | Select-Object DriveLetter, FileSystemType, SizeRemaining, Size, DriveType   
    
    
           #menu sortie
    
        Write-Host "Pour mettre à jours les informations : 1 "
        Write-Host "Pourevenir au menu précédent : 2 "
        Write-Host ""
        $decision = Read-Host "Entrez votre choix (1 ou 2)"
    
    
    
    
    
        switch ($decision) {
    
            "1" {
    
                write-host " Mise à jours des informations : "
                continue
                }
    
            "2" {
    
                write-host "Retour au menu précédent "
    
               break
    
                }
    
    
            default {
                write-host "Choix incorrect, entree 1 ou 2 "
                }
    
           
      }     
      }           
    
      log_evt "Fin de la fonction informations disques"
    }

# FONCTION CREATION REPERTOIRE
# Demander le chemin de base
function Creation_Repertoire {
$cheminBase = Read-Host "Entrez le chemin où créer le dossier (ex: C:\Utilisateurs\Nom)"

# Vérifier si le chemin de base existe
if (-Not (Test-Path -Path $cheminBase)) {
    Write-Host "Le chemin spécifié n'existe pas. Veuillez vérifier et réessayer." -ForegroundColor Red
    return
}

# Demander le nom du dossier à créer
$nomDossier = Read-Host "Entrez le nom du dossier à créer"

# Construire le chemin complet
$cheminComplet = Join-Path -Path $cheminBase -ChildPath $nomDossier

# Créer le dossier si ce n'est pas déjà fait
if (-Not (Test-Path -Path $cheminComplet)) {
    New-Item -Path $cheminComplet -ItemType Directory | Out-Null
    Write-Host "Dossier créé avec succès à l'emplacement : $cheminComplet" -ForegroundColor Green
} else {
    Write-Host "Le dossier existe déjà à cet emplacement." -ForegroundColor Yellow
}

# FONCTION MODIFICATION REPERTOIRE
function Modification_Repertoire {
log_evt "Début de la fonction modification de répertoire"
    # Demander le chemin complet du répertoire à renommer
$ancienChemin = Read-Host "Quel est le chemin complet du répertoire à renommer ?"

# Vérifier si le répertoire existe
if (Test-Path -Path $ancienChemin) {
    # Demander le nouveau nom du répertoire
    $nouveauNom = Read-Host "Quel est le nouveau nom du répertoire ?"

    # Obtenir le dossier parent
    $parent = Split-Path -Path $ancienChemin -Parent

    # Construire le nouveau chemin complet
    $nouveauChemin = Join-Path -Path $parent -ChildPath $nouveauNom

    # Vérifier si un dossier avec le nouveau nom existe déjà
    if (-Not (Test-Path -Path $nouveauChemin)) {
        try {
            Rename-Item -Path $ancienChemin -NewName $nouveauNom
            Write-Output "Répertoire renommé en : $nouveauChemin"
            log_evt "Répertoire renommé en $nouveauChemin"
        } catch {
            Write-Error "Erreur lors du renommage du répertoire : $_"
            log_evt "Erreur lors du renommage du répertoire : $_"
        }
    } else {
        Write-Error "Un répertoire avec le nom '$nouveauNom' existe déjà à cet emplacement."
        log_evt "Un répertoire avec le nom '$nouveauNom' existe déjà à cet emplacement."
    }
} else {
    Write-Error "Le répertoire spécifié n'existe pas : $ancienChemin"
    log_evt "Le répertoire spécifié n'existe pas : $ancienChemin"
}
log_evt "Fin de la fonction modification de répertoire"
}
}

# FONCTION SUPPRESSION REPERTOIRE
# Demander le chemin de base
function Suppression_Repertoire {
$cheminBase = Read-Host "Entrez le chemin où se trouve le dossier à supprimer (ex: C:\Utilisateurs\Nom)"

# Vérifier si le chemin existe
if (-Not (Test-Path -Path $cheminBase)) {
    Write-Host "Le chemin spécifié n'existe pas. Veuillez vérifier et réessayer." -ForegroundColor Red
    exit
}

# Demander le nom du dossier à supprimer
$nomDossier = Read-Host "Entrez le nom du dossier à supprimer"

# Construire le chemin complet
$cheminComplet = Join-Path -Path $cheminBase -ChildPath $nomDossier

# Vérifier si le dossier existe
if (-Not (Test-Path -Path $cheminComplet)) {
    Write-Host "Le dossier spécifié n'existe pas à cet emplacement." -ForegroundColor Red
    exit
}

# Demander confirmation
$confirmation = Read-Host "Êtes-vous sûr de vouloir supprimer ce dossier ? (O/N)"
if ($confirmation -eq "O" -or $confirmation -eq "o") {
    try {
        Remove-Item -Path $cheminComplet -Recurse -Force
        Write-Host "Dossier supprimé avec succès." -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur lors de la suppression : $_" -ForegroundColor Red
    }
} else {
    Write-Host "Suppression annulée par l'utilisateur." -ForegroundColor Yellow
}
}



#############################################################################################
####                                                                                    #####
####                          FONCTIONS SECURITE ET RESEAUX                             #####
####                                                                                    #####
#############################################################################################

function Securite_Reseaux {
    log_evt "Début de la fonction sécurité et réseaux"
    $exitLoop = $false  # Variable pour contrôler la sortie de la boucle
    
    while (-not $exitLoop) {

        #########################################################################################
        #nb interfaces + adreesses MAC +nom des interfaces
        ##########################################################################################
        $adaptateurs = Get-NetAdapter
        if ($adaptateurs) {
        
                $nb_adaptateurs = $(($adaptateurs | measure-object).Count)
                write-host "Nombre d'interfaces reseau :  $nb_adaptateurs"
                log_evt "Nombre d'interfaces reseau :  $nb_adaptateurs"
                write-host""
        
                #nom + mac de chaque interface
                $adaptateurs | ForEach-Object {
                    Write-Host " Nom:  $($_.Name),  Adresse MAC : $($_.MacAddress)"
                }
                Write-Host""
                log_evt " Nom:  $($_.Name),  Adresse MAC : $($_.MacAddress)"
        } else { 
            Write-Host "Pas d'interface réseau détectée"
            Write-Host ""
            log_evt "Pas d'interface réseau détectée"
        }
        
        ##############################################################################################
        #adresse ip
        ##############################################################################################
        $ipconfigs = Get-NetIPConfiguration
        
        if ($ipconfigs) {
        
            $ipconfig = $ipconfigs | Where-Object { $_.InterfaceAlias -eq $adaptateur.name }
        
            $ipv4 = $ipconfig.IPv4Address | ForEach-Object { $_.IPAddress}
            $ipv6 = $ipconfig.IPv6Address | ForEach-Object { $_.IPAddress}
        
            if ($ipv4) {
                foreach ($ip4 in $ipv4) {
                    Write-Host "Adresse IPv4 :  " $ip4
                    log_evt "Affichage de l'adresse IPv4"
                    Write-Host""
                }
            }
        
            if ($ipv6) {
                foreach ($ip6 in $ipv6) {
                    Write-Host "Adresse IPv6 : " $ip6
                    log_evt "Affichage de l'adresse IPv6"
                    Write-Host""
                }
            }
        } else {
            Write-Host "Pas d'adresse IP détectée"
            Write-Host
        }

        ##############################################################################################
        #ports ouverts
        ##############################################################################################
        $openports_tcp = Get-NetTCPConnection
        
        if ($openports_tcp) {
            $openport_tcp = $openports_tcp | ForEach-Object {$_.LocalPort}
            Write-Host "Liste des ports TCP ouverts :" $openport_tcp
        } else {
            Write-Host "Aucun port ouvert détecté"
            log_evt "Aucun port ouvert détecté"
        }

        Write-host""
        
        $openports_udp = Get-NetUDPEndpoint
        
        if ($openports_udp) {
            $openport_udp = $openports_tcp | foreach {$_.LocalPort}
            Write-Host "Liste des ports UDP ouverts : " $openport_udp
            log_evt "Liste des ports UDP ouverts"
        }
        
        ########################################################################################
        #menu de sortie
        ########################################################################################
        
        Write-Host "Pour afficher à nouveau les informations --> 1"
        Write-Host "Pour revenir au menu précédent --> 2"
        
        $choix = Read-Host "Entre votre choix (1 ou 2)"
        
        switch ($choix) {
            "1" {
                Write-Host "Mise à jour des informations"
                continue  # Continuer à afficher les informations
            }
            "2" {
                Write-Host "Retour au menu précédent"
                $exitLoop = $true  # Mettre fin à la boucle while et sortir
            }
            default {
                Write-Host "Saisie invalide, choisissez 1 ou 2"
                continue
            }
        }
    }
    log_evt "Fin de la fonction sécurité et réseaux"
}


#FONCTION PARE-FEU
function Pare_Feu {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION ¨PRISE EN MAIN A DISTANCE
function Remote {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION EXECUTION DU SCRIPT SUR LA MACHINE DISTANTE
function Script_Distance {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#############################################################################################
####                                                                                    #####
####                          FONCTIONS GESTIONS SYSTEME                                #####
####                                                                                    #####
#############################################################################################

#FONCTION INSTALATION LOGICIEL
function Install_Logiciel {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION DESINSTALATION LOGICIEL
function Desinstall_Logiciel {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION ARRET SYSTEME
function Arret_Sys {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION REDEMARRAGE SYSTEME
function Reboot {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION VEROUILLAGE
function Lock {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION VERSION DE L OS
function OS_Version {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION MAJ
function Maj {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION RECHERCHE EVENEMENTS DANS LE FICHIER LOG
function Recherche_Logs {
Write-Host "Fonction en développement" -ForegroundColor Red
}

#FONCTION RECHERCHE EVENEMENTS DANS LE FICHIER JOURNALISATION
function Recherche_Journa {
Write-Host "Fonction en développement" -ForegroundColor Red
}


#############################################################################################
####                                                                                    #####
####                                  ARBORESCENCE                                      #####
####                                                                                    #####
#############################################################################################


#menu principal
log_evt "Menu principal"
#boucle While avec compteur pour sortir revenir par defaut au debut aprés une utilisation
$compteurgeneral = "1"
while ($compteurgeneral -eq "1") {
    Clear-Host
    Write-Host "Menu principal :"
    Write-Host "1 - Utilisateur"
    Write-Host "2 - Disque et Répertoire"
    Write-Host "3 - Sécurité et réseaux"
    Write-Host "4 - Gestion système - developpement en cours"
    Write-Host "5 - Quitter"

    $choix = Read-Host "Votre réponse en chiffre"

    #switch du menu utilisateur
    switch ($choix) {
    
        1 {
            log_evt "Menu utilisateur"
            $compteur = "1"
            while ($compteur -eq "1" ) {
                #switch sous-menu groupe Utilisateur
                Write-Host "1 - Compte"
                Write-Host "2 - Groupe"
                Write-Host "3 - Droits d'accés"
                Write-Host "4 - Historique"
                Write-Host "5 - Quitter"
                $menutilisateur = Read-Host "Votre réponse en chiffre"
               
               # sous-menu utilisateur
               switch ($menutilisateur) {
                    1 {
                        log_evt "Menu de gestion des utilisateur"
                        $compteurutilisateur = "1"
                        while ($compteurutilisateur -eq "1") {
                            Write-Host "1 - Création de compte utilisateur local"
                            Write-Host "2 - Changement de mot de passe"
                            Write-Host "3 - Suppression de compte utilisateur local"
                            Write-Host "4 - Désactivation de compte utilisateur local"
                            Write-Host "5 - Quitter"
                            $menutilisateurcompte = Read-Host "votre réponse en chiffre"
                        

                            switch ($menutilisateurcompte) {
                                1 { Nouvel_Utilisateur }
                                2 { Nouveau_Mdp } 
                                3 { Suppression_Compte } 
                                4 { Activation_Desactivation_Compte } 
                                5 { $compteurutilisateur = "0" }
                                Default { Write-Host "Erreur de saisie" }
                            }
                        }
                       }
                    
                    2 {
                        log_evt "Menu de gestion des groupes"
                        $compteurutilisateurgroupe = "1"
                        while ($compteurutilisateurgroupe -eq "1") {
                            Write-Host " 1 - Ajout à un groupe d'administration"
                            Write-Host " 2 - Ajout à un groupe local"
                            Write-host " 3 - Sortie d'un groupe Local"
                            Write-Host " 4 - Groupe d'appartenance d'un utilisateur"
                            Write-Host " 5 - Quitter"
                            $choixutilisateurgroupe = Read-Host "votre réponse en chiffre"
                        

                            switch ($choixutilisateurgroupe) {
                                1 { Addadmin_Group }
                                2 { Addlocalgroup }
                                3 { Exclusion_Group_Local }
                                4 { Groupe_Appartenance }
                                5 { $compteurutilisateurgroupe = "0" } 
                                default { Write-Host "Erreur de saisie" }
                                
                            }
                        }}
                    3 {
                        log_evt "Menu de gestion des droits d'accès"
                        $compteurdroitdacces = "1"
                        while ($compteurdroitdacces -eq "1" ) {
                            Write-Host " 1 - Droit/permissions de l'utilisateur sur un fichier/dossier"
                            Write-Host " 2 - Quitter"
                            $choixdroitdacces = Read-Host "votre réponse en chiffre"

                            switch ($choixdroitdacces) {
                                1 { Droits_Acces } 
                                2 { $compteurdroitdacces = "0" }
                                default { Write-Host "Erreur de saisie" }

                            
                            }
                        }}
                    4 {
                        log_evt "Menu de gestion de l'historique"
                        $compteurhistorique = "1"
                        while ($compteurhistorique -eq "1") {
                            Write-Host " 1 - Date de dernière connexion d'un utilisateur"
                            Write-Host " 2 - Date de dernière modification du mot de passe"
                            Write-Host " 3 - Liste des sessions ouvertes par l'utilisateur"
                            Write-Host " 4 - Historique des commandes exécutées par l'utilisateur"
                            Write-Host " 5 - Quitter"
                            $choixhistorique = Read-Host "votre réponse en chiffre"

                            switch ($choixhistorique) {
                                1 { Last-Connexion } 
                                2 { mdp_history } 
                                3 { last_sessions } 
                                4 { last_command } 
                                5 { $compteurhistorique = "0" } 
                                default { Write-Host "Erreur de saisie" }
                            }
                        }

                    }
                    5 { $compteur = "0" } 
                    default { Write-Host "Erreur de saisie" }

                    

               
                    
                } 
               
            } 
        }

        2 {
            log_evt "Menu de gestion des disques et répertoires"
            $compteurdisquerepertoire = "1"
            while ($compteurdisquerepertoire -eq "1" ) {
                #sous menu du groupe disque et repertoire
                Write-Host "1 - Disques"
                Write-Host "2 - Répertoire"
                Write-Host "3 - Quitter"
                $menuDiskDir = Read-Host "Votre réponse en chiffre"
                
                switch ($menuDiskDir) {
                    1 {
                        $compteurdisque = "1"
                        while ($compteurdisque -eq "1") {
                            #sous sous menu de disque
                            Write-Host "1 - Informations disques"
                            Write-Host "2 - Quitter"
                            $menuDisque = Read-Host "Votre réponse en chiffre"

                            switch ($menuDisque) {
                                "1" { Informations_Disques}
                                "2" { $compteurdisque = "0" }
                                default { Write-Host "Erreur de saisie" }
                            }
                        } 
                    }

                    2 {
                        $compteurrepertoire = "1"
                        while ($compteurrepertoire -eq "1") {
                            #sous sous menu de repertoire
                            Write-Host "1 - Création de répertoire"
                            Write-Host "2 - Modification de répertoire"
                            Write-Host "3 - Suppression de répertoire"
                            Write-Host "4 - Quitter"
                            $menuRepertoire = Read-Host "Votre réponse en chiffre"

                            switch ($menuRepertoire) {
                                "1" { Creation_Repertoire }
                                "2" { Modification_Repertoire }
                                "3" { Suppression_Repertoire }
                                "4" { $compteurrepertoire = "0" }
                                default { Write-Host "Erreur de saisie" }
                            }
                        }
                    }

                    3 { $compteurdisquerepertoire = "0" }
                    default { Write-Host "Erreur de saisie" }
                }
            }
        }

         3 {
                    log_evt "Menu de gestion sécurité et réseaux"
                    $compteurSecurite_Reseaux = "1"
                    while ($compteurSecurite_Reseaux -eq "1") {
                        Write-Host "1 - Reseau"
                        Write-Host "2 - Pare-feu"
                        Write-Host "3 - Gestion à distance"
                        Write-Host "4 - Quitter"
                        $choixSecurite_Reseaux = Read-Host "Votre réponse en chiffre"

                        switch ($choixSecurite_Reseaux) {
                            "1" { Securite_Reseaux }
                            "2" { Pare_Feu }
                            "3" { Script_Distance }
                            "4" { $compteurSecurite_Reseaux = "0" }
                            default { Write-Host "Erreur de saisie" }
                        }
                    }
                }

        4 {
                    log_evt "Menu de gestion système"
                    #Sous menu de Gestion systéme
                    $compteurgestion = "1"
                      while ($compteurgestion -eq "1") {
                            Write-Host "1 - Installation logiciel"
                            Write-Host "2 - Désinstallation logiciel"
                            Write-Host "3 - Arrêt système"
                            Write-Host "4 - Redémarrage"
                            Write-Host "5 - Verrouillage session"
                            Write-Host "6 - Version de l'OS"
                            Write-Host "7 - Mise à jour système"
                            Write-Host "8 - Recherche logs"
                            Write-Host "9 - Recherche journaux"
                            Write-Host "10 - Quitter"
                         $choixgestion = Read-Host "Votre réponse en chiffre"

                        switch ($choixgestion) {
                            "1"  { Install_Logiciel }
                            "2"  { Desinstall_Logiciel }
                            "3"  { Arret_Sys }
                            "4"  { Reboot }
                            "5"  { Lock }
                            "6"  { OS_Version }
                            "7"  { Maj }
                            "8"  { Recherche_Logs }
                            "9"  { Recherche_Journa }
                            "10" { $compteurgestion = "0" }
                            default { Write-Host "Erreur de saisie" }
                        }
                    }
                }

        5 { 
        log_evt "Sortie du menu d'administration"
        $compteurgeneral = "0" }

        default {Write-Host "Erreur de saisie" }
    }
    }

    log_evt "Sortie du script"
