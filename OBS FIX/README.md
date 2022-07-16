# READ THIS BEFORE USING

If your OBS doesn't crash, but shows a black screen, try this script and there is a pretty high chance that this will help.<br>
It's a full patch, so it moves all DLLs and such to where they have to be.
<br><br>
Notes:
- you don't need to use aimware to apply the OBS game capture patch. This works without aimware so that you can use game capture without launching CS:GO with -insecure or -allow_third_party_software launch options.
- The DLLs in fixed_obs.zip are from masterlooser18's thread on unknowncheats.
- The files in obs-studio-hook.zip are the same DLLs and some json files related to the DLLs.
- You must close CS:GO and OBS before using the script.
<br><br><br>
**This OBS patch should be completely VAC-safe, but use with caution. I am not responsible for any damage caused by the DLLs' usage.**

## Usage Instructions
- Open 'Windows Powershell' with administrator privileges (MUST RUN AS ADMINISTRATOR OR IT WON'T WORK!)
- Paste the following code into the command line:
~~~~
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/OBS%20FIX/obs-fix.ps1'));
~~~~
- Wait for the operation to finish.

That's it. If you have any issues, feel free to contact me.
