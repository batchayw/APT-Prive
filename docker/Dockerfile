FROM debian:bullseye

# Désactivation du mode interactif pour debconf
ENV DEBIAN_FRONTEND=noninteractive

# Installation des dépendances nécessaires
RUN apt-get update && apt-get install -y \
    nginx \
    gnupg2 \
    dpkg-dev \
    apt-utils \
    reprepro \
    dpkg-sig \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copie des scripts shell (les fichiers ont été copiés dans le dossier docker via la CI)
COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

# Copie du fichier de configuration Nginx personnalisé
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose le port 80 pour Nginx
EXPOSE 80

# La commande de démarrage est définie via docker-compose (setup puis nginx)
CMD ["nginx", "-g", "daemon off;"]
