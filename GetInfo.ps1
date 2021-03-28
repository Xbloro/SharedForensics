
<### Feel free improve this script
Made by Xbloro

To enable search function : 
create a folder name "conf" in the same dir as the script
create a file name checkItemAbsolute.txt and put it in conf folder
create a file name searchItem.txt and put it in conf folder
in check item specify full path of thing to search ex : C:\users\X\file.txt
in searchItem.txt specify juste the name of the file to look for ex : file.txt

This script gather computeur info and write them to files
Must be run as Admin
Artefact collected : 
system info ;
TimeZone;
users info ;
firewall info ; 
Windefender info ;
Startup info ; 
Schedudle tasks;
Gather Windows Logs ;
UAC Infos.

-pathToSearch : the path to look for files
Example : C:\user\Hugo\Desktop\Getinfo.ps1 -pathToOutput . -pathToSearch "C:\" 
It will write the results in the curent directory.

#>
##################################################################
####################### Main Menu ##################

#""""""""""""""""""""""""" Args """""""""""""""""""""""""""""""""

param(

    [Parameter()]
    [String]$PathToOutput = ".",
    [Parameter()]
    [String]$pathToSearch = ".",
    [Parameter()]
    [switch]$Menu,
    [Parameter()]
    [switch]$A,
    [Parameter()]
    [switch]$H
) #Must be t


function Write-Help {

    Write-Host "#################### Args ###################### " -ForegroundColor Green
    Write-Host " args -PathToOutput the destination folder, default is current"
    Write-Host " args -PathToSearch the path to look for file , default is current"
    Write-Host " args -A to perform all actions"
    Write-Host " args -Menu to go to an interactive menu"
    Write-Host " args -H to go show this Help"
    Write-Host "################################################# "-ForegroundColor Green
    Write-Host "#################### Info ###################### "-ForegroundColor Blue
    Write-Host "Artefact collected : system info; TimeZone; users info; firewall info;  Windefender info; Startup info; Schedudle tasks; Gather Windows Logs; UAC Infos."
    Write-Host "Search file specified in the conf folder "
    Write-Host "################################################# " -ForegroundColor blue
    Write-Host "To enable search function : "
    Write-Host " - create a folder name 'conf' in the same dir as the script"
    Write-Host " - create a file name checkItemAbsolute.txt and put it in conf folder"
    Write-Host " - create a file name searchItem.txt and put it in conf folder"
    Write-Host " - in check item specify full path of thing to search ex : C:\users\X\file.txt"
    Write-Host " - in searchItem.txt specify juste the name of the file to look for ex : file.txt"
    Write-Host "################################################# " -ForegroundColor Green
}

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
Get-WmiObject Win32_LoggedOnUser | Out-File -FilePath $EndFileName -Append
Get-WmiObject win32_logonsession | Out-File -FilePath $EndFileName -Append

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
    reg query HKCU\Software\Classes\ms-settings\shell\open\command| Out-File -FilePath $EndFileName -Append
}


function Search-ElementAbsolute {
    param (
        [Parameter(Mandatory)]
        [String]$PathToOutput
    )
    $EndFolder = "Search"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    $pathToConfFile = ".\conf\checkItemAbsolute.txt"
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath 
    } 
    $EndFileName = Join-Path -Path $FinalPath -childPath "SearchAbsolute.txt"


    try{
        If((test-path $pathToConfFile))
        {  
        foreach($line in Get-Content ".\conf\checkItemAbsolute.txt") {
            $result = Test-Path $line    
            if($result -eq "True"){ 
                Add-Content -Path $EndFileName -Value $line" exist"
               # Write-Host $line "exist"  -ForegroundColor green
            }
            <#else { Write-Host $line "does not exist"  -ForegroundColor red }#>
        }
    }
    else {
        Write-Host "conf file does not exist aboarding" -ForegroundColor red
    }
    }
    catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Host $ErrorMessage $FailedItem
    }
}

function Search-ElementFromFile {
    param (
        [Parameter(Mandatory)]
        [String]$PathToOutput,
        [Parameter(Mandatory)]
        [String]$Path
    )

    $EndFolder = "Search"
    $pathToConfFile = ".\conf\searchItem.txt"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath 
    } 
    $EndFileName = Join-Path -Path $FinalPath -childPath "SearchFromName.txt"
    try{
        If((test-path $pathToConfFile))
        {
        foreach($line in Get-Content $pathToConfFile) {
            $res = Get-ChildItem -Path $path -Filter $line -Recurse | ForEach-Object{$_.FullName}
            if(![string]::IsNullOrWhiteSpace($res)) { 
                foreach($element in $res){
                    #Write-Host $res "exist" -ForegroundColor green
                    Add-Content -Path $EndFileName -Value $res
                    }
            }
            <#
            else { 
                Write-Host $line "does not exist"  -ForegroundColor red 
                #Add-Content -Path $EndFileName -Value $line "does not exist
                } #>
        }
        }
        else {
            Write-Host "conf file does not exist aboarding" -ForegroundColor red
        }
        
    }
    catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Host $ErrorMessage $FailedItem
   }
}


function Get-DefenderInfo {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

    $EndFolder = "WinDefender"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath 
    } 
    $EndFileName = Join-Path -Path $FinalPath -childPath "DefenderInfo.txt"
    Get-MpComputerStatus | Out-File -FilePath $EndFileName -Append
    $EndFileName = Join-Path -Path $FinalPath -childPath "DefenderPreferences.txt"
    Get-MpPreference | Out-File -FilePath $EndFileName -Append
    $EndFileName = Join-Path -Path $FinalPath -childPath "DefenderThreatDetections.txt"
    Get-MpThreatDetection | Out-File -FilePath $EndFileName -Append
    $EndFileName = Join-Path -Path $FinalPath -childPath "DefenderThreat.txt"
    Get-MpThreat | Out-File -FilePath $EndFileName -Append
     
}


function Get-WinEventLogs {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput
    ) #Must be t

    $EndFolder = "WinEvents"
    $FinalPath = Join-Path -Path $PathToOutput -childPath $EndFolder
    If(!(test-path $FinalPath))
    {
          New-Item -ItemType Directory -Force -Path $FinalPath 
    } 

    Copy-Item -Path "C:\WINDOWS\System32\Winevt\Logs\" -Destination $FinalPath -Recurse
    Compress-Archive -Path $FinalPath"\Logs\*" -DestinationPath "WinEvents\Logs.zip"
    Remove-Item -Path $FinalPath"\Logs" -Force -Recurse -Confirm:$false
}
function CompressResults {
    param(
        [Parameter(Mandatory)]
        [String]$PathToOutput
        ) #Must be t

    $machineName = HOSTNAME
    $EndFileName = Join-Path -Path $PathToOutput -childPath $machineName".zip"

    Get-ChildItem -Path $PathToOutput -Exclude *.ps1, conf | Compress-Archive -DestinationPath $EndFileName
    Get-ChildItem -Path $PathToOutput -Exclude *.ps1, conf,*.zip -Directory | Remove-Item -Force -Recurse -Confirm:$false 
}

function Do_All {
    param(
    [Parameter(Mandatory)]
    [String]$PathToOutput,
    [Parameter(Mandatory)]
    [String]$pathToSearch
    
    ) #Must be t

    Get-AllUsersInfo -PathToOutput $PathToOutput
    Get-FirewallInfo -PathToOutput $PathToOutput
    Get-startupInfo -PathToOutput $PathToOutput
    Get-sysInfo -PathToOutput $PathToOutput
    Get-UACInfo -PathToOutput $PathToOutput
    Get-ScheduledTasks  -PathToOutput $PathToOutput
    Search-ElementAbsolute -PathToOutput $PathToOutput
    Search-ElementFromFile -PathToOutput $PathToOutput -Path $pathToSearch
    Get-DefenderInfo -PathToOutput $PathToOutput
    Get-WinEventLogs -PathToOutput $PathToOutput
    CompressResults -PathToOutput $PathToOutput
    Clear-Host
    Write-Host "All action have been performed " -ForegroundColor Green
}

function Show-Menu {
    param (
        [string]$Title = 'PowerGatherForensics'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for All options"
    Write-Host "2: Press '2' to search for files"
    Write-Host "3: Press '3' for this option."
    Write-Host "Q: Press 'Q' to quit."
}
 function Do_Menu {

     do
     {
        Show-Menu
        $selection = Read-Host "Please make a selection"
        switch ($selection)
        {
        '1' {
            Do_All -PathToOutput $PathToOutput -pathToSearch $pathToSearch
        } '2' {
            Search-ElementAbsolute -PathToOutput $PathToOutput
            Search-ElementFromFile -PathToOutput $PathToOutput -Path $pathToSearch
        } '3' {
          'You chose option #3'
        }
        }
        pause
     }
     until ($selection -eq 'q')
 }


############################## MAIN ###########################################################

if($Menu){ Do_Menu}
elseif($A){ Do_All -PathToOutput $PathToOutput -pathToSearch $pathToSearch}
elseif($H){ Write-Help}
else{Write-Help}



#################################################################################################
<# to do




function Search-ElementFromName {
    param (
        [Parameter(Mandatory)]
        [String]$path,
        [Parameter(Mandatory=$false)]
        [String]$file,
        [Parameter(Mandatory=$false)]
        [String]$extension
    )

    #([io.fileinfo]"c:\temp\myfile.txt").Extension

    $res = Get-ChildItem -Path $path -Filter $file$extension -Recurse | ForEach-Object{$_.FullName}
   
        if([string]::IsNullOrEmpty($res)) { 
            # trouve ap
        }
        else { 
            foreach($element in $res){
                # si on trouve
                
                }
        }
}    
#>

