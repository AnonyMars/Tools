curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update

#changer ip
WAZUH_MANAGER="192.168.0.236" WAZUH_REGISTRATION_PASSWORD="password_wazuh" WAZUH_AGENT_NAME="socwebclient" WAZUH_AGENT_GROUP="linux" apt-get install wazuh-agent
#Changer les valeurs de : WAZUH_MANAGER='192.168.0.236' WAZUH_REGISTRATION_PASSWORD=$'password_wazuh' WAZUH_AGENT_GROUP='linux' WAZUH_AGENT_NAME='socweb'


sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

