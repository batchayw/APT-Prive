#!/bin/bash
set -e

# Configure GPG en mode non interactif
export GPG_TTY=$(tty)
export GNUPGHOME=/root/.gnupg
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Vérifie que le fichier de configuration du dépôt existe
if [ ! -f "/var/www/html/apt-repo/conf/distributions" ]; then
    echo "Erreur: Le fichier de configuration du dépôt n'existe pas."
    exit 1
fi

# Vérifie que le fichier 'updates' existe
if [ ! -f "/var/www/html/apt-repo/conf/updates" ]; then
    echo "Erreur: Le fichier de configuration 'updates' n'existe pas."
    exit 1
fi

# Mise à jour du dépôt APT
reprepro -b /var/www/html/apt-repo update
