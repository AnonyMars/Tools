sudo apt-get install debhelper tar curl libcap2-bin -y
#Si vous n'avez pas déjà le repo Wazuh d'installé.

#sudo apt-get install gnupg apt-transport-https -y
#sudo curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
#sudo echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
#sudo apt-get update -y

sudo apt-get -y install wazuh-dashboard

#Téléchargement du fichier de config à modifier
#STANDALONE CONFIG FILE
sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/Wazuh/Dashboard/etc/wazuh-dashboard/opensearch_dashboards.yml -O /tmp/opensearch_dashboards.yml

# Sauvegarder l'ancien fichier de configuration
sudo cp /etc/wazuh-dashboard/opensearch_dashboards.yml /etc/wazuh-dashboard/opensearch_dashboards.yml.backup

# Remplacer l'ancien fichier par le nouveau
sudo mv /tmp/opensearch_dashboards.yml /etc/wazuh-dashboard/opensearch_dashboards.yml

NODE_NAME=soc1

sudo mkdir /etc/wazuh-dashboard/certs
sudo tar -xf ./wazuh-certificates.tar -C /etc/wazuh-dashboard/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./root-ca.pem
sudo chmod 500 /etc/wazuh-dashboard/certs
sudo chmod 400 /etc/wazuh-dashboard/certs/*
sudo chown -R wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/certs

sudo systemctl daemon-reload
sudo systemctl enable wazuh-dashboard
sudo systemctl start wazuh-dashboard

sudo /usr/share/wazuh-indexer/plugins/opensearch-security/tools/wazuh-passwords-tool.sh --change-all 
.
#21/11/2023 18:32:06 INFO: The password for user admin is x+OHxFS61Jwj?U?i5xTwQQsSpc9OwRTI
#21/11/2023 18:32:06 INFO: The password for user kibanaserver is u4Vvo*IQjUh4MgS7cBN*Hf3K*UVfiQQ4

KIB_PASSWORD=u4Vvo*IQjUh4MgS7cBN*Hf3K*UVfiQQ4

echo $KIB_PASSWORD | /usr/share/wazuh-dashboard/bin/opensearch-dashboards-keystore --allow-root add -f --stdin opensearch.password

#Connectez vous à https:ip avec compte admin + mdp admin