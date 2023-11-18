sudo apt install gpg -y

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install elasticsearch

export ELASTIC_PASSWORD="GxlWfp8eWF8e3F-Z6YlU"

sudo vim /etc/elasticsearch/elasticsearch.yml

#Permettre la création automatique d'indices de système
#Shift + inser
action.auto_create_index: .monitoring*,.watches,.triggered_watches,.watcher-history*,.ml*

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

#Activer journalisation dans systemctl
sudo sed -i '/ExecStart/s/ --quiet//' /etc/systemd/system/multi-user.target.wants/elasticsearch.service

sudo systemctl restart elasticsearch

sudo apt install curl -y

curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200 

#CONFIGURATION 


sudo cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.backup
sudo cp /etc/default/elasticsearch /etc/default/elasticsearch.backup

sudo chown -R root:elasticsearch /etc/elasticsearch
sudo chmod -R 750 /etc/elasticsearch
sudo find /etc/elasticsearch -type d -exec chmod g+s {} \;

echo 'ES_JAVA_OPTS="-Xms2g -Xmx2g"' | sudo tee -a /etc/default/elasticsearch

echo 'RESTART_ON_UPGRADE=true' | sudo tee -a /etc/default/elasticsearch

sudo mkdir -p /etc/systemd/system/elasticsearch.service.d/
echo -e '[Service]\nLimitMEMLOCK=infinity' | sudo tee /etc/systemd/system/elasticsearch.service.d/override.conf

sudo systemctl daemon-reload
sudo systemctl restart elasticsearch
sudo systemctl status elasticsearch

curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200 


