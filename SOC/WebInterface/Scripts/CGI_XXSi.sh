#!/bin/bash

#A placer dans /usr/lib/cgi-bin/


echo "Content-type: text/html"
echo ""
echo "<html><head><title>XSS Alert Triggered</title></head><body>"
echo "<h1>XSS Alert Generated!</h1>"
echo "<p>A Cross-Site Scripting (XSS) attempt was logged.</p>"

# Générer une entrée de log pour un XSS
logger -t XSS_ALERT "Cross-Site Scripting (XSS) attempt detected from IP: ${REMOTE_ADDR}"

echo "</body></html>"
