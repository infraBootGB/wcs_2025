
#### Contenu du journal de log

- Afficher le contenu

        cat /var/log/apache2/access.log

- Lecture du contenu

        192.168.1.149 - - [07/Jun/2025:12:31:38 +0000] "GET / HTTP/1.1" 200 10926 "-" "curl/8.5.0"

    - Connexion depuis 192.168.1.149 le 7 Juin 2025 à 12H31 via une requête GET en http sur la page d'accueil du serveur.

    - Le code 200 indique connexion réussie

    - 10926 le nomnbre d'octets envoyés

    - curl 8.5 et l'outils utilisé pour générer la requête.


