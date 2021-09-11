##  The Art of Managing who Can Create Groups in a medium to large O365 tenant
# Medium URL:        https://j0rt3g4.medium.com/unsplash-api-powershell-8214cfc4c87b
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/d7e5069f02b31e4da27d240319802a8237129d61/OAuth%202.0%20with%20Powershell%20for%20Unsplash%20API%20bearer%C2%A0token/Do-Oauth20forUnsplash.ps1
# YOUTUBE            https://youtu.be/xxXtT648ZeI


#set up executionpolicy
Write-Host -ForegroundColor Green "Setting up Powershell Execution Policy"
Set-executionPolicy Remotesigned

#Install EXO PS Module
Write-Host -ForegroundColor Green "Install EXchange Online (EXO) PowerShell (PS) Module"
Install-Module ExchangeOnlineManagement -AllowClobber -force

#connect EXO module to local computer
Write-Host -ForegroundColor Green "Connecting to EXO PS Module, please add your Global Admin Credentials"
Connect-ExchangeOnline | Out-Null


Write-Host -ForegroundColor Magenta "Validating Property"
$OC= Get-OrganizationConfig | select SendFromAliasEnabled

if($OC.SendFromAliasEnabled){
	Write-Host -ForegroundColor Green "Your tenant was already enabled so no changes needed to be done"
	exit -1;
}
else{
	Write-Host -ForegroundColor Magenta "Setting up the property to true."
	Set-OrganizationConfig -SendFromAliasEnabled $true
}



Write-Host -ForegroundColor Cyan "Please validate on your own if the property SendFromAliasEnabled was set to ""TRUE"" "
Get-OrganizationConfig | select SendFromAliasEnabled

