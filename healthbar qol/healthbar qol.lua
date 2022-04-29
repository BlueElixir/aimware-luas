local yes = gui.Window(customHealth, "                   Better Health", 100, 100, 200, 260)
local healthItems = {"Off", "Team only", "Enemy only", "On"}
local healthSelect = gui.Combobox(yes, "something2", "Mode", unpack(healthItems))
local colourEnemy = gui.ColorPicker(yes, "something3", "Enemy colour", 255, 0, 0, 255)
local colourTeam = gui.ColorPicker(yes, "something4", "Team colour", 0, 255, 0, 255)
local showHealthNumber = gui.Checkbox(yes, "something5", "Show number", true)
local positionItems = {"Left", "Right"}
local position = gui.Combobox(yes, "something2", "Mode", unpack(positionItems))

local function esp(builder)
    local localPlayer = entities.GetLocalPlayer();
    local ent = builder:GetEntity();
    local health = ent:GetHealth()
    builder:Color(255, 0, 0, 255)
    if healthSelect:GetValue() == 0 then
        return
    elseif healthSelect:GetValue() == 1 then
        if ent:IsPlayer() and ent:GetTeamNumber() == localPlayer:GetTeamNumber() then
            if position:GetValue() == 0 then
                builder:Color(colourTeam:GetValue())
                builder:AddBarLeft(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextLeft(health)
                end
            else
                builder:Color(colourTeam:GetValue())
                builder:AddBarRight(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextRight(health)
                end
            end
        end
    elseif healthSelect:GetValue() == 2 then
        if ent:IsPlayer() and ent:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
            if position:GetValue() == 0 then
                builder:Color(colourEnemy:GetValue())
                builder:AddBarLeft(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextLeft(health)
                end
            else
                builder:Color(colourEnemy:GetValue())
                builder:AddBarRight(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextRight(health)
                end
            end
        end
    elseif healthSelect:GetValue() == 3 then
        if ent:IsPlayer() and ent:GetTeamNumber() == localPlayer:GetTeamNumber() then
            if position:GetValue() == 0 then
                builder:Color(colourTeam:GetValue())
                builder:AddBarLeft(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextLeft(health)
                end
            else
                builder:Color(colourTeam:GetValue())
                builder:AddBarRight(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextRight(health)
                end
            end
        end
        if ent:IsPlayer() and ent:GetTeamNumber() ~= localPlayer:GetTeamNumber() then
            if position:GetValue() == 0 then
                builder:Color(colourEnemy:GetValue())
                builder:AddBarLeft(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextLeft(health)
                end
            else
                builder:Color(colourEnemy:GetValue())
                builder:AddBarRight(health/100)
                if showHealthNumber:GetValue() then
                    builder:AddTextRight(health)
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
