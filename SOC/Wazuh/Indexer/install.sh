sudo apt install curl -y

sudo curl -sO https://packages.wazuh.com/4.3/wazuh-certs-tool.sh
sudo curl -sO https://packages.wazuh.com/4.3/config.yml

#ATTENTION : Modifier fichier config.yml avec ip adéquate.

sudo bash ./wazuh-certs-tool.sh -A

sudo tar -cvf ./wazuh-certificates.tar -C ./wazuh-certificates/ .
sudo rm -rf ./wazuh-certificates



#Copier coller wazuh-install-files.tar sur les machines qui auront Wazuh Manager ou Wazuh Indexer
#Ici je transfers l'archive tar vers ma seconde machine où sera installé wazuh manager sur la .236

sudo scp wazuh-certificates.tar soc@192.168.0.236:/home/soc/

sudo apt-get install debconf adduser procps -y
sudo apt-get install gnupg apt-transport-https -y
sudo curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
sudo apt-get update

sudo apt-get -y install wazuh-indexer=4.3.11-1

#Télécharger le fichier opensearch.yml et modifier fichier avec vos valeurs

#Intégration certificats :

NODE_NAME=soc1


sudo mkdir /etc/wazuh-indexer/certs
sudo tar -xf ./wazuh-certificates.tar -C /etc/wazuh-indexer/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./admin.pem ./admin-key.pem ./root-ca.pem
sudo chmod 500 /etc/wazuh-indexer/certs
sudo chmod 400 /etc/wazuh-indexer/certs/*
sudo chown -R wazuh-indexer:wazuh-indexer /etc/wazuh-indexer/certs

# Télécharger le fichier modifié depuis GitHub
#STANDALONE CONFIG FILE
sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/Wazuh/Indexer/Standalone_version/opensearch.yml -O /tmp/opensearch.yml

# Sauvegarder l'ancien fichier de configuration
sudo cp /etc/wazuh-indexer/opensearch.yml /etc/wazuh-indexer/opensearch.yml.backup

# Remplacer l'ancien fichier par le nouveau
sudo mv /tmp/opensearch.yml /etc/wazuh-indexer/opensearch.yml

#Modification de la limitation des ressources system
sudo cp /usr/lib/systemd/system/wazuh-indexer.service /usr/lib/systemd/system/wazuh-indexer.service.backup
sudo sed -i '/\[Service\]/a LimitMEMLOCK=infinity' /usr/lib/systemd/system/wazuh-indexer.service

sudo cp /etc/wazuh-indexer/jvm.options /etc/wazuh-indexer/jvm.options.backup
sudo sed -i 's/-Xms1g/-Xms4g/' /etc/wazuh-indexer/jvm.options
sudo sed -i 's/-Xmx1g/-Xmx4g/' /etc/wazuh-indexer/jvm.options



systemctl daemon-reload
systemctl enable wazuh-indexer
systemctl start wazuh-indexer

echo 'export PATH="/usr/sbin:$PATH"' >> ~/.bashrc && source ~/.bashrc


/usr/share/wazuh-indexer/bin/indexer-security-init.sh

sudo apt install -y net-tools

sudo netstat -laputen |grep :9

