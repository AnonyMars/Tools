#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Ask for the new hostname
read -p "Enter the new hostname for the machine: " new_hostname

# Change the hostname of the machine
hostnamectl set-hostname $new_hostname

# Update /etc/hosts without touching the localhost entry
sed -i "s/127\.0\.1\.1\s.*/127.0.1.1\t$new_hostname/g" /etc/hosts

echo "The machine's hostname has been changed to $new_hostname."

# Release the current IP address and request a new one from the DHCP server
echo "Releasing and renewing the IP address for enp0s3..."
/usr/sbin/dhclient -r enp0s3
/usr/sbin/dhclient enp0s3

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
