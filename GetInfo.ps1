
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
Startup info ; 
Schedudle tasks;
UAC.

-pathToSearch : the path to look for files
Example : C:\user\Hugo\Desktop\Getinfo.ps1 -pathToOutput . -pathToSearch "C:\" 
It will write the results in the curent directory.

#>
##################################################################
####################### Main Menu ##################

#""""""""""""""""""""""""" Args """""""""""""""""""""""""""""""""

param(

    [Parameter(Mandatory)]
    [String]$PathToOutput,
    [Parameter(Mandatory)]
    [String]$pathToSearch
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
}

Do_All -PathToOutput $PathToOutput -pathToSearch $pathToSearch






<#
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
