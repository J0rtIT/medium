##
# Medium URL: https://j0rt3g4.medium.com/how-to-change-the-location-of-an-ms-o365-user-e55018fd9617
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/master/How%20to%20enable%20International%20and%20Domestic%20Calls%20for%20O365%20users%20if%20your%20live%20out%20of%20the%20US/Change-Location.ps1
# YOUTUBE - Scheduled


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
