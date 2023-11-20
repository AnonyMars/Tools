wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install kibana

#Enrollment token pour sécuriser connexion Elastic et Kibana
bin/elasticsearch-create-enrollment-token -s kibana

#Garder token généré pour Kibana par Elastic =   eyJ2ZXIiOiI4LjExLjEiLCJhZHIiOlsiMTkyLjE2OC4wLjIzNTo5MjAwIl0sImZnciI6IjI4NzBhM2ExYzRjYjUyYmQzOWVkNGNiYmJkYTU1OWVjNmVlYTA4NTRjODg2YzJlZjA5MGY0MzI2NTVjYTU4NTMiLCJrZXkiOiJ4bGhwNDRzQjlrTVFQRnI5UnJIMDpDWENIeWVTQlEyLVd6TGhnVnpCdmF3In0=

sudo sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml

sudo systemctl restart kibana

#Garder le code Kibana pour première authentification
sudo /usr/share/kibana/bin/kibana-verification-code

#Se connecter à Kibana avec user "elastic et mdp d'elastic"

#Installation de l'intégration "File Integrity Monitoring"