#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Ask for the new hostname
read -p "Enter the new hostname for the machine: " new_hostname

# Change the hostname of the machine
sudo hostnamectl set-hostname $new_hostname

# Release the current IP address and request a new one from the DHCP server
sudo echo "Releasing and renewing the IP address for enp0s3..."
sudo /usr/sbin/dhclient -r enp0s3
sudo /usr/sbin/dhclient enp0s3

# Get the current IP address of enp0s3
current_ip=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Update /etc/hosts to include the new hostname with the current IP address of enp0s3
sudo sed -i "/^127\.0\.0\.1\slocalhost.*/a $current_ip\t$new_hostname" /etc/hosts

echo "The machine's hostname has been changed to $new_hostname."

# Generate a new UUID for the machine
echo "Generating a new unique identifier for the machine (UUID)..."
if [ -f /etc/machine-id ]; then
    rm /etc/machine-id
    systemd-machine-id-setup
    echo "A new UUID has been generated."
else
    echo "Error: The file /etc/machine-id does not exist."
fi

echo "The script has completed its tasks."
echo "System rebooting..."
systemctl reboot
