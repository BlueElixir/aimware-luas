# READ THIS BEFORE USING

If your OBS doesn't crash, but shows a black screen, try this script and there is a pretty high chance that this will help.
It's a full patch, so it moves all DLLs and such to where they have to be.

## Usage Instructions
* 1. Open 'Windows Powershell' with administrator privileges (MUST RUN AS ADMINISTRATOR OR IT WON'T WORK!)
* 2. Paste the following code into the command line:
- `iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/OBS%20FIX/obs-fix.ps1'));`
* 3. Wait for the operation to finish

If everything went well, OBS will work too.
