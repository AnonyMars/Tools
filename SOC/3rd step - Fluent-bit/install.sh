sudo curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh

#télécharger conf
sudo wget https://github.com/AnonyMars/Tools/raw/main/SOC/Fluent-bit/fluent-bit.conf 

#modifier host et port dans la config
sudo vim fluent-bit.conf 

#backup old config
sudo cp /etc/fluent-bit/fluent-bit.conf /etc/fluent-bit/fluent-bit.conf.backup
#import nouvel config
sudo cp ./fluent-bit.conf /etc/fluent-bit/fluent-bit.conf

sudo systemctl enable fluent-bit
sudo systemctl start fluent-bit

#checker les logs fluentbit
sudo tail -f /var/log/td-agent-bit.log