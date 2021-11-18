## Removing groups using Powershell from Office 365 Tenant
# Medium URL: https://j0rt3g4.medium.com/microsoft-tasks-disallow-users-to-delete-tasks-they-dont-own-3e5241adb654
# GITHUB Repository: https://github.com/j0rt3g4/medium/blob/d3e5c5ebb9492c508e625850d577b464e2e18e67/Get%20root%20and%20All%20Folder%20size%20within%20a%20drive%20on%20your%C2%A0computer/Get-FoldersSize.ps1
# GIFT File : http://g.recordit.co/Q7BCvqMXBF.gif
# RECORDIT : https://recordit.co/Q7BCvqMXBF
# Youtube Video: https://youtu.be/DxxrQx9uWS4

#requires -version 5.0

[cmdletbinding()]
Param(
    #Drive parameter it should be only the drive letter ex: c:\  d:\ e:\ (it's not case sensitive)
    [Parameter(mandatory=$false,Position=0)]$Drive="E:\",
    #How would you like the output to be, 
    #First10 => on screen 1st 10
    #First10toFile => output CSV 1st 10 result into current user's desktop as CSV File with name Size10D.csv, where "D" comes from the letter drive.
    #OnScreen => Full list on screen (Default Behavior)
    #OnFile => Full output list on File into current user's desktop as CSV File with name SizeD.csv , where "D" comes from the letter drive.
    [Parameter(mandatory=$false,Position=1)][ValidateSet("First10","First10toFile","OnScreen","OnFile")]$DoReport="OnScreen"
)

$Report=@()

$i=1; $j=0;

$allDirectories= Get-ChildItem -Path $Drive -Directory -Force | Select -ExpandProperty FullName
$total = $allDirectories.Count + 1

[Long]$length=0
$Size  = Gci -Path $Drive -File | select -ExpandProperty Length
foreach($ss in $Size){
    $length+= [Long]$ss
}

Write-Progress -Activity "Calculating busy Disk space in $Drive drive" -PercentComplete ($i*100/$total) -id 1

$Report+=New-Object -TypeName psobject -Property @{"Folder"=$Drive;"SizeInGB" = $length/1Gb}

foreach($dir in $allDirectories){
    Write-Progress -Activity "Calculating busy Disk space in $Drive drive" -PercentComplete ($i*100/$total) -id 1
    
    Write-Progress -Activity "Working with Folder: $dir" -PercentComplete $(Get-Random -Minimum 1 -Maximum 95) -id 2 -ParentId 1

    [Long]$length=0
    if($dir -like "*$*" -or $dir -like "*system Volume Information*"){
        continue;
    }
    $Size  = Gci -Path $dir -File -Recurse  | select -ExpandProperty Length

    foreach($ss in $Size){
        $length+= [Long]$ss
    }

   $report+= New-Object -TypeName psobject -Property @{"Folder"=$dir;"SizeInGB" = $length/1Gb}
   Write-Progress -Activity "Working with Folder: $dir" -PercentComplete 100 -id 2 -ParentId 1 -Completed
   $i++
}

Write-Progress -Activity "Calculating busy Disk space in $Drive drive" -PercentComplete 100 -id 1 -Completed

Switch($DoReport){
     "First10toFile" { $Report| Sort-Object SizeInGB -Descending | select -First 10 | Export-Csv -NoTypeInformation "$env:userprofile\desktop\Sizes10$($Drive.Split(':')[0]).csv"; break;}
     "First10"       { $Report| Sort-Object SizeInGB -Descending | select -First 10; break;}
     "OnScreen"      { $Report| Sort-Object SizeInGB -Descending; break;}
     "OnFile"        { $Report| Sort-Object SizeInGB -Descending | Export-Csv -NoTypeInformation "$env:userprofile\desktop\Sizes$($Drive.Split(':')[0]).csv"; break;}
}
