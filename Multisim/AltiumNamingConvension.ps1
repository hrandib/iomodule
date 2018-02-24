$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Write-host $dir
$name = (Get-ChildItem $dir -Filter *.ms14).BaseName
$gerberPath = "$dir/Ultiboard Exports"
$files = Get-ChildItem $gerberPath

$exportDir = "$dir/Altium"

If(!(Test-Path $exportDir)) {
    New-Item -ItemType directory $exportDir
}

Function CopyAltium {
    Write-Host "$($args[0].Name) -> $($name + '.' + $args[1])"
    Copy-Item "$gerberPath/$($args[0].Name)" -Destination "$exportDir/$($name + '.' + $args[1])" -Force
}

ForEach($file in $files) {
    Switch -Wildcard ($file.Name) {
    "*- Board Outline.gbr" { CopyAltium $file 'GKO'; Break }
    "*- Copper Bottom.gbr" { CopyAltium $file 'GBL';Break }
    "*- Copper Top.gbr" { CopyAltium $file 'GTL';Break }
    "*- Silkscreen Bottom.gbr" { CopyAltium $file 'GBO';Break }
    "*- Silkscreen Top.gbr" { CopyAltium $file 'GTO';Break }
    "*- Solder Mask Bottom.gbr" { CopyAltium $file 'GBS';Break }
    "*- Solder Mask Top.gbr" { CopyAltium $file 'GTS';Break }
    "*.drl" { CopyAltium $file 'txt';Break }
    } 
}