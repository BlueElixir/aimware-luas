local aatab = gui.Reference("Legitbot", "Semirage", "Anti-Aim")
local aatoggle = gui.Checkbox(aatab, "aatoggle", "Toggle Inverter", false)
local aainv = gui.Keybox(aatab, "aainvkey", "Anti-Aim Inverter", 0)

local function AAInverter()
    if aatoggle:GetValue() == true then
		if aainv:GetValue() ~= 0 then
			gui.SetValue("lbot.antiaim.direction", 1)
			if input.IsButtonPressed(aainv:GetValue()) then
				if gui.GetValue("lbot.antiaim.leftkey") ~= 0 and gui.GetValue("lbot.antiaim.rightkey") == 0 then
					gui.SetValue("lbot.antiaim.leftkey", 0)
					gui.SetValue("lbot.antiaim.rightkey", aainv:GetValue())
				elseif gui.GetValue("lbot.antiaim.leftkey") == 0 and gui.GetValue("lbot.antiaim.rightkey") ~= 0 then
					gui.SetValue("lbot.antiaim.leftkey", aainv:GetValue())
					gui.SetValue("lbot.antiaim.rightkey", 0)
                elseif gui.GetValue("lbot.antiaim.leftkey") == 0 and gui.GetValue("lbot.antiaim.rightkey") == 0 then
                    local var = math.random(1, 100)
                    if var > 50 then
                        gui.SetValue("lbot.antiaim.leftkey", aainv:GetValue())
                    else
                        gui.SetValue("lbot.antiaim.rightkey", aainv:GetValue())
                    end
				end
			end
		end
    end
end

callbacks.Register("Draw", AAInverter)

aatoggle:SetDescription("Enable anti-aim inverter.")
aainv:SetDescription("Choose the inverter keybind.")
