## Removing groups using Powershell from Office 365 Tenant
# Medium URL: https://j0rt3g4.medium.com/removing-groups-using-powershell-from-office-365-tenant-b1f2e6de3179
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/master/Removing%20groups%20using%20Powershell%20from%20Office%20365%20Tenant/Remove-O365Groups.ps1

#region ConfigureEnvironment

#Allowing RemoteSigned Cmdlets and installing the ExchangeOnlineModule (or updating it if required)
Set-ExecutionPolicy RemoteSigned
Install-Module ExchangeOnlineManagement -AllowClobber -Force

#endregion


#region ConnectToExchangeOnline
Connect-ExchangeOnline
]#endregion

#region ScriptCSV
#Create CSV file into the logged user's Desktop
Get-UnifiedGroup | Select DisplayName, Name, WhenCreated | where{ ($_.WhenCreated).year -eq 2020} | sort-object WhenCreated -Descending | Export-Csv -NoTypeInformation "$env:userprofile\desktop\Export.csv"
#endregion


##Required to analyze the CSV file using Excel, Notepad or Notepad++
##and finally use the Export2.csv File (gy renaming or copying it to keep Original Export.csv intact.

#region PreFinalCode
foreach($ug in Import-CSV "$env:userprofile\desktop\Export2.csv" -Delimiter ','){
    #Final code to execute with the last simulation "it would simulate" that it will remove but it won't
    Write-host -ForeGroundColor Magenta "Working With ""$($ug.DisplayName)"""
    Get-UnifiedGroup $ug.Name | Remove-UnifiedGroup -Confirm:$false -WhatIf
}

#endregion

#region FinalCode
    #Final code to execute without any confirmation or warning the code over all the groups in the CSV file
foreach($ug in Import-CSV "$env:userprofile\desktop\Export2.csv" -Delimiter ','){
    Write-host -ForeGroundColor Magenta "Working With ""$($ug.DisplayName)"" "
    Get-UnifiedGroup $ug.Name | Remove-UnifiedGroup -Confirm:$false
}
#endregion