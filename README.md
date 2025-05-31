# Windows scripts
## Pre-requisite : 
Install Windows Powershell greater than version 7.0 from Microsoft Store . Alternatively you can run `winget install --id Microsoft.Powershell --source winget` to install it .
Else run `set-executionpolicy bypass -Scope Process -force` in regular powershell to run the scripts .

## Detail of scripts :
* check_disk_all_volumes.ps1 - This script runs checkdisk on all environments .
* download_calibre.ps1 - This script update Calibre Software to latest version .    
* download_libreoffice.ps1 - This script update Libreoffice to latest version .
* download_hwmonitor.ps1 - This script updates CPUID HWMonitor to latest version .
* download_LinuxReader.ps1 - This script updates Diskinternals Linux Reader to latest version . This script can be currently run only in foreground .
* download_7zip.ps1 - This script installs or updates 7 Zip program by Igor Pavlov to latest version . This script can be currently run only in foreground .
* download_transmission.ps1 - This scrippt installs or updates Transmission program to latest version . This script can be currently run only in foreground .
