#!/bin/bash

# Génération de la paire de clés SSH
echo "Étape 1: Génération de la paire de clés SSH"
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Génération d'une nouvelle paire de clés SSH..."
    ssh-keygen -t rsa -b 4096
    echo "Paire de clés SSH générée."
else
    echo "Une paire de clés SSH existe déjà."
fi

# Installation de la clé publique
echo "Étape 2: Installation de la clé publique"
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
fi
if [ ! -f ~/.ssh/authorized_keys ]; then
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
echo "Clé publique ajoutée au fichier authorized_keys."

# Désactivation de l'authentification par mot de passe
echo "Étape 3: Désactivation de l'authentification par mot de passe"
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
echo "Configurations de sécurité mises à jour dans sshd_config."

# Changement du port SSH par défaut
echo "Étape 4: Changement du port SSH par défaut"
sudo sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
echo "Port SSH changé en 2222."

# Redémarrage du service SSH
echo "Étape 5: Redémarrage du service SSH"
sudo systemctl restart sshd
echo "Service SSH redémarré."

# Configuration du pare-feu avec ufw
echo "Étape 6: Configuration du pare-feu avec ufw"
sudo apt install -y ufw
sudo ufw allow 2222/tcp
sudo ufw enable
echo "Pare-feu ufw configuré et activé."


