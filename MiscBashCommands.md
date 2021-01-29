## Grep all IP addresses from a file

```bash
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
```

## Geolocate a list of IP addresses

```bash
for ip in $(cat ip_list); do curl -s https://freegeoip.app/json/"$ip" | cut -d":" -f3 | cut -d"," -f1; echo ":$ip"; done
```
