$obs = Get-Process obs64 -ErrorAction SilentlyContinue
$csgo = Get-Process csgo -ErrorAction SilentlyContinue
if ($obs) {
    Write-Host "     Close OBS.      " -BackgroundColor Red -ForegroundColor White
    return
}
if ($csgo) {
    Write-Host "     Close CSGO.     " -BackgroundColor Red -ForegroundColor White
    return
}

$DesktopPath = [Environment]::GetFolderPath("Desktop")
Write-Progress "got desktop path, downloading obs patch"

$sourcePatch = 'https://github.com/BlueElixir/aimware-luas/raw/main/OBS%20FIX/obs-studio-hook.zip'
$sourceDLL = 'https://github.com/BlueElixir/aimware-luas/raw/main/OBS%20FIX/fixed_obs.zip'
$destinationPatch = "$DesktopPath\obs-studio-hook.zip"
$destinationDLL = "$DesktopPath\fixed_obs.zip"
$destDLLwc = "C:\Program Files\obs-studio\obs-plugins\64bit\"
$destDLLgh = "C:\Program Files\obs-studio\data\obs-plugins\win-capture\graphics-hook32.dll"

Invoke-RestMethod -Uri $sourcePatch -OutFile $destinationPatch
Invoke-RestMethod -Uri $sourceDLL -OutFile $destinationDLL
Write-Progress "downloaded obs patch, applying"

Expand-Archive -Path "$DesktopPath\obs-studio-hook.zip" -DestinationPath "C:\Windows" -Force
Write-Progress "applied patch, moving DLLs"

if ([System.IO.File]::Exists($destDLLgh)) {Remove-Item -Path $destDLLgh -Force}
if ([System.IO.File]::Exists($destDLLwc)) {Remove-Item -Path $destDLLwc -Force}

Expand-Archive -Path "$DesktopPath\fixed_obs.zip" -DestinationPath $DesktopPath -Force
Move-Item -Path "$DesktopPath\fixed_obs\win-capture.dll" -Destination $destDLLwc -Force
Move-Item -Path "$DesktopPath\fixed_obs\graphics-hook32.dll" -Destination $destDLLgh -Force
Write-Progress "DLLs moved, patch applied, finishing up"

Remove-Item -Path "$DesktopPath\obs-studio-hook.zip" -Force
Remove-Item -Path "$DesktopPath\fixed_obs.zip" -Force
$directoryInfo = Get-ChildItem "$DesktopPath\fixed_obs\" | Measure-Object
if ($directoryInfo.count -eq 0){
    Remove-Item -Path "$DesktopPath\fixed_obs\"
}
Write-Progress "operation finished"

Write-Host "                                                                                   " -BackgroundColor Black -ForegroundColor White
Write-Host "                                                                                   " -BackgroundColor Black -ForegroundColor White
Write-Host "                 Operation completed. Please restart CS:GO and OBS.                " -BackgroundColor Black -ForegroundColor White
Write-Host "             If the patch failed, please contact me @ BlueElixir#0985.             " -BackgroundColor Black -ForegroundColor White
Write-Host "                                                                                   " -BackgroundColor Black -ForegroundColor White
Write-Host "                                                                                   " -BackgroundColor Black -ForegroundColor White
