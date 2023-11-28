
#!/bin/bash


#sur machine server graylog
# Définir l'URL de l'archive
ARCHIVE_URL="https://github.com/AnonyMars/Tools/raw/main/SOC/Graylog/geocity_db/GeoLite2-City_20231124.tar.gz"

# Définir le chemin de destination
DEST_PATH="/etc/graylog/server/GeoLite2-City.mmdb"

# Télécharger l'archive
sudo wget "$ARCHIVE_URL" -O /tmp/GeoLite2-City.tar.gz

# Extraire le contenu de l'archive
sudo tar -xzf /tmp/GeoLite2-City.tar.gz -C /tmp

# Déplacer le fichier .mmdb dans le dossier de destination
sudo mv /tmp/GeoLite2-City_20231124/GeoLite2-City.mmdb "$DEST_PATH"

# Nettoyer les fichiers temporaires
sudo rm -rf /tmp/GeoLite2-City.tar.gz
sudo rm -rf /tmp/GeoLite2-City_*

# Afficher un message de confirmation
echo "Le fichier GeoLite2-City.mmdb a été extrait et déplacé vers $DEST_PATH"
