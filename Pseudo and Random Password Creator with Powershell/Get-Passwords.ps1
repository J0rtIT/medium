##  Pseudo and random Password creator with Powershell
# Medium URL:        https://j0rt3g4.medium.com/pseudo-and-random-password-creator-with-powershell-2796bd7b830b
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/7daa2312cb0901b4f676d88e01c7bd7310c8b0de/Pseudo%20and%20Random%20Password%20Creator%20with%20Powershell/Get-Passwords.ps1
# YOUTUBE            PENDING


[cmdletbinding(DefaultParameterSetName="default")]
param(
    #Password Number to be created at the same time (to do a sandwich with them), default a concat of 3 passwords
    [Parameter(Mandatory=$false,position=0)]$Npass=3,
    #Longitude of each password (8 by default)
    [Parameter(Mandatory=$false,position=1)]$NLong=8,
    #Special Characters Numbers (default = 0 )
    [Parameter(Mandatory=$false,position=2)]$NSChar=0,
    #Special Characters Numbers (default = 0 )
    [Parameter(Mandatory=$true,position=3,ParameterSetName="other")]$passwords

)

Add-Type -AssemblyName System.Web

Function Pick-Color{
    param(
        [Parameter(Position=0,Mandatory=$false)]$previousColor="none"
    )
    
    do{
        [string]$color=[string]::Empty
        $a = Get-Random -Minimum 1 -Maximum 7
        switch($a){
            1 {$color="Blue";
                break;}
            2 {$color="Cyan";
                break;}
            3 {$color="Gray";
                break;}
            4 {$color="green"
                ;break;}
            5 {$color="magenta";
                break;}
            6 {$color="red";
                break;}
            default {$color="white";
                break;}
        }
    }
    while($color -eq $previousColor)
    return $color
}

switch ($PsCmdlet.ParameterSetName) {
    "default" { 
        Write-Host "Total char numbers in password: $($Npass * $NLong) with $NSChar special chars each"
        for($i=0; $i -lt $Npass;$i++){
            if($i -eq 0){
                [string]$color=Pick-Color
                Write-host -ForegroundColor $color -Object $([System.Web.Security.Membership]::GeneratePassword($NLong,$NSChar)) -NoNewline
            }
            elseif(!($i -eq $Npass - 1)){
                [string]$color=Pick-Color -previousColor $color
                Write-host -ForegroundColor $color $([System.Web.Security.Membership]::GeneratePassword($NLong,$NSChar)) -NoNewline
            }
            else{
                [string]$color=Pick-Color -previousColor $color
                Write-host -ForegroundColor $color $([System.Web.Security.Membership]::GeneratePassword($NLong,$NSChar))
            }
        }
    }
    "other"{
        Write-Host "$passwords passwords with Total $($Npass * $NLong) chars with $NSChar special chars each"
        for($j=0; $j -lt $passwords;$j++){
            for($i=0; $i -lt $Npass;$i++){
                if($i -eq 0){
                    [string]$color=Pick-Color
                    Write-host -ForegroundColor $color -Object $([System.Web.Security.Membership]::GeneratePassword($NLong,$NSChar)) -NoNewline
                }
                elseif(!($i -eq $Npass - 1)){
                    [string]$color=Pick-Color -previousColor $color
                    Write-host -ForegroundColor $color $([System.Web.Security.Membership]::GeneratePassword($NLong,$NSChar)) -NoNewline
                }
                else{
                    [string]$color=Pick-Color -previousColor $color
                    Write-host -ForegroundColor $color $([System.Web.Security.Membership]::GeneratePassword($NLong,$NSChar))
                }
            }
        }
    }
}
