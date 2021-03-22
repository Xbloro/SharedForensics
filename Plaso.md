

## Timeline

### Creating a supertimeline with **log2timeline** from an image disk
```bash
# Creating the bodyfile
log2timeline.py <timeline.plaso> <disk_image.E01>

# Making the plaso readable (csv) and filtering by date (from 01/12/2020 00:00 to 31/12/2020 00:00)
psort.py -z "UCT" -o l2tcsv <timeline.plaso> "date > '2020-12-01 00:00:00' AND date < '2020-12-31 00:00:00'" -w <timeline.csv>
```


## Sort all failled Connexion by IP and sort them by number

```bash
log2timeline.py mus.sec.evtx.l2t securityevt/*

*psort.py -o l2tcsv -w mus.sec.evtx.csv mus.sec.evtx.l2t*

Total Failed Logons: *grep “EventID>4625” mus.sec.evtx.csv | wc -l* 

Top Failed Accounts: *grep  “EventID>4625″ mus.sec.evtx.csv | awk -F”xml_string: ” ‘{print $2}’ | awk -F”TargetUserName\”>” ‘{print $2}’ | awk -F”<” ‘{print $1}’ | sort | uniq -c | sort -n -r | head*

Top Failed Logon Accounts: *grep “EventID>4625″ mus.sec.evtx.csv | awk -F”xml_string: ” ‘{print $2}’ | awk -F”LogonType\”>” ‘{print $2}’ | awk -F”<” ‘{print $1}’ | sort | uniq -c | sort -n -r | head*

Top Failed IP Address Origins:
 *grep “EventID>4625″  mus.sec.evtx.csv | awk -F”xml_string: ” ‘{print $2}’ | awk  -F”IpAddress\”>” ‘{print $2}’ | awk -F”<” ‘{print $1}’ | sort |  uniq -c | sort -n -r | head*

Top Dates With Failed Logons: *grep  “EventID>4625″ mus.sec.evtx.csv | awk -F”xml_string: ” ‘{print $2}’ | awk -F”TimeCreated SystemTime=\”” ‘{print $2}’ | awk -F”T” ‘{print $1}’ | sort | uniq -c | sort -n -r | head
```
