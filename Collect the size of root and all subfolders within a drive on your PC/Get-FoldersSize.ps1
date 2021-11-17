[cmdletbinding()]
Param(
    [Parameter(mandatory=$false,Position=0)]$Drive="E:\"
)



$Report=@()
$i=0; $j=0;

$allDirectories= Get-ChildItem -Path $Drive -Directory -Force | Select -ExpandProperty FullName
$total = $allDirectories.Count + 1

 [Long]$length=0
 $Size  = Gci -Path $Drive -File | select -ExpandProperty Length
 foreach($ss in $Size){
    $length+= [Long]$ss
}


$i++;
Write-Progress -Activity "Calculating busy Disk space in $Drive drive" -PercentComplete ($i*100/$total) -id 1

$Report+=New-Object -TypeName psobject -Property @{"Folder"=$Drive;"Size" = $length/1Gb}




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

   $report+= New-Object -TypeName psobject -Property @{"Folder"=$dir;"Size" = $length/1Gb}

   Write-Progress -Activity "Working with Folder: $dir" -SecondsRemaining 0.5 -PercentComplete 100 -id 2 -ParentId 1 -Completed
   $i++
 }

 Write-Progress -Activity "Calculating busy Disk space in $Drive drive" -PercentComplete 100 -id 1 -Completed
 $Report| Sort-Object Size -Descending #| select -First 10
