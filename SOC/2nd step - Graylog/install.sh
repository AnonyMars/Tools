sudo apt update && sudo apt upgrade
sudo apt install apt-transport-https uuid-runtime pwgen dirmngr gnupg wget -y

#INSTALLATION MONGODB, cette bdd stocke la config de Graylog, pas des logs en eux-mêmes
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl daemon-reload
sudo systemctl enable mongod.service
sudo systemctl restart mongod.service
sudo systemctl --type=service --state=active | grep mongod

wget https://packages.graylog2.org/repo/packages/graylog-5.2-repository_latest.deb
sudo dpkg -i graylog-5.2-repository_latest.deb
sudo apt-get update && sudo apt-get install graylog-server

#CONFIGURATION HTTPS GRAYLOG => WAZUH INDEXER
sudo mkdir /etc/graylog/server/certs
sudo cp -a /usr/share/graylog-server/jvm/lib/security/cacerts /etc/graylog/server/certs/cacerts
sudo cp /etc/wazuh-indexer/certs/root-ca.pem /etc/graylog/server/certs/root-ca.pem
sudo /usr/share/graylog-server/jvm/bin/keytool -importcert -keystore /etc/graylog/server/certs/cacerts -storepass changeit -alias root_ca -file /etc/graylog/server/certs/root-ca.pem


#COMMANDE DEBUG CERTIFICAT
#sudo openssl x509 -noout -in root-ca.pem -fingerprint -sha256
#sudo keytool -keystore /etc/graylog/server/certs/cacerts -storepass changeit -list | grep elasticsearch -A1



#Ajout de la CA dans la config de graylog
sudo vim /etc/default/graylog-server
#Commenter GRAYLOG_SERVER_JAVA_OPTS="$GRAYLOG_SERVER_JAVA_OPTS -Dlog4j2.formatMsgNoLookups=true"
#Et rajouter en dessous : 
#GRAYLOG_SERVER_JAVA_OPTS="$GRAYLOG_SERVER_JAVA_OPTS -Dlog4j2.formatMsgNoLookups=true -Djavax.net.ssl.trustStore=/etc/graylog/server/certs/cacerts -Djavax.net.ssl.trustStorePassword=changeit"

#Génération d'un password secret : 
sudo pwgen -N 1 -s 96
#  3VxwJFRmZdCQPtjkKUb3lFO7Ea6Hgv7ANKD4Kwxae5SoKYrSaiUdCD4BBpwo4WEuexGEau8FcmKnoBKDloPVn4XEJSw16CSc

#Rajout du secret à password_secret
sudo vim /etc/graylog/server/server.conf

#Rajout de l'interface web modifiée : 
#http_bind_address = 0.0.0.0:9000

#Rajout du HTTPS sur l'interface web de graylog
sudo cp /etc/wazuh-dashboard/certs/soc1* /etc/graylog/server/certs
sudo sed -i 's|^#http_enable_tls =.*|http_enable_tls = true|' /etc/graylog/server/server.conf
sudo sed -i 's|^#http_tls_cert_file =.*|http_tls_cert_file = /etc/graylog/server/certs/soc1.pem|' /etc/graylog/server/server.conf
sudo sed -i 's|^#http_tls_key_file =.*|http_tls_key_file = /etc/graylog/server/certs/soc1-key.pem|' /etc/graylog/server/server.conf
sudo chown -R graylog:graylog /etc/graylog/server/certs/
sudo chmod 600 /etc/graylog/server/certs/*

sudo keytool -importcert -keystore /etc/graylog/server/certs/cacerts -storepass changeit -alias graylog_self_signed -file /etc/graylog/server/certs/soc1.pem


#Génération de la signature sha2 du mdp root graylog
#Renseignez "password" comme valeur
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
#  5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8

#Sur Wazuh Dashboard, créer un internal_user "graylog" ( voir captures écrans dans dossier)
# mdp de graylog = Tikisoc_1
#Lui affecter le rôle admin dans la section "Backend roles - optional"


#Renseigner adresse wazuh-indexer dans conf
sed -i 's|#elasticsearch_hosts = http://node1:9200,http://user:password@node2:19200|elasticsearch_hosts = https://graylog:Tikisoc_1@192.168.0.235:9200|' /etc/graylog/server/server.conf

#Démarrage

sudo systemctl daemon-reload
sudo systemctl enable graylog-server
sudo systemctl start graylog-server
sudo systemctl --type=service --state=active | grep graylog

# se connecter à ip:9000 avec admin:password