#!/bin/bash
# Monitors Speedtests of Home Broadband via logging
# Plans to add interactive monitoring + email notifications

echo "<p>"  >> /var/www/html/index.html
date >> /var/www/html/index.html
echo "<br>" >> /var/www/html/index.html
/usr/local/bin/speedtest --simple >>  /var/www/html/index.html
echo "</p><br>" >> /var/www/html/index.html
