#To run the script first run this
set-executionpolicy bypass -Scope Process -force 
#To open a admin powershell run-this
#Start-Process PowerShell -Verb runAs
$volumes = mountvol 
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}
# Extract volume GUIDs
#$volumeGUIDs = $volumes -match '\\?\Volume{[a-f0-9-]+}'
$volumeGUIDs = echo $volumes | select-string "Volume{"
# Loop through each volume and scan it
foreach ($volume in $volumeGUIDs) {
    # Remove trailing backslash
    $volume = $volume  -replace '}\\','}'
    # Remove blank spaces
    $volume = $volume -replace '\s',''

    # Scan the volume
        Write-Output "Scanning volume $volume"
        chkdsk /f $volume
}