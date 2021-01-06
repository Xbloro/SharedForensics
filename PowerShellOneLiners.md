# oneLinerPowershellDfir
powershell cmd 

## Get evt by process
Get-WinEvent -FilterHashTable @{Logname = "Security" ; ID = 5059,5061}
 
## get TCP and PID
while($true){ $processes = (Get-NetTCPConnection | ? {($_.RemoteAddress -eq "IPaddr")}).OwningProcess; foreach ($process in $processes) { Get-Process -PID $process | select ID,ProcessName } }
