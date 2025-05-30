set-executionpolicy bypass -Scope Process -force
if ( $(get-appPackage -name Microsoft.PowerShell) )
{
	if (!([Security.Principal.WindowsPrincipal] 	[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
    	Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs
    	exit
	}
	invoke-webrequest 'https://www.libreoffice.org/download/download-libreoffice/?type=win-x86_64' -Outfile libre_webpage
	$ver=$(get-content .\libre_webpage | select-string "dl/win-x86_64" | Select-Object -First 1 | ForEach-Object{($_ -split "\s+")[3]} | ForEach-Object{($_ -split "/+")[5]})
	remove-item libre_webpage
	Write-Output "Website version is $ver"
	Write-Output "Checking current installed version..."
	$ver1=$($(Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version | select-string "libreoffice" | select-object -last 1 | ForEach-Object{($_ -split "=+")[2]}).remove(6))
	Write-Output "Current Installed version is $ver1"
	if("$ver" -ne "$ver1")
	{
		$mirror='https://mirrors.in.sahilister.net/tdf/libreoffice/stable'
		Write-Output "Downloading and installing libreoffice..."
		$url="$mirror/$ver/win/x86_64/LibreOffice_${ver}_Win_x86-64.msi"
		Set-Location $Env:temp
		invoke-webrequest -Uri $url -Outfile LibreOffice_${ver}_Win_x86-64.msi
		Start-Process msiexec.exe -Wait -ArgumentList "/i $PWD\LibreOffice_${ver}_Win_x86-64.msi /q /lie $PWD\LibreOffice_${ver}.log"
		## the log contains only start and stop timing in case of success ##
		## however, in case of failures, it also logs the reason of failre ##
		remove-item LibreOffice_${ver}_Win_x86-64.msi
		Write-Output "Downloading and installing libreoffice helppack files..."
		invoke-webrequest $mirror/$ver/win/x86_64/LibreOffice_${ver}_Win_x86-64_helppack_en-US.msi -Outfile LibreOffice_${ver}_Win_x86-64_helppack_en-US.msi
		Start-Process msiexec.exe -Wait -ArgumentList "/i $PWD\LibreOffice_${ver}_Win_x86-64_helppack_en-US.msi /q /le $PWD\LibreOffice_helppack_${ver}.log"
		remove-item LibreOffice_${ver}_Win_x86-64_helppack_en-US.msi
		start-sleep 1
		Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "libreoffice*" } | Select-Object -Property Name, Version,Vendor
		start-sleep 1
		Write-output ""
		Write-Output "This Window will close in 10 seconds..."
		Start-Sleep 10
	}
	else
	{
		Write-Output "$ver is already installed"
		start-sleep 1
		Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "libreoffice*" } | Select-Object -Property Name, Version,Vendor
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
