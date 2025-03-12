#!/bin/bash
set -e

# Vérifie qu'un paquet est bien passé en argument
if [ -z "$1" ]; then
    echo "Erreur : Aucun paquet spécifié."
    exit 1
fi

# Configure GPG en mode non interactif
export GPG_TTY=$(tty)
export GNUPGHOME=/root/.gnupg
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Vérifie si le paquet existe déjà dans le dépôt
PACKAGE_NAME=$(basename "$1")
if reprepro -b /var/www/html/apt-repo list william | grep -q "$PACKAGE_NAME"; then
    echo "Le paquet $PACKAGE_NAME existe déjà dans le dépôt."
    exit 1
fi

# Ajout du paquet .deb au dépôt APT
reprepro -b /var/www/html/apt-repo includedeb william "$1"
