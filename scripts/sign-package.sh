#!/bin/bash
set -e

# Configure GPG en mode non interactif
export GPG_TTY=$(tty)
export GNUPGHOME=/root/.gnupg
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Vérifie que le paquet existe
if [ ! -f "$1" ]; then
    echo "Erreur: Le paquet $1 n'existe pas."
    exit 1
fi

# Affiche les clés importées pour vérification
gpg --list-keys --keyid-format LONG

# Récupére l'ID de la clé GPG
KEY_ID=$(gpg --list-keys --keyid-format LONG | grep '^pub' | head -n1 | awk -F'/' '{print $2}' | awk '{print $1}')
if [ -z "$KEY_ID" ]; then
    echo "Erreur: Aucune clé GPG trouvée."
    exit 1
fi

# Signature du paquet .deb avec dpkg-sig
dpkg-sig -k "$KEY_ID" --sign builder "$1"
