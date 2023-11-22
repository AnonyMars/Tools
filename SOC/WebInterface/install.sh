sudo apt-get update
sudo apt-get install apache2 -y

sudo a2enmod cgi
sudo service apache2 restart



sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/WebInterface/Alert_generator_apache_index/index.html -O /var/www/html/index.html

sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/WebInterface/CGI-Scripts/CGI_XXSi.sh -O /usr/lib/cgi-bin/CGI_XXSi.sh
sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/WebInterface/CGI-Scripts/CGI_SQLi.sh -O /usr/lib/cgi-bin/CGI_SQLi.sh
sudo wget https://raw.githubusercontent.com/AnonyMars/Tools/main/SOC/WebInterface/CGI-Scripts/CGI_Failed_SSH.sh -O /usr/lib/cgi-bin/CGI_Failed_SSH.sh

sudo chmod +x /usr/lib/cgi-bin/*.sh

sudo systemctl restart apache2

# Obtenir l'adresse IP par défaut de la machine virtuelle
ip_vm=$(hostname -I | awk '{print $1}')

# Remplacer l'IP exemple par l'IP réelle dans la chaîne de texte
echo "Lancer votre navigateur avec l'ip de la vm ex : $ip_vm"


#TEST après clic alerte
echo "Après avoir cliqué sur les boutons, vérifier la présence d'alertes"
echo "sudo cat /var/log/syslog | grep ALERT"



