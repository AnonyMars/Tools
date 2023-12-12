#!/bin/bash

# Fonction pour valider les adresses IP
validate_ip() {
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Configuration de fail2ban
echo "Configuration de fail2ban..."

# Installation de fail2ban
sudo apt install -y fail2ban

# Copie du fichier de configuration par défaut
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configuration de fail2ban
sudo sed -i 's/^bantime  = 10m/bantime  = 600/' /etc/fail2ban/jail.local
sudo sed -i 's/^maxretry = 5/maxretry = 3/' /etc/fail2ban/jail.local

# Liste blanche à partir d'un fichier
WHITELIST_FILE="./whitelist.txt"
if [ -f "$WHITELIST_FILE" ]; then
    if [ -s "$WHITELIST_FILE" ]; then
        echo "Ajout des adresses IP de la liste blanche..."
        while IFS= read -r ip
        do
            if validate_ip "$ip"; then
                sudo fail2ban-client set sshd addignoreip $ip
                echo "IP $ip ajoutée à la liste blanche."
            else
                echo "IP invalide détectée : $ip. Ignorée."
            fi
        done < "$WHITELIST_FILE"
    else
        echo "Fichier de liste blanche trouvé mais vide. Aucune IP ajoutée à la liste blanche."
    fi
else
    echo "Fichier de liste blanche non trouvé. Aucune IP ajoutée à la liste blanche."
fi

# Redémarrage de fail2ban
echo "Voulez-vous redémarrer fail2ban maintenant ? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo systemctl restart fail2ban
    echo "Fail2ban redémarré."
else
    echo "Redémarrage de fail2ban annulé."
fi
