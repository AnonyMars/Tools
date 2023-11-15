#!/bin/bash

#A placer dans /usr/lib/cgi-bin/


echo "Content-type: text/html"
echo ""
echo "<html><head><title>SSH Alert Triggered</title></head><body>"
echo "<h1>SSH Failed Login Alert Generated!</h1>"
echo "<p>A failed SSH login attempt was logged.</p>"

# Générer une entrée de log pour une tentative de connexion SSH échouée
logger -t SSH_ALERT "Failed SSH login attempt detected from IP: ${REMOTE_ADDR}"

echo "</body></html>"
