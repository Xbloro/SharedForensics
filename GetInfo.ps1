


##################################################################
####################### Main Menu ##################

#""""""""""""""""""""""""" Args """""""""""""""""""""""""""""""""

param(

    [Parameter(Mandatory)]
    [String]$PathToOutput
) #Must be t


function Get-sysInfo {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

$EndFolder = "SystemInfo"
$FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
If(!(test-path $FinalPath))
{
      New-Item -ItemType Directory -Force -Path $FinalPath
}
$EndFileName = Join-Path -Path $FinalPath -childPath "systemInfo.txt"
systeminfo | Out-File -FilePath $EndFileName -Append

$EndFileName = Join-Path -Path $FinalPath -childPath "computerInfo.txt"
get-computerinfo | Out-File -FilePath $EndFileName -Append

$EndFileName = Join-Path -Path $FinalPath -childPath "timezone.txt"
reg query "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" | Out-File -FilePath $EndFileName -Append
}

function Get-AllUsersInfo {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t
    $EndFolder = "UsersInfo"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath
    }

$EndFileName = Join-Path -Path $FinalPath -childPath "AdminInfo.txt"
net localgroup administrators | Out-File -FilePath $EndFileName -Append

$EndFileName = Join-Path -Path $FinalPath -childPath "AccountInfo.txt"
wmic useraccount list | Out-File -FilePath $EndFileName -Append
wmic netlogin list /format:List | Out-File -FilePath $EndFileName -Append

$EndFileName = Join-Path -Path $FinalPath -childPath "LogonInfo.txt"
Get-WmiObject Win32_LoggedOnUser | Out-File -FilePath $FinalPath -Append
Get-WmiObject win32_logonsession | Out-File -FilePath $FinalPath -Append

}

function Get-FirewallInfo {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

    $EndFolder = "FirewallInfo"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath
    }

$EndFileName = Join-Path -Path $FinalPath -childPath "FirewallInfos.txt"
netsh Firewall show state | Out-File -FilePath $EndFileName -Append
netsh advfirewall firewall show rule name=all dir=in type=dynamic | Out-File -FilePath $EndFileName -Append
netsh advfirewall firewall show rule name=all dir=out type=dynamic | Out-File -FilePath $EndFileName -Append
netsh advfirewall firewall show rule name=all dir=in type=static | Out-File -FilePath $EndFileName -Append
netsh advfirewall firewall show rule name=all dir=out type=static | Out-File -FilePath $EndFileName -Append

}

function Get-startupInfo {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

    $EndFolder = "StartupInfo"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath
    }   

$EndFileName = Join-Path -Path $FinalPath -childPath "StartupInfos.txt"
wmic startup list full | Out-File -FilePath $EndFileName -Append
Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | FL | Out-File -FilePath $EndFileName -Append
}


function Get-ScheduledTasks {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

    $EndFolder = "ScheduledTasks"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath
    }   

$EndFileName = Join-Path -Path $FinalPath -childPath "scheduledTasks.txt"
Get-ScheduledTask | Out-File -FilePath $EndFileName -Append
schtasks.exe | Out-File -FilePath $EndFileName -Append
}


function Get-UACInfo {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

    $EndFolder = "UacInfo"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath 
    } 
    $EndFileName = Join-Path -Path $FinalPath -childPath "UacInfo.txt"
    reg query HKCU\Software\Classes\ms-settings\shell\open\command| Out-File -FilePath $FinalPath -Append
}


function Do_All {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t
    
    Get-AllUsersInfo -PathToOutput $PathToOutput
    Get-FirewallInfo -PathToOutput $PathToOutput
    Get-startupInfo -PathToOutput $PathToOutput
    Get-sysInfo -PathToOutput $PathToOutput
    Get-UACInfo -PathToOutput $PathToOutput
    Get-ScheduledTasks  -PathToOutput $PathToOutput
}

Do_All -PathToOutput $PathToOutput