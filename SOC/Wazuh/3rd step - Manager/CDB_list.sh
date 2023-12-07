#CREATION D'UNE LISTE DE PORTS WHITELIST

#copier coller le contenu du fichier wl-ports dans le même dossier du repo
sudo vim /var/ossec/etc/lists/wl-ports

sudo chown wazuh:wazuh /var/ossec/etc/lists/wl-ports
sudo chmod 660 /var/ossec/etc/lists/wl-ports

#Intégrer la liste à la config de Wazuh dans le ruleset
sudo vim /var/ossec/etc/ossec.conf
====>     "<list>etc/lists/wl-ports</list>"

sudo systemctl restart wazuh-manager

#Sur wazuh dashboard dans wazuh > management > CDB list
https://192.168.0.235/app/wazuh#/manager/?tab=lists

#Rajout d'une alerte Wazuh au fichier de rules pour écouter la nouvelle liste CDB
#Sur l'interface web, chercher 102101-MITRE_TECHNIQUES_FROM_SYSMON_EVENT3.xml
#Rajouter cette règle tout en bas du fichier dans les balises
"<!-- Abnormal Destination Port Detected -->
<rule id="102503" level="10">
  <if_group>sysmon_event3</if_group>
  <list field="win.eventdata.destinationPort" lookup="not_address_match_key">etc/lists/wl-ports</list>
  <description>Sysmon - Event 3: Network connection to Uncommon Port by $(win.eventdata.image)</description>
  <options>no_full_log</options>
  <group>sysmon_event3,</group>
</rule>"

sudo systemctl restart wazuh-manager