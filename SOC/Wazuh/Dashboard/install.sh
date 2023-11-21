sudo apt-get install debhelper tar curl libcap2-bin -y
#Si vous n'avez pas déjà le repo Wazuh d'installé.

#sudo apt-get install gnupg apt-transport-https -y
#sudo curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
#sudo echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
#sudo apt-get update -y

sudo apt-get -y install wazuh-dashboard

#Téléchargement du fichier de config à modifier
#STANDALONE CONFIG FILE
sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/Wazuh/Indexer/Standalone_version/opensearch.yml -O /tmp/opensearch.yml

# Sauvegarder l'ancien fichier de configuration
sudo cp /etc/wazuh-indexer/opensearch.yml /etc/wazuh-indexer/opensearch.yml.backup

# Remplacer l'ancien fichier par le nouveau
sudo mv /tmp/opensearch.yml /etc/wazuh-indexer/opensearch.yml

NODE_NAME=<dashboard-node-name>