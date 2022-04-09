local aatab = gui.Reference("Legitbot", "Semirage")
local aabox = gui.Groupbox(aatab, "Anti-Aim Inverter", 16, 360, 297, 200)
local aatoggle = gui.Checkbox(aabox, "aatoggle", "Toggle Inverter", false)
local aainv = gui.Keybox(aabox, "aainvkey", "Anti-Aim Inverter", 0)
local aasideind = gui.Checkbox(aabox, "aaindicator", "Anti-Aim Side Indicator", false)
local aaindcolour = gui.ColorPicker(aasideind, "aaindcolour", "Indicator Colour", 255, 255, 255, 255)
local offset = gui.Slider(aabox, "aaindoffset", "Indicator Horizontal Offset", "0", "0", "100")
local screenwidth, screenheight = draw.GetScreenSize()
local leftind = screenwidth/2 - 50
local rightind = screenwidth/2 + 30
local indheight = screenheight/2-10
local font = draw.CreateFont("Verdana", 30, 900)

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
		if aasideind:GetValue() == true then
			draw.SetFont(font)
			draw.Color(aaindcolour:GetValue())
			if gui.GetValue("lbot.antiaim.leftkey") ~= 0 and gui.GetValue("lbot.antiaim.rightkey") == 0 then
				draw.Text(rightind+offset:GetValue(), screenheight/2-10, ">")
			elseif gui.GetValue("lbot.antiaim.leftkey") == 0 and gui.GetValue("lbot.antiaim.rightkey") ~= 0 then
				draw.Text(leftind-offset:GetValue(), screenheight/2-10, "<")
			end
		end
    end
end

callbacks.Register("Draw", AAInverter)

aatoggle:SetDescription("Enable anti-aim inverter.")
aainv:SetDescription("Choose the inverter keybind.")
