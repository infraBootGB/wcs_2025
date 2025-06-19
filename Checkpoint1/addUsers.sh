#!/bin/bash


#fonction newaddUser
         

        # boucle for pour chaque  nom d'argument récupéré dans fichier txt awk 
        for $newuser1 etc...

        do 

            #doit vérifier si l'utilisateur existe dans le systeme
            [ if cat /etc/passwd | grep $newuser1 ]

        #si existant "L'utilisateur <nom_utilisateur> existe déjà" et le script continue boucle"
        then
        echo "L'utilisateur $newuser1 etc existe déjà"


        #sinon créerle nouvel utilisateur
        else
        sudo adduser $newuser1 etc

        done

        
        



#verifier que le script a des arguments sinon sortie 1
#"afficher "Il manque les noms d'utilisateurs en argument - Fin du script"

if [-z $# ]


    then

    echo "Il manque les noms d'utilisateurs en argument - Fin du script"
    exit 1

    else 

fi


#boucle while tant que les nouveaux utilisateurs indiqués en arguments ne sont pas dans etc/passwd
while ![cat /etc/passwd | grep $newuser]

do

    #récupérer les arguments du script avec $@  > fichier txt > découper les arguments avec awk
    
    # récupérer chaque argument du fichier txt pour créer variable $newuser pour chaque argument $1 $2 etc..


    #  appel fonction newadduser
    #(résultat de la fonction)


    #vérification création utilisateur pour chaque newsuser
    #si oui "L'utilisateur <nom_utilisateur> a été crée"
    #si oui "L'utilisateur <nom_utilisateur> a été crée"
    #si non "Erreur à la création de l'utilisateur <nom_utilisateur>"

    if cat /etc/passwd | grep $newuser
    echo "L'utilisateur $newuser été crée"

    else 
    echo "Erreur à la création de l'utilisateur $newuser"

done
# le script continue




