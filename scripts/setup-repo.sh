#!/bin/bash
set -e

# Configure GPG en mode non interactif
export GPG_TTY=$(tty)
export GNUPGHOME=/root/.gnupg
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Création de la structure du dépôt APT
mkdir -p /var/www/html/apt-repo/{conf,db,incoming}

# Création initiale du fichier de configuration des distributions (temporaire)
cat <<EOF > /var/www/html/apt-repo/conf/distributions
Codename: william
Components: main
Architectures: amd64
SignWith: 7BEE699ED62CBB43  # Remplacez par l'ID de votre clé GPG initial
EOF

# Importe les clés GPG privée et publique
gpg --import /gpg/private.key
gpg --import /gpg/public.key

# Affiche les clés importées (pour debug)
gpg --list-keys --keyid-format LONG

# Récupération de l'ID de la clé GPG avec un regex
KEY_ID=$(gpg --list-keys --keyid-format LONG | grep '^pub' | head -n1 | awk -F'/' '{print $2}' | awk '{print $1}')
if [ -z "$KEY_ID" ]; then
    echo "Erreur: Aucune clé GPG trouvée."
    exit 1
fi

# Réécriture du fichier de configuration avec le bon ID
cat <<EOF > /var/www/html/apt-repo/conf/distributions
Codename: william
Components: main
Architectures: amd64
SignWith: $KEY_ID
Update: william-updates
EOF

# Création du fichier de configuration des mises à jour
cat <<EOF > /var/www/html/apt-repo/conf/updates
Name: william-updates
Method: file:///var/www/html/apt-repo
Suite: william
Components: main
Architectures: amd64
VerifyRelease: $KEY_ID  # Remplacez par l'ID de votre clé GPG
EOF