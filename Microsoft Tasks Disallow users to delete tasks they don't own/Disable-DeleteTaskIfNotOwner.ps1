## Removing groups using Powershell from Office 365 Tenant
# Medium URL: https://j0rt3g4.medium.com/removing-groups-using-powershell-from-office-365-tenant-b1f2e6de3179
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/master/Removing%20groups%20using%20Powershell%20from%20Office%20365%20Tenant/Remove-O365Groups.ps1

#requires -version 5.0

[CmdletBinding(DefaultParameterSetName='alone')]
param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="alone")]$UPN
    [Parameter(Mandatory=$true ,Position=0,ValueFromPipeline=$true,ParameterSetName="file")]$CSVFile=""
)

#region ConfigureEnvironment
$ModuleLocation="D:\Descargas\PlannerTenantAdmin\plannertenantadmin.psm1"
if($(Get-ExecutionPolicy) -ne 'unrestricted'){
    Set-ExecutionPolicy unrestricted
}

if(!(Test-Path $ModuleLocation)){
    Write-Host -ForegroundColor Red "The location of the module doesn't exists, please open the script and correct the value between """" in line 14 for the path where you unzipped the file with extension psm1."
    exit -1;
}
Import-module $ModuleLocation
#endregion




if($PsCmdlet.ParameterSetName -eq "alone"){
    try{
        #BeforeTheChange
        Get-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN
        Set-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN -BlockDeleteTasksNotCreatedBySelf $true
        #AfterTheChange
        Get-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN
    }
    Catch{
        Write-Error "There was an error: $($_.Exception.Message)"
    }
}
else if($PsCmdlet.ParameterSetName -eq "file"){

    try{
        if(!(Test-Path $CSVFile)){
            Write-Host -ForegroundColor Red "The location of the CSVFile (""$CSVFile"") doesn't exists, please provide a valid File"
            exit -1;
        }
}
        Import-Csv $CSVFile | %{ 
            Set-PlannerUserPolicy -UserAadIdOrPrincipalName $_.UserPrincipalName -BlockDeleteTasksNotCreatedBySelf $true
        }
    }
    catch{

    }
}