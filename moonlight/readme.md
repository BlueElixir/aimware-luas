IMPORTANT

This changelog contains all the previous, current and near-future updates of moonlight.
These update logs might not be 100% accurate and can be imperfect, that's just how it is.
Update logs for future versions indicate what's (probably) coming in that version.

<br><br><br>
v0.1 release 08-05-2022
- added indicators and watermark
- added bindable backtrack switcher (from 0 to 50, from 50 to 100 etc.)
- added backtrack randomisation
- added option to change triggerbot values for multiple weapon groups at the same time
- added bindable esp toggle
- added aspect ratio changer
- added viewmodel / autoexec / custom moonlight theme import

<br><br><br>
v0.2 release 09-05-2022
- added more options to esp toggle
- added esp on dead
- improved version check logic

<br><br><br>
v0.3 release 10-05-2022
- added engine radar
- added start/stop mm queue buttons
- added separate toggle for other settings in esp tab
- added ping to watermark
- fixed esp on dead
- changed default aspect ratio value to 178 instead of 177
- improved esp toggle logic
- has defuser esp flag now properly saves with config

<br><br><br>
v0.4 release 16-05-2022
- added full support for Customish Healthbar lua
- added toggleable moonlight logo to watermark
- added toggleable box around indicators
- added website and update buttons when script is outdated
- fixed not having a triggerbot key set spamming console and messing up indicators

<br><br><br>
v0.5 release 20-05-2022
- added custom spectator list
- added new style of indicators
- added option to switch between old and new styles of indicators
- added force crosshair on snipers

<br><br><br>
v0.6 25-05-2022
- spectator list now shows up either when someone is spectating you or menu is open
- added player avatars to spectator list
- added title "Spectators" to spectator list
- added colour customisation for player names and spectator list title
- added automatic avatar refresh on certain conditions
- fixed "healthbar" and "healthnum" not being disabled if "esp toggle" is off and "toggle healthbar" is on
- fixed "HP Colours" setting not working if esp toggle is off
- added some secret easter eggs (if you don't like them just let me know)

<br><br><br>
v0.7 11-06-2022
- added a wiki page that explains what each setting does in more detail https://github.com/BlueElixir/aimware-luas/wiki/moonlight-features-explanation-and-recommended-settings
- fixed "moonlight v0.x.lua:2: attempt to index a nil value" error. if you find any more, please let me know
- added manual buybot (bind to a key, all options configurable in menu, don't spam it unless you want to get kicked from the server)
  * added option to autobuy on round start
- indicators now show up either when player is in game or menu is open
- indicators "new" style improved, more in-line with what the spectator list looks like (on/off status, https://gcdnb.pbrd.co/images/BuAl9wBk9dnD.png?o=1)
  * in the future, i might add more indicator styles, however i can't guarantee that
  * the "new" style might be improved a bit more after this (toggles with "off" status are removed, only "on" are added, similar to speclist)
- old indicator style no longer shows backtrack
- added toggle for showing avatars in spectator list
- added the option to apply custom colour filter on avatars in spectator list (set to white to clear it)
- completely reworked backtrack
  * added per-weapon group backtrack time
  * added the option to increase/decrease the backtrack time for the current weapon group using keybinds
  * added the option to set a custom backtrack change value for the increase/decrease function
  * added the option to set a custom backtrack randomisation amount
  * added bactrack + ping option (adds your ping to the backtrack time)
  * added the option to set a custom ping multiplier (multiplier = 0.67, 100ms ping --> your current setting + 67ms)
  * backtrack weapon group automatically changes when you switch weapons (exactly what ragebot -> accuracy does when switching weapons)
- changed button size in "Other" -> "Imports" and "Fun" sections
- aspect ratio can now be modified more precisely and default value is now 177.7 (16:9)
- added magnet triggerbot (uses settings from aimbot tab, force enables aimbot, recommended to bindhold to whatever you triggerbot key is!!!)

<br><br><br>

as of right now i don't feel like doing any coding as i've reached pretty much what i wanted to achieve with this script.
i might come back for some time and do a bit of coding once in a while.

there is no eta for the next update, don't expect anything to come out soon.

what caused this drop in eagerness to continue updating and developing this script is mostly the reaction received after i published v0.7. i added a per-weapon legit backtrack option, which many people actually wanted, yet, to this day, there has been no reaction. i don't know how to feel about it - is everyone happy with it or does no one even care? without feedback i can't improve, and if i can't improve then what's the point of releasing low-quality and useless scripts?

i genuinely thank everyone who appreciates and supports my work. to everyone else, if you like it, i'm glad. if you don't, well, that's too bad.

i will still be accepting further feedback related to my script and will implement highly-requested features (when someone actually requests something).

important info related to v1.0:
due to constant aimware crashes for reasons unbeknownst to man i decided to call off the project. while it was going smoothly at first, it became apparent that i lack the concentration and motivation necessary to create and maintain a fully custom menu based on a lua api that's bound to change one day.

<br><br><br>

v0.8 eta: soon :)
- added shadow modulation
 - for the best result use highest shadow quality
- added fog modulation
  - (to-do) custom colours for fog
- added the option to change aimware menu icon (previously it was random and you couldn't change it back to default)

<br><br><br>
v1.0 eta: not soon :(
- (planned) bomb information with 2 different styles
- (planned) chams support for esp toggle
- (planned) remove old indicators style
- (scrapped) custom menu

  Post your suggestions on the forums or join my [Discord server](https://discord.gg/XCpTmK8DAw) 
