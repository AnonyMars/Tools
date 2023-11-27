sudo apt-get install gnupg apt-transport-https
sudo apt install curl -y
sudo curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && sudo chmod 644 /usr/share/keyrings/wazuh.gpg

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

sudo echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee -a /etc/apt/sources.list.d/wazuh.list
sudo apt-get update
sudo apt-get -y install wazuh-manager

sudo systemctl daemon-reload
sudo systemctl enable wazuh-manager
sudo systemctl start wazuh-manager

sudo systemctl status wazuh-manager

#AJOUT AUTHENTIFICATION AGENT au MANAGER
#Passer use_password à yes "<use_password>yes</use_password>"
vim /var/ossec/etc/ossec.conf

echo "password_wazuh" > /var/ossec/etc/authd.pass

chmod 640 /var/ossec/etc/authd.pass
chown root:wazuh /var/ossec/etc/authd.pass

#Activation vulnerability detector et debian vuln
#<vulnerability-detector>
#<enabled>yes</enabled>
#ET
#Debian OS vulnerabilities
#<provider name="debian"
#       <enabled>yes</enabled>
vim /var/ossec/etc/ossec.conf

#Activation de l'archivage
#Passer à yes les valeurs avec des flèches
<ossec_config>
  <global>
    <jsonout_output>yes</jsonout_output>
    <alerts_log>yes</alerts_log>
    <logall>yes</logall> <======
    <logall_json>yes</logall_json> <======
</ossec_config>

#WAZUH RULES CUSTOM
sudo apt install git -y
sudo curl -so ~/wazuh_rules.sh https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/Wazuh/Manager/wazuh_rules.sh && sudo bash ~/wazuh_socfortress_rules.sh

#Créer l'index d'archivages en l'appelant wazuh-archives-*

#sur l'interface web du wazuh dashboard : Stack management > Index patterns > Create index pattern
#ATTENTION sélectionner "timestamp" et pas "@timestamp" dans la liste

#SUIVRE SUR FICHIER INSTALLATION FILEBEAT

