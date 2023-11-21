sudo apt install curl -y

sudo curl -sO https://packages.wazuh.com/4.6/wazuh-certs-tool.sh
sudo curl -sO https://packages.wazuh.com/4.6/config.yml

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

sudo apt-get -y install wazuh-indexer

#Télécharger le fichier opensearch.yml et modifier fichier avec vos valeurs

#Intégration certificats :

NODE_NAME=soc1


mkdir /etc/wazuh-indexer/certs
tar -xf ./wazuh-certificates.tar -C /etc/wazuh-indexer/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./admin.pem ./admin-key.pem ./root-ca.pem
chmod 500 /etc/wazuh-indexer/certs
chmod 400 /etc/wazuh-indexer/certs/*
chown -R wazuh-indexer:wazuh-indexer /etc/wazuh-indexer/certs