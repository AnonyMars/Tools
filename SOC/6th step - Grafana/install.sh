sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key

echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install grafana -y

#copie des certificats wazuh pour les utiliser pour le chiffrement HTTPS lors de la connexion à grafana
sudo mkdir /etc/grafana/certs
sudo cp /etc/wazuh-dashboard/certs/soc1* /etc/grafana/certs
sudo chown -R grafana:grafana /etc/grafana/certs
sudo chmod 400 /etc/grafana/certs/*

#décommenter ;protocol dans le fichier /etc/grafana/grafana.ini
===> protocol = https

#décommenter ;cert_file et ;certkey et faites les pointer vers les certificats dans /etc/ssl/priate copiés précédemment# https certs & key file
===> cert_file = /etc/grafana/certs/soc1.pem
===> cert_key = /etc/grafana/certs/soc1-key.pem



sudo systemctl start grafana-server
sudo systemctl enable grafana-server

sudo grafana-cli plugins install netsage-sankey-panel
sudo grafana-cli plugins install grafana-worldmap-panel

#Aller sur https://votreip:3000
#login : admin
#password: admin
#Remplacer par "grafanasoc1"

#Sur Wazuh Dashboard, créer un internal_user "grafana_role" ( voir les images dans le dossier)
#https://votreipindexer/app/security-dashboards-plugin#/roles
#password compte grafana "P@sswordgrafa_1"