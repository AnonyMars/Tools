#auth key api : 6Tq2Wm8wLBxr64w881hzvJfVnDsdvbwa6vRwEbqG

#Commande test à réaliser depuis machine graylog
curl --insecure -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: 6Tq2Wm8wLBxr64w881hzvJfVnDsdvbwa6vRwEbqG" https://192.168.0.238/attributes/restSearch/value:mb4z3nlfyrcjnoqf.onion

#se rendre sur graylog dans data adapters
http://192.168.0.235:9000/system/lookuptables/data_adapters

#Créer un cache appelé MISP sur 
http://192.168.0.235:9000/system/lookuptables/caches/

#Enfin, créer un lookup tables qui va utiliser le cache et le data dapters
http://192.168.0.235:9000/system/lookuptables

#Création d'une pipeline pour venir enrichir automatiquement les logs lorsque MISP peut-être utilisé
http://192.168.0.235:9000/system/pipelines/rules/new?rule_builder=true
#Checker rule.txt "5-..."" pour la rule

#Création une pipeline ou une étape si pipeline déjà existante pour associer la pipeline rule à la pileine
#checker "6-"
