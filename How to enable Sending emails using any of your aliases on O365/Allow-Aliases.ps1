##  The Art of Managing who Can Create Groups in a medium to large O365 tenant
# Medium URL:        https://j0rt3g4.medium.com/how-to-enable-sending-emails-using-any-of-your-aliases-on-o365-a3f410eabbb
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/b08fbe24dd3b72453019f0c0d1f1444c21acc570/How%20to%20enable%20Sending%20emails%20using%20any%20of%20your%20aliases%20on%20O365/Allow-Aliases.ps1
# YOUTUBE            https://youtu.be/xxXtT648ZeI
# RecordIT: When disabled: https://recordit.co/rQwD4Pz9Po / When is already enabled: http://recordit.co/zvXcpb24TV


#set up executionpolicy
Write-Host -ForegroundColor Green "Setting up Powershell Execution Policy"
Set-executionPolicy Remotesigned

#Check or install EXO PS Module

Write-Host -ForegroundColor Green "Trying to connect to EXO PS Module, please add your Global Admin Credentials"
try{
	Connect-ExchangeOnline -ea Stop | Out-Null
}
Catch{
	Write-Host -ForegroundColor Yellow "That tried failed, but dont worry We'd install the required module now and retry"
	Install-Module ExchangeOnlineManagement -AllowClobber -force

	#connect EXO module to local computer
	Write-Host -ForegroundColor Green "Connecting to EXO PS Module, please add your Global Admin Credentials"
	Connect-ExchangeOnline | Out-Null
}

Write-Host -ForegroundColor Magenta "Validating Property"
$OC= Get-OrganizationConfig | select SendFromAliasEnabled

if($OC.SendFromAliasEnabled){
	Write-Host -ForegroundColor Green "Your tenant was already enabled so no changes needed to be done"
}
else{
	Write-Host -ForegroundColor Magenta "Setting up the property to true."
	Set-OrganizationConfig -SendFromAliasEnabled $true
}

Write-Host -ForegroundColor Cyan "Please validate on your own if the property SendFromAliasEnabled was/is ""TRUE"" "
Get-OrganizationConfig | select SendFromAliasEnabled

