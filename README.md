# APT-Privé
Installation d'un dépôt APT privé sur votre serveur (Ngnix, etc.)

## Objectif:
Ce projet permet d'héberger des paquets APT privés avec une signature GPG pour sécuriser le dépôt. Il est automatisé avec Docker, des scripts shell, Python et Go, et est mis à disposition via Nginx. Un pipeline CI/CD est également configuré avec GitHub Actions.

## Requis:
- Git
- Docker & Docker Compose
- Golang
- le paquet `.deb` à ajouter et placer dans `/packages`
- GPG pour générer votre `KEY_ID`

## Installation:

1. Clonez ce dépôt.
```bash
git clone git@github.com:batchayw/APT-Prive.git
cd APT-Prive
```

2. Configurez vos clés GPG dans le dossier `gpg/`.
    - Exporter la clé privée (Cela crée un fichier `private.key` dans le dossier `gpg/`):
    ```bash
    gpg --export-secret-keys -a VOTRE_EMAIL > gpg/private.key
    ```
    - Exporter la clé publique (Cela crée un fichier `public.key` dans le dossier `gpg/`):
    ```bash
    gpg --export -a VOTRE_EMAIL > gpg/public.key
    ```
    ***NB:*** *Remplacez `VOTRE_EMAIL` par l'adresse e-mail associée à votre clé GPG* 

3. Construisez et lancez les conteneurs Docker:
```bash
docker-compose -f docker/docker-compose.yml build
docker-compose -f docker/docker-compose.yml up -d
```
où
```bash
make build
make run
```

4. Ajoutez des paquets au dépôt avec:
```bash
docker exec apt-repo /usr/local/bin/add-package.sh /packages/new-htop.deb
```
où
```bash
make add-package
```

5. Mettez à jour le dépôt avec:
```bash
docker exec apt-repo /usr/local/bin/update-repo.sh
```
où
```bash
make update-repo
```

### Autre
L'autre moyen d'installer l'APT-Privé est d'utiliser un `Makefile`.
```Makefile
.PHONY: build run add-package sign-package update-repo

build:
    docker-compose -f docker/docker-compose.yml build

run:
    docker-compose -f docker/docker-compose.yml up -d

add-package:
    docker exec apt-repo /usr/local/bin/add-package.sh /packages/new-htop.deb

sign-package:
    docker exec apt-repo /usr/local/bin/sign-package.sh /packages/new-htop.deb

update-repo:
    docker exec apt-repo /usr/local/bin/update-repo.sh
```

## Attention:
- Vous devez remplacer dans tout le code `YOUR_GPG_KEY_ID` par l'ID de votre clé GPG. 
    - Pour obtenir l'ID de votre clé GPG (`YOUR_GPG_KEY_ID`) suivez les étapes suivantes:
        ```bash
        gpg --list-keys --keyid-format LONG
        ```
    - Cela affichera une sortie similaire à:
        ```txt
        ... key:2B39F051F1CEE171 ...
        pub   rsa1024/53047F18E2437881BA96F7D62B39F051F1CEE171 2023-10-01 [SC] [expires: 2025-10-01]
        uid                 [ultimate] Votre Nom <votre@email.com>
        sub   rsa1024/53047F18E2437881BA96F7D62B39F051F1CEE171 2023-10-01 [E] [expires: 2025-10-01]
        ```
    - L'ID de votre clé GPG est la partie après `rsa1024/` dans la ligne pub.
        - Dans cet exemple, l'ID est `2B39F051F1CEE171`.

- Si vous n'avez pas encore de clés GPG, vous pouvez en générer une nouvelle paire (publique et privée) avec la commande suivante:
    ```bash
    gpg --full-generate-key
    ```
    - Choisissez le type de clé: `RSA and RSA` (par défaut).
    - Taille de la clé: `1024` (le recommandé est `4096`).
    - Durée de validité: choisissez une durée (par exemple, `2y` pour 2 ans).
    - Entrez votre `nom` et votre adresse `e-mail`.
    - Protégez votre clé avec une passphrase `vide` (mais vous pouvez définir un mot de passe).

- Si vous voulez signer un paquet (action optionnel):
    ```bash
    docker exec apt-repo /usr/local/bin/sign-package.sh /packages/new-htop.deb
    ```
    où
    ```bash
    umake sign-package
    ```

## Problèmes possible:

- Si vous rencontrer des problèmes lier aux paquets, ceci est du au fait que certains outils comme reprepro ne supportent pas certains formats de compression pour le fichier de contrôle (exemple: `xz`, `zst`, `gz`, ...). 
    Pour resoudre cela vous pouvez utiliser les deux approches suivantes:
    1. **Recompiler/Reconditionner le paquet avec une compression compatible**
    ```bash
    dpkg-deb --build --control-compression=gzip <répertoire_du_paquet> <nom_paquet>.deb
    ```
    2. **Reconditionner le paquet existant en convertissant le format du fichier de contrôle**
        - Extraire le contenu du paquet:
        ```bash
        mkdir temp && cd temp
        ar x ../<nom_paquet>.deb
        ```
        - Extraire les fichiers de contrôle:
        ```bash
        mkdir control_files
        tar -xf control.tar.xz -C control_files
        ```
        - Recréer le fichier de contrôle avec gzip:
        ```bash
        tar -czf control.tar.gz -C control_files .
        ```
        - Reconstituer le paquet Debian avec le nouveau fichier de contrôle:
        ```bash
        ar r new-htop.deb debian-binary control.tar.gz data.tar.xz
        ```

## Utilisation:
Accédez à votre dépôt APT privé via `http://localhost:8080`.

## Pipeline CI/CD
Le pipeline CI/CD est configuré avec GitHub Actions. Il se déclenche automatiquement lors d'un `git push` sur la branche `main`.

## Licence
Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.
