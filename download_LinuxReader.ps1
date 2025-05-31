set-executionpolicy bypass -Scope Process -force
if ( $(get-appPackage -name Microsoft.PowerShell) )
{
	if (!([Security.Principal.WindowsPrincipal] 	[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
    	Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs
    	exit
	}
    $url="https://www.diskinternals.com/linux-reader/"
	invoke-webrequest $url -Outfile lr_webpage
    $ver=$($(Get-Content lr_webpage |  select-string "GET IT FREE" | ForEach-Object{($_ -split "\s+")[10]}).remove(4))
    write-output "Latest Website on website is $ver"
    Remove-Item lr_webpage
    $inst_ver=$(Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion  | select-string "Linux" | ForEach-Object{($_ -split "=+")[2]}).remove(4)
    if($inst_ver)
    {
        write-output "Current Installed version of Diskinternals Linux reader is $inst_ver"
    }
    else
    {
        write-output "Diskinternals Linux reader is not installed"
        $inst_ver="0"
    }
    if ("$ver" -eq "$inst_ver" )
    {
        write-output "No new version found..existing in 10 seconds..."
        Start-Sleep 10
    }
    else
    {
        Write-Output "Downloading and installing..."
        $urld="https://eu.diskinternals.com/download/Linux_Reader.exe"
        Set-Location $Env:temp
        invoke-webrequest -Uri $urld -Outfile Linux_Reader.exe
        Start-Process -Wait Linux_Reader.exe
        Remove-Item Linux_Reader.exe
        $inst_ver=$(Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion  | select-string "Linux" | ForEach-Object{($_ -split "=+")[2]}).remove(4)
        Write-Output "Current installed version is $inst_ver "
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
