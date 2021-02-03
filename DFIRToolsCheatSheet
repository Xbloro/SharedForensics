# DFIR Tools Cheatsheet

## Timeline

### Creating a supertimeline with **log2timeline** from an image disk
```bash
# Creating the bodyfile
log2timeline.py <timeline.plaso> <disk_image.E01>

# Making the plaso readable (csv) and filtering by date (from 01/12/2020 00:00 to 31/12/2020 00:00)
psort.py -z "UCT" -o l2tcsv <timeline.plaso> "date > '2020-12-01 00:00:00' AND date < '2020-12-31 00:00:00'" -w <timeline.csv>
```

### Creating a timeline with **fls** 
```bash
# Creating the bodyfile from an image disk
fls.exe -m C: -f ntfs -r <disk_image.E01> > <timeline.bodyfile>

# Creating the bodyfile from a live disk
fls.exe -m C: -f ntfs -r \\.\C: > <D:\timeline.bodyfile>

# Making the bodyfile readable (csv) and filtering by date (from 01/12/2020 to 31/12/2020)
mactime -d -b <timeline.bodyfile> 2020-12-01..2020-12-31 > <timeline.csv>
```
