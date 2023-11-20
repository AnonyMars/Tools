#Requis pour avoir des métriques sur les noeuds du cluster ELK
sudo curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.11.1-amd64.deb
sudo dpkg -i metricbeat-8.11.1-amd64.deb

#Création d'un keystore pour créer un secret qui contient le mdp d'elastic
#Cela évite d'écrire en dur le mdp dans la configuration de metricbeat
sudo metricbeat keystore create
sudo metricbeat keystore add ES_PWD

#Obtenir la signature CA
sudo openssl x509 -fingerprint -sha256 -noout -in /etc/elasticsearch/certs/http_ca.crt | awk -F "=" '{print $2}' | sed 's/://g'
echo "2870A3A1C4CB52BD39ED4CBBBDA559EC6EEA0854C886C2EF090F432655CA5853"

# Définissez le chemin du fichier de configuration ici
CONFIG_FILE="/etc/metricbeat/metricbeat.yml"

# Obtenez le fingerprint du certificat
FINGERPRINT=$(sudo openssl x509 -fingerprint -sha256 -noout -in /etc/elasticsearch/certs/http_ca.crt | awk -F "=" '{print $2}' | sed 's/://g')

# Vérifiez que nous avons bien récupéré le fingerprint
if [ -z "$FINGERPRINT" ]; then
    echo "Le fingerprint n'a pas pu être récupéré."
    exit 1
fi

# Décommentez et modifiez les lignes nécessaires
sudo sed -i 's/#protocol: "https"/protocol: "https"/' $CONFIG_FILE
sudo sed -i 's/#username: "elastic"/username: "elastic"/' $CONFIG_FILE
sudo sed -i 's/#password: "changeme"/password: ${ES_PWD}/' $CONFIG_FILE

# Ajoutez le bloc SSL après le mot de passe
sudo sed -i "/password: \"\${ES_PWD}\"/a \  ssl:\n    enabled: true\n    ca_trusted_fingerprint: \"$FINGERPRINT\"" $CONFIG_FILE

# Affichez un message ou le nouveau contenu du fichier pour vérifier
echo "Modifications apportées avec succès."
sudo grep -A 15 'output.elasticsearch:' $CONFIG_FILE

metricbeat modules enable elasticsearch-xpack


metricbeat setup -e








