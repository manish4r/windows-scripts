set-executionpolicy bypass -Scope Process -force

$install_loc='D:\Windows Softwares\hwmonitor'
echo "Checking for latest version of CPUID HWMonitor online"
invoke-webrequest 'https://www.cpuid.com/softwares/hwmonitor.html#version-history' -Outfile hwmonitor_webpage

$verw=$($(get-content .\hwmonitor_webpage | select-string "zip" | select-object -first 1 | ForEach-Object{($_ -split "/+")[3]} | ForEach-Object{($_ -split '"+')[0]} |  ForEach-Object{($_ -split "_+")[1]}) -replace '.zip','')
#fname=$(get-content .\hwmonitor_webpage | select-string "zip" | select-object -first 1 | ForEach-Object{($_ -split "/+")[3]} | ForEach-Object{($_ -split '"+')[0]})
remove-item hwmonitor_webpage
echo "Website version is $verw."
$ver=$(get-content "${install_loc}\hwm_readme.txt" |select-string "VERSION" | ForEach-Object{($_ -split "\s+")[1]})
if ($ver)
{
	echo "Current installed version is $ver."
	if("$ver" -ne "$verw")
	{
		echo "Downloading version ${verw}"
		$url="https://download.cpuid.com/hwmonitor/hwmonitor_${verw}.zip"
		invoke-webrequest -Uri $url -Outfile hwmonitor.zip
		Expand-Archive -Path .\hwmonitor.zip -DestinationPath $install_loc -Force
		remove-item hwmonitor.zip
		$veri=$(get-content "${install_loc}\hwm_readme.txt" |select-string "VERSION" | ForEach-Object{($_ -split "\s+")[1]})
		echo "Current installed version is $veri."
	}
	else
	{
		echo "Version $ver is already installed..skipping"
	}
}
else
{
	"CPU-ID HWMonitor is not installed at ${install_loc}"
}