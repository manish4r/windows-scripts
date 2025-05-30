set-executionpolicy bypass -Scope Process -force
if ( $(get-appPackage -name Microsoft.PowerShell) )
{
	if (!([Security.Principal.WindowsPrincipal] 	[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
    	Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs
    	exit
	}
	invoke-webrequest 'https://calibre-ebook.com/download_windows' -Outfile calibre_webpage
	$ver=$(get-content .\calibre_webpage | select-string "Version: .*whats-new" | ForEach-Object{($_ -split "\s+")[2]})
	remove-item calibre_webpage
	Write-Output "Website version is $ver"
	Write-Output "Checking current installed version..."
	$ver1=$($(Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version | select-string "calibre"| ForEach-Object{($_ -split "=+")[2]}) -replace '}','')
	Write-Output "Current Installed version is $ver1"
	if("$ver" -ne "$ver1")
	{
		Write-Output "Installing Calibre..."
		Set-Location $Env:temp
		invoke-webrequest 'https://calibre-ebook.com/dist/win64' -Outfile Calibre_$ver.msi
		Start-Process msiexec.exe -Wait -ArgumentList "/i $PWD\Calibre_$ver.msi /q /lie $PWD\Calibre_$ver.log"
		## the log contains only start and stop timing in case of success ##
		## however, in case of failures, it also logs the reason of failre ##
		remove-item Calibre_$ver.msi
		start-sleep 1
		Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "calibre*" } | Select-Object -Property Name, Version,Vendor
		start-sleep 1
		Write-output ""
		Write-Output "This Window will close in 10 seconds..."
		Start-Sleep 10
	}
	else
	{
		Write-Output "$ver is already installed"
		start-sleep 1
		Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "calibre*" } | Select-Object -Property Name, Version,Vendor
		start-sleep 1
		Write-output ""
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
