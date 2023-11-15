#!/bin/bash

# Vérifiez que le script est exécuté en tant que root
if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root." 1>&2
   exit 1
fi

# Demandez le nouveau nom d'hôte
read -p "Entrez le nouveau nom de la machine : " new_hostname

# Change le nom de la machine
hostnamectl set-hostname $new_hostname

# Met à jour /etc/hosts sans toucher à l'entrée localhost
sed -i "/127.0.0.1\slocalhost/!s/127\.0\.0\.1\s.*/127.0.0.1\t$new_hostname/g" /etc/hosts

echo "Le nom de la machine a été changé en $new_hostname."

# Libère l'adresse IP actuelle et demande une nouvelle adresse au serveur DHCP
echo "Libération et renouvellement de l'adresse IP pour enp0s3..."
/usr/sbin/dhclient -r enp0s3
/usr/sbin/dhclient enp0s3

# Générer un nouvel UUID pour la machine
echo "Génération d'un nouvel identifiant unique de la machine (UUID)..."
if [ -f /etc/machine-id ]; then
    rm /etc/machine-id
    systemd-machine-id-setup
    echo "Un nouvel UUID a été généré."
else
    echo "Erreur : le fichier /etc/machine-id n'existe pas."
fi

echo "Le script a terminé ses tâches."
