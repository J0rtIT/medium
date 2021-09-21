## Removing groups using Powershell from Office 365 Tenant
# Medium URL: https://j0rt3g4.medium.com/microsoft-tasks-disallow-users-to-delete-tasks-they-dont-own-3e5241adb654
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/master/Removing%20groups%20using%20Powershell%20from%20Office%20365%20Tenant/Remove-O365Groups.ps1

#requires -version 5.0

[CmdletBinding(DefaultParameterSetName='alone')]
param(
	[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="alone")]$UPN,
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
		#Write-host -foregroundColor "Black" -BackgroundColor "White" "Before the Change"
		Write-host -foregroundColor "Black" -BackgroundColor "White" "1st line is the before and the second line is the after"
		Get-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN | select Id, blockDeleteTasksNotCreatedBySelf
		
		#check if false
		if (! $(Get-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN | select -expandproperty blockDeleteTasksNotCreatedBySelf)){
			Set-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN -BlockDeleteTasksNotCreatedBySelf $true
		}
		else{
			Write-host -foregroundColor "Magenta" "No changes were applied since they're already there."
		}
		
		
		
		#AfterTheChange
		#Write-host -foregroundColor "Black" -BackgroundColor "White" "Before the Change"
		Get-PlannerUserPolicy -UserAadIdOrPrincipalName $UPN | select Id, blockDeleteTasksNotCreatedBySelf
	}
	Catch{
		Write-Error "There was an error: $($_.Exception.Message)"
	}
}

if( $PsCmdlet.ParameterSetName -eq "file"){

	try{
		if(!(Test-Path $CSVFile)){
			Write-Host -ForegroundColor Red "The location of the CSVFile (""$CSVFile"") doesn't exists, please provide a valid File"
			exit -1;
		}
	
		Import-Csv $CSVFile | %{ 
			if (! $(Get-PlannerUserPolicy -UserAadIdOrPrincipalName $_.'User principal name' | select -expandproperty blockDeleteTasksNotCreatedBySelf)){
				Set-PlannerUserPolicy -UserAadIdOrPrincipalName $_.'User principal name' -BlockDeleteTasksNotCreatedBySelf $true
			}
			else{
				Write-host -foregroundColor "Magenta" "No changes were applied since they're already there. for user $($_.'User principal name')"
			}
		}
	}
	catch{
		Write-Error "There was an error: $($_.Exception.Message)"
	}
}