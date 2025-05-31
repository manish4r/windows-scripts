set-executionpolicy bypass -Scope Process -force
if ( $(get-appPackage -name Microsoft.PowerShell) )
{
	if (!([Security.Principal.WindowsPrincipal] 	[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
    	Start-Process pwsh.exe "-File `"$PSCommandPath`"" -Verb RunAs
    	exit
	}
    $url="https://github.com/ip7z/7zip/releases/latest"
	invoke-webrequest $url -Outfile 7z_webpage
    $verd=$(Get-Content 7z_webpage | select-string "title>" | ForEach-Object{($_ -split "\s+")[2]})
    Write-Output "Website version of 7 zip by Igor Pavlov is $verd"
    $ver=$(Write-Output $verd) -replace '\.','' 
    Remove-Item 7z_webpage
    $pgmf=$Env:Programfiles
    $inst_ver=$(get-content "$pgmf\7-Zip\History.txt" | select-string ^[0-9] | select-object -first 1 | ForEach-Object{($_ -split "\s+")[0]})
    if($inst_ver)
    {
        write-output "Current Installed version of 7 zip by Igor Pavlov is $inst_ver"
    }
    else
    {
        write-output "7 zip by Igor Pavlov is not installed"
        $inst_ver="0"
    }
    if ("$verd" -eq "$inst_ver" )
    {
        write-output "No new version found..exiting in 10 seconds..."
        Start-Sleep 10
    }
    else
    {
        Write-Output "Downloading and installing..."
        $urld="https://github.com/ip7z/7zip/releases/download/${verd}/7z${ver}-x64.msi"
        write-output $urld
        Set-Location $Env:temp
        invoke-webrequest -Uri $urld -Outfile 7z${ver}-x64.msi
        ## Cleanup old installation
        #Start-Process msiexec.exe -Wait -ArgumentList "/x 7z${ver}-x64.msi /quiet /lie $PWD\7z_uninstall.log"
        #remove-item -recurse "C:\Program Files\7-Zip" -Force
        ## Begin new-installation
        Start-Process msiexec.exe -Wait -ArgumentList "/i 7z${ver}-x64.msi /lie $PWD\7z_install.log"
        Remove-Item 7z${ver}-x64.msi
        $inst_ver=$(get-content "$pgmf\7-Zip\History.txt" | select-string ^[0-9] | select-object -first 1 | ForEach-Object{($_ -split "\s+")[0]})
        Write-Output "Current installed version is $inst_ver"
        Write-Output "Detailed installation logs can be found in $Env:temp\7z_install.log"
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
