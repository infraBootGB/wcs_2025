# Chemin du fichier qui contient les cibles
$cheminscript_cibles = "C:\Users\Administrator\Documents\Scripts\fichier_cibles.txt"

# Chemin du script adminmenu
$chemin_script_general = "C:\Users\Administrator\Documents\Scripts\script_general.ps1"

clear-host

# Boucle principale
while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host " Bienvenue dans votre système de gestion "
    Write-Host ""

    # Propose d'entrer une valeur (IP, nom de machine ou utilisateur)
    $choix = Read-Host "Entrez un IP, un nom de machine, un nom d'utilisateur ou faites Entrée pour voir les clients disponibles"

    # Lire le contenu du fichier cibles sous forme de lignes brutes
    $cibles_liste = Get-Content -Path $cheminscript_cibles

    # Filtrer les lignes correspondantes (correspondance partielle dans toute la ligne)
    $cible_correspondante = $cibles_liste | Where-Object { $_ -like "*$choix*" }

    # Si pas de correspondance
    if (-not $cible_correspondante) {
        Write-Host "Aucune correspondance pour '$choix'" 
        Write-Host "Appuyez sur EntrÃ©e pour continuer..."
        Read-Host
        continue
    }

    # Afficher les lignes correspondantes avec un numÃ©ro
    Write-Host ""
    Write-Host " Cibles Correspondantes :   " 
    Write-Host ""

    $index = 1
    foreach ($cible in $cible_correspondante) {
        Write-Host "$index. $cible" 
        $index++
    }

    Write-Host ""
    $selection = Read-Host "Entrez le numÃ©ro de la cible (1-$($cible_correspondante.Count)) ou 'q' pour quitter"

    # switch selection
    switch ($selection) {
        "q" {
            Write-Host "Sortie du programme..." 
            exit
        }
        { $_ -in (1..$cible_correspondante.Count | ForEach-Object { $_.ToString() }) } {

            # Saisie correcte, sÃ©lectionner la ligne et extraire l'IP

            $selectedLine = $cible_correspondante[[int]$selection - 1]
            $selectedIP = ($selectedLine -split ":")[0]

             $result = Invoke-Command -ComputerName "$selectedIP" -FilePath "$chemin_script_general" -ErrorAction SilentlyContinue -ErrorVariable invokeError
             if ($invokeError) {


             Write-Host "Erreur d'éxécution"
             Write-Host $invokeError
             write-host $invokeError.Exception.Message

             continue
           
            }
           
        }
        default {
            # Saisie incorrecte, afficher message et retourner au menu
            Write-Host "Saisie incorrecte, choisissez une des entrÃ©es possibles ou 'q' pour quitter." 
            Write-Host "Appuyez sur EntrÃ©e pour continuer..."
            Read-Host
            continue
        }
    }

    }

