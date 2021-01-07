# Event Log filter

## Get all RDP events
```XML
<select>
*[System[(EventID=4624)]]
and *[EventData[Data[@Name=’LogonType’] and Data='10']]
</select>
```

## Get all remote connection events from user "administrator"
```XML
<select>
*[System[(EventID=4624)]]
and *[EventData[Data[@Name=’LogonType’] and (Data='10' or Data='3)]]
and *[EventData[Data[@Name='TargetUserName'] and (Data='administrtator')]]
</select>
```

## Get all RDP connections that occured between the 01/01/1970 18:20 and 01/03/1970 23:39
```XML
*[System[(EventID=4624)]] and *[EventData[Data[@Name=’LogonType’] and (Data='10')]]
and *[System[TimeCreated[@SystemTime'] &gt;= '1970-01-01T18:20:000Z']]
and *[System[TimeCreated[@SystemTime'] &lt;= '1970-03-01T23:39:000Z']]
```
