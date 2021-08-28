##
# Medium URL: https://j0rt3g4.medium.com/unsplash-api-powershell-8214cfc4c87b
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/d7e5069f02b31e4da27d240319802a8237129d61/OAuth%202.0%20with%20Powershell%20for%20Unsplash%20API%20bearer%C2%A0token/Do-Oauth20forUnsplash.ps1


[Cmdletbinding()]
param(                                                                            
	[Parameter(Mandatory=$false,ValueFromPipeline=$true,Position=0)]$AccessKey =  'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
	[Parameter(Mandatory=$false,ValueFromPipeline=$true,Position=1)]$SecretKey=   'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
	[Parameter(Mandatory=$false,ValueFromPipeline=$true,Position=2)]$Scope='public+read_user+read_photos+write_likes+write_followers+read_collections',
	[Parameter(Mandatory=$false,ValueFromPipeline=$true,Position=3)]$RedirectUriParam="https://localhost:63437/signin-unsplash"
)

#Do not change this 
$global:AccessKey = $AccessKey    
$global:SecretKey = $SecretKey
$global:RedirectUri = $RedirectUriParam
$CleanUpGlobal+="AccessKey"
$CleanUpGlobal+="SecretKey"
$CleanUpGlobal+="RedirectUriParam"

#Clean Up Variable
#Stradegy of clean up save All the names of the variables during the run of the scripts and then just go foreach var in both scope (local and global, one variable for each).
$CleanUpVar=@()
$CleanUpGlobal=@()


Function Show-OAuth2Window {
	[cmdletbinding()]
	param(
		[System.Uri]$Url
	)

	Add-Type -AssemblyName System.Windows.Forms

	$form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=1080;Height=840}
	$web = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=1060;Height=820;Url=($url ) }
	$DocComp = {
		$Global:uri = $web.Url.AbsoluteUri
		if ($Global:Uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
	}
	
	$web.ScriptErrorsSuppressed = $true
	$web.Add_DocumentCompleted($DocComp)
	$form.Controls.Add($web)
	$form.Add_Shown({$form.Activate()})
	$form.ShowDialog() | Out-Null
	$queryOutput = [System.Web.HttpUtility]::ParseQueryString($web.Url.Query)
	$output = @{}
	foreach($key in $queryOutput.Keys){
		$output["$key"] = $queryOutput[$key]
	}
	return $output
	#Write-Output $output
   #Write-Verbose $($web.Url.Query)
}

Function Get-OAuth2Authorization {
	<#
	.SYNOPSIS
	Gets OAuth2 Authorization code
	
	#>
	[cmdletbinding()]
	Param (
		#public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections
		$AuthPage = "https://unsplash.com/oauth/authorize?client_id=$global:AccessKey&redirect_uri=$global:RedirectUri&response_type=code&scope=$Scope"
	)
	
	# Start login
	Add-Type -AssemblyName System.Web
	$loginUrl = "$AuthPage"
	
	Try {
		$queryOutput = Show-OAuth2Window -Url $loginUrl -Verbose
	  
	} 
	Catch {
		Write-error $_.Exception.Message
	}
	return $queryOutput.code`
}
#Using the Authorization Code to Get Tokens
Function Get-OAuth2Token {
	[cmdletbinding()]
	Param(
		[parameter(Mandatory=$false,Position=1)]$Uri ='https://unsplash.com/oauth/token',
		[parameter(Mandatory=$true,Position=0)]$authcode
	)

	Try{
		$uri="$Uri/?client_id=$global:AccessKey&client_secret=$global:SecretKey&redirect_uri=$global:RedirectUri&grant_type=authorization_code&code=$authcode"
		Return Invoke-RestMethod -Method Post -Uri $Uri 
	}
	Catch {
		Write-host "Error occured while using: `n$uri"
		Write-host "Exception Message: $($_.Exception.Message)"
	}
}


Write-host -ForegroundColor Cyan "Getting the Authorization Code" -NoNewline
$code = Get-OAuth2Authorization
Write-host -ForegroundColor Green "`t Done" 
$CleanUpVar+="code"

Write-host -ForegroundColor Cyan "Getting Beared Token Code" -NoNewline
$tmp = Get-OAuth2Token -authcode $code
Write-host -ForegroundColor Green "`t Done" 

if($tmp){
	$CleanUpVar+="tmp"
	$tmp  | fl        
}
else{
	Write-Host "There was an error on the request" -ForegroundColor Red
	exit -1
}


Write-Host -ForegroundColor Magenta "Cleaning up"

$CleanUpVar| ForEach-Object{
	Remove-Variable $_
	}
$CleanUpGlobal | ForEach-Object{
	Remove-Variable -Scope global $_
}
Remove-Variable CleanUpGlobal,CleanUpVar
