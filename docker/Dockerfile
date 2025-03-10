# Utilise une image de base Ubuntu 20.04, vous pouvez utiliser d'autre comme debian, centos, etc.
FROM ubuntu:20.04

# Installe les dépendances nécessaires : Nginx, GPG, dpkg-dev, etc.
RUN apt-get update && apt-get install -y \
    nginx \
    gnupg2 \
    dpkg-dev \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Copie les scripts shell dans le conteneur
COPY scripts/setup-repo.sh /usr/local/bin/setup-repo.sh
COPY scripts/add-package.sh /usr/local/bin/add-package.sh
COPY scripts/sign-package.sh /usr/local/bin/sign-package.sh
COPY scripts/update-repo.sh /usr/local/bin/update-repo.sh

# Rend les scripts exécutables
RUN chmod +x /usr/local/bin/*.sh

# Expose le port 80 pour Nginx
EXPOSE 80

# Démarre Nginx au lancement du conteneur
CMD ["nginx", "-g", "daemon off;"]