#!/bin/bash

# Définir le mot de passe admin pour AWX
AWX_ADMIN_PASSWORD='your_admin_password' # Remplacez par le mot de passe souhaité

# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer les dépendances requises pour Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Ajouter le repository Docker à APT
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Mettre à jour les paquets après l'ajout du repository Docker
sudo apt update

# Installer Docker CE
sudo apt install -y docker-ce

# Installer Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Installer les dépendances supplémentaires requises pour AWX
sudo apt install -y python3-pip git gettext

# Installer Ansible via pip
sudo pip3 install ansible

# Cloner le dépôt AWX
cd /opt
sudo git clone https://github.com/ansible/awx.git

# Aller dans le dossier d'installation d'AWX
cd awx/installer/

# Configurer l'inventaire d'AWX avec sed
sed -i "s|admin_password=.*|admin_password=${AWX_ADMIN_PASSWORD}|" inventory

# Lancer l'installation d'AWX
ansible-playbook -i inventory install.yml

# Vérifier que les conteneurs Docker sont en cours d'exécution
sudo docker ps

# Afficher l'adresse IP et le port pour accéder à AWX
echo "AWX est maintenant installé. Accédez-y via http://$(hostname -I | awk '{print $1}'):80"
