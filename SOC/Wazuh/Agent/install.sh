#ATTENTION, la ligne suivante sous-entend que la config du manager a été correctement réalisé avec un mdp et la création d'un groupe d'agents linux
sudo wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.6.0-1_amd64.deb && sudo WAZUH_MANAGER='192.168.0.236' WAZUH_REGISTRATION_PASSWORD='password_wazuh' WAZUH_AGENT_GROUP='linux' dpkg -i ./wazuh-agent_4.6.0-1_amd64.deb

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent