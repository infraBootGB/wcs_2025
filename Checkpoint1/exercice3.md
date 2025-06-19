1. Donne une ligne de commande bash qui permet de lister la liste des utilisateurs d'un système Linux

        cat /etc/passwd

2. Quelle commande bash permet de changer les droits du fichier myfile en rwxr—r-- ?

        chmod 744

3. Comment faire pour que les fichiers pdf d'un dépôt local git ne soient pas pris en compte lors d'un git push ?

        Utiliser le fichier .gitignore

4. Quelles commandes git utiliser pour fusionner les branches main et test_valide ?

        git-merge nom_de_la_branche
        git push origin main


5. Donne la(les) ligne(s) de commande(s) bash pour afficher le texte suivant :
Malgré le prix élevé de 100$, il a dit "Bonjour !" au vendeur :
- "Bonjour est-ce que ce clavier fonctionne bien ?"
- "Evidemment ! On peut tout écrire avec, que ce soit des pipe | ou bien des backslash \\ !"
- "Même des tildes ~ ?"
- "Evidemment !"

        echo "Malgré le prix élevé de 100$, il a dit    "Bonjour !" au vendeur :
        - "Bonjour est-ce que ce clavier fonctionne bien ?"
        - "Evidemment ! On peut tout écrire avec, que ce soit   des pipe | ou bien des backslash \\ !"
        - "Même des tildes ~ ?"
        - "Evidemment !""



6. La commande jobs -l donne le résultat ci-dessous :
wilder@Ubuntu:~$ jobs -l
[1]  37970 En cours d'exécution   gedit &
[2]  37971 En cours d'exécution   xeyes &
[3]- 37972 En cours d'exécution   sleep
Quelle commande te permet de mettre en avant le processus gedit ?

        La commande  bg


7. Quels matériels réseaux sont sur la couche 2 et la couche 3 du modèle OSI ? Donne leurs spécificités.

        COUCHE 2 --> switch : sépare les réseau
        Coucge 3 --> routeur : permet aux hotes du réseau local  d'avoir accès aux autres réseaux.


8. Quels sont les équivalent PowerShell des commandes bash cd, cp, mkdir, ls.

        cd = Get-Location   
        cp = Copy-Item
        mkdir = mkdir
        ls = Get-Content



9. Dans la trame ethernet, qu'est-ce que le payload ?

        La charge utile

10. Pourquoi les classes IP sont remplacées par le CIDR ?

        Cela permet d'économiser des adresses 
        IP.
