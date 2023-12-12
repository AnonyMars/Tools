# Télécharger le script
wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/Packetbeat/packebeat.sh -O packetbeat.sh

# Rendre le script exécutable
chmod +x packetbeat.sh

# Exécuter le script
./packetbeat.sh

#Rajouter l'écoute du dossier packetbeat à la config des agents linux sur l'interface du wazuh-manager
<localfile>
<log_format>json</log_format>
<location>/tmp/packetbeat/packetbeat</location>
</localfile>

sudo systemctl daemon-reload
sudo systemctl enable packetbeat
sudo systemctl start packetbeat