--[[   To change when HP based colour changes, edit the values below. They should go from bigger to lower, for example:

local healthAmt1 = 69
local healthAmt2 = 42

or

local healthAmt1 = 70
local healthAmt2 = 40

The first value shows when colour changes from HP 1 to HP 2.
The second value shows when colour changes from HP 2 to HP 3.

Again, change the values below to fit your needs or use default ones.
]]

local healthAmt1 = 60
local healthAmt2 = 30


local yes = gui.Window(customHealth, "             Customish Healthbar", 100, 100, 200, 500)
local toggle = gui.Checkbox(yes, "toggle", "Toggle Healthbar", false)
toggle:SetDescription("Bind to toggle on/off.")
local healthItems = {"Off", "Team only", "Enemy only", "On"}
local healthSelect = gui.Combobox(yes, "something2", "Position", unpack(healthItems))
local hpBasedColours = gui.Checkbox(yes, "hpBasedColours", "HP Colours", false)
hpBasedColours:SetDescription("Custom colour for 100/50/20 HP.")
local health = nil
--local colourItems = {"Off", "1", "2", "3"}                                                            soon
--local hpBasedColours = gui.Combobox(yes, "hpBasedColours", "HP Based Colours", unpack(colourItems))   soon
--hpBasedColours:SetDescription("Custom colour for certain amounts of HP.")                             soon

local hp1 = gui.ColorPicker(yes, "hp1", "HP 1", 255, 0, 0, 255)
local hp2 = gui.ColorPicker(yes, "hp2", "HP 2", 255, 0, 0, 255)
local hp3 = gui.ColorPicker(yes, "hp3", "HP 3", 255, 0, 0, 255)
local colourEnemyHp = gui.ColorPicker(yes, "colourEnemyHp", "not supposed to see this", 255, 255, 255, 255)
local colourEnemyNumberHp = gui.ColorPicker(yes, "colourEnemyNumberHp", "not supposed to see this", 255, 255, 255, 255)
local colourTeamHp = gui.ColorPicker(yes, "colourTeamHp", "not supposed to see this", 255, 255, 255, 255)
local colourTeamNumberHp = gui.ColorPicker(yes, "colourTeamNumberHp", "not supposed to see this", 255, 255, 255, 255)
hp1:SetInvisible(true)
hp2:SetInvisible(true)
hp3:SetInvisible(true)
colourEnemyHp:SetInvisible(true)
colourEnemyNumberHp:SetInvisible(true)
colourTeamHp:SetInvisible(true)
colourTeamNumberHp:SetInvisible(true)

local colourEnemy = gui.ColorPicker(yes, "something3", "Enemy Colour", 255, 0, 0, 255)
local colourEnemyNumber = gui.ColorPicker(yes, "enemyNumberColour", "Enemy Number Colour", 255, 0, 0, 255)
local colourTeam = gui.ColorPicker(yes, "something4", "Team Colour", 0, 255, 0, 255)
local colourTeamNumber = gui.ColorPicker(yes, "teamNumberColour", "Team Number Colour", 0, 255, 0, 255)

local showHealthNumber = gui.Checkbox(yes, "something5", "Show number", true)
showHealthNumber:SetDescription("Show health number with healthbar.")
local positionItems = {"Left", "Right"}
local position = gui.Combobox(yes, "something2", "Mode", unpack(positionItems))
position:SetDescription("Choose healthbar position.")

local function esp(builder)
    local localPlayer = entities.GetLocalPlayer();
    local ent = builder:GetEntity();
    health = ent:GetHealth()
    if hpBasedColours:GetValue() then
        colourEnemy:SetInvisible(true)
        colourEnemyNumber:SetInvisible(true)
        colourTeam:SetInvisible(true)
        colourTeamNumber:SetInvisible(true)
        hp1:SetInvisible(false)
        hp2:SetInvisible(false)
        hp3:SetInvisible(false)
        if ent:IsPlayer() then
            if health >= healthAmt1 then
                colourEnemyHp:SetValue(hp1:GetValue())
                colourEnemyNumberHp:SetValue(hp1:GetValue())
                colourTeamHp:SetValue(hp1:GetValue())
                colourTeamNumberHp:SetValue(hp1:GetValue())
            elseif health >= healthAmt2 and health < healthAmt1 then
                colourEnemyHp:SetValue(hp2:GetValue())
                colourEnemyNumberHp:SetValue(hp2:GetValue())
                colourTeamHp:SetValue(hp2:GetValue())
                colourTeamNumberHp:SetValue(hp2:GetValue())
            elseif health < healthAmt2 then
                colourEnemyHp:SetValue(hp3:GetValue())
                colourEnemyNumberHp:SetValue(hp3:GetValue())
                colourTeamHp:SetValue(hp3:GetValue())
                colourTeamNumberHp:SetValue(hp3:GetValue())
            end
        end
    else
        colourEnemy:SetInvisible(false)
        colourEnemyNumber:SetInvisible(false)
        colourTeam:SetInvisible(false)
        colourTeamNumber:SetInvisible(false)
        hp1:SetInvisible(true)
        hp2:SetInvisible(true)
        hp3:SetInvisible(true)
    end
    if toggle:GetValue() then
        if healthSelect:GetValue() == 0 then
            return
        elseif healthSelect:GetValue() == 1 then
            if ent:IsPlayer() and ent:GetTeamNumber() == localPlayer:GetTeamNumber() then
                if position:GetValue() == 0 then
                    if hpBasedColours:GetValue() then
                        builder:Color(colourTeamHp:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourTeamNumberHp:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if hpBasedColours:GetValue() then
                        builder:Color(colourTeamHp:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourTeamNumberHp:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
        elseif healthSelect:GetValue() == 2 then
            if ent:IsPlayer() and ent:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
                if position:GetValue() == 0 then
                    if hpBasedColours:GetValue() then
                        builder:Color(colourEnemyHp:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourEnemyNumberHp:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if hpBasedColours:GetValue() then
                        builder:Color(colourEnemyHp:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourEnemyNumberHp:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
        elseif healthSelect:GetValue() == 3 then
            if ent:IsPlayer() and ent:GetTeamNumber() == localPlayer:GetTeamNumber() then
                if position:GetValue() == 0 then
                    if hpBasedColours:GetValue() then
                        builder:Color(colourTeamHp:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourTeamNumberHp:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if hpBasedColours:GetValue() then
                        builder:Color(colourTeamHp:GetValue())
                    else
                        builder:Color(colourTeam:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourTeamNumberHp:GetValue())
                        else
                            builder:Color(colourTeamNumber:GetValue())
                        end
                        builder:AddTextRight(health)
                    end
                end
            end
            if ent:IsPlayer() and ent:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
                if position:GetValue() == 0 then
                    if hpBasedColours:GetValue() then
                        builder:Color(colourEnemyHp:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarLeft(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourEnemyNumberHp:GetValue())
                        else
                            builder:Color(colourEnemyNumber:GetValue())
                        end
                        builder:AddTextLeft(health)
                    end
                else
                    if hpBasedColours:GetValue() then
                        builder:Color(colourEnemyHp:GetValue())
                    else
                        builder:Color(colourEnemy:GetValue())
                    end
                    builder:AddBarRight(health/100)
                    if showHealthNumber:GetValue() then
                        if hpBasedColours:GetValue() then
                            builder:Color(colourEnemyNumberHp:GetValue())
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
    if not gui.Reference("Menu"):IsActive() then
        yes:SetInvisible(true)
    else
        yes:SetInvisible(false)
    end
end)
callbacks.Register("DrawESP", "esp", esp);
