.PHONY: build run add-package sign-package update-repo

# Construit l'image Docker
build:
    docker-compose -f docker/docker-compose.yml build

# Lance le conteneur
run:
    docker-compose -f docker/docker-compose.yml up -d

# Ajoute un paquet au dépôt
add-package:
    docker exec apt-repo /usr/local/bin/add-package.sh /packages/new-htop.deb

# Signer un paquet au dépôt
sign-package:
    docker exec apt-repo /usr/local/bin/sign-package.sh /packages/new-htop.deb

# Met à jour le dépôt
update-repo:
    docker exec apt-repo /usr/local/bin/update-repo.sh