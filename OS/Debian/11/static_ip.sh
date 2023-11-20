#!/bin/bash

# Les valeurs doivent être remplacées par les valeurs réelles que vous souhaitez configurer
IP_ADDRESS="192.168.1.100"
IP_GATEWAY="192.168.1.1"
INTERFACE="enp0s3"

# Créez une sauvegarde du fichier interfaces actuel
sudo cp /etc/network/interfaces /etc/network/interfaces.backup

# Écrivez la nouvelle configuration statique dans le fichier interfaces
sudo bash -c "cat > /etc/network/interfaces <<EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto $INTERFACE
iface $INTERFACE inet static
    address $IP_ADDRESS
    netmask 255.255.255.0
    gateway $IP_GATEWAY
EOF"


sudo systemctl restart networking

# Afficher la nouvelle configuration IP
ip addr show $INTERFACE