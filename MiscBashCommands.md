Grep all IP addresses from a file
<code>
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
</code>

Geolocate a list of IP addresses
<code>
for ip in $(cat ip_list); do curl -s https://freegeoip.app/json/"$ip" | cut -d";" -f3 | cut -d"," -f1; echo ":$ip"; done
</code>
