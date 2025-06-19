#!/bin/bash



#######################################################################################################################
#             					 Plan de script
######################################################################################################################
#
#            1) Déclaration de toutes les fonctions
#            2) Déclaration de la fonction menu_admin qui sert a rappeler toutes les fonctions
#            2) Script sélection du client cible et connexion  --> lancement de la fonction admin_menu_dans ssh
#
#######################################################################################################################





#######################################
### MISE EN PLACE DE LA JOURNALISATION#
#######################################

#Script de journalisation pour les actions
#Cette fonction assurera que les différents éléments factuels soient enregistrés
log_evt() {
local log_file="/tmp/log_evt.log"
local date=$(date +%Y%m%d)
local time=$(date +%H%M%S)
local user=$(whoami)
local event="$*"
echo "$date-$time-$user-$event" >> "$log_file"

sudo chmod 666 "$log_file" 
}





###########################################################################################################
# Fichier avec les informations nécessaires pour SSH au format "ip:name:user"
#############################################################################################################

ID="fichier_ID.txt"  #doit etre dans le meme dossier que le script au bon format





#######################################################################################################################
#######################         1) DÉCLARATION DES FONCTIONS       ########################################################
#######################################################################################################################



    
        ###########################################################################################################################
        #AJOUT D'UTILISATEUR
        ###########################################################################################################################

        fonction_compte()

        {
        log_evt "Début de la fonction ajout utilisateur"


            #variables locales
            local user


            while true; do
                read -p "Merci d'indiquer le nom d'utilisateur : " user
                # Vérification si l'utilisateur a bien été saisi
                if [ -z "$user" ]; then
                    echo "Merci d'entrer un nom d'utilisateur valide"
                    continue
                fi

                # Vérification si l'utilisateur existe déjà
                if grep -q "$user:" /etc/passwd; then
                    echo "L'utilisateur $user existe déjà."
                    continue
                fi
                break
            done
            
            # Tentative de création de l'utilisateur
            if sudo useradd "$user"; then
                echo "L'utilisateur $user a été créé avec succès !"
                log_evt "L'utilisateur $user a été créé avec succès !"
            fi

        log_evt "Fin de la fonction ajout utilisateur"
        }


        ###################################################################################################
        #GESTION DE MOT DE PASSE
        ###############################################################################################"

        fonction_mdpasse() 

        {
        log_evt "Début du changement de mot de passe"

            #variables locales
            local user

            echo "Affichage des 15 derniers comptes crées"
            cut -d: -f1 /etc/passwd | tail -n 15
            
            while true; do
                #Choisir le compte pour lequel on souhaite changer le mot de passe
                read -p "Merci d'indiquer le compte pour lequel vous souhaitez changer le mot de passe : " user

                if [ -z "$user" ]; then
                    echo "Merci d'entrer un nom d'utilisateur valide"
                    continue
                fi

                if ! id "$user" &>/dev/null; then
                    echo "Merci d'entrer un nom d'utilisateur valide"
                    continue
                fi
                
                echo "Vous avez choisi le compte "$user" && passwd "$user""
                log_evt "Vous avez choisi le compte "$user" && passwd "$user""
                break
            done 

        log_evt "Fin du changement de mot de passe"
        }

        ################################################################################################
        #SUPPRESSION DE COMPTE
        ################################################################################################

        fonction_userdelete() 

        {
        log_evt "Début de la fonction suppression d'utilisateur"

            #variables locales
            local user
            local confirmation


            echo "Affichage des 15 derniers comptes crées"
            cut -d: -f1 /etc/passwd | tail -n 15
            
            while true; do
                # Demande d'insertion/vérification du compte à supprimer
                read -p "Merci d'indiquer le nom d'utilisateur : " user

                # Vérifie si vide
                if [ -z "$user" ]; then
                    echo "Merci d'entrer un nom d'utilisateur valide"
                    continue
                fi

                # Vérifie si l'utilisateur existe
                if ! id "$user" &>/dev/null; then
                    echo "Le compte \"$user\" n'existe pas."
                    continue
                fi
                break
            done
            
            # Demande de confirmation
            echo "Vous avez choisi de supprimer le compte \"$user\", êtes-vous sûr ? -Oui/Non- "
            read confirmation

            case $confirmation in
                [Oo]ui|[Oo]UI)
                    deluser "$user"
                    echo "Le compte "$user" a bien été supprimé"
                    log_evt "Le compte "$user" a bien été supprimé"
                                        ;;
                [Nn]on|[Nn]ON)
                    echo "Suppression de compte annulée"
                    log_evt "Suppression de compte annulée"
                    ;;
                *)
                    echo "Réponse invalide, suppression annulée"
                    log_evt "Réponse invalide, suppression annulée"
                    ;;
            esac

        log_evt "Fin de la fonction suppression d'utilisateur"
        }


        ################################################################################################""
        #ACTIVATION/DÉSACTIVATION DE COMPTE
        #############################################################################################""""

        fonction_usershadow() 

        {
        log_evt "Début de la fonction désactivation d'utilisateur"

            #variables locales
             local user
             local choice


            echo "Affichage des 15 derniers comptes crées"
            cut -d: -f1 /etc/passwd | tail -n 15
            
            while true; do
                #Demande d'insertion/vérification du compte à activer/désactiver
                read -p "Merci d'indiquer le nom d'utilisateur : " user

                if [ -z "$user" ]; then
                    echo "Merci d'entrer un nom d'utilisateur valide"
                    continue
                fi

                # Vérifie si l'utilisateur existe
                if ! id "$user" &>/dev/null; then
                    echo "Le compte $user n'existe pas."
                    continue
                fi
                break
            done

            echo "1 - Activer un compte"
            echo "2 - Désactiver un compte"
            read -p "Choisissez une option 1-2 : " choice

            case $choice in
                1)
                    echo "Menu d'activation"
                    # Demande de confirmation
                    echo "Vous avez choisi d'activer le compte $user, êtes-vous sûr ? -Oui/Non-"
                    
                    #Ajout de la variable de confirmation du script activation
                    read confirmation 
                    case $confirmation in
                        [Oo]ui|[Oo]UI)
                            sudo passwd -u "$user"
                            echo "Le compte $user a bien été activé"
                            log_evt "Le compte $user a bien été activé"
                            ;;
                        [Nn]on|[Nn]ON)
                            echo "Activation de compte annulée"
                            log_evt "Activation de compte annulée"
                            return 1
                            ;;
                        *)
                            echo "Réponse invalide, activation annulée"
                            log_evt "Réponse invalide, activation annulée"
                            return 1
                            ;;
                    esac
                    ;;
                2)
                    echo "Menu de désactivation"
                    # Demande de confirmation
                    echo "Vous avez choisi de désactiver le compte $user, êtes-vous sûr ? -Oui/Non-"
                    
                    #Ajout de la variable de confirmation du script désactivation
                    read confirmation 
                    case $confirmation in
                        [Oo]ui|[Oo]UI)
                            sudo passwd -l "$user"
                            echo "Le compte $user a bien été désactivé"
                            log_evt "Le compte $user a bien été désactivé"
                            ;;
                        [Nn]on|[Nn]ON)
                            echo "Désactivation de compte annulée"
                            log_evt "Désactivation de compte annulée"
                            return 1
                            ;;
                        *)
                            echo "Réponse invalide, désactivation annulée"
                            log_evt "Réponse invalide, activation annulée"
                            return 1
                            ;;
                    esac
                    ;;
                *)
                    echo "Option invalide"
                    ;;
            esac

        log_evt "Fin de la fonction désactivation d'utilisateur"
        }


        ###############################################################################################""
        #Demande d'ajout à un groupe d'administration
        ################################################################################################""

        fonction_addadmingroup() 

        {
        log_evt "Début de la fonction ajout au groupe administrateur"

            #variables locales
             local user
             local confirmation

            #On vérifie l'existence du compte
            read -p "Merci d'indiquer le nom d'utilisateur à upgrade : " user

            if [ -z "$user" ]; then
                echo "Le nom d'utilisateur n'existe pas"
                return 1
            fi 

            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi

            # Demande de confirmation
            echo "Vous avez choisi d'ajouter le compte $user au groupe administrateur, êtes-vous sûr ? -Oui/Non-"

            #Ajout de la variable de confirmation d'ajout au groupe administrateur
            read confirmation
            case $confirmation in
                [Oo]ui|[Oo]UI)
                    sudo usermod -aG sudo "$user"
                    echo "L'utilisateur $user a été ajouté au groupe administrateur"
                    log_evt "L'utilisateur $user a été ajouté au groupe administrateur"
                    ;;
                [Nn]on|[Nn]ON)
                    echo "Commande d'ajout dans le groupe administrateur annulée"
                    log_evt "Commande d'ajout dans le groupe administrateur annulée"
                    ;;
                *)
                    echo "Réponse invalide, sortie"
                    log_evt "Réponse invalide, sortie"
                    ;;
            esac

        log_evt "Fin de la fonction ajout au groupe administrateur"
        }

        ###############################################################################################
        #Demande d'ajout à un groupe local
        ################################################################################################

        fonction_addlocalgroup() 

        {
        log_evt "Début de la fonction ajout au groupe local"

            #variables locales
            local user
            local group
            local confirmation


            #On vérifie l'existence du compte
            read -p "Merci d'indiquer le nom d'utilisateur à upgrade : " user

            if [ -z "$user" ]; then
                echo "Le nom d'utilisateur n'existe pas"
                return 1
            fi

            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi

            read -p "Merci d'indiquer le nom du groupe local : " group
            
            if [ -z "$group" ]; then
                echo "Le nom du groupe n'a pas été spécifié"
                return 1
            fi

            # Vérifie si le groupe existe
            if ! grep -q "^$group:" /etc/group; then
                # Demande de confirmation pour créer le groupe
                echo "Le groupe $group n'existe pas. Voulez-vous le créer ? -Oui/Non-"
                read confirmation
                case $confirmation in
                    [Oo]ui|[Oo]UI)
                        sudo groupadd "$group"
                        echo "Le groupe $group a été créé."
                        log_evt "Le groupe $group a été créé."
                        ;;
                    [Nn]on|[Nn]ON)
                        echo "Commande de création de groupe annulée"
                        log_evt "Commande de création de groupe annulée"
                        return 1
                        ;;
                    *)
                        echo "Réponse invalide, sortie"
                        log_evt "Réponse invalide, sortie"
                        return 1
                        ;;
                esac
            fi

            # Demande de confirmation pour ajouter l'utilisateur au groupe
            echo "Vous avez choisi d'ajouter le compte $user au groupe local $group, êtes-vous sûr ? -Oui/Non-"
            read confirmation
            case $confirmation in
                [Oo]ui|[Oo]UI)
                    sudo usermod -aG "$group" "$user"
                    echo "L'utilisateur $user a été ajouté au groupe $group"
                    log_evt "L'utilisateur $user a été ajouté au groupe $group"
                    ;;
                [Nn]on|[Nn]ON)
                    echo "Commande d'ajout dans le groupe local annulée"
                    log_evt "Commande d'ajout dans le groupe local annulée"
                    ;;
                *)
                    echo "Réponse invalide, sortie"
                    log_evt "Réponse invalide, sortie"
                    ;;
            esac

        log_evt "Fin de la fonction ajout au groupe local"
        }


        ###########################################################################################
        #Demande d'exclusion à un groupe local
        #############################################################################################""

        fonction_exclusiongrouplocal() 

        {
        log_evt "Début de la fonction exclusion du groupe local"
            #variables locales
            local user
            local group
            local confirmation

            read -p "Merci d'indiquer le nom d'utilisateur à exclure : " user

            if [ -z "$user" ]; then
                echo "Le nom d'utilisateur n'existe pas"
                return 1
            fi

            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi
            
            read -p "Merci d'indiquer le nom du groupe local : " group

            #Vérifier l'existence du groupe local
            if [ -z "$group" ]; then
                echo "Le groupe n'a pas été spécifié"
                return 1
            fi
            
            # Vérifie si le groupe existe
            if ! grep -q "^$group:" /etc/group; then
                echo "Le groupe $group n'existe pas."
                return 1
            fi

            # Demande de confirmation d'exclusion
            echo "Vous avez choisi d'exclure le compte $user du groupe local $group, êtes-vous sûr ? -Oui/Non-"
            read confirmation
            case $confirmation in
                [Oo]ui|[Oo]UI)
                    sudo gpasswd -d "$user" "$group"
                    echo "L'utilisateur $user a été exclu du groupe $group"
                    log_evt "L'utilisateur $user a été exclu du groupe $group"
                    ;;
                [Nn]on|[Nn]ON)
                    echo "Commande d'exclusion du groupe local annulée"
                    log_evt "Commande d'exclusion du groupe local annulée"
                    ;;
                *)
                    echo "Réponse invalide, sortie"
                    log_evt "Réponse invalide, sortie"
                    ;;
            esac

        log_evt "Fin de la fonction exclusion du groupe local"
        }


        #########################################################################################
        #DROIT D'ACCES
        #########################################################################################

        #On veut modifier les droits d'accès de l'utilisateur sur un fichier ou un dossier.
        fonction_droits-acces() 

        {
        log_evt "Début de la fonction modification des droits d'accès"

             local type 
             local cible 
             local perms

        # Choix rapide : fichier ou dossier
        read -p "Type de cible (fichier/dossier) : " type

        # Vérification de type
            if [[ "$type" != "fichier" && "$type" != "dossier" ]]; then
                echo "Type invalide. Veuillez taper 'fichier' ou 'dossier'."
                return 1
            fi

        # Demande du chemin de la cible
        read -p "Chemin complet du $type : " cible

            if [[ "$type" == "fichier" && ! -f "$cible" ]]; then
                echo "Fichier introuvable."
                return 1
            elif [[ "$type" == "dossier" && ! -d "$cible" ]]; then
                echo "Dossier introuvable."
                return 1
            fi

        # Saisie des droits
        read -p "Droits à appliquer (ex: 755, 644, ---) : " perms

        # Interprétation rapide : --- = aucun droit
            if [[ "$perms" == "---" ]]; then
            perms="000"
            fi

        # Application des droits
            chmod "$perms" "$cible"
            echo "Droits $perms appliqués sur $cible"
            ls -ld "$cible" 
            log_evt "Droits $perms appliqués sur $cible"

        log_evt "Fin de la fonction modification des droits d'accès"
        }


        ###############################################################################################
        #dernières connexion d'un utilisateur
        ###############################################################################################

        fonction_lastconnexion() 
        {
        log_evt "Début de la fonction historique de connexion"

            #variables locales
            local user


            read -p "Merci d'entrer le nom d'un utilisateur : " user

            #On vérifie si l'argument est bien rempli
            if [ -z "$user" ]; then
                echo "Vous devez entrer un nom d'utilisateur"
                return 1
            fi
            
            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi

            #On lance l'historique de connection
            last | grep  "$user" 
            log_evt "Consultation de l'historique de connection de '$user'"

        log_evt "Fin de la fonction historique de connexion"
        }



        #############################################################################################
        #dernières modifications de mdp
        ##############################################################################################

        fonction_lastmdpmodif() 

        {
        log_evt "Début de la fonction historique de changement de mot de passe"
            #variables locales
            local user

            read -p "Merci d'entrer le nom d'un utilisateur : " user

            #On vérifie si l'argument est bien rempli            
            if [ -z "$user" ]; then
                echo "Vous devez entrer un nom d'utilisateur"
                return 1
            fi
            
            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi

            #On lance l'historique de modification de mdp
            chage -l "$user"
            log_evt "Consultation de l'historique de modification de mot de passe de '$user'"
        
        log_evt "Début de la fonction historique de changement de mot de passe"
        }


        ###############################################################################################
        #liste des sessions ouvertes par l'utilisateur
        ################################################################################################

        fonction_sessions-ouvertes() 

        {
        log_evt "Début de la fonction liste des sessions ouvertes"

            #variables locales
            local user

            read -p "Merci d'entrer le nom d'un utilisateur : " user

            #On vérifie si l'argument est bien rempli 
            if [ -z "$user" ]; then
                echo "Vous devez entrer un nom d'utilisateur"
                return 1
            fi
            
            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi

            echo "Sessions ouvertes par l'utilisateur $user :"
            who | grep "^$user"
            log_evt  "consultation des sessions ouvertes de '$user'"

        log_evt "Fin de la fonction liste des sessions ouvertes"
        }


        ##########################################################################################""
        #Lecture du fichier history
        ############################################################################################

        fonction_history() 
        {
        log_evt "Début de la fonction historique"

            read -p "Nom d’utilisateur dont tu veux voir l’historique : " user

                  #On vérifie si l'argument est bien rempli 
            if [ -z "$user" ]; then
                echo "Vous devez entrer un nom d'utilisateur"
                return 1
            fi
            
            # Vérifie si l'utilisateur existe
            if ! id "$user" &>/dev/null; then
                echo "Le compte $user n'existe pas."
                return 1
            fi

            sudo cat "/home/$user/.bash_history"
            log_evt "Consultation de l'historique bash de l'utilisateur '$user'"

        log_evt "Fin de la fonction historique"
        }



        ################################################################################################################""
        # fonction "Informations Réseau"
        ################################################################################################################""
        Informations_reseau()

        {
        log_evt "Début de la fonction informations réseau"
            

            #sécurité et réseau
            #partie réseau
            #suppose qu'on est déjà connecté à la machine en ssh et dans la ligne de commande

            # établir la fonction "Informations Réseau"
            #boucle de script while
            #extraire et afficher le  nombre d"interfaces réseau (j'ai rajouté les noms pour faciliter la lecture des infos)
            #extraire et afficher les adresse ip correspondantes aux interfaces listés
            #extraire et afficher les adresses mac
            #extraire et afficher la liste des ports ouverts
            #afficher le menu de boucle ou sortie avec case
            #case pour recommencer (donc réafficher les informations, nouvelle boucle script) / ou revenir au menu précédent


            
            #variables locales 
            local liste_interfaces
            local nb_interfaces
            local liste_ip
            local ports_ouverts
            local choix



            while true
                do

                #afficher le  nombre d"interfaces réseau (j'ai rajouté les noms pour faciliter la lecture des infos)
                liste_interfaces=$(ip link show)

                #si les nombre d interfaces n'est pas vide
                if [ -n "$liste_interfaces" ]; then

                    #extraire le nombre de ligne commencant par un chiffre et ":" et afficher le nombre de lignes
                    #inclure ce résultat dans une variable pour l'afficher dans une réponse
                
                    nb_interfaces=$(echo "$liste_interfaces" | awk -F: '/^[0-9]+:/ {print $1}' | wc -l) ### définit le délimiteur par ":" et filtre les lignes qui commencent (^) par 1nombre ou + et imprime le 1er champ ->et compte le résultat
                    echo "Nombre d'interfaces réseau détectées : $nb_interfaces"
                    log_evt "Detection de "'$nb_interfaces'""
                else 
                    echo "Nombre d'interfaces réseau détectées : 0"
                    log_evt "0 interfaces détéctées"
                fi

                    #afficher les nom des interfaces réseau correspondants
                    liste_ip=$(ip a)

                if [ -n "$liste_ip" ]; then
                    echo "Interfaces réseau détectées :"
                    echo "$liste_ip" |awk -F: '/^[0-9]+:/ {print $2}' ### idem mais filtre le champ 2
                    log_evt "Une ou plusieurs interface réseaux détectées"
                    #autrement afficher "Aucune interface réseau détectée"
                else 
                    echo "Aucune interface réseau détectée"
                    log_evt "Aucune interface réseau détectée"
                fi


                
                #extraire et afficher les ip correspondantes
                if [ -n "$liste_ip" ]; then ###si la liste n'est pas vide 
                
                    echo "Adresses IP détectées :"
                    echo "$liste_ip" |awk '/inet / {print $2}' ###sélectionne les lignes commencant par inet, séparé par espace et imprime le 2eme element
                else 
                    echo "Aucune adresse IP détectée"
                    log_evt "Aucune adresse IP détéctée"

                fi 



                
                #filtrer et afficher les adresses mac
                if [ -n "$liste_interfaces" ]; then
                    echo "Adresses MAC détectées :"
                    echo "$liste_interfaces" |awk '/link/ {print $2}' ###ici pas d'espace après link
                else
                    echo "Pas d'adresse MAC détectée"
                fi

                
                #lister les ports ouverts 
                #il faut mettre dans une variable :interroger la liste des ports : ss -tuln #extraire les ports - couper la ligne d'entête 
                #et conserver que la première information derrière les 2 points
                #si il y a quelquechose
                ports_ouverts=$(ss -tuln | tail -n +2 |awk '{sub(/.*:/, "", $5);print $5}' | sort -u)  ##envoi pipe--> commence à partir de la ligne 2 --> 
                # --> awk supprime tout ce qu il y a avant $5  et garde chaine vide donc garde que le numéro de port --> "sort" classe en suprimant les doublons.

                #afficher "Liste des ports ouverts :"
                # afficher les ports ouvert
                #si rien dans la sortie : afficher "Aucun port ouvert détecté"

                if [ -n "$ports_ouverts" ]; then #vérifie liste des ports non vide
                
                    echo "Liste des ports ouverts: "
                    echo "$ports_ouverts"  
                    log_evt "Detection de "'$ports_ouverts'""
                else 
                    echo "Aucun port ouvert détecté"
                    log_evt "Aucun port ouvert détécté"
                fi 


            
                #Afficher le menu de boucle ou sortie
                
                echo "Voulez-vous : "
                echo "1 - Afficher à nouveau les informations"
                echo "2 - Revenir au menu précédent"
                read -p "Saisissez 1 ou 2 : "  choix



            
                #case pour recommencer (donc réafficher les informations, nouvelle boucle script) / ou revenir au menu précédent
            
                case $choix in
                    1)
                        continue;;
                    2)
                        return;;
                    *)  echo "Choix invalide retour au menu précédent"  #pour toute autre touche
                    
                    return;;  #pour revenir au menu
                

                esac    






            done

        log_evt "Fin de la fonction informations réseau"
        }


        ############################################################################################################################
        #fonction pare-feu
        ##############################################################################################################################
        # mettre en fonction "pare-feu"
        #boucle while
        #afficher le statut du pare-feu
        #SI dÉsactivÉ proposer d'activer--> si oui activation et retour au menu prÉcÉdent
        #si activÉ poroposer de dÉsactiver ---> si oui dÉsactiver sinon revenir au menu prÉcÉdent
        #Sinon revenir au menu prÉcÉdent


        pare_feu()
        {
        log_evt "Début de la fonction pare-feu"

            #variables locales
            local statut
            local reponse
            local choix





            while true
            do

                    #afficher le statut du pare-feu
                    statut=$(ufw status | grep -o "actif\|inactif")
                    echo "Statut du pare-feu : $statut"


                #proposer d'activer ou dÉsactiver le  pare-feu
                if [ "$statut" = "actif" ]; then
                    echo "Voulez-vous désactiver le pare-feu ? -o/n- "
                
                    read -p "Entrez votre choix : " reponse
                        if [ "$reponse" = "o" ]; then
                                sudo ufw disable
                                echo "Pare-feu désactivé."
                                log_evt "Désactivation du pare-feu"
                            else
                            echo "Aucune modification effectuée."
                        fi

                else
                            echo "Voulez-vous activer le pare-feu ? -o/n- "
                           
                            read -p "Entrez votre choix : " reponse
                            if [ "$reponse" = "o" ]; then
                                sudo ufw enable
                                echo "Pare-feu activé."
                                log_evt "Activation du pare-feu"
                            else
                                echo "Aucune modification effectuée."
                            fi
                fi

                        # Proposer de recommencer ou de quitter
                        echo "Pour recommencer :1 "
                        echo "Pour revenir au menu précédent : 2 "
                
                        read -p "Entrez votre choix : " choix
                        
                        case "$choix" in
                            1) 
                                continue;; #remodifier le pare feu
                            2)
                                return;; #sortie
                            *)
                                return;; #sortie

                  
		      esac

           	return

		 done

        log_evt "Fin de la fonction pare-feu"
        }




        #############################################################################################################################
        #fonction gestion a distance
        #################################################################################################################################
        #boucle while
        #entrez le chemin du script à éxécuter
        #verifier si script existe
        #si oui
        #vérifier ou rendre executable chmod
        #lancer le script
        #confirmer ok ou nok
        #proposer nouveau script ou sortie
        #sinon proposer d'entrer nouveau chemin ou return

        script_distant()
        {
        log_evt "Début de la fonction script_distant"

            #variables locales
            local chemin
            local reponse
            local choix
            local erreur_script
            local valeur_sortie

            while true
            do

                #entrez le chemin du script à éxécuter
                # shellcheck disable=SC2162
                read -p "Entrez le chemin/nom du script : " chemin


                #verifier si script existe
                if ! [ -f "$chemin" ]; then

                    echo "Aucun script détécté"
                    echo "Pour entrer un nouveau chemin : 1 "
                    echo "Pour revenir au menu précédent : 2 "
                    
                    read -p "Entrez votre choix : " reponse

                    case $reponse in
                        1)
                            continue;;
                        2)
                            return;;
                        *) 
                            echo "Choix invalide, retour au menu précédent"
                            return;; 

                    esac    
            
                else 

                    #rendre éxécutable et lancer script + si erreur
                    chmod u+x "$chemin"
                    erreur_script=$(bash "$chemin" 2>&1 >/dev/null)  #pour récupérer l"rreur et l'afficher après
                    valeur_sortie=$?
                    
                    #pour vérifier l éxécution
                        if [ $valeur_sortie -eq 0 ]; then

                            echo "Exécution du script effectuée"
                        else
                            echo "Script non éxécuté "
                            echo " Erreur : $erreur_script"

                        fi
                fi 

                echo "Essayer un autre script - 1 "
                echo "Revenir au menu précédent - 2 "
               
                read -p "Entrez votre choix : " choix

                case $choix in

                    1) 
                        continue;;

                    2) 
                        return;;

                    *) 
                        echo "Choix invalide, retour au menu précédent" 
                        return;;

                esac

            done

        log_evt "Fin de la fonction script_distant"
        }


        #######################################################################################################################################
        #fonction installation de logiciel
        ####################################################################################################################################""

        script_install()
        {
        log_evt "Début de la fonction installation de logiciel"

            #variables locales
            local logiciel
            local presence
            local retour
            local choix
            
        

            while true
            do

                #récupérer le nom du logiciel
                read -p "Entrez le nom exact du logiciel à installer :  " logiciel

                #verifier si deja installé branche

                
                presence=$(find /usr/bin /bin /usr/local/bin /snap/bin -type f -executable -name "$logiciel" 2>/dev/null)


                if [ -z "$presence" ] && [ ! -z "$logiciel" ]; then  #si existe pas et entrée non nulle

                    echo "Installation en cours"
                    sudo apt update && sudo apt install "$logiciel" -y 2> erreur.txt

                    retour=$?
                    if [ "$retour" -eq 0 ]; then
                
                        echo "Installation terminée"
                        log_evt "Instalation du logiciel "'$logiciel'" terminée"
                
                
                        else      

                        echo " L'installation a échouée "
                        log_evt "L'installation du logiciel "'$logiciel'" a échouée"
                        
                    fi


                
                
            
                else

                    echo " Programme déjà présent ou saisie vide."
                
                fi



                echo "Pour installer un nouveau programme : 1"
                echo "Pour revenir au menu précédent : 2 "
                read -p "Entrez votre choix :  " choix

                case $choix in 
                        1) 
                            continue;;
                        2)
                            break;;
                        *)
                            break;;

                esac
            done

        log_evt "Fin de la fonction installation de logiciel"
        }


        ###############################################################################################################################
        #fonction déseinstallation logiiel
        ###############################################################################################################################

        script_uninstall()
        {
        log_evt "Début de la fonction désinstallation de logiciel"

            #variables locales
            local logiciel
            local verif
            local choix

            while true
            do

                #récupérer le nom du logiciel
                read -p "Entrez le nom exact du logiciel à désinstaller:  " logiciel

                #verifier si deja installé branche

                presence=$(find /usr/bin /bin /usr/local/bin /snap/bin -type f -executable -name "$logiciel" 2>/dev/null)


                if [ -n "$presence" ] && [  -n "$logiciel" ] ; then  #si existant et entrée non nulle

                    echo "Désinstallation en cours"
                    sudo apt purge "$logiciel" -y 2> erreur.txt
                

                    verif=$?
                    if [ "$verif" -eq 0 ]; then
                
                        echo "Désinstallation terminée"
                        log_evt "Désinstallation du logiciel "'$logiciel'" terminée"
                
                
                        else      

                        echo " La désinstallation a échouée "
                        cat erreur.txt
                        log_evt "La désinstallation du logiciel "'$logiciel'" a échouée"
                        
                    fi

                    rm -f erreur.txt

                
                
            
                else
        
                    echo " Programme non détecté ou saisie vide."
                    log_evt "Programme non détécté ou saisie vide"
                
                fi



                echo "Pour Désinstaller un nouveau programme : 1"
                echo "Pour revenir au menu précédent : 2 "
                read -p "Entree votre choix :  " choix

                case $choix in 
                        1) 
                            continue;;
                        2)
                            break;;
                        *)
                            break;;

                esac

            done

        log_evt "Fin de la fonction désinstallation de logiciel"
        }


        ###############################################################################################################################""
        #Fonction shutdown
        ###################################################################################################################################"

        shutdown ()
        {
        log_evt "Début de la fonction Shutdown"

            local eteindre #variable locale


            echo "Confirmez pour éteindre la machine"
            
            read -p " 1 pour confirmer / 2 pour revenir au menu :  "    eteindre

                case $eteindre in

                1)
                    echo "Arrêt de la machine en cours" 
                    log_evt "Arret de la machine en cours"
                    # shellcheck disable=SC2033
                    sudo shutdown now;;
                    
                2)

                    return;;

                *)
                    echo "Choix incorrect retour au menu précédent."
                    return;;
            
                esac

        log_evt "Fin de la fonction Shutdown"
        }




        ###############################################################################################################
        #fonction redémarrage
        #######################################################################################################################      
        
        reboot ()
        {
        log_evt "Début de la fonction Reboot"

            #variable locale
            local choix

            read -p "Pour redémarrer la machine appuyez sur R sinon appuyez sur une touche pour revenir au menu précédent" choix

            case $choix in

                R) 
                echo "Redémarrage demandé, la connexion sera interrompue"
		sleep 1
                    sudo reboot ;;

                *) 
                    return

                    ;;

            esac         





        log_evt "Fin de la fonction Reboot"
        }        


        #####################################################################################################################
        #fonction update
        ##########################################################################################################################

        update ()
        {
        log_evt "Début de la fonction Update"
            
            #variable locale
            local choix

                read -p "Pour mettre à jours la machine appuyez sur M , sinon appuyez sur un touche pour revenir au menu précédent" choix
                case $choix in

                    M) 
                            echo "Mise a jours demandée, veuillez patienter.."
			    sleep 1
                            sudo apt update && sudo apt upgrade -y ;;
                    
                    *)
			
			echo " Retour au  menu précédent"
                        return ;;

                esac 

        log_evt "Fin de la fonction Reboot"
        } 

        ####################################################################################################################
        #fonction afficher OS
        ########################################################################################################################""
        

        osversion ()
        {
        log_evt "Début de la fonction osversion"
            
            #variable locale
            local choix

                read -p "Pour afficher la version de l'OS appuyez sur V , sinon appuyez sur une touche pour revenir au menu précédent" choix
                case $choix in

                    V) 
                            echo " Version de l'OS "
                            lsb_release -a ;;
                    
                    *)
                        return ;;

                esac 

        log_evt "Fin de la fonction OSversion"
        } 



        ################################################################################################################################
        #fonction verrouillage
        ################################################################################################################################""

        verrouillage()

        {
        log_evt "Début de la fonction vérrouillage" 
            #variable locale
            local choix

            while true
            do

                echo " WARNING"
                echo " Le verrouillage de la machine est potentiellement "
                echo " irréversible si vous êtes en accès distant."

                echo " 1 - pour verrouiller" 


                echo "2 - pour déverrouiller"

                echo " R pour revenir au menu précédent"


                read -p "Entrez votre choix :   " choix

                    case $choix in

                        1) 
            
                            loginctl lock-session
                            echo "Session verrouillée"
                            log_evt "Session verrouillée"
                            return;;

                        2)
                            loginctl unlock-session
                            echo "Session déverouillée"
                            log_evt "Session déverouillée"
                            return;;

                        *)

                            return;;

                    esac

            done

        log_evt "Fin de la fonction vérrouillage" 
        }
















########################################################################################################################################""
################    2) Déclaration de la fonction menu_admin qui sert a rappeler toutes les fonctions    ###############
#########################################################################################################################################

#fonction admin_menu
admin_menu ()

{
log_evt "Début de la navigation dans le menu" 

    
    #boucle avec utilisateur et ip constante
    while true; do
        #On pose la question Utilisateur ou Disque & Répertoire ou Sécurité & réseaux ou Gestion système ou Quitter?
        echo "Quel est votre choix entre:"
        echo "1 - Utilisateur"
        echo "2 - Disque et répertoire"
        echo "3 - Sécurité et réseaux"
        echo "4 - Gestion système"
        echo "5 - Quitter"
        read -p "Votre reponse en chiffre: " menu_general

        #Si Utilisateur
        case $menu_general in
            1)
                #On pose la question compte, groupe, Droits d'accés ou historique ou Quitter?
                while true; do
                    echo "Quel est votre choix entre:"
                    echo "1 - Compte"
                    echo "2 - Groupe"
                    echo "3 - Droits d'accés"
                    echo "4 - Historique"
                    echo "5 - Quitter"
                    read -p "Votre reponse en chiffre: " menu_utilisateur

                    case $menu_utilisateur in 
                        #Si Compte
                        1)
                            #lancement sous menu compte
                            #On pose la question Création de compte, Changement de mot de passe , Suppression de Compte , désactivation de compte ou quitter.
                            while true; do
                                echo "Quel est votre choix entre:"
                                echo "1 - Création de compte"
                                echo "2 - Changement de mot de passe"
                                echo "3 - Suppression de compte"
                                echo "4 - Désactivation de compte"
                                echo "5 - Quitter"
                                read -p "Quel est votre reponse en chiffre ? " menu_compte

                                case $menu_compte in
                                    # si Création de compte
                                    1) 
                                        fonction_compte
                                        echo "Interface création de compte lancé" 
                                    ;;

                                    # si Changement de mot de passe
                                    2)
                                        fonction_mdpasse
                                        echo "Interface de changement de mot de passe"
                                    ;;  

                                    # si Suppression de compte
                                    3)
                                        fonction_userdelete
                                        echo "Interface de suppression de compte"
                                    ;;

                                    # Si Désactivation de compte
                                    4)
                                        fonction_usershadow
                                        echo "Interface de desactivation de compte"
                                    ;;
                                    
                                    # si Quitter
                                    5)
                                        break
                                    ;;

                                    # Si erreur de Saisie
                                    *)
                                        echo "Erreur de saisie"
                                    ;;
                                esac
                            done
                        ;;
                        
                        #Si Groupe
                        2)
                            # On pose la question Ajout à un groupe d'adminstration ou ajout d'un groupe Local ou Sortie d'un groupe local ou Groupe d'appartance d'un utilisateur ou quitter
                            while true; do
                                echo "Quel est votre choix entre:"
                                echo "1 - Ajout à un groupe d'administration"
                                echo "2 - Ajout à un groupe local"
                                echo "3 - Sortie d'un groupe local"
                                echo "4 - Groupe d'appartenance"
                                echo "5 - Quitter"
                                read -p "Quel est votre réponse en chiffre? " menu_groupe

                                case $menu_groupe in
                                    #Si Ajoute à un groupe d'administration
                                    1) fonction_addadmingroup
                                    echo "Interface d'ajout au groupe d'admininistration"
                                    ;;

                                    #Si Ajoute à un groupe Local
                                    2) fonction_addlocalgroup
                                    echo "Interface d'ajout au groupe d'admininistration"
                                    ;;

                                    #Si Sortie D'un groupe Local
                                    3) fonction_exclusiongrouplocal
                                    echo "Interface d'exclusion d'un groupe local"
                                    ;;
                                    
                                    #si Groupe d'appartenance
                                    4)
                                    ;;

                                    #Si Quitter
                                    5)
                                        break
                                    ;;

                                    #Si erreur de Saisie
                                    *)
                                        echo "Erreur de saisie"
                                    ;;
                                esac
                            done
                        ;;
                        
                        #Si Droits d'accés
                        3)
                            # On pose la question Droits/permissions de l'utilisateur sur un dossier ou un fichier
                            while true; do
                                echo "Quel est votre choix entre:"
                                echo "1 - Droit/permissions sur un dossier ou fichier"
                                echo "2 - Quitter"
                                read -p "Votre réponse en chiffre? " menu_droit_acces

                                case $menu_droit_acces in
                                    # si droit/permissions sur un dossier
                                    1) fonction_droits-acces
                                    echo "Interface de modification de droits d'acces sur un dossier ou fichier"
                                    ;;
                                    
                                    # si quitter
                                    2)
                                        break
                                    ;;

                                    # si erreur de saisie
                                    *)
                                        echo "Erreur de saisie"
                                    ;;
                                esac
                            done
                        ;;
                        
                        #si Historique
                        4)
                            # On demande si l'utilisateur veut lire la date de dernière connexion d'un user, modif de mdp, consulter la liste des sessions ouverte et l'historique des commandes
                            while true; do
                                echo "Quel est votre choix entre:"
                                echo "1 - Afficher la dernière connexion d'un utilisateur"
                                echo "2 - Afficher la dernière modification du mot de passe"
                                echo "3 - Afficher les sessions ouvertes par l'utilisateur"
                                echo "4 - Afficher l'historique des commandes exécutées par l'utilisateur"
                                echo "5 - Quitter"
                                read -p "Votre reponse en chiffre? " menu_historique

                                case $menu_historique in
                                    # si Affichage de la derniere connexion d'un utilisateur
                                    1) fonction_lastconnexion
                                    ;;

                                    # si Affichage de la derniere modification du mot de passe
                                    2) fonction_lastmdpmodif
                                    ;;

                                    # si Affichage des sessions ouvertes par l'utilisateur
                                    3) fonction_sessions-ouvertes
                                    ;;

                                    # si Affichage de l'historique des commandes exécitées par l'utilisateur
                                    4) fonction_history
                                    ;;

                                    # si quitter
                                    5)
                                        break
                                    ;;

                                    # si erreur de saisie
                                    *)
                                        echo "Erreur de saisie"
                                    ;;
                                esac
                            done
                        ;;

                        #Si quitter
                        5)
                            break
                        ;;

                        #si erreur de saisies
                        *)
                            echo "Erreur de saisie"
                        ;;
                    esac
                done
            ;;
        
        2)
        #Si Disque et Repertoire

            #On pose la question Disque ou Repertoire ou  Quitter?
            while true
            do
            echo "Quel est votre choix entre:"
            echo "1 - Disque"
            echo "2 - Repertoire"
            echo "3 - Quitter"
            read -p "Votre réponce en chiffre:" menu_disque_repertoire

            case $menu_disque_repertoire in
                
                #Si Disque
                1)
                    #On pose la question Nb de disque ou Partition ou Espace disque restant par Partition ou Nom et espace disque d'un dossier ou Liste des lecteurs monté ou quitter
                    while true
                    do
                    echo "Quel est votre choix entre:"
                    echo "1 - Nombre de disque"
                    echo "2 - Partition"
                    echo "3 - Espace disque restant par partition/volume"
                    echo "4 - Nom et espace disque d'un dossier -nom de dossier demandé-"
                    echo "5 - Liste des lecteurs monté -disques, cd, etc...-"
                    echo "6 - Quitter"
                    read -p "Quel est votre réponse en chiffre: " menu_disque
                    case $menu_disque in
                
                        #  Si Nb de Disque
                        1)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."
                        ;;

                        # Si Partition
                        2)
                                echo "Fonction en cours de développement"
                                echo "Appuyé sur Entrée.."
                        ;;

                        # Si Espace disque restant par partition
                        3)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."
                        ;;

                        # Si Nom et espace disque d'un dossier
                        4)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."
                        ;; 

                        # Si liste des lecteurs monté
                        5)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."
                        ;;

                        # Si Quitter
                        6)
                        break
                        ;;

                        # Else erreur
                        *)
                        echo "erreur de saisie"
                        echo "Appuyez sur Entrée.."

                        ;;

                        esac
                    done

                ;;

                #Si Repertoire
                2)

                    # on pose la question Création de repertoire ou modification répertoire ou suppression de repertoire ou quitter
                    while true
                    do
                    echo "1 - Création de répertoire"
                    echo "2 - Modification de répertoire"
                    echo "3 - Suppression de répertoire"
                    echo "4 - Quitter"
                    read -p "Quel est votre réponse en chiffre:" menu_repertoire

                    case $menu_repertoire in

                        #si Création de de repertoire
                        1)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."
                        ;;

                        #si modification répertoire
                        2)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."
                        ;;

                        #suppression de repertoire 
                        3)
                                echo "Fonction en cours de développement"
                                echo "Appuyez sur Entrée.."

                        ;;

                        #si quitter
                        4)
                        break
                        ;;

                        #si erreur de saisie
                        *)
                        echo "Erreur de saisie"
                        echo "Appuyez sur Entrée.."
                        ;;

                        esac

                    done

                ;;

                #si quitter
                3)
                break
                ;;

                #else erreur de saisie
                *)
                echo "Erreur de saisie"
                echo "Appuyez sur Entrée.."
                ;;

                esac
            done
        ;;

        3)
        # Si Sécurité et réseaux

            #On pose le question Réseau ou Pare-Feu ou Gestion à distance ou quitter
            while true
            do
            echo "quel est votre choix?"
            echo "1 - Réseau"
            echo "2 - Pare-feu"
            echo "3 - Gestion à distance"
            echo "4 - Revenir au menu précédent"
            read -p " Entrez votre choix :  " menu_securite_reseaux

            case $menu_securite_reseaux in

                #si Réseau
                1) Informations_reseau

                   
                ;;

                #si Pare Feu
                2) pare_feu

                    
                ;;

                #Si Gestion à distance
                3) script_distant

                  
                ;;

                #si quitter
                4)
                break
                ;;

                #si erreur de saisie
                *)
                echo "Erreur de saisie"
                ;;

                esac
            done

        ;;

        4)
        #Si Gestion syteme

            #on pose la question Logiciel ou système ou Journaux d'evenements ou quitter
            while true
            do
            echo "Quel est votre choix entre:"
            echo "1 - Logiciel"
            echo "2 - Sytème"
            echo "3 - Journaux d'évenements"
            echo "4 - Quitter"
            read -p "Saisissez votre choix  : " menu_gestion_syteme

            case $menu_gestion_syteme in
            
                #si logiciel
                1) 

                #On pose la question Installation ou désinstallation
                echo "Que voulez-vous faire ?"
                echo "1 - Installer un logiciel"
                echo "2 - Désinstaller un logiciel"
                echo "3 - Retour au menu gestion systeme"
                    read -p "Entrez votre choix :  " choix
                    case $choix in

                        #si Installaition de Logiciel
                        1) script_install
                        ;;
                        #si Désinstallation de logiciel
                        2) script_uninstall
                        ;;     
                        #si quitter
                        3) break
                        ;;
                    esac
                ;;
                #Si Systeme
                2) 
                
                echo "Pour arreter la machine       - 1"
                echo "Pour redémarrer la machine    - 2"
                echo "Pour verouiller la  machine   - 3"
                echo "Pour mettre à jour le système - 4"
                echo "Afficher version de l'OS      - 5"
                echo "Retour au menu précédent      - 6"
                read -p "Saisissez votre choix  : " choisys
                    case $choisys in 

                        1) shutdown
                    
                        ;;

                        #mettre fonction reboot
                        2) reboot

                            
                        
                            ;;

                        3) verrouillage 
                        
                        ;;

                        #Mise à jours système
                        4) update 

                        
                        ;;

                        #afficher version os
                        5) osversion

                          
                            ;;
                            
                         #retour menu précédent   
                        6)

                            return
                            ;;


                        #erreur de saisie
                        *)

                        return

                    
                    esac 



                 
                
                ;;

                #Si Journaux d'événements
                3) 


                echo "Pour rechercher un évènement utilisateur        - 1"
                echo "Pour rechercher un évènement machine            - 2"
                read -p "Saisissez votre choix :   " choijou
                    case $choijou in 
                
                    1) 
                        echo "Fonction en cours de développement"
                        ;;

                    2)

                        echo "Fonction en cours de développement"
                        ;;
                    *) 

                        return ;;

                    esac 

                ;;

                #Si Quitter
                4)
                break
                ;;
                
                #Si erreur ou des cas précedent.
                *)
                echo "Erreur de saisie"
                ;;

                esac
            done
        

        ;;
        
        #Si quitter
        5)
	break
        ;;
        #Si erreur ou autre choix.
        *)
        echo "Erreur de saisie"
        ;;
        esac
    
    
    #Quitter boucle fonction
    done

log_evt "Fin de la navigation dans le menu" 

}


##########################################################################################################
#               3) Script sélection de cible et connexion SSH
#########################################################################################################"""



#Variables utilisées pour l'identification de la cible et connexion SSH#
# adresses=  IP dans fichier ID
# machine_name= nom des machines dans le fichier ID
# utiilisateur= user dans le fichier ID
# cibles_ID = Machine ip ou user trouvés après filtrage
# info_ID= couple ip/user utilisé pour conxexion ssh
# IP = IP utilisée pour ssh
# user = user utilisé pour ssh

# Lire le fichier ligne par ligne
#afficher les lignes qui contiennent la saisie utilisateur
#proposer choix si plusieurs 1 ou 2 etc
#si pas de correspondance retour au menu
# découper pour récuper IP et USER pour ssh



while true
do

    echo " "
    echo " "
    echo "Bienvenue dans votre utilitaire de gestion"
    echo " "
    echo "Choisissez :" 
    echo "1 - Pour entrer une info : IP, nom de machine nom d'utilisateur"
    echo "2 - Pour quitter"
    read -p "Saisissez votre choix ici : " cibles

    #réinitaliser les variables
    choix=""
    info_ID=""
    cibles_ID=""
    ip=""
    user=""


   
    #  si choix 1, sinon retour au menu
    if [ "$cibles" = "1" ]; then
  

        # récupérer saisi utilisateur
        read -p "Entrez une info : IP, Nom de machine ou nom d'utilisateur) : " choix

        # Filtrer choix avec grep dans fichier.ID et enregistrer dans cibles_id le retour de grep
        cibles_ID=$(grep -i "$choix" "$ID")

    elif [ "$cibles" = "2" ];then

        #si choix 2 quitter sortir du script
        
        echo "Vous avez demandé à sortir du programme"
        
        break 

    else
            
            echo "Saisie incorrecte retour au menu"

            exit 0


    fi

    # Si pas de correspondance, retour au menu
    if [ -z "$cibles_ID" ]; then
        echo "Aucun résultat pour votre entrée"
        continue
    
    else
        # Afficher les cibles trouvées
        echo "Les cibles trouvées :"
        echo "$cibles_ID" | nl -w1 -s" - "
    fi    

    # Compter les lignes wc
    nbdelignes=$(echo "$cibles_ID" | wc -l)

    
    # si plus de 1 ligne
    if [ "$nbdelignes" -gt 1 ]; then

        
        read -p "Choisissez un numéro (1-$nbdelignes) : " choix_ligne

        #pour valider le choixil faut
        #unnombre et
        #supérieur a 1 et
        # inférieur ou égal à $nbdeligne
        if [[ $choix_ligne =~ ^[0-9]+$ ]] && [ "$choix_ligne" -ge 1 ] && [ "$choix_ligne" -le "$nbdelignes" ]; then
        
            #afficher la ligne choisie mais pas $choixligne qui est un némero-> $cibles_ID
            #avec echo et l'envoye
            # dans un pipe pour traitementavec awk
            # découper format ip:name:user avec awk pour extraire IP et user et srtocker dans 2 variables différentes
             ip=$(echo "$cibles_ID" | awk -F':' "NR==$choix_ligne { print \$1 }")
            user=$(echo "$cibles_ID" | awk -F':' "NR==$choix_ligne { print \$3 }")


          

        else

            echo "Saisie incorrecte, retour au menu."
            read -n 1 -s -r -p "Appuyez sur une touche pour continuer..."
            
            continue 
        fi
            






    else  #si une seule ligne découper avec awk pour extraire IP et user et stocker dans 2 variables diofférentes

            ip=$(echo "$cibles_ID" | awk -F':' '{ print $1 }')
            user=$(echo "$cibles_ID" | awk -F':' '{ print $3 }')

      

           
    fi


    ######################################################################################################
    #Initialisation connexion SSH
    #####################################################################################################



# Envoi de admin_menu dans la commande
commande="$(printf '%q' "$(declare -f); admin_menu")"

# Connexion SSH au serveur
ssh -t "$user@$ip" "sudo bash -c $commande"
ssh_status=$?

if [ $ssh_status -eq 0 ]; then
    echo "Connexion SSH réussie. Récupération des logs..."

    # Récupérer le fichier log depuis /var/log/ du serveur vers le client
    scp "$user@$ip:/tmp/log_evt.log" "/var/log/script/log_evt_${ip}_$(date +%Y%m%d_%H%M%S).log"

    # Supprimer le fichier log sur le serveur
    ssh -t "$user@$ip" "sudo rm -f /tmp/log_evt.log"

    echo "Connection SSH terminée. À bientôt!"
    break
else
    echo "Échec de la connexion SSH."
    echo "Retour au menu..."
    continue
fi

    
   

done
