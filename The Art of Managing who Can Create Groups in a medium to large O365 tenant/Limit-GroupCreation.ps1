##  The Art of Managing who Can Create Groups in a medium to large O365 tenant
# Medium URL:        https://j0rt3g4.medium.com/unsplash-api-powershell-8214cfc4c87b
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/d7e5069f02b31e4da27d240319802a8237129d61/OAuth%202.0%20with%20Powershell%20for%20Unsplash%20API%20bearer%C2%A0token/Do-Oauth20forUnsplash.ps1
# YOUTUBE            https://youtu.be/Lum3NTgSc7s

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false,Position=0)]$GroupName="testGroup"
)
#const vars
$AllowGroupCreation = $False
$GroupMembers="jortega@faboit.com","wortega@faboit.com"
$domain = "faboit.com"

#making sure you have only one AzureAD module installed, and if you have the Regular AzureAD remove them both since you only need the preview version
Write-Host -ForegroundColor Magenta "Removing Modules with AzureAD"
Get-Module -ListAvailable | where { $_.Name -like "*AzureAD*"} | Remove-Module -confirm:$false

#Install the latest AzureADPreview
Write-Host -ForegroundColor Green "Installing Module AzureADPreview"
Install-Module AzureADPreview -AllowClobber -Force -Confirm:$false

#connect to start the script provide Global Admin Access (or account)
Write-Host -ForegroundColor Green "Connecting to AzureAD"

try{
    Connect-AzAccount -ea Stop | out-null
}
catch{
    Write-Error "There was an error while trying to connect to the AzureAD, script will exit now"
    exit -1;
}


#connect to Exchange Online
try{
    Connect-ExchangeOnline -ea Stop | out-null
}
catch{
    try{
        Install-Module ExchangeOnlineManagement -AllowClobber -Force
        Connect-ExchangeOnline
    }
    catch{
        Write-Error "There was an error while trying to connect to Exchange Online Module. Script will exit now."
        exit -1;
    }
}

#Validate the Name of the group exists or ask for creation:

Write-Host -ForegroundColor Magenta "Checking if ""$GroupName"" exists"
if( !($(Get-UnifiedGroup | where {$_.DisplayName -like "*$($GroupName)*"}).Count -gt 0)) {
    #group does not exist
    #Create New Office 365 Group 
    try{
        Write-Host -ForegroundColor Cyan "Creating Group: $GroupName"
        New-UnifiedGroup -DisplayName $GroupName  -Alias $GroupName -EmailAddresses "$($GroupName)@$domain" -AccessType Private -Members $GroupMembers | out-null
    }
    catch{

        exit -1;
    }
}



#gather current settings 
$settingsObjectID = (c | Where-object -Property Displayname -Value "Group.Unified" -EQ).id

#if the settings are empty, then go gather the template
if(!$settingsObjectID)
{
    $template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
    $settingsCopy = $template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $settingsCopy
    $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation

if($GroupName)
{
  $settingsCopy["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $GroupName).objectid
}
 else {
$settingsCopy["GroupCreationAllowedGroupId"] = $GroupName
}
Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

(Get-AzureADDirectorySetting -Id $settingsObjectID).Values