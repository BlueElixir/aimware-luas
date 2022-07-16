$DesktopPath = [Environment]::GetFolderPath("Desktop")
Write-Progress "got desktop path, downloading obs patch"

$sourcePatch = 'https://github.com/BlueElixir/aimware-luas/raw/main/OBS%20FIX/obs-studio-hook.zip'
$sourceDLL = 'https://github.com/BlueElixir/aimware-luas/raw/main/OBS%20FIX/fixed_obs.zip'
$destinationPatch = "$DesktopPath\obs-studio-hook.zip"
$destinationDLL = "$DesktopPath\fixed_obs.zip"

Invoke-RestMethod -Uri $sourcePatch -OutFile $destinationPatch
Invoke-RestMethod -Uri $sourceDLL -OutFile $destinationDLL
Write-Progress "downloaded obs patch, applying"

Expand-Archive -Path "$DesktopPath\obs-studio-hook.zip" -DestinationPath "C:\Windows" -Force
Write-Progress "applied patch, moving DLLs"

Expand-Archive -Path "$DesktopPath\fixed_obs.zip" -DestinationPath "$DesktopPath" -Force
Move-Item -Path "$DesktopPath\fixed_obs\win-capture.dll" -Destination "C:\Program Files\obs-studio\obs-plugins\64bit\" -Force
Move-Item -Path "$DesktopPath\fixed_obs\graphics-hook32.dll" -Destination "C:\Program Files\obs-studio\data\obs-plugins\win-capture\graphics-hook32.dll" -Force
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
