#!/bin/bash



# WARNING : REQUIRE ON VM Devices > Insert Additional Guest Image Disk enabled on vm 
# check the dsk image on vb interface on your vm


# Check if the script is run with superuser privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with administrator rights."
    exit 1
fi

# Mounting point for the CD-ROM
MOUNT_DIR="/media/cdrom"

# Unmount the CD-ROM if it is already mounted
if mountpoint -q -- "${MOUNT_DIR}"; then
    umount "${MOUNT_DIR}"
    echo "CD-ROM successfully unmounted."
fi

# Create a mounting point for the CD-ROM if needed
mkdir -p "${MOUNT_DIR}"

# Mount the CD-ROM
mount /dev/sr0 "${MOUNT_DIR}" 2>/dev/null

# Verify that the mount was successful
if mountpoint -q -- "${MOUNT_DIR}"; then
    echo "CD-ROM mounted successfully."
else
    echo "Error mounting CD-ROM."
    exit 1
fi

# Install the Guest Additions
echo "Installing VirtualBox Guest Additions..."
"${MOUNT_DIR}/VBoxLinuxAdditions.run"

# Cleanup after installation
umount "${MOUNT_DIR}"
echo "VirtualBox Guest Additions were installed successfully."

# Recommended restart
read -p "It is recommended to restart your system. Would you like to restart now? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    shutdown -r now
fi
