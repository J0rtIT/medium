##
# Medium URL: https://j0rt3g4.medium.com/how-to-change-the-location-of-an-ms-o365-user-e55018fd9617
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/d7e5069f02b31e4da27d240319802a8237129d61/OAuth%202.0%20with%20Powershell%20for%20Unsplash%20API%20bearer%C2%A0token/Do-Oauth20forUnsplash.ps1
# YOUTUBE - Schedulled


Set-executionpolicy remoteSigned

#Then install the MSOnline module
Install-module MSOnline

#Connect to MSOnline
Connect-MsolService

#Get all the information from (a user, dummy@faboit.com)
Get-MsolUser -UserPrincipalName dummy@faboit.com | select UserPrincipalName,UsageLocation

#See the UsageLocation and change it to a country where the calling plans are enabled, for example, the United States. "US"
Get-MsolUser -UserPrincipalName <upn> | Set-MsolUser -UsageLocation US

#Validate the change
Get-MsolUser -UserPrincipalName dummy@faboit.com | select UserPrincipalName,UsageLocation
Get-MsolUser -UserPrincipalName <upn> | Set-MsolUser -UsageLocation US


