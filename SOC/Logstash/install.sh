wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update && sudo apt-get install logstash=1:7.10.2-1 

sudo systemctl start logstash
sudo systemctl enable logstash


sudo /usr/share/logstash/bin/logstash -e 'input { stdin { } } output { stdout {} }'

sudo mkdir /etc/logstash/certs
sudo cp /etc/wazuh-indexer/certs/soc1* /etc/logstash/certs/
sudo cp /etc/wazuh-indexer/certs/root-ca.pem /etc/logstash/certs/
sudo chown -R logstash:logstash /etc/logstash/certs/
sudo chmod 400 /etc/logstash/certs/*

sudo systemctl restart logstash

sudo /usr/share/logstash/bin/logstash-keystore --path.settings /etc/logstash create

#RENSEIGNER IDENTIFIANT ES
sudo /usr/share/logstash/bin/logstash-keystore --path.settings /etc/logstash add ES_USER
#logstash
sudo /usr/share/logstash/bin/logstash-keystore --path.settings /etc/logstash add ES_PASS
#   +U*I.Er401iltydEnG5j2D0IlOT4a5tB
sudo /usr/share/logstash/bin/logstash-keystore --path.settings /etc/logstash list


#tester la configuration de votre fichier de conf
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/02-beats-input.conf --config.test_and_exit --path.settings /etc/logstash

#reboot logstash pour libérer le port 5044
sudo systemctl restart logstash

#Activation config reload automatique pour ne pas avoir à reboot logstash à chaque changement du fichier de conf
sudo sed -i 's/# config.reload.automatic: false/config.reload.automatic: true/' /etc/logstash/logstash.yml

