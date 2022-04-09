-- CHANGE LEFT/RIGHT INDICATORS
--
-- if you want to set your own left/right indicator symbol,
-- change the < and > below to whatever you want.
-- find symbols to use at http://xahlee.info/comp/unicode_arrows.html
-- some symbols might not work
-- not recommended to use more than 1 symbol, it doesn't look nice
--
-- you can also change the size, though i recommend sticking with 30
-- changing thickness is also not recommended, but if you want, go right ahead

local leftIndicator = "<"				-- custom symbol, <, L, 🠈
local rightIndicator = ">"				-- custom symbol, >, R, 🠊
local indicatorSize = 30				-- any size, not recommended to change
local thickness = 900					-- from 100 to 900

local aatab = gui.Reference("Legitbot", "Semirage")
local aabox = gui.Groupbox(aatab, "Anti-Aim Inverter", 16, 360, 297, 200)
local aatoggle = gui.Checkbox(aabox, "aatoggle", "Toggle Inverter", false)
local aainv = gui.Keybox(aabox, "aainvkey", "Anti-Aim Inverter", 0)
local aasideind = gui.Checkbox(aabox, "aaindicator", "Anti-Aim Side Indicator", false)
local aaindcolour = gui.ColorPicker(aasideind, "aaindcolour", "Indicator Colour", 255, 255, 255, 255)
local offset = gui.Slider(aabox, "aaindoffset", "Indicator Offset", "0", "0", "200")
local screenwidth, screenheight = draw.GetScreenSize()
local leftind = screenwidth/2 - 50
local rightind = screenwidth/2 + 30
local indheight = screenheight/2 - 10
local font = draw.CreateFont("Verdana", indicatorSize, thickness)

--vars
local aaleft = "lbot.antiaim.leftkey"
local aaright = "lbot.antiaim.rightkey"
local value = 1

local function AAInverter()
    if aatoggle:GetValue() == true and gui.GetValue("lbot.master") == true then
		if aainv:GetValue() ~= 0 then
			gui.SetValue("lbot.antiaim.direction", 1)
			if input.IsButtonPressed(aainv:GetValue()) then
				if not gui.Reference("Menu"):IsActive() then
					if value == 1 then
						gui.SetValue(aaleft, 0)
						gui.SetValue(aaright, aainv:GetValue())
						value = 2
					elseif value == 2 then
						gui.SetValue(aaleft, aainv:GetValue())
						gui.SetValue(aaright, 0)
						value = 1
      	          else
     	               local var = math.random(1, 100)
            	        if var > 50 then
                 	    	gui.SetValue(aaleft, aainv:GetValue())
							value = 1
               		     else
							gui.SetValue(aaright, aainv:GetValue())
							value = 2
						end
					end
				end
			end
		end
		if aasideind:GetValue() == true then
			draw.SetFont(font)
			
			if value == 2 then
				draw.Color(aaindcolour:GetValue())
				draw.Text(rightind+offset:GetValue(), screenheight/2-10, rightIndicator)
				draw.Color(107, 107, 107, 150)
				draw.Text(leftind-offset:GetValue(), screenheight/2-10, leftIndicator)
			elseif value == 1 then
				draw.Color(aaindcolour:GetValue())
				draw.Text(leftind-offset:GetValue(), screenheight/2-10, leftIndicator)
				draw.Color(107, 107, 107, 150)
				draw.Text(rightind+offset:GetValue(), screenheight/2-10, rightIndicator)
			else
				draw.Color(107, 107, 107, 150)
				draw.Text(leftind-offset:GetValue(), screenheight/2-10, leftIndicator)
				draw.Text(rightind+offset:GetValue(), screenheight/2-10, rightIndicator)
			end
		end
    end
end

callbacks.Register("Draw", AAInverter)

aatoggle:SetDescription("Enable anti-aim inverter.")
aainv:SetDescription("Choose the inverter keybind.")
aasideind:SetDescription("Very basic anti-aim side indicator.")
offset:SetDescription("Move the indicators horizontally.")
