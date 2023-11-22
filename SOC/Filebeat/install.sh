sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get install apt-transport-https

sudo echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install filebeat -y





sudo wget https://github.com/AnonyMars/Tools/raw/main/SOC/Filebeat/filebeat-oss-7.10.2-amd64.deb

sudo sudo apt install ./filebeat-oss-7.10.2-amd64.deb

sudo systemctl enable filebeat

sudo curl -so /etc/filebeat/filebeat.yml https://packages.wazuh.com/4.6/tpl/wazuh/filebeat/filebeat.yml

#Rajouter une ligne dans le /etc/hosts de soc2 pour résoudre soc1 qui est le wazuh indexer
#127.0.0.1       localhost
#127.0.0.1       soc2
#192.168.0.235 soc1 <===

vim /etc/hosts

#Télécharger le fichier filebeat.yml custom
wget 

filebeat keystore create

#Créer des secrets pour les variables username et password
echo admin | filebeat keystore add username --stdin --force
echo x+OHxFS61Jwj?U?i5xTwQQsSpc9OwRTI | filebeat keystore add password --stdin --force

#Téléchargement template custom wazuh pour le wazuh indexer
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v4.6.0/extensions/elasticsearch/7.x/wazuh-template.json
chmod go+r /etc/filebeat/wazuh-template.json

#Installation module wazuh pour filebeat
curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.2.tar.gz | tar -xvz -C /usr/share/filebeat/module

#Déploiement des certificats d'authentification au Wazuh Indexer crée précédemment
NODE_NAME=soc1


#ATTENTION cette étape requiert d'avoir l'archive wazuh-certificates.tar générée précédemment
mkdir /etc/filebeat/certs
tar -xf ./wazuh-certificates.tar -C /etc/filebeat/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./root-ca.pem
chmod 500 /etc/filebeat/certs
chmod 400 /etc/filebeat/certs/*
chown -R root:root /etc/filebeat/certs

systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat

filebeat test output