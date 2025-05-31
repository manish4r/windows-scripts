set-executionpolicy bypass -Scope Process -force
if ( $(get-appPackage -name Microsoft.PowerShell) )
{
	if (!([Security.Principal.WindowsPrincipal] 	[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
    	Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs
    	exit
	}
    $url="https://github.com/transmission/transmission/releases/latest"
	invoke-webrequest $url -Outfile tr_webpage
    $verd=$(Get-Content tr_webpage | select-string "title>" | ForEach-Object{($_ -split "\s+")[2]})
    Write-Output "Website version of Tranmission is $verd"
    #$ver=$(Write-Output $verd) -replace '\.','' 
    Remove-Item tr_webpage
    $inst_ver=$($(Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Transmission*" } | Select-Object -Property Name, Version | ForEach-Object{($_ -split "=+")[2]}) -replace '}','')
    if($inst_ver)
    {
        write-output "Current Installed version of Tranmission is $inst_ver"
    }
    else
    {
        write-output "Tranmission is not installed"
        $inst_ver="0"
    }
    if ("$verd" -eq "$inst_ver" )
    {
        Write-Output "$verd is already installed"
        start-sleep 1
        Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Transmission*" } | Select-Object -Property Name, Version,Vendor
        write-output ""
        write-output "This Window will close in 10 seconds..."
        Start-Sleep 10
    }
    else
    {
        Write-Output "Downloading and installing..."
        $urld="https://github.com/transmission/transmission/releases/download/${ver}/transmission-${ver}-x64.msi"
        write-output $urld
        Set-Location $Env:temp
        invoke-webrequest -Uri $urld -Outfile transmission-${ver}-x64.msi
        ## Cleanup old installation
        #Start-Process msiexec.exe -Wait -ArgumentList "/x transmission-${ver}-x64.msi /quiet /lie $PWD\Transmission_uninstall.log"
        #remove-item -recurse "C:\Program Files\7-Zip" -Force
        ## Begin new-installation
        Start-Process msiexec.exe -Wait -ArgumentList "/i transmission-${ver}-x64.msi /lie $PWD\Transmission_install.log"
        Remove-Item transmission-${ver}-x64.msi
        start-sleep 1
        Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Transmission*" } | Select-Object -Property Name, Version,Vendor
        write-output ""
        start-sleep 1
        Write-Output "This Window will close in 10 seconds..."
        Start-Sleep 10
    }
}
else
{
	Write-Output "Install powershell package higher than version 7 from Microsoft Store"
	Write-Output "This Window will close in 10 seconds..."
	Start-Sleep 10
}
