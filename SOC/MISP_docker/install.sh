sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo git clone https://github.com/coolacid/docker-misp
cd docker-misp
sudo vim docker-compose.yml

#Changer config .env à partir du .env sur github
#environment:
#      - "BASEURL=https://192.168.0.238"

#Rajouter  ==>   "restart: always"   <==  à toutes les images

#Génération certificat auto-signé
#ATTENTION, changez CN et subjcetaltname par l'IP de votre misp

cd ssl
sudo mdkir test
#on déplace les anciens certificats auto-signés pour du local host car ils poseront problème pour la communication au MISP
mv cert.pem test/
mv dhparams.pem test/
mv key.pem test/

#Génération nouveaux certificats directement dans répertoire qui sera monté pour le docker compose
sudo openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -nodes -subj "/CN=192.168.0.238" -extensions v3_ca -config <(cat /etc/ssl/openssl.cnf <(printf "[v3_ca]\nsubjectAltName=IP:192.168.0.238"))

#Upload du certificat misp vers la machine avec graylog
scp cert.pem soc@192.168.0.235:/home/soc/cert.pem

#ATTENTION ===> ACTION A REALISER SUR MACHINE GRAYLOG
 ===> sudo mv /home/soc/cert.pem /etc/graylog/server/certs
 ===> sudo /usr/share/graylog-server/jvm/bin/keytool -importcert -keystore /etc/graylog/server/certs/cacerts -storepass changeit -alias self_signed_misp_192.168.0.238 -file /etc/graylog/server/certs/cert.pem
 ===> sudo systemctl restart graylog-server



sudo docker compose up -d

#se connecter interface web ip

#User: admin@admin.test
#Password: admin

#changer mdp : Tikisocmisp_1

#Importer feed misp sur interface web
https://192.168.0.238/feeds/importFeeds 

https://github.com/MISP/MISP/blob/2.4/app/files/feed-metadata/defaults.json

#Activer tous les feeds avec la checkbox 
#ATTENTION : LE FAIRE SUR TOUTES LES PAGES

#Activer "Fetch and store all feed data" 

#vérifier le download dans https://192.168.0.238/jobs/index
#Attentionn filtrer par "job type" 

#================== update les feeds=========#

#Ajouter une nouvelle clé pour authentifier l'appel à l'API qui va update les feeds
https://192.168.0.238/auth_keys/index
#allowed ip : 0.0.0.0/0
#api key :  AQUrZlwcDOKhA9tpAuwH5K44s6oAiTpFvOGIuxki

#Créer une tâche cron pour  :
# Sync MISP feed daily
crontab -e

0 1 * * * /usr/bin/curl -XPOST --insecure --header "Authorization: AQUrZlwcDOKhA9tpAuwH5K44s6oAiTpFvOGIuxki" --header "Accept: application/json" --header "Content-Type: application/json" https://192.168.0.238/feeds/fetchFromAllFeeds
