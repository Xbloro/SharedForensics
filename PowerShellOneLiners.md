# OneLiner Powershell Dfir
powershell cmd 
template line code :
```PowerShell
code
```

## Get evt by process
```PowerShell
Get-WinEvent -FilterHashTable @{Logname = "Security" ; ID = 5059,5061}
```

## get TCP and PID
```PowerShell
while($true){ $processes = (Get-NetTCPConnection | ? {($_.RemoteAddress -eq "IPaddr")}).OwningProcess; foreach ($process in $processes) { Get-Process -PID $process | select ID,ProcessName } }
```
