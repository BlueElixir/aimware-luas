gui.Command("clear")
local scriptVersion = "0.8"
local latestScriptVersion
if http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/ver.txt") == nil then
	print("Unable to fetch version information. Please check your internet connection.")
	latestScriptVersion = "9"
elseif http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/ver.txt") == "404: Not Found" then
	print([[
Unable to fetch version information. Please post this on the Discord server:
---------------------
download error
file not found
---------------------
]])
	latestScriptVersion = "9"
else
	latestScriptVersion = http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/ver.txt"):gsub("\n", "")
end
if scriptVersion == latestScriptVersion then
	print("\n\nYou're running the latest version of moonlight (v" .. scriptVersion .. ")!")
elseif scriptVersion < latestScriptVersion then
	print("\n\nYou're running an older or modified version of moonlight (v" .. scriptVersion .. ")!")
	print("Latest offical version: v" .. latestScriptVersion)
	print("Get it @ https://www.xbluescripts.xyz/scripts/moonlight/")
else
	print("\n\nYou're running a modified version of moonlight (v" .. scriptVersion .. ")!")
end

local logoImageTexture = draw.CreateTexture(common.DecodePNG(http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/files/logo.png")))
local awlogoImageTexture = draw.CreateTexture(common.DecodePNG(http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/files/awlogo.png")))
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
local moonlightFont2 = draw.CreateFont("Sitka Small", 20, 0, 0) -- indicators style old
local moonlightFont3 = draw.CreateFont("Sitka Small", 18, 0, 0) -- spec list / indicators style new
local moonlightFont4 = draw.CreateFont("Sitka Small", 15, 0, 0) -- watermark

local screenWidth, screenHeight = draw.GetScreenSize()
local moduleWidth = screenWidth * 0.07 -- 0.5 centre
local moduleHeight = screenHeight * 0.46 -- 0.485 above crosshair

local gv = gui.GetValue
local sv = gui.SetValue


--  ███    ███  █████  ██ ███   ██ 
--  ████  ████ ██   ██ ██ ████  ██ 
--  ██ ████ ██ ███████ ██ ██ ██ ██ 
--  ██  ██  ██ ██   ██ ██ ██  ████ 
--  ██      ██ ██   ██ ██ ██   ███ 

local mainScriptToggleBox = gui.Groupbox(mainTab, "Master Switch", 10, 10, 285, 30)
local scriptToggle = gui.Checkbox(mainScriptToggleBox, "masterswitch", "Master Switch", false)
scriptToggle:SetDescription("Enable moonlight lua script.")

local hudOptions = gui.Groupbox(mainTab, "HUD Options", 10, 130, 285, 50)
local drawWatermark = gui.Checkbox(hudOptions, "watermark", 'Draw Watermark', false)
drawWatermark:SetDescription('Show moonlight watermark on the screen.')
local drawWatermarkLogo = gui.Checkbox(hudOptions, "watermark.logo", 'Watermark Logo', false)
drawWatermarkLogo:SetDescription('Show moonlight logo in the watermark.')
drawWatermarkLogo:SetDisabled(true)

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and drawWatermark:GetValue() then
		local ping = ""
		if entities.GetLocalPlayer() ~= nil then
			ping = " | " .. (entities.GetPlayerResources():GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex()) .. " ms")
		end
		draw.SetFont(moonlightFont4)
		local user = cheat.GetUserName()
		local temp = draw.GetTextSize(user .. ping)
		draw.Color(0, 0, 20, 255)
		if drawWatermarkLogo:GetValue() then
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
		drawWatermarkLogo:SetDisabled(false)
	else
		drawWatermarkLogo:SetDisabled(true)
	end
end)

local drawToggles = gui.Checkbox(hudOptions, "toggles", "Draw Toggles List", false)
drawToggles:SetDescription("Show toggles list.")
local drawTogglesColours = {
	gui.ColorPicker(drawToggles, "togglesListWindowNameColour", "Toggles List Window Name Colour", 255, 255, 255, 255),
	gui.ColorPicker(drawToggles, "togglesListNameColour", "Toggles List Name Colour", 57, 108, 255, 255)
}

local minimiseBox = gui.Groupbox(mainTab, "Window Options", 430, 435, 160, 40)
local minimiseWindow = gui.Window("minimiseWindow", "moonlight mini", 100, 100, 160, 90)
minimiseWindow:SetActive(true)
local changeAimwareMenuLogo = gui.Checkbox(hudOptions, "changeAimwareMenuLogo", "Change Menu Icon", false)
changeAimwareMenuLogo:SetDescription("Change default aimware logo to moonlight.")
callbacks.Register("Draw", function()
	if changeAimwareMenuLogo:GetValue() and scriptToggle:GetValue() then
		gui.Reference("Menu"):SetIcon(logoImageTexture, 0.75)
	else
		gui.Reference("Menu"):SetIcon(awlogoImageTexture, 0.8)
	end
end)

if math.random(1, 10) == 8 then
	
end
local minimise = false
local minimiseToggle1 = gui.Button(minimiseBox, "Minimise", function()
	minimise = true
end)
local minimiseToggle2 = gui.Button(minimiseWindow, "Maximise", function()
	minimise = false
end)

callbacks.Register("Draw", gui_controller, function()
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
end)

local mainScriptInfoBox = gui.Groupbox(mainTab, "Welcome to moonlight v" .. scriptVersion, 305, 10, 285, 30)
local additionalText = ""
if math.random(1, 10) == 8 then
	additionalText = [[
If you like what you see, please leave a +rep
on my forums profile! Thanks!

]]
end
local usageInformation = gui.Text(mainScriptInfoBox, [[
Thank you for using my script.

]]
.. additionalText ..
[[
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
		panorama.RunScript('SteamOverlayAPI.OpenExternalBrowserURL("https://www.xbluescripts.xyz/scripts/moonlight/")')
	end)
elseif scriptVersion ~= latestScriptVersion then
	local warnUserAboutUpdate = gui.Text(mainScriptInfoBox, "You are using a modified version of moonlight!\nCurrently running v" .. scriptVersion .. ", latest release: v" .. latestScriptVersion)
end

local mainMenuCredits = gui.Groupbox(mainTab, "Made by xBlue | 404765", 10, 484, 158, 0)

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() == false then
		legitTab:SetDisabled(true)
		espTab:SetDisabled(true)
		hudOptions:SetDisabled(true)
	else
		legitTab:SetDisabled(false)
		espTab:SetDisabled(false)
		hudOptions:SetDisabled(false)
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
local eventList = {
	"round_start",
	"round_end",
	"player_connect",
	"player_disconnect",
	"round_prestart",
	"player_death"
}
local indicatorItems = {}
indicatorItems.toggleList = {
	"aimbot",
	"triggerbot",
	"bunnyhop",
	"esp",
	"backtrack",
	"chams"
}
indicatorItems.toggleColours = {
	{255, 255, 255, 255},
	{3, 252, 165, 255},	 
	{3, 252, 74, 255},	 
	{3, 132, 252, 255},	 
	{212, 51, 51, 255},	 
}
indicatorItems.toggleListBTStates = {
	"off",
	"50",
	"100",
	"200",
	"400"
}
indicatorItems.toggleListValues = {
	0,
	0,
	0,
	0,
	1
}
local btGroupWpns = {
    "Pistols",
    "Heavy Pistols",
    "Rifles",
    "Scout",
    "AWP",
    "Autosniper",
    "SMGs",
    "Shotguns",
    "LMGs",
    "Shared"
}
local isHealthBarEspEnabled

local chamsTogglesEnemy = {
	enemy_model_occluded,				"esp.chams.enemy.occluded"				,	0,
	enemy_model_overlay,				"esp.chams.enemy.overlay"				,	0,
	enemy_model_visible,				"esp.chams.enemy.visible"				,	0,
	enemy_model_glow,					"esp.chams.enemy.glow"					,	0,
	enemy_attachments_occluded,			"esp.chams.enemyattachments.occluded"	,	0,
	enemy_attachments_overlay,			"esp.chams.enemyattachments.overlay"	,	0,
	enemy_attachments_visible,			"esp.chams.enemyattachments.visible"	,	0,
	enemy_ragdoll_occluded,				"esp.chams.enemyragdoll.occluded"		,	0,
	enemy_ragdoll_overlay,				"esp.chams.enemyragdoll.overlay"		,	0,
	enemy_ragdoll_visible,				"esp.chams.enemyragdoll.visible"		,	0,
	enemy_backtrack_occluded,			"esp.chams.backtrack.occluded"			,	0,
	enemy_backtrack_overlay,			"esp.chams.backtrack.overlay"			,	0,
	enemy_backtrack_visible,			"esp.chams.backtrack.visible"			,	0,
	enemy_onshot_occluded,				"esp.chams.onshot.occluded"				,	0,
	enemy_onshot_overlay,				"esp.chams.onshot.overlay"				,	0,
	enemy_onshot_visible,				"esp.chams.onshot.visible"				,	0
}

local chamsTogglesOther = {
	other_weapon_occluded,				"esp.chams.weapon.occluded"				,	0,
	other_weapon_overlay,				"esp.chams.weapon.overlay"				,	0,
	other_weapon_visible,				"esp.chams.weapon.visible"				,	0,
	other_weapon_glow,					"esp.chams.weapon.glow"					,	0,
	other_nades_occluded,				"esp.chams.nades.occluded"				,	0,
	other_nades_overlay,				"esp.chams.nades.overlay"				,	0,
	other_nades_visible,				"esp.chams.nades.visible"				,	0,
	other_nades_glow,					"esp.chams.nades.glow"					,	0
}

local chams_cached = false
local chams_returned = false
local chams_disabled = false



--  ██      ███████  ██████  ██ ████████ 
--  ██      ██      ██       ██    ██    
--  ██      █████   ██   ██  ██    ██    
--  ██      ██      ██    ██ ██    ██    
--  ███████ ███████  ██████  ██    ██    

local guiBoxLegitMain = gui.Groupbox(legitTab, "Legit Toggle", 10, 10, 285, 50)
local legitTabToggle = gui.Checkbox(guiBoxLegitMain, "legitTabToggle", "Legit Toggle", false)
legitTabToggle:SetDescription("Toggle Legit tab settings.")

local guiBoxLegitBacktrack = gui.Groupbox(legitTab, "Backtrack Settings", 10, 130, 285, 50)
local btGroupWpnSelection = gui.Combobox(guiBoxLegitBacktrack, "btGroupWpnSelection", "Backtrack Weapon Group", unpack(btGroupWpns))
btGroupWpnSelection:SetDescription("Select backtrack time for each weapon.")
local btWpnSlider = {
	gui.Slider(guiBoxLegitBacktrack, "wpnPistol", "Pistols Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnHpistol", "Heavy Pistols Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnRifle", "Rifles Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnScout", "Scout Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnAWP", "AWP Backtrack Time", 0, 0, 400, 5),
    gui.Slider(guiBoxLegitBacktrack, "wpnAuto", "Autosniper Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnSMG", "SMGs Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnSG", "Shotguns Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnLMG", "LMGs Backtrack Time", 0, 0, 400, 5),
	gui.Slider(guiBoxLegitBacktrack, "wpnShared", "Shared Backtrack Time", 0, 0, 400, 5)
}

local btDecKey = gui.Keybox(guiBoxLegitBacktrack, "btDecKey", "Decrease", 37)
btDecKey:SetDescription("Decrease BT time.")
btDecKey:SetWidth(200)
local btIncKey = gui.Keybox(guiBoxLegitBacktrack, "btIncKey", "Increase", 39)
btIncKey:SetDescription("Increase BT time.")
btIncKey:SetWidth(200)
btIncKey:SetPosX(120)
btIncKey:SetPosY(132)

local btChangeValue = gui.Slider(guiBoxLegitBacktrack, "btChangeValue", "Backtrack Change Value", 5, 5, 50, 5)
btChangeValue:SetDescription("Set by how much bactrack is increased/decreased.")
local legitBacktrackRandomisation = gui.Checkbox(guiBoxLegitBacktrack, "legitBacktrackRandomisation", "Randomise Backtrack Value", false)
legitBacktrackRandomisation:SetDescription("Randomise backtrack value to make it look more legit.")
local legitBacktrackRandomisationAmount = gui.Slider(guiBoxLegitBacktrack, "legitBacktrackRandomisationAmount", "Randomisation Amount", 25, 0, 100, 5)
legitBacktrackRandomisationAmount:SetDescription("Min and max bactrack time randomisation amount.")
local legitBacktrackPing = gui.Checkbox(guiBoxLegitBacktrack, "legitBacktrackPing", "Backtrack + Ping", false)
legitBacktrackPing:SetDescription("Add your ping to the backtrack time.")
local legitBacktrackPingMultiplier = gui.Slider(guiBoxLegitBacktrack, "legitBacktrackPingMultiplier", "Ping Multiplier", 0.67, 0, 1, 0.01)
legitBacktrackPingMultiplier:SetDescription("Set a custom multiplier for ping added to backtrack.")
for i=1, #btWpnSlider do
    btWpnSlider[i]:SetInvisible(true)
    btWpnSlider[i]:SetDescription("Change the "..btGroupWpns[i].." backtrack time.")
end
local btCurWpn = 10
local btWpnClassInt = 0

local function getCurWpn()
    if entities.GetLocalPlayer() ~= nil then
        local player = entities.GetLocalPlayer()
		if player:GetWeaponID() ~= nil then
        	btCurWpn = player:GetWeaponID()
		end
        if btCurWpn == 2 or btCurWpn == 3 or btCurWpn == 4 or btCurWpn == 30 or btCurWpn == 32 or btCurWpn == 36 or btCurWpn == 61 or btCurWpn == 63 then
            btWpnClassInt = 1
        elseif btCurWpn == 1 then
            btWpnClassInt = 2
        elseif btCurWpn == 7 or btCurWpn == 8 or btCurWpn == 10 or btCurWpn == 13 or btCurWpn == 16 or btCurWpn == 39 or btCurWpn == 61 then
            btWpnClassInt = 3
        elseif btCurWpn == 40 then
            btWpnClassInt = 4
        elseif btCurWpn == 9 then
            btWpnClassInt = 5
        elseif btCurWpn == 38 or btCurWpn == 11 then
            btWpnClassInt = 6
        elseif btCurWpn == 17 or btCurWpn == 19 or btCurWpn == 23 or btCurWpn == 24 or btCurWpn == 26 or btCurWpn == 33 or btCurWpn == 34 then
            btWpnClassInt = 7
        elseif btCurWpn == 25 or btCurWpn == 27 or btCurWpn == 29 or btCurWpn == 35 then
            btWpnClassInt = 8
        elseif btCurWpn == 28 or btCurWpn == 14 then
            btWpnClassInt = 9
        else
            btWpnClassInt = 10
        end
    end
end

callbacks.Register("Draw", function()
    getCurWpn()
	local bt = 0

    if entities.GetLocalPlayer() ~= nil then
		bt = btWpnSlider[btWpnClassInt]:GetValue()
        if legitBacktrackPing:GetValue() then
            bt = bt + math.floor(entities.GetPlayerResources():GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex())*legitBacktrackPingMultiplier:GetValue())
        end
        if legitBacktrackRandomisation:GetValue() then
            local tmp = legitBacktrackRandomisationAmount:GetValue()
            bt = bt + math.random(-tmp, tmp)
        end
    end

    sv("lbot.extra.backtrack", bt)
    btWpnSlider[btGroupWpnSelection:GetValue()+1]:SetInvisible(false)
    for i=1, #btWpnSlider do
        if i ~= btGroupWpnSelection:GetValue()+1 then
            btWpnSlider[i]:SetInvisible(true)
        end
    end
    if input.IsButtonPressed(btDecKey:GetValue()) then
        btWpnSlider[btGroupWpnSelection:GetValue()+1]:SetValue(btWpnSlider[btGroupWpnSelection:GetValue()+1]:GetValue()-btChangeValue:GetValue())
    end
    if input.IsButtonPressed(btIncKey:GetValue()) then
        btWpnSlider[btGroupWpnSelection:GetValue()+1]:SetValue(btWpnSlider[btGroupWpnSelection:GetValue()+1]:GetValue()+btChangeValue:GetValue())
    end
end)

callbacks.Register("FireGameEvent", function(e)
    getCurWpn()
    if e:GetName() == "item_equip" then
        btGroupWpnSelection:SetValue(btWpnClassInt-1)
    end
end)
client.AllowListener("item_equip")

local guiBoxLegitTriggerbot = gui.Groupbox(legitTab, "Triggerbot Settings", 305, 10, 285, 50)
local triggerMagnetToggle = gui.Checkbox(guiBoxLegitTriggerbot, "triggerMagnetToggle", "Magnet Triggerbot Toggle", false)
triggerMagnetToggle:SetDescription("Enable magnet triggerbot.")

local legitTriggerbotWeapons = gui.Multibox(guiBoxLegitTriggerbot, "Triggerbot Weapons Configuration")
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
					sv(legitTriggerbotDelayItems[i], val1)
					sv(legitTriggerbotHitchanceItems[i], val2)
				end
			end
			if triggerMagnetToggle:GetValue() and gv("lbot.master") then
				sv("lbot.aim.enable", true)
				if gv("lbot.trg.key") ~= 0 and input.IsButtonDown(gv("lbot.trg.key")) then
					sv("lbot.aim.autofire", true)
					sv("lbot.aim.fireonpress", false)
				else
					sv("lbot.aim.autofire", false)
				end
			else
				sv("lbot.aim.autofire", false)
			end
		end
	end
end)



--   ███████  ██████ ██████  
--   ██      ██      ██   ██ 
--   █████    █████  ██████  
--   ██           ██ ██      
--   ███████ ██████  ██      

local guiBoxEspMain = gui.Groupbox(espTab, "ESP Settings", 10, 10, 285, 50)
local espTabToggle = gui.Checkbox(guiBoxEspMain, "espt", "ESP Toggle", false)
local chamsToggle = gui.Checkbox(guiBoxEspMain, "chams.toggle", "Chams Toggle", true)
local espEnableOnDeath = gui.Checkbox(guiBoxEspMain, "espod", "ESP When Dead", false)
local espMainToggles = gui.Multibox(guiBoxEspMain, "ESP Display")
local espFlagToggles = gui.Multibox(guiBoxEspMain, "ESP Flags")
local enhanceEspPrecision = gui.Checkbox(guiBoxEspMain, "enhanceEspPrecision", "Enhance ESP Precision", false)
espTabToggle:SetDescription("Toggle ESP settings. Recommended to bind.")
chamsToggle:SetDescription("Toggle Chams. Recommended to bind.")
espEnableOnDeath:SetDescription("Enables ESP when dead. Disables ESP on round start.")
espMainToggles:SetDescription("Select what the ESP will draw.")
espFlagToggles:SetDescription("Select which ESP flags will be drawn.")
enhanceEspPrecision:SetDescription("Improve ESP drawing accuracy.")



local function cacheChams()
	for i=0, #chamsTogglesEnemy/3-1 do
		chamsTogglesEnemy[i*3+3] = gv(chamsTogglesEnemy[i*3+2])
	end
	for i=0, #chamsTogglesOther/3+2 do
		chamsTogglesOther[i*3+3] = gv(chamsTogglesOther[i*3+2])
	end
	chams_cached = true
end

local function chamsDisable()
	for i=0, #chamsTogglesEnemy/3-1 do
		sv(chamsTogglesEnemy[i*3+2], 0)
	end
	for i=0, #chamsTogglesOther/3+2 do
		sv(chamsTogglesOther[i*3+2], 0)
	end
	chams_returned = false
end

local function chamsReturn()
	for i=0, #chamsTogglesEnemy/3-1 do
		sv(chamsTogglesEnemy[i*3+2], chamsTogglesEnemy[i*3+3])
	end
	for i=0, #chamsTogglesOther/3+2 do
		sv(chamsTogglesOther[i*3+2], chamsTogglesOther[i*3+3])
	end
	chams_returned = true
end

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() then
		if chamsToggle:GetValue() then
			if not chams_returned then
				chamsReturn()
			end
			chams_cached = false
		else
			if not chams_cached then
				cacheChams()
			end
			chamsDisable()
		end	
	end
end)



callbacks.Register("Draw", function()
    if scriptToggle:GetValue() and espTabToggle:GetValue() then
        sv("esp.overlay.friendly.precision", enhanceEspPrecision:GetValue())
        sv("esp.overlay.enemy.precision", enhanceEspPrecision:GetValue())
    end
end)

local indicatorListSliderX = gui.Slider(mainScriptToggleBox, "indicatorSavePositionX", "indicatorListSliderX", moduleWidth*0.70, 0, screenWidth)
local indicatorListSliderY = gui.Slider(mainScriptToggleBox, "indicatorSavePositionY", "indicatorListSliderY", moduleHeight+14, 0, screenHeight)
indicatorListSliderX:SetInvisible(true)
indicatorListSliderY:SetInvisible(true)
local indicatorListMouseX, indicatorListMouseY, indicatorListDx, indicatorListDy, indicatorListWidth, indicatorListHeight = 0, 0, 0, 0, 100, 60
local indicatorListX, indicatorListY
callbacks.Register("Draw", function()
    indicatorListX, indicatorListY = indicatorListSliderX:GetValue(), indicatorListSliderY:GetValue()
end)
local shouldDragIndicatorList = false

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and drawToggles:GetValue() then
		if entities.GetLocalPlayer() ~= nil or gui.Reference("Menu"):IsActive() then
			draw.SetFont(moonlightFont2)
			draw.Color(0, 0, 20, 100)
			draw.FilledRect(indicatorListX, indicatorListY-5, indicatorListX+150, indicatorListY+20 + #indicatorItems.toggleList*14+5)
			draw.ShadowRect(indicatorListX, indicatorListY-5, indicatorListX+150, indicatorListY-62 + #indicatorItems.toggleList*14+5, 2)
			draw.Color(57, 108, 255, 255)
			draw.Color(drawTogglesColours[2]:GetValue())
			draw.Line(indicatorListX, indicatorListY-6, indicatorListX+150, indicatorListY-6)
			draw.TextShadow(indicatorListX+48, indicatorListY-3, "Toggles")
			draw.SetFont(moonlightFont3)
			draw.Color(drawTogglesColours[1]:GetValue())
			for i=1, #indicatorItems.toggleList, 1 do
				draw.TextShadow(indicatorListX+8, indicatorListY+i*15+3, indicatorItems.toggleList[i])
				draw.TextShadow(indicatorListX+90, indicatorListY+i*15+3, "[")
				local state = "off"
				if i == 1 then
					if gv(miscOtherVariables[1]) and gv(miscOtherVariables[5]) then
						state = "on"
						draw.Color(unpack(indicatorItems.toggleColours[3]))
					end
				elseif i == 2 then
					if gv(miscOtherVariables[1]) and gv(miscOtherVariables[3]) then
						if gv(miscOtherVariables[7]) ~= nil and gv(miscOtherVariables[7]) ~= 0 then
							if input.IsButtonDown(gv(miscOtherVariables[7])) then
								if triggerMagnetToggle:GetValue() and legitTabToggle:GetValue() then
									state = "magnet"
									draw.Color(unpack(indicatorItems.toggleColours[3]))
								else
									state = "on"
									draw.Color(unpack(indicatorItems.toggleColours[3]))
								end
							end
						end
						if gv(miscOtherVariables[8]) then
							state = "af"
							draw.Color(unpack(indicatorItems.toggleColours[5]))
						end
					end
				elseif i == 3 then
					if gv(miscOtherVariables[6]) == 1 then
						state = "on"
						draw.Color(unpack(indicatorItems.toggleColours[3]))
					elseif gv(miscOtherVariables[6]) == 2 then
						state = "legit"
						draw.Color(unpack(indicatorItems.toggleColours[2]))
					end
				elseif i == 4 then
					local temp = 0
					for i=1, #espMainVariables, 1 do
						if gv(espMainVariables[i]) then
							temp = temp +1
						end
					end
					if isHealthBarEspEnabled == 1 then
						temp = temp + 1
					end
					if temp-3 > 0 then
						state = "on"
						draw.Color(unpack(indicatorItems.toggleColours[3]))
					end
				elseif i == 5 then
					if entities.GetLocalPlayer() ~= nil then
						state = btWpnSlider[btWpnClassInt]:GetValue()
					else
						state = 0
					end
					if state == 0 then
						draw.Color(255, 255, 255, 255)
					elseif state < 55 then
						draw.Color(unpack(indicatorItems.toggleColours[2]))
					elseif state < 105 then
						draw.Color(unpack(indicatorItems.toggleColours[3]))
					elseif state < 205 then
						draw.Color(unpack(indicatorItems.toggleColours[4]))
					else
						draw.Color(unpack(indicatorItems.toggleColours[5]))
					end
					if legitBacktrackPing:GetValue() then
						state = state .. ",p"
					end
					if legitBacktrackRandomisation:GetValue() then
						state = state .. ",r"
					end
				elseif i == 6 then
					if chamsToggle:GetValue() then
						draw.Color(unpack(indicatorItems.toggleColours[3]))
						state = "on"
					end
				end
				local gt = draw.GetTextSize
				draw.TextShadow(indicatorListX+90 + gt("[") , indicatorListY+i*15+3, state)
				draw.Color(drawTogglesColours[1]:GetValue())
				draw.TextShadow(indicatorListX+90 + gt("["..state), indicatorListY+i*15+3, "]")
				state = ""
			end

			if input.IsButtonDown(1) then
				indicatorListMouseX, indicatorListMouseY = input.GetMousePos()
				if shouldDragIndicatorList then
					indicatorListX = indicatorListMouseX - indicatorListDx
					indicatorListY = indicatorListMouseY - indicatorListDy
				end
				if indicatorListMouseX >= indicatorListX and indicatorListMouseX <= indicatorListX + indicatorListWidth and indicatorListMouseY >= indicatorListY and indicatorListMouseY <= indicatorListY+5*15+5 then
					shouldDragIndicatorList = true
					indicatorListDx = indicatorListMouseX - indicatorListX
					indicatorListDy = indicatorListMouseY - indicatorListY
				end
			else
				shouldDragIndicatorList = false
			end
			indicatorListSliderX:SetValue(indicatorListX)
			indicatorListSliderY:SetValue(indicatorListY)
		end
	end
end)

local guiBoxEspOther = gui.Groupbox(espTab, "Other Settings", 305, 10, 285, 30)
local espOtherToggle = gui.Checkbox(guiBoxEspOther, "otherEspToggle", "Other ESP Toggle", false)
local engineRadar = gui.Checkbox(guiBoxEspOther, "engineRadar", "Engine Radar", false)
local rankRevealToggle = gui.Checkbox(guiBoxEspOther, "rankEsp", "Rank Reveal", false)
local forceCrosshair = gui.Checkbox(guiBoxEspOther, "forceCrosshair", "Force Crosshair", false)
local antiObsScreenshot = gui.Checkbox(guiBoxEspOther, "antiObsScreenshot", "Anti-OBS and Anti-Screenshot", false)
local sharedEsp = gui.Checkbox(guiBoxEspOther, "sharedEsp", "Share ESP with team", false)
espOtherToggle:SetDescription("Enable other ESP settings.")
engineRadar:SetDescription("Show enemies in normal radar.")
rankRevealToggle:SetDescription("Show team and enemy ranks in scoreboard.")
forceCrosshair:SetDescription("Force crosshair on snipers.")
antiObsScreenshot:SetDescription("Enable Anti-OBS and Anti-Screenshot.")
sharedEsp:SetDescription("Share your ESP information with your team.")
local sharedEspDesc = gui.Text(guiBoxEspOther, "You can only share your ESP information with \nother aimware users!")

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and espOtherToggle:GetValue() then
		sv("misc.rankreveal", rankRevealToggle:GetValue())
		sv("esp.other.antiobs", antiObsScreenshot:GetValue())
		sv("esp.other.antiscreenshot", antiObsScreenshot:GetValue())
		if sharedEsp:GetValue() then
			sv("esp.other.sharedesp", 1)
		else
			sv("esp.other.sharedesp", 0)
		end
		for i, player in pairs(entities.FindByClass("CCSPlayer")) do
			if engineRadar:GetValue() then        
				player:SetProp("m_bSpotted", 1)
			else
				player:SetProp("m_bSpotted", 0)
			end
		end
		if forceCrosshair:GetValue() then
			local isScoped = entities.GetLocalPlayer():GetPropBool("m_bIsScoped")
			if isScoped then
				client.SetConVar("weapon_debug_spread_show", 0, 1)
			else
				client.SetConVar("weapon_debug_spread_show", 3, 1)
			end
		else
			client.SetConVar("weapon_debug_spread_show", 0, 1)
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
					sv(espMainVariables[i], 1)
				else
					sv(espMainVariables[i], 0)
				end
			end
		else
			for i=1, #espMainVariables, 1 do
				sv(espMainVariables[i], 0)
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

local guiBoxEspHealth = gui.Groupbox(espTab, "Healthbar Settings", 305, 445, 285, 30)
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
	if toggleAdvancedHealthbar:GetValue() and scriptToggle:GetValue() then
		if healthSelect:GetValue() ~= 0 then
			if espTabToggle:GetValue() then
				isHealthBarEspEnabled = 1
			else
				isHealthBarEspEnabled = 0
			end
		else
			isHealthBarEspEnabled = 0
		end
		sv(espMainVariables[2], 0)
		sv(espMainVariables[3], 0)
		espSettingsItems[2]:SetDisabled(true)
		espSettingsItems[3]:SetDisabled(true)
		espSettingsItems[2]:SetValue(false)
		espSettingsItems[3]:SetValue(false)
	else
		isHealthBarEspEnabled = 0
		espSettingsItems[2]:SetDisabled(false)
		espSettingsItems[3]:SetDisabled(false)
    end
	if healthBasedColours:GetValue() and scriptToggle:GetValue() then
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

local function customHealthbarEsp(builder)
    local localPlayer = entities.GetLocalPlayer()
    local ent = builder:GetEntity()
    local health = ent:GetHealth()
    if toggleAdvancedHealthbar:GetValue() and scriptToggle:GetValue() and espTabToggle:GetValue() then
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
callbacks.Register("DrawESP", "customHealthbarEsp", customHealthbarEsp)

local guiBoxEspWorld = gui.Groupbox(espTab, "World Modulation", 10, 595, 285, 30)
local enableWorldModulation = gui.Checkbox(guiBoxEspWorld, "enableWorldModulation", "World Modulation", false)
local enableShadowsModulation = gui.Checkbox(guiBoxEspWorld, "enableShadowsModulation", "Shadows Modulation", false)
local shadowsPositionX = gui.Slider(guiBoxEspWorld, "shadowsPositionX", "Shadows X", 50, 0, 360)
local shadowsPositionY = gui.Slider(guiBoxEspWorld, "shadowsPositionY", "Shadows Y", 43, 0, 360)
local enableFogModulation = gui.Checkbox(guiBoxEspWorld, "enableFogModulation", "Fog Modulation", false)
local skyboxFogColor = gui.ColorPicker(enableFogModulation, "skyboxFogColor", "Skybox Fog Colour", 255, 255, 255, 255)
local fogColor = gui.ColorPicker(enableFogModulation, "fogColor", "Fog Colour", 255, 255, 255, 255)
local fogStart = gui.Slider(guiBoxEspWorld, "fogStart", "Fog Start", 0, 0, 2000)
local fogEnd = gui.Slider(guiBoxEspWorld, "fogEnd", "Fog End", 1000, 0, 3000)
local fogDensity = gui.Slider(guiBoxEspWorld, "fogDensity", "Fog Density", 0.2, 0, 1, 0.1)
local skyboxFogStart = gui.Slider(guiBoxEspWorld, "skyboxFogStart", "Skybox Fog Start", 0, 0, 2000)
local skyboxFogEnd = gui.Slider(guiBoxEspWorld, "skyboxFogEnd", "Skybox Fog End", 1000, 0, 3000)
local skyboxFogDensity = gui.Slider(guiBoxEspWorld, "skyboxFogDensity", "Skybox Fog Density", 0.2, 0, 1, 0.1)

callbacks.Register("Draw", function()
	if scriptToggle:GetValue() and enableWorldModulation:GetValue() then
		if enableShadowsModulation:GetValue() then
			if client.GetConVar("cl_csm_rot_override") ~= 1 then
				client.SetConVar("cl_csm_rot_override", 1, false)
			end
			client.SetConVar("cl_csm_rot_x", shadowsPositionX:GetValue(), false)
			client.SetConVar("cl_csm_rot_y", shadowsPositionY:GetValue(), false)
		else
			if client.GetConVar("cl_csm_rot_override") ~= 0 then
				client.SetConVar("cl_csm_rot_override", 0, false)
			end
		end
		if enableFogModulation:GetValue() then
			if client.GetConVar("fog_override") ~= 1 then
				client.SetConVar("fog_override", 1, true)
			end
		else
			if client.GetConVar("fog_override") ~= 0 then
				client.SetConVar("fog_override", 0, true)
			end
		end
		if enableFogModulation:GetValue() then
			local fca,fcb,fcc = fogColor:GetValue()
			local tempfc = fca .. " " .. fcb .. " " .. fcc
			local sfca,sfcb,sfcc = skyboxFogColor:GetValue()
			local tempsfc = sfca .. " " .. sfcb .. " " .. sfcc
			client.SetConVar("fog_start", fogStart:GetValue(), true)
			client.SetConVar("fog_end", fogEnd:GetValue(), true)
			client.SetConVar("fog_maxdensity", fogDensity:GetValue(), true)
			client.SetConVar("fog_color", tempfc, true)
			client.SetConVar("fog_colorskybox", tempsfc, true)
			client.SetConVar("fog_startskybox", skyboxFogStart:GetValue(), true)
			client.SetConVar("fog_endskybox", skyboxFogEnd:GetValue(), true)
			client.SetConVar("fog_maxdensityskybox", skyboxFogDensity:GetValue(), true)
		end
	else
		if client.GetConVar("cl_csm_rot_override") ~= 0 then
			client.SetConVar("cl_csm_rot_override", 0, false)
		end
		if client.GetConVar("fog_override") ~= 0 then
			client.SetConVar("fog_override", 0, true)
		end
		client.SetConVar("fog_color", "-1 -1 -1", true)
	end

end)



--   █████  ████████ ██   ██ ███████ ██████  
--  ██   ██    ██    ██   ██ ██      ██   ██ 
--  ██   ██    ██    ███████ █████   ██████  
--  ██   ██    ██    ██   ██ ██      ██   ██ 
--   █████     ██    ██   ██ ███████ ██   ██ 

local guiBoxOtherMain = gui.Groupbox(otherTab, "Other Settings", 10, 10, 285, 50)
local aspectRatioChangerToggle = gui.Checkbox(guiBoxOtherMain, "aspect_ratio_check", "Aspect Ratio Changer", false)
aspectRatioChangerToggle:SetDescription("Set custom aspect ratio. 100 - 1:1, 133 - 4:3, 178 - 16:9")
local aspectRatioChangerValue = gui.Slider(guiBoxOtherMain, "aspectRatioChangerValue", "Aspect Ratio", 177.7, 1, 200, 0.1)
callbacks.Register("Draw", function()
	local val
	if aspectRatioChangerToggle:GetValue() == true then
		val = aspectRatioChangerValue:GetValue()/100
	else
		val = screenWidth/screenHeight
	end
	client.SetConVar("r_aspectratio", val, true)
end)

local guiBoxOtherMainImports = gui.Groupbox(guiBoxOtherMain, "Imports", 0, 100, 255, 50)
local importViewmodelPosition = gui.Button(guiBoxOtherMainImports, "viewmodel", function()
	client.Command("viewmodel_offset_x 2 viewmodel_offset_y 2 viewmodel_offset_z -2 viewmodel_fov 68 cl_righthand 1 cl_bobcycle 0 cl_bobamt_vert 0 cl_bobamt_vert 0 cl_bobamt_lat 0 cl_bob_lower_amt 0", true)
end)

local importAutoexecConfig = gui.Button(guiBoxOtherMainImports, "autoexec.cfg", function()
	client.Command("exec autoexec", true)
end)

local importMoonlightTheme = gui.Button(guiBoxOtherMainImports, "moonlight theme", function()
	sv("theme.footer.bg", 0, 0, 0, 255)
	sv("theme.header.bg", 0, 0, 0, 255)
	sv("theme.nav.active", 0, 0, 0, 255)
	sv("theme.nav.bg", 0, 0, 0, 255)
	sv("theme.tablist.tabactivebg", 0, 0, 0, 255)
	sv("theme.footer.text", 57, 108, 255, 255)
	sv("theme.header.line", 57, 108, 255, 255)
	sv("theme.header.text", 57, 108, 255, 255)
	sv("theme.nav.shadow", 57, 108, 255, 255)
	sv("theme.nav.text", 57, 108, 255, 255)
	sv("theme.tablist.shadow", 57, 108, 255, 255)
	sv("theme.tablist.tabdecorator", 57, 108, 255, 255)
	sv("theme.tablist.text", 57, 108, 255, 255)
	sv("theme.tablist.textactive", 57, 108, 255, 255)
	sv("theme.ui.bg1", 24, 24, 24, 255)
	sv("theme.ui.bg2", 57, 108, 255, 255)
	sv("theme.ui.border", 57, 108, 255, 255)
end)
importViewmodelPosition:SetWidth(105)
importAutoexecConfig:SetWidth(105)
importAutoexecConfig:SetPosY(0)
importAutoexecConfig:SetPosX(120)
importMoonlightTheme:SetWidth(105)

local guiBoxOtherFun = gui.Groupbox(otherTab, "Fun", 10, 338, 285, 50)
local startQueueButton = gui.Button(guiBoxOtherFun, "Start MM Queue", function()
	panorama.RunScript('LobbyAPI.StartMatchmaking("", "", "", "")')
end)
startQueueButton:SetWidth(120)
local cancelQueueButton = gui.Button(guiBoxOtherFun, "Cancel MM Queue", function()
	panorama.RunScript("LobbyAPI.StopMatchmaking()")
end)
cancelQueueButton:SetWidth(120)
cancelQueueButton:SetPosX(135)
cancelQueueButton:SetPosY(0)

local guiBoxOtherInformation = gui.Groupbox(otherTab, "Information Settings", 305, 10, 285, 50)
local spectatorList = gui.Checkbox(guiBoxOtherInformation, "toggleSpectatorList", "Spectator List", false)
spectatorList:SetDescription("Enable moonlight's spectator list.")
local spectatorListColours = {
	gui.ColorPicker(spectatorList, "specListWindowNameColour", "Spectator List Window Name Colour", 255, 255, 255, 255),
	gui.ColorPicker(spectatorList, "specListNameColour", "Spectator List Name Colour", 57, 108, 255, 255)
}
local togglePlayerAvatars = gui.Checkbox(guiBoxOtherInformation, "togglePlayerAvatars", "Toggle Avatars", false)
togglePlayerAvatars:SetDescription("Toggle between show/hide player avatars in speclist.")
local togglePlayerAvatarsColour = gui.ColorPicker(togglePlayerAvatars, "togglePlayerAvatarsColour", "Player Avatar Filter Colour", 255, 255, 255, 255)

local playerAvatarUpdateMode = gui.Multibox(guiBoxOtherInformation, "Avatar Update Mode")
local playerAvatarUpdateModeItems = {
	gui.Checkbox(playerAvatarUpdateMode, "modeManual", "Manual", false),
	gui.Checkbox(playerAvatarUpdateMode, "modeRoundStart", "On Round Start", false),
	gui.Checkbox(playerAvatarUpdateMode, "modeRoundEnd", "On Round End", false),
	gui.Checkbox(playerAvatarUpdateMode, "modePlayerConnect", "On Player Connect", false),
	gui.Checkbox(playerAvatarUpdateMode, "modePlayerDisconnect", "On Player Disconnect", false)
}
local updatePlayerAvatars = gui.Checkbox(guiBoxOtherInformation, "updatePlayerAvatars", "Update Avatars", false)
updatePlayerAvatars:SetDescription("Download new avatars. Will freeze your game!")
callbacks.Register("Draw", function()
	if togglePlayerAvatars:GetValue() then
		playerAvatarUpdateMode:SetDisabled(false)
		if playerAvatarUpdateModeItems[1]:GetValue() then
			updatePlayerAvatars:SetDisabled(false)
		else
			updatePlayerAvatars:SetDisabled(true)
		end
	else
		playerAvatarUpdateMode:SetDisabled(true)
		updatePlayerAvatars:SetDisabled(true)
	end
end)

local specListSliderX = gui.Slider(guiBoxOtherInformation, "specListSavePositionX", "specListSliderX", 25, 0, screenWidth)
local specListSliderY = gui.Slider(guiBoxOtherInformation, "specListSavePositionY", "specListSliderY", 660, 0, screenHeight)
specListSliderX:SetInvisible(true)
specListSliderY:SetInvisible(true)
local specListMouseX, specListMouseY, specListDx, specListDy, specListWidth, specListHeight = 0, 0, 0, 0, 200, 60
local specListX, specListY
callbacks.Register("Draw", function()
    specListX, specListY = specListSliderX:GetValue(), specListSliderY:GetValue()
end)
local shouldDragSpectatorList = false

local function getSpectatorList()
    local spectators = {}
     if entities.GetLocalPlayer() ~= nil then
      local players = entities.FindByClass("CCSPlayer")
        for i=1, #players do
            local player = players[i]
            if player ~= entities.GetLocalPlayer() and not player:IsAlive() then
                local name = player:GetName()
                if player:GetPropEntity("m_hObserverTarget") ~= nil then
                    local playerindex = player:GetIndex()
                    if name ~= "GOTV" and playerindex ~= 1 then
                        local target = player:GetPropEntity("m_hObserverTarget")
                        if target:IsPlayer() then
                            local targetindex = target:GetIndex()
                            local myindex = client.GetLocalPlayerIndex()
                            if entities.GetLocalPlayer():IsAlive() then
                                if targetindex == myindex then
                                    table.insert(spectators, player)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return spectators
end


local botAvatar = draw.CreateTexture(common.DecodeJPEG(http.Get("https://raw.githubusercontent.com/BlueElixir/aimware-luas/main/moonlight/files/csgo_bot_avatar.jpg")))

local function getUserAvatar(userID)
	local userProfileLinkXMLContents = http.Get("https://steamcommunity.com/profiles/[U:1:" .. userID .. "]?xml=true")
	local function get(data,name)
		return data:match("<"..name..">(.-)</"..name..">")
	end
	local imageLink = get(userProfileLinkXMLContents, "avatarIcon"):gsub("<!.CDATA.", ""):gsub("..>", "")
	local imageOutput = draw.CreateTexture(common.DecodeJPEG(http.Get(imageLink)))
	return imageOutput
end

local playerAvatar = {
	ID = {},
	Picture = {}
}

local function getAllPictures()
	local players = entities.FindByClass("CCSPlayer")
	for i=1, #players do
		local index = players[i]:GetIndex()
		local steamID = client.GetPlayerInfo(index).SteamID
		local isBot = client.GetPlayerInfo(index).IsBot
		if not isBot then
			if playerAvatar.ID[steamID] ~= steamID then
				playerAvatar.ID[steamID] = steamID
				playerAvatar.Picture[steamID] = getUserAvatar(steamID)
			end
		else
			playerAvatar.ID[index] = index
			playerAvatar.Picture[index] = botAvatar
		end
	end
end

callbacks.Register("FireGameEvent", function(e)
	for i=2, 4 do
		if playerAvatarUpdateModeItems[i]:GetValue() then
			if e:GetName() == eventList[i-1] then
				getAllPictures()
			end
		end
	end
end)

local function getPlayerPicture(index)
	local avatar
	local steamID = client.GetPlayerInfo(index).SteamID
	if playerAvatar.ID[steamID] ~= nil or not client.GetPlayerInfo(index).IsBot then
		avatar = playerAvatar.Picture[steamID]
	else
		avatar = botAvatar
	end
	return avatar
end

callbacks.Register("Draw", function()
	if updatePlayerAvatars:GetValue() then
		getAllPictures()
		updatePlayerAvatars:SetValue(false)
	end
end)

callbacks.Register("Draw", function()
	if spectatorList:GetValue() then
		local spectators = getSpectatorList()
		draw.SetFont(moonlightFont2)
		if #spectators ~= 0 or gui.Reference("Menu"):IsActive() then
			draw.Color(0, 0, 20, 100)
			draw.FilledRect(specListX, specListY-5, specListX+200, specListY+#spectators*15+20)
			draw.ShadowRect(specListX, specListY-5, specListX+200, specListY+13, 2)
			draw.Color(spectatorListColours[2]:GetValue())
			draw.TextShadow(specListX+63, specListY-3, "Spectators")
			draw.Line(specListX, specListY-6, specListX+200, specListY-6)
			draw.SetFont(moonlightFont3)
			for i, player in pairs(spectators) do
				draw.Color(spectatorListColours[1]:GetValue())
				local name = ""
				if client.GetPlayerInfo(player:GetIndex()).IsBot then
					name = "BOT "
				end
				name = name .. player:GetName()
				draw.TextShadow(specListX+8, specListY+3+i*15, name)
				draw.Color(255, 255, 255, 255)
				if togglePlayerAvatars:GetValue() then
					draw.Color(togglePlayerAvatarsColour:GetValue())
					draw.SetTexture(getPlayerPicture(player:GetIndex()))
					draw.FilledRect(specListX+170, specListY+1+i*15, specListX+184, specListY+3+i*15+12)
					draw.SetTexture(nil)
				end
			end
			if input.IsButtonDown(1) then
				specListMouseX, specListMouseY = input.GetMousePos()
				if shouldDragSpectatorList then
					specListX = specListMouseX - specListDx
					specListY = specListMouseY - specListDy
				end
				if specListMouseX >= specListX and specListMouseX <= specListX + specListWidth and specListMouseY >= specListY and specListMouseY <= specListY+#spectators*15+5 then
					shouldDragSpectatorList = true
					specListDx = specListMouseX - specListX
					specListDy = specListMouseY - specListY
				end
			else
				shouldDragSpectatorList = false
			end
			specListSliderX:SetValue(specListX)
			specListSliderY:SetValue(specListY)
		end
	end
end)

local guiBoxOtherBuybot = gui.Groupbox(otherTab, "Buy Bot", 305, 295, 285, 50)

local primary = {"", "ak47", "ssg08", "sg556", "awp", "galilar", "mac10", "mp7", "ump45", "p90", "bizon", "nova", "xm1014", "mag7", "m249", "negev"}
local secondary = {"", "glock", "elite", "p250", "tec9", "deagle"}
local equipment = {"vest", "vesthelm", "taser"}
local equipmentnames = {"Kevlar Vest", "Kevlar + Helmet", "Zeus x27"}
local grenades = {"molotov", "decoy", "flashbang", "flashbang", "hegrenade", "smokegrenade"}
local grenadesnames = {"Molotov / Incendiary Grenade", "Decoy Grenade", "Flashbang", "Flashbang", "HE Grenade", "Smoke Grenade"}

local primarySelection = gui.Combobox(guiBoxOtherBuybot, "primarySelection", "Primary", "None", "AK-47 / M4A4 / M4A1-S", "SSG 08", "SG 553 / AUG", "AWP", "G3SG1 / SCAR-20", "Galil AR / Famas", "MAC-10", "MP7", "UMP-45", "P90", "PP-Bizon", "Nova", "XM1014", "Mag-7", "Sawed-Off", "M249", "Negev")
local secondarySelection = gui.Combobox(guiBoxOtherBuybot, "secondarySelection", "Secondary", "None", "Glock-18 / USP-S / P2000", "Dual Berretas", "P250", "Tec-9 / Five-Seven / CZ75-Auto", "Desert Eagle / Revolver")
local equipmentSelection = gui.Multibox(guiBoxOtherBuybot, "Equipment")
local grenadesSelection = gui.Multibox(guiBoxOtherBuybot, "Grenades")

local equipmentSelectionItems = {}
for i=1, #equipment do
	equipmentSelectionItems[i] = gui.Checkbox(equipmentSelection, "equipment." .. equipment[i], equipmentnames[i], false)
end

local grenadesSelectionItems = {}
for i=1, #grenades do
	grenadesSelectionItems[i] = gui.Checkbox(grenadesSelection, "grenades." .. grenades[i], grenadesnames[i], false)
end

callbacks.Register("Draw", function()
	local temp = 0
	for i=1, #grenades do
		if grenadesSelectionItems[i]:GetValue() then
			temp = temp + 1
		end
	end
	for i=1, #grenades do
		if temp == 4 then
			if not grenadesSelectionItems[i]:GetValue() then
				grenadesSelectionItems[i]:SetDisabled(true)
			end
		else
			grenadesSelectionItems[i]:SetDisabled(false)
		end
	end
	if equipmentSelectionItems[1]:GetValue() then
		equipmentSelectionItems[2]:SetDisabled(true)
	else
		equipmentSelectionItems[2]:SetDisabled(false)
	end
	if equipmentSelectionItems[2]:GetValue() then
		equipmentSelectionItems[1]:SetDisabled(true)
	else
		equipmentSelectionItems[1]:SetDisabled(false)
	end
end)

local function buyWeapon()
	local buystring = ""
	for i=1, #grenadesSelectionItems do
		if grenadesSelectionItems[i]:GetValue() then
			buystring = buystring .. "buy " .. grenades[i] .. ""
		end
	end
	for i=1, #equipmentSelectionItems do
		if equipmentSelectionItems[i]:GetValue() then
			buystring = buystring .. "buy " .. equipment[i] .. ""
		end
	end
	buystring = buystring .. "buy " .. primary[primarySelection:GetValue()+1] .. ""
	buystring = buystring .. "buy " .. secondary[secondarySelection:GetValue()+1] .. ""
	if buystring == "buy buy " then
		print("Please select items to buy.")
		return
	end
	client.Command(buystring)
end

local purchaseItems = gui.Checkbox(guiBoxOtherBuybot, "purchaseItems", "Purchase Items", false)
purchaseItems:SetDescription("Purchase selected items. Spamming it will kick you.")
callbacks.Register("Draw", function()
	if purchaseItems:GetValue() then
		purchaseItems:SetValue(false)
		buyWeapon()
	end
end)
local autoPurchaseItems = gui.Checkbox(guiBoxOtherBuybot, "autoPurchaseItems", "Autobuy on Round Start", false)
autoPurchaseItems:SetDescription("Buy selected weapons on round start automatically.")
callbacks.Register("FireGameEvent", function(e)
	if e:GetName() == "round_start" and autoPurchaseItems:GetValue() then
		buyWeapon()
	end
end)

for i=1, #eventList do
	client.AllowListener(eventList[i])
end

callbacks.Register("Unload", function()
	chamsToggle:SetValue(true)
	chamsReturn()
end)
