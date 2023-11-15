#!/bin/bash

#A placer dans /usr/lib/cgi-bin/



echo "Content-type: text/html"
echo ""
echo "<html><head><title>SQLi Alert Triggered</title></head><body>"
echo "<h1>SQL Injection Alert Generated!</h1>"
echo "<p>A SQL Injection (SQLi) attempt was logged.</p>"

# Générer une entrée de log pour une SQLi
logger -t SQLI_ALERT "SQL Injection (SQLi) attempt detected from IP: ${REMOTE_ADDR}"

echo "</body></html>"
