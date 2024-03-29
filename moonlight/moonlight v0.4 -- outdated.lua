local scriptVersion = "0.4" -- do not edit this unless you know what you're doing
local latestScriptVersion = http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/ver.txt"):gsub("\n", "")
gui.Command("cls")
if scriptVersion == latestScriptVersion then
	print("\n\nYou're running the latest version of moonlight (v" .. scriptVersion .. ")!")
elseif scriptVersion < latestScriptVersion then
	print("\n\nYou're running an older or modified version of moonlight (v" .. scriptVersion .. ")!")
	print("Latest offical version: v" .. latestScriptVersion)
	print("Get it @ http://moonlightscript.ml/")
	print("Disable this notice by changing the scriptVersion at the top to v" .. latestScriptVersion .. "!\n\n")
else
	print("\n\nYou're running a modified version of moonlight (v" .. scriptVersion .. ")!")
end


local logoImageData = http.Get("https://blueelixir.github.io/aimware-luas/images/moonlight.png")
local logoImageDataRGBA, logoImageDataWidth, logoImageDataHeight = common.DecodePNG(logoImageData)
local logoImageTexture = draw.CreateTexture(logoImageDataRGBA, logoImageDataWidth, logoImageDataHeight)
local moonlightGui = gui.XML(
[[
	<Window var="moonlight" name="       moonlight           " width="600" height="600">
		<Tab var="main" name="Main"></Tab>
		<Tab var="legit" name="Legit"></Tab>
		<Tab var="esp" name="ESP"></Tab>
		<Tab var="other" name="Other"></Tab>
	</Window>
]])

local mainTab 	=  moonlightGui:Reference("main")
local legitTab	=  moonlightGui:Reference("legit")
local espTab 	=  moonlightGui:Reference("esp")
local otherTab	=  moonlightGui:Reference("other")

local moonlightFont1 = draw.CreateFont("Bahnschrift Light", 20, 0, 900)
local moonlightFont2 = draw.CreateFont("Sitka Small", 20, 0, 0)
local moonlightFont3 = draw.CreateFont("Bahnschrift Light", 10, 0, 0)
local moonlightFont4 = draw.CreateFont("Sitka Small", 15, 0, 0)

local screenWidth, screenHeight = draw.GetScreenSize()
local moduleWidth = screenWidth * 0.07 -- 0.5 centre
local moduleHeight = screenHeight * 0.46 -- 0.485 above crosshair



--  ███    ███  █████  ██ ███   ██ 
--  ████  ████ ██   ██ ██ ████  ██ 
--  ██ ████ ██ ███████ ██ ██ ██ ██ 
--  ██  ██  ██ ██   ██ ██ ██  ████ 
--  ██      ██ ██   ██ ██ ██   ███ 

local mainScriptToggleBox = gui.Groupbox(mainTab, "Master Switch", 10, 10, 285, 30)
local scriptToggle = gui.Checkbox(mainScriptToggleBox, "scriptToggle", "Master Switch", false)
scriptToggle:SetDescription("Enable moonlight lua script.");

local mainTabInterface = gui.Groupbox(mainTab, "Visual Interface", 10, 130, 285, 50)
local displayMoonlightWatermark = gui.Checkbox(mainTabInterface, "displayMoonlightWatermark", 'Display Watermark', false)
displayMoonlightWatermark:SetDescription('Show moonlight watermark on the screen.');
local displayMoonlightLogo = gui.Checkbox(mainTabInterface, "displayMoonlightLogo", 'Display Logo', false)
displayMoonlightLogo:SetDescription('Show moonlight logo in the watermark.');
displayMoonlightLogo:SetInvisible(true)

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and displayMoonlightWatermark:GetValue() then
		local ping = ""
		if entities.GetLocalPlayer() ~= nil then
			ping = " | " .. (entities.GetPlayerResources():GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex()) .. " ms")
		end
		draw.SetFont(moonlightFont4)
		local user = cheat.GetUserName()
		local temp = draw.GetTextSize(user .. ping)
		draw.Color(0, 0, 20, 255)
		if displayMoonlightLogo:GetValue() then
			draw.ShadowRect(screenWidth-116-temp, 20, screenWidth-20, 42, 4)
			draw.Color(57, 108, 255, 255)
			draw.Line(screenWidth-116-temp, 20, screenWidth-20, 20)
			draw.Color(255, 255, 255, 255)
			draw.TextShadow(screenWidth-90-temp, 27, "moonlight | " .. user .. ping)
			draw.SetTexture(logoImageTexture)
			draw.FilledRect(screenWidth-111-temp, 22, screenWidth-93-temp, 40) -- 18x18px
		else
			draw.ShadowRect(screenWidth-96-temp, 20, screenWidth-20, 42, 4)
			draw.Color(57, 108, 255, 255)
			draw.Line(screenWidth-96-temp, 20, screenWidth-20, 20)
			draw.Color(255, 255, 255, 255)
			draw.TextShadow(screenWidth-90-temp, 27, "moonlight | " .. user .. ping)
		end
		displayMoonlightLogo:SetInvisible(false)
	else
		displayMoonlightLogo:SetInvisible(true)
	end
end)

local displayToggles = gui.Checkbox(mainTabInterface, "showIndicators", "Show Indicators", false)
displayToggles:SetDescription("Enable indicators.");
local displayTogglesBox = gui.Checkbox(mainTabInterface, "showBoxAroundIndicators", "Draw Indicator Box", false)
displayTogglesBox:SetDescription("Draw a box around indicators for better visibility.");
displayTogglesBox:SetInvisible(true)

local minimiseBox = gui.Groupbox(mainTab, "Window Options", 430, 435, 160, 40)
local minimiseWindow = gui.Window("minimiseWindow", "moonlight mini", 100, 100, 160, 90)
minimiseWindow:SetActive(true)

local minimise = nil
local minimiseToggle1 = gui.Button(minimiseBox, "Minimise", function()
	minimise = true
end)
local minimiseToggle2 = gui.Button(minimiseWindow, "Maximise", function()
	minimise = false
end)

local function gui_controller()
	if minimise then
		moonlightGui:SetInvisible(true)
		if not gui.Reference("Menu"):IsActive() then
			minimiseWindow:SetActive(false)
		else
			minimiseWindow:SetActive(true)
		end
	else
		minimiseWindow:SetActive(false)
		if not gui.Reference("Menu"):IsActive() then
			moonlightGui:SetInvisible(true)
		else
			moonlightGui:SetInvisible(false)
		end
	end
end
callbacks.Register("Draw", gui_controller)

local mainScriptInfoBox = gui.Groupbox(mainTab, "Welcome to moonlight v" .. scriptVersion, 305, 10, 285, 30)
local usageInformation = gui.Text(mainScriptInfoBox, [[

Thank you for using my script.
Make sure to turn on the Master Switch!

The settings in the "Other" category can be used
without enabling the Master Switch.


User: ]] .. cheat.GetUserName() .. "\nUser ID: " .. cheat.GetUserID())
if scriptVersion < latestScriptVersion then
	local warnUserAboutUpdate = gui.Text(mainScriptInfoBox, "A new version of moonlight is available!\nCurrently running v" .. scriptVersion .. ", latest release: v" .. latestScriptVersion)
	local updateMoonlight = gui.Button(mainScriptInfoBox, "Update to v" .. latestScriptVersion, function()
		http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/moonlight%20v" .. latestScriptVersion .. ".lua", function(content)
			local f = file.Open("moonlight v".. latestScriptVersion .. ".lua" , "w")
			f:Write(content)
			f:Close()
		end)
	end)
	local moonlightWebsite = gui.Button(mainScriptInfoBox, "Website", function()
		panorama.RunScript('SteamOverlayAPI.OpenExternalBrowserURL("http://moonlightscript.ml/")')
	end)
elseif scriptVersion ~= latestScriptVersion then
	local warnUserAboutUpdate = gui.Text(mainScriptInfoBox, "You are using a modified version of moonlight!\nCurrently running v" .. scriptVersion .. ", latest release: v" .. latestScriptVersion)
end

local mainMenuCredits = gui.Groupbox(mainTab, "Made by xBlue | 404765", 10, 484, 158, 0)

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() == false then
		legitTab:SetDisabled(true)
		espTab:SetDisabled(true)
		mainTabInterface:SetDisabled(true)
	else
		legitTab:SetDisabled(false)
		espTab:SetDisabled(false)
		mainTabInterface:SetDisabled(false)
	end
end)



--  ██    ██  █████  ██████   ██████ 
--  ██    ██ ██   ██ ██   ██ ██      
--   ██  ██  ███████ ██████   █████  
--    ████   ██   ██ ██   ██      ██ 
--     ██    ██   ██ ██   ██ ██████  

local espMainVariables = {
	"esp.overlay.enemy.name",
	"esp.overlay.enemy.health.healthbar",
	"esp.overlay.enemy.health.healthnum",
	"esp.overlay.enemy.weapon", -- 4 int value
	"esp.overlay.enemy.ammo",
	"esp.overlay.enemy.money",
	"esp.overlay.enemy.dormant",
	"esp.overlay.enemy.defusing",
	"esp.overlay.enemy.planting",
	"esp.overlay.enemy.scoped",
	"esp.overlay.enemy.reloading",
	"esp.overlay.enemy.flashed",
	"esp.overlay.enemy.hasdefuser",
	"esp.overlay.enemy.hasc4",
	"esp.overlay.enemy.ping",
	"esp.overlay.weapon.name", -- 16 int value
	"esp.overlay.weapon.defuser",
	"esp.overlay.weapon.c4timer",
	"esp.overlay.enemy.box", -- 19 int value
	"esp.overlay.enemy.skeleton",
	"esp.overlay.enemy.armor",
	"esp.overlay.enemy.barrel"
}
local miscOtherVariables = {
	"lbot.master",
	"lbot.extra.backtrack",
	"lbot.trg.enable",
	"lbot.antiaim.type",
	"lbot.aim.enable",
	"misc.autojump",
	"lbot.trg.key",
	"lbot.trg.autofire"
}
local legitTriggerbotDelayItems = {
	"lbot.trg.shared.delay",
	"lbot.trg.zeus.delay",
	"lbot.trg.pistol.delay",
	"lbot.trg.hpistol.delay",
	"lbot.trg.smg.delay",
	"lbot.trg.rifle.delay",
	"lbot.trg.shotgun.delay",
	"lbot.trg.scout.delay",
	"lbot.trg.asniper.delay",
	"lbot.trg.sniper.delay",
	"lbot.trg.lmg.delay"
}
local legitTriggerbotHitchanceItems = {
	"lbot.trg.shared.hitchance",
	"lbot.trg.zeus.hitchance",
	"lbot.trg.pistol.hitchance",
	"lbot.trg.hpistol.hitchance",
	"lbot.trg.smg.hitchance",
	"lbot.trg.rifle.hitchance",
	"lbot.trg.shotgun.hitchance",
	"lbot.trg.scout.hitchance",
	"lbot.trg.asniper.hitchance",
	"lbot.trg.sniper.hitchance",
	"lbot.trg.lmg.hitchance"
}
local indicatorItems = {}
indicatorItems.toggleList = {
	"aimbot",
	"triggerbot",
	"bunnyhop",
	"esp",
	"backtrack"
}
indicatorItems.toggleColours = {
	{100, 100, 100, 255},
	{3, 252, 165, 255},	 
	{3, 252, 74, 255},	 
	{3, 132, 252, 255},	 
	{212, 51, 51, 255},	 
}
indicatorItems.toggleListValues = {
	0,
	0,
	0,
	0,
	1
}
local isHealthBarEspEnabled



--  ██      ███████  ██████  ██ ████████ 
--  ██      ██      ██       ██    ██    
--  ██      █████   ██   ██  ██    ██    
--  ██      ██      ██    ██ ██    ██    
--  ███████ ███████  ██████  ██    ██    

local guiBoxLegitMain = gui.Groupbox(legitTab, "Legit Toggle", 10, 10, 285, 50);
local legitTabToggle = gui.Checkbox(guiBoxLegitMain, "legitTabToggle", "Legit Toggle", false)
legitTabToggle:SetDescription("Toggle Legit tab settings.");

local guiBoxLegitBacktrack = gui.Groupbox(legitTab, "Backtrack Settings", 10, 130, 285, 50);
local legitBacktrackItems = {"Off", "Legit", "Normal", "Maximum", "Mexico"}
local legitBacktrackOptions = gui.Combobox(guiBoxLegitBacktrack, "legitBacktrackOptions", "Backtrack Options", unpack(legitBacktrackItems))
legitBacktrackOptions:SetDescription("Backtrack window. 0 / 50 / 100 / 200 / 400 ms")
local legitBacktrackKeybind = gui.Keybox(guiBoxLegitBacktrack, "legitBacktrackKeybind", "Backtrack Cycle", 0)
legitBacktrackKeybind:SetDescription("Cycle through all backtrack modes.")
local legitBacktrackRandomisation = gui.Checkbox(guiBoxLegitBacktrack, "legitBacktrackRandomisation", "Randomise Backtrack Value", false)
legitBacktrackRandomisation:SetDescription("Randomise backtrack value to make it look more legit.")

callbacks.Register("Draw", "legitBacktrack", function()
	if scriptToggle:GetValue() then
		if legitTabToggle:GetValue() then
			local val = legitBacktrackOptions:GetValue()
			local opt = {0, 0, 50, 100, 200, 400}
			if legitBacktrackRandomisation:GetValue() and val then
				gui.SetValue(miscOtherVariables[2], math.random(opt[val+1], opt[val+2]))
			else
				gui.SetValue(miscOtherVariables[2], opt[val+2])
			end
			if legitBacktrackKeybind:GetValue() ~= 0 then
				if input.IsButtonPressed(legitBacktrackKeybind:GetValue()) then
					if val >= 0 and val < 5 then
						val = val + 1
					end
					if val == 5 then
						val = 0
					end
				end
				legitBacktrackOptions:SetValue(val)
			end
			indicatorItems.toggleListValues[5] = val+1
		end
	end
end)

local guiBoxLegitTriggerbot = gui.Groupbox(legitTab, "Triggerbot Settings", 305, 10, 285, 50)
local legitTriggerbotWeapons = gui.Multibox(guiBoxLegitTriggerbot, "Triggerbot Weapons")
local legitTriggerbotWeaponItems = {
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotshared", "Shared", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbottaser", "Taser", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotpistols", "Pistols", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotheavypistols", "Heavy Pistols", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotsmgs", "SMGs", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotrifles", "Rifles", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotshotguns", "Shotguns", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotscout", "Scout", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotautosnipers", "Auto Snipers", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotawp", "AWP", false),
	gui.Checkbox(legitTriggerbotWeapons, "triggerbotlmgs", "LMGs", false)
}
local legitTriggerbotDelay = gui.Slider(guiBoxLegitTriggerbot, "legitUniversalTriggerbotDelay", "Triggerbot Reaction Time", 100, 0, 500)
legitTriggerbotDelay:SetDescription("Change triggerbot reaction time for selected weapons.")
local legitTriggerbotHitchance = gui.Slider(guiBoxLegitTriggerbot, "legitUnviersalTriggerbotHitchance", "Triggerbot Hit Chance", 50, 0, 100)
legitTriggerbotHitchance:SetDescription("Change triggerbot hit chance for selected weapons.")

callbacks.Register("Draw", "legitTriggerbot", function()
	if scriptToggle:GetValue() then
		if legitTabToggle:GetValue() then
			local val1 = legitTriggerbotDelay:GetValue()
			local val2 = legitTriggerbotHitchance:GetValue()
			for i=1, 11, 1 do
				if legitTriggerbotWeaponItems[i]:GetValue() then
					gui.SetValue(legitTriggerbotDelayItems[i], val1)
					gui.SetValue(legitTriggerbotHitchanceItems[i], val2)
				end
			end
		end
	end
end)



--   ███████  ██████ ██████  
--   ██      ██      ██   ██ 
--   █████    █████  ██████  
--   ██           ██ ██      
--   ███████ ██████  ██      

local guiBoxEspMain = gui.Groupbox(espTab, "ESP Settings", 10, 10, 285, 50);
local espTabToggle = gui.Checkbox(guiBoxEspMain, "espt", "ESP Toggle", false);
espTabToggle:SetDescription("Toggle ESP settings. Recommended to bind.");
local espEnableOnDeath = gui.Checkbox(guiBoxEspMain, "espod", "ESP When Dead", false);
espEnableOnDeath:SetDescription("Enables ESP when dead. Disables ESP on round start.")
local espMainToggles = gui.Multibox(guiBoxEspMain, "ESP Display");
espMainToggles:SetDescription("Select what the ESP will draw.");
local espFlagToggles = gui.Multibox(guiBoxEspMain, "ESP Flags");
espFlagToggles:SetDescription("Select which ESP flags will be drawn.");
local enhanceEspPrecision = gui.Checkbox(guiBoxEspMain, "enhanceEspPrecision", "Enhance ESP Precision", false)
enhanceEspPrecision:SetDescription("Improve ESP drawing accuracy.");
callbacks.Register("Draw", function()
    if scriptToggle:GetValue() and espTabToggle:GetValue() and enhanceEspPrecision:GetValue() then
        gui.SetValue("esp.overlay.friendly.precision", true)
        gui.SetValue("esp.overlay.enemy.precision", true)
    else
        gui.SetValue("esp.overlay.friendly.precision", false)
        gui.SetValue("esp.overlay.enemy.precision", false)
    end
end)

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and displayToggles:GetValue() then
		displayTogglesBox:SetInvisible(false)
		if displayTogglesBox:GetValue() then
			draw.Color(20, 20, 20, 20)
			draw.FilledRect(moduleWidth*0.70, moduleHeight+14, moduleWidth*1.30, moduleHeight-14-#indicatorItems.toggleList*14)
			draw.Color(20, 20, 20, 80)
			draw.OutlinedRect(moduleWidth*0.70, moduleHeight+14, moduleWidth*1.30, moduleHeight-14-#indicatorItems.toggleList*14)
		end
	else
		displayTogglesBox:SetInvisible(true)
	end
	if scriptToggle:GetValue() and displayToggles:GetValue() and entities.GetLocalPlayer() then
		draw.SetFont(moonlightFont2)
		for i=1, #indicatorItems.toggleList, 1 do
			draw.Color(100, 100, 100)
			if i == 1 then
				local temp = indicatorItems.toggleListValues[5]
				draw.Color(unpack(indicatorItems.toggleColours[temp]))
			elseif i == 2 then
				local temp = 0
				for i=1, #espMainVariables, 1 do
					if gui.GetValue(espMainVariables[i]) then
						temp = temp +1
					end
				end
				if isHealthBarEspEnabled == 1 then
					temp = temp + 1
				end
				if temp-3 > 0 then
					draw.Color(unpack(indicatorItems.toggleColours[3]))
				end
			elseif i == 3 then
				if gui.GetValue(miscOtherVariables[6]) == 1 then
					draw.Color(unpack(indicatorItems.toggleColours[3]))
				elseif gui.GetValue(miscOtherVariables[6]) == 2 then
					draw.Color(unpack(indicatorItems.toggleColours[4]))
				end
			elseif i == 4 then
				if gui.GetValue(miscOtherVariables[1]) and gui.GetValue(miscOtherVariables[3]) then
					if gui.GetValue(miscOtherVariables[7]) ~= nil and gui.GetValue(miscOtherVariables[7]) ~= 0 then
						if input.IsButtonDown(gui.GetValue(miscOtherVariables[7])) then
							draw.Color(unpack(indicatorItems.toggleColours[3]))
						end
					end
					if gui.GetValue(miscOtherVariables[8]) then
						draw.Color(unpack(indicatorItems.toggleColours[3]))
					end
				end
			elseif i == 5 then
				if gui.GetValue(miscOtherVariables[1]) and gui.GetValue(miscOtherVariables[5]) then
					draw.Color(unpack(indicatorItems.toggleColours[3]))
				end
			end
			local val = draw.GetTextSize(indicatorItems.toggleList[#indicatorItems.toggleList+1-i])
			draw.TextShadow(moduleWidth - val*0.5, moduleHeight-(i * 14), indicatorItems.toggleList[#indicatorItems.toggleList+1-i])
		end
	end
end)

local guiBoxEspOther = gui.Groupbox(espTab, "Other Settings", 305, 10, 285, 30)
local espOtherToggle = gui.Checkbox(guiBoxEspOther, "otherEspToggle", "Other ESP Toggle", false);
espOtherToggle:SetDescription("Enable other ESP settings.")
local engineRadar = gui.Checkbox(guiBoxEspOther, "engineRadar", "Engine Radar", false)
engineRadar:SetDescription("Show enemies in normal radar.")
local rankRevealToggle = gui.Checkbox(guiBoxEspOther, "rankEsp", "Rank Reveal", false)
rankRevealToggle:SetDescription("Show team and enemy ranks in scoreboard.")
local antiObsScreenshot = gui.Checkbox(guiBoxEspOther, "antiObsScreenshot", "Anti-OBS and Anti-Screenshot", false)
antiObsScreenshot:SetDescription("Enable Anti-OBS and Anti-Screenshot.")
local sharedEsp = gui.Checkbox(guiBoxEspOther, "sharedEsp", "Share ESP with team", false)
sharedEsp:SetDescription("Share your ESP information with your team.")
local sharedEspDesc = gui.Text(guiBoxEspOther, "You can only share your ESP information with \nother aimware users!")

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and espOtherToggle:GetValue() then
		gui.SetValue("misc.rankreveal", rankRevealToggle:GetValue())
		gui.SetValue("esp.other.antiobs", antiObsScreenshot:GetValue())
		gui.SetValue("esp.other.antiscreenshot", antiObsScreenshot:GetValue())
		if sharedEsp:GetValue() then
			gui.SetValue("esp.other.sharedesp", 1)
		else
			gui.SetValue("esp.other.sharedesp", 0)
		end
		for i, player in pairs(entities.FindByClass("CCSPlayer")) do
			if engineRadar:GetValue() then        
				player:SetProp("m_bSpotted", 1);
			else
				player:SetProp("m_bSpotted", 0);
			end
		end
	end
end)

local espSettingsItems = {
	gui.Checkbox(espMainToggles, "espOverlayName", "Name", false),
	gui.Checkbox(espMainToggles, "espOverlayHealthbar", "Healthbar", false),
	gui.Checkbox(espMainToggles, "espOverlayHealthnum", "Healthnum", false),
	gui.Checkbox(espMainToggles, "espOverlayWeapon", "Weapon", false),
	gui.Checkbox(espMainToggles, "espOverlayAmmo", "Ammo", false),
	gui.Checkbox(espMainToggles, "espOverlayMoney", "Money", false),
	gui.Checkbox(espMainToggles, "espOverlayDormant", "Dormant", false),
	gui.Checkbox(espFlagToggles, "espOverlayDefusing", "Defusing", false),
	gui.Checkbox(espFlagToggles, "espOverlayPlanting", "Planting", false),
	gui.Checkbox(espFlagToggles, "espOverlayScoped", "Scoped", false),
	gui.Checkbox(espFlagToggles, "espOverlayReloading", "Reloading", false),
	gui.Checkbox(espFlagToggles, "espOverlayFlashed", "Flashed", false),
	gui.Checkbox(espFlagToggles, "espOverlayHasDefuser", "Has Defuser", false),
	gui.Checkbox(espFlagToggles, "espOverlayC4", "Has C4", false),
	gui.Checkbox(espFlagToggles, "espOverlayPing", "Ping", false),
	gui.Checkbox(guiBoxEspMain, "espOverlayItem", "Item ESP", false),
	gui.Checkbox(guiBoxEspMain, "espOverlayDefuser", "Defuser ESP", false),
	gui.Checkbox(guiBoxEspMain, "espOverlayBomb", "Bomb ESP", false),
	gui.Checkbox(espMainToggles, "espOverlayBox", "Box", false),
	gui.Checkbox(espMainToggles, "espOverlaySkeleton", "Skeleton", false),
	gui.Checkbox(espMainToggles, "espOverlayArmor", "Armour", false),
	gui.Checkbox(espMainToggles, "espOverlayBarrel", "Barrel", false)
}

espSettingsItems[16]:SetDescription("Show weapon icons.")
espSettingsItems[17]:SetDescription("Show defusers when missing one.")
espSettingsItems[18]:SetDescription("Show bomb timer.")

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() then
		if espTabToggle:GetValue() then
			for i=1, #espMainVariables, 1 do
				if espSettingsItems[i]:GetValue() then
					gui.SetValue(espMainVariables[i], 1)
				else
					gui.SetValue(espMainVariables[i], 0)
				end
			end
		else
			for i=1, #espMainVariables, 1 do
				gui.SetValue(espMainVariables[i], 0)
			end
		end
		if espEnableOnDeath:GetValue() then
			if not entities.GetLocalPlayer():IsAlive() then
				espTabToggle:SetValue(true)
			end
		end
	end
end)
callbacks.Register("FireGameEvent", function(e)
	if espEnableOnDeath:GetValue() then
		if e:GetName() == "round_prestart" then
			espTabToggle:SetValue(false)
		end
	end
end)
client.AllowListener("round_prestart");
client.AllowListener("player_death");

local guiBoxEspHealth = gui.Groupbox(espTab, "Healthbar Settings", 305, 390, 285, 30)
local healthAmount1 = 60
local healthAmount2 = 30

local toggleAdvancedHealthbar = gui.Checkbox(guiBoxEspHealth, "toggleAdvancedHealthbar", "Toggle Healthbar", false)
toggleAdvancedHealthbar:SetDescription("Automatically turns off built-in healthbar.")

local healthItems = {"Off", "Team only", "Enemy only", "On"}
local healthSelect = gui.Combobox(guiBoxEspHealth, "healthSelect", "Mode", unpack(healthItems))

local healthBasedColours = gui.Checkbox(guiBoxEspHealth, "healthBasedColours", "HP Colours", false)
healthBasedColours:SetDescription("Custom colour for 100/" .. healthAmount1 .. "/" .. healthAmount2 .. "HP.")

local enemyHP1 = gui.ColorPicker(guiBoxEspHealth, "enemyHP1", "Enemy HP 1", 0, 255, 0, 255)
local enemyHP2 = gui.ColorPicker(guiBoxEspHealth, "enemyHP2", "Enemy HP 2", 255, 255, 0, 255)
local enemyHP3 = gui.ColorPicker(guiBoxEspHealth, "enemyHP3", "Enemy HP 3", 255, 0, 0, 255)
local teamHP1 = gui.ColorPicker(guiBoxEspHealth, "teamHP1", "Team HP 1", 0, 255, 0, 255)
local teamHP2 = gui.ColorPicker(guiBoxEspHealth, "teamHP2", "Team HP 2", 255, 255, 0, 255)
local teamHP3 = gui.ColorPicker(guiBoxEspHealth, "teamHP3", "Team HP 3", 255, 0, 0, 255)
local enemyColourHealth = gui.ColorPicker(guiBoxEspHealth, "enemyColourHealth", "not supposed to see this", 255, 255, 255, 255)
local enemyColourNumberHealth = gui.ColorPicker(guiBoxEspHealth, "enemyColourNumberHealth", "not supposed to see this", 255, 255, 255, 255)
local teamColourHealth = gui.ColorPicker(guiBoxEspHealth, "teamColourHealth", "not supposed to see this", 255, 255, 255, 255)
local teamColourNumberHealth = gui.ColorPicker(guiBoxEspHealth, "teamColourNumberHealth", "not supposed to see this", 255, 255, 255, 255)
enemyColourHealth:SetInvisible(true)
enemyColourNumberHealth:SetInvisible(true)
teamColourHealth:SetInvisible(true)
teamColourNumberHealth:SetInvisible(true)
enemyHP1:SetInvisible(true)
enemyHP2:SetInvisible(true)
enemyHP3:SetInvisible(true)
teamHP1:SetInvisible(true)
teamHP2:SetInvisible(true)
teamHP3:SetInvisible(true)

local colourEnemy = gui.ColorPicker(guiBoxEspHealth, "colourEnemy", "Enemy Colour", 0, 141, 255, 255)
local colourEnemyNumber = gui.ColorPicker(guiBoxEspHealth, "colourEnemyNumber", "Enemy Number Colour", 0, 141, 255, 255)
local colourTeam = gui.ColorPicker(guiBoxEspHealth, "colourTeam", "Team Colour", 0, 255, 0, 255)
local colourTeamNumber = gui.ColorPicker(guiBoxEspHealth, "colourTeamNumber", "Team Number Colour", 0, 255, 0, 255)

local showHealthNumber = gui.Checkbox(guiBoxEspHealth, "showHealthNumber", "Show number", false)
showHealthNumber:SetDescription("Show health number with healthbar.")
local healthPositionItems = {"Left", "Right"}
local healthposition = gui.Combobox(guiBoxEspHealth, "healthposition", "Mode", unpack(healthPositionItems))
healthposition:SetDescription("Choose healthbar position.")

callbacks.Register("Draw", function()
	if toggleAdvancedHealthbar:GetValue() and scriptToggle:GetValue() and espTabToggle:GetValue() then
		if healthSelect:GetValue() ~= 0 then
			isHealthBarEspEnabled = 1
		else
			isHealthBarEspEnabled = 0
		end
		gui.SetValue(espMainVariables[2], 0)
		gui.SetValue(espMainVariables[3], 0)
		espSettingsItems[2]:SetDisabled(true)
		espSettingsItems[3]:SetDisabled(true)
		espSettingsItems[2]:SetValue(false)
		espSettingsItems[3]:SetValue(false)
	else
		isHealthBarEspEnabled = 0
		espSettingsItems[2]:SetDisabled(false)
		espSettingsItems[3]:SetDisabled(false)
    end
end)

local function customHealthbarEsp(builder)
    local localPlayer = entities.GetLocalPlayer()
    local ent = builder:GetEntity()
    local health = ent:GetHealth()
    if toggleAdvancedHealthbar:GetValue() and scriptToggle:GetValue() and espTabToggle:GetValue() then
		if healthSelect:GetValue() ~= 0 then
			isHealthBarEspEnabled = 1
		end
		gui.SetValue(espMainVariables[2], 0)
		gui.SetValue(espMainVariables[3], 0)
		espSettingsItems[2]:SetDisabled(true)
		espSettingsItems[3]:SetDisabled(true)
		espSettingsItems[2]:SetValue(false)
		espSettingsItems[3]:SetValue(false)
        if ent:IsPlayer() then
            if health >= healthAmount1 then
                enemyColourHealth:SetValue(enemyHP1:GetValue())
                enemyColourNumberHealth:SetValue(enemyHP1:GetValue())
                teamColourHealth:SetValue(teamHP1:GetValue())
                teamColourNumberHealth:SetValue(teamHP1:GetValue())
            elseif health >= healthAmount2 and health < healthAmount1 then
                enemyColourHealth:SetValue(enemyHP2:GetValue())
                enemyColourNumberHealth:SetValue(enemyHP2:GetValue())
                teamColourHealth:SetValue(teamHP2:GetValue())
                teamColourNumberHealth:SetValue(teamHP2:GetValue())
            elseif health < healthAmount2 then
                enemyColourHealth:SetValue(enemyHP3:GetValue())
                enemyColourNumberHealth:SetValue(enemyHP3:GetValue())
                teamColourHealth:SetValue(teamHP3:GetValue())
                teamColourNumberHealth:SetValue(teamHP3:GetValue())
            end
        end
        if healthSelect:GetValue() == 1 then
            if ent:IsPlayer() and ent:GetTeamNumber() == localPlayer:GetTeamNumber() then
                if healthposition:GetValue() == 0 then
                    if healthBasedColours:GetValue() then
                        builder:Color(teamColourHealth:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(teamColourNumberHealth:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if healthBasedColours:GetValue() then
                        builder:Color(teamColourHealth:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(teamColourNumberHealth:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
        elseif healthSelect:GetValue() == 2 then
            if ent:IsPlayer() and ent:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
                if healthposition:GetValue() == 0 then
                    if healthBasedColours:GetValue() then
                        builder:Color(enemyColourHealth:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(enemyColourNumberHealth:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if healthBasedColours:GetValue() then
                        builder:Color(enemyColourHealth:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(enemyColourNumberHealth:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
        elseif healthSelect:GetValue() == 3 then
            if ent:IsPlayer() and ent:GetTeamNumber() == localPlayer:GetTeamNumber() then
                if healthposition:GetValue() == 0 then
                    if healthBasedColours:GetValue() then
                        builder:Color(teamColourHealth:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(teamColourNumberHealth:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if healthBasedColours:GetValue() then
                        builder:Color(teamColourHealth:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(teamColourNumberHealth:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
            if ent:IsPlayer() and ent:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
                if healthposition:GetValue() == 0 then
                    if healthBasedColours:GetValue() then
                        builder:Color(enemyColourHealth:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(enemyColourNumberHealth:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if healthBasedColours:GetValue() then
                        builder:Color(enemyColourHealth:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if healthBasedColours:GetValue() then
                            builder:Color(enemyColourNumberHealth:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
		end
    end
end

callbacks.Register("Draw", function()
    if healthBasedColours:GetValue() and scriptToggle:GetValue() and espTabToggle:GetValue() then
        colourEnemy:SetInvisible(true)
        colourEnemyNumber:SetInvisible(true)
        colourTeam:SetInvisible(true)
        colourTeamNumber:SetInvisible(true)
		enemyHP1:SetInvisible(false)
		enemyHP2:SetInvisible(false)
		enemyHP3:SetInvisible(false)
		teamHP1:SetInvisible(false)
		teamHP2:SetInvisible(false)
		teamHP3:SetInvisible(false)
    else
        colourEnemy:SetInvisible(false)
        colourEnemyNumber:SetInvisible(false)
        colourTeam:SetInvisible(false)
        colourTeamNumber:SetInvisible(false)
		enemyHP1:SetInvisible(true)
		enemyHP2:SetInvisible(true)
		enemyHP3:SetInvisible(true)
		teamHP1:SetInvisible(true)
		teamHP2:SetInvisible(true)
		teamHP3:SetInvisible(true)
    end
end)
callbacks.Register("DrawESP", "customHealthbarEsp", customHealthbarEsp);


--   █████  ████████ ██   ██ ███████ ██████  
--  ██   ██    ██    ██   ██ ██      ██   ██ 
--  ██   ██    ██    ███████ █████   ██████  
--  ██   ██    ██    ██   ██ ██      ██   ██ 
--   █████     ██    ██   ██ ███████ ██   ██ 

local guiBoxOtherMain = gui.Groupbox(otherTab, "Other Settings", 10, 10, 285, 50)
local aspectRatioChangerToggle = gui.Checkbox(guiBoxOtherMain, "aspect_ratio_check", "Aspect Ratio Changer", false)
aspectRatioChangerToggle:SetDescription("Set custom aspect ratio. 100 - 1:1, 133 - 4:3, 178 - 16:9")
local aspectRatioChangerValue = gui.Slider(guiBoxOtherMain, "aspectRatioChangerValue", "Aspect Ratio", 178, 1, 200)
callbacks.Register("Draw", function()
	local val
	if aspectRatioChangerToggle:GetValue() == true then
		val = aspectRatioChangerValue:GetValue()/100
	else
		val = screenWidth/screenHeight
	end
	client.SetConVar("r_aspectratio", val, true)
end)

local guiBoxOtherMainImports = gui.Groupbox(guiBoxOtherMain, "Import Settings", 0, 100, 255, 50)
local setViewmodel = gui.Button(guiBoxOtherMainImports, "viewmodel", function()
	client.Command("viewmodel_offset_x 2; viewmodel_offset_y 2; viewmodel_offset_z -2; viewmodel_fov 68; cl_righthand 1; cl_bobcycle 0; cl_bobamt_vert 0; cl_bobamt_vert 0; cl_bobamt_lat 0; cl_bob_lower_amt 0", true)
end)
local importAutoexecConfig = gui.Button(guiBoxOtherMainImports, "autoexec.cfg", function()
	client.Command("exec autoexec", true)
end)
local importMoonlightTheme = gui.Button(guiBoxOtherMainImports, "moonlight theme", function()
	gui.SetValue("theme.footer.bg", 0, 0, 0, 255)
	gui.SetValue("theme.header.bg", 0, 0, 0, 255)
	gui.SetValue("theme.nav.active", 0, 0, 0, 255)
	gui.SetValue("theme.nav.bg", 0, 0, 0, 255)
	gui.SetValue("theme.tablist.tabactivebg", 0, 0, 0, 255)
	gui.SetValue("theme.footer.text", 57, 108, 255, 255)
	gui.SetValue("theme.header.line", 57, 108, 255, 255)
	gui.SetValue("theme.header.text", 57, 108, 255, 255)
	gui.SetValue("theme.nav.shadow", 57, 108, 255, 255)
	gui.SetValue("theme.nav.text", 57, 108, 255, 255)
	gui.SetValue("theme.tablist.shadow", 57, 108, 255, 255)
	gui.SetValue("theme.tablist.tabdecorator", 57, 108, 255, 255)
	gui.SetValue("theme.tablist.text", 57, 108, 255, 255)
	gui.SetValue("theme.tablist.textactive", 57, 108, 255, 255)
	gui.SetValue("theme.ui.bg1", 24, 24, 24, 255)
	gui.SetValue("theme.ui.bg2", 57, 108, 255, 255)
	gui.SetValue("theme.ui.border", 57, 108, 255, 255)
end)

local guiBoxOtherFun = gui.Groupbox(otherTab, "Fun", 10, 385, 285, 50)
local startQueueButton = gui.Button(guiBoxOtherFun, "Start MM Queue", function()
	panorama.RunScript('LobbyAPI.StartMatchmaking("", "", "", "")')
end)
local cancelQueueButton = gui.Button(guiBoxOtherFun, "Cancel MM Queue", function()
	panorama.RunScript("LobbyAPI.StopMatchmaking()")
end)

local guiBoxOtherMovement = gui.Groupbox(otherTab, "Movement Settings", 305, 10, 285, 50)
local bunnyHopItems = {"Off", "Legit", "Perfect"}
local bunnyHopMode = gui.Combobox(guiBoxOtherMovement, "bht", "AutoJump Mode", unpack(bunnyHopItems))
bunnyHopMode:SetDescription("Default AutoJump mode.")
local function defaultAutojumpMode()
	if bunnyHopMode:GetValue() == 0 then
		gui.SetValue("misc.autojump", 0)
	elseif bunnyHopMode:GetValue() == 1 then
		gui.SetValue("misc.autojump", 2)
	else
		gui.SetValue("misc.autojump", 1)
	end
end
callbacks.Register("Draw", defaultAutojumpMode)
local otherImportantNotice = gui.Text(guiBoxOtherMovement, [[


This section is under construction.
More features coming in later versions.

If you want something added, do not hesitate
to PM me on the forum or reply to the thread.

You can also DM me on Discord with your
suggestions @ BlueElixir#0001


]])
