# Fichier : load-balancing/haproxy/webserver/Dockerfile
# Rôle    : image de démonstration nginxdemos/hello avec les paquets Alpine
#           mis à jour (l'image d'origine n'est plus reconstruite depuis 2025)
# Utilise : nginxdemos/hello (version 0.4 épinglée)
# Utilisé par : services webserver1 et webserver2 du compose.yaml

FROM nginxdemos/hello:0.4-plain-text

# Applique les correctifs de sécurité publiés par Alpine (OpenSSL, pcre2...)
# --no-cache : ne garde pas l'index des paquets dans l'image (plus légère)
RUN apk upgrade --no-cache
