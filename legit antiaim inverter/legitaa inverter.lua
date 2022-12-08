-- CHANGE LEFT/RIGHT INDICATORS
--
-- if you want to set your own left/right indicator symbol,
-- change the < and > below to whatever you want.
-- find symbols to use at http://xahlee.info/comp/unicode_arrows.html
-- some symbols might not work
-- not recommended to use more than 1 symbol, it doesn't look nice
--
-- you can also change the size, though i recommend sticking with 30
-- changing indicator_thickness is also not recommended, but if you want, go right ahead

local left_indicator_symbol = "<"				-- custom symbol, <, L, 🠈
local right_indicator_symbol = ">"				-- custom symbol, >, R, 🠊
local indicator_size = 30				        -- any size, not recommended to change
local indicator_thickness = 900					-- from 100 to 900

local aatab = gui.Reference("Legitbot", "Semirage")
local aabox = gui.Groupbox(aatab, "Anti-Aim Inverter", 16, 360, 297, 200)
local aa_toggle = gui.Checkbox(aabox, "aa_toggle", "Toggle Inverter", false)
local aa_inverter_keybox = gui.Keybox(aabox, "aainvkey", "Anti-Aim Inverter", 0)
local aa_indicator_box = gui.Checkbox(aabox, "aaindicator", "Anti-Aim Side Indicator", false)
local aa_indicator_colour = gui.ColorPicker(aa_indicator_box, "aa_indicator_colour", "Indicator Colour", 255, 255, 255, 255)
local aa_indicator_offset = gui.Slider(aabox, "aaindoffset", "Indicator Offset", 0, 0, 200)
local screenwidth, screenheight = draw.GetScreenSize()
local left_indicator_position = screenwidth/2 - 50
local right_indicator_position = screenwidth/2 + 30
local font = draw.CreateFont("Verdana", indicator_size, indicator_thickness)

--vars
local aa_left_key = "lbot.antiaim.leftkey"
local aa_right_key = "lbot.antiaim.rightkey"
local temp = 1

local function AAInverter()
    if aa_toggle:GetValue() == true and gui.GetValue("lbot.master") == true then
		if aa_inverter_keybox:GetValue() ~= 0 and gui.GetValue("lbot.antiaim.type") ~= '"Off"' then
			if input.IsButtonPressed(aa_inverter_keybox:GetValue()) then
				if not gui.Reference("Menu"):IsActive() then
					if temp == 1 then
						gui.SetValue(aa_left_key, 0)
						gui.SetValue(aa_right_key, aa_inverter_keybox:GetValue())
						temp = 2
					elseif temp == 2 then
						gui.SetValue(aa_left_key, aa_inverter_keybox:GetValue())
						gui.SetValue(aa_right_key, 0)
						temp = 1
      	          else
     	               local var = math.random(1, 100)
            	        if var > 50 then
                 	    	gui.SetValue(aa_left_key, aa_inverter_keybox:GetValue())
							temp = 1
               		     else
							gui.SetValue(aa_right_key, aa_inverter_keybox:GetValue())
							temp = 2
						end
					end
				end
			end
		end
		if aa_indicator_box:GetValue() == true then
			draw.SetFont(font)
			
			if temp == 1 and gui.GetValue("lbot.antiaim.type") ~= '"Off"' then
				draw.Color(aa_indicator_colour:GetValue())
				draw.Text(right_indicator_position+aa_indicator_offset:GetValue(), screenheight/2-10, right_indicator_symbol)
				draw.Color(107, 107, 107, 150)
				draw.Text(left_indicator_position-aa_indicator_offset:GetValue(), screenheight/2-10, left_indicator_symbol)
			elseif temp == 2 and gui.GetValue("lbot.antiaim.type") ~= '"Off"' then
				draw.Color(aa_indicator_colour:GetValue())
				draw.Text(left_indicator_position-aa_indicator_offset:GetValue(), screenheight/2-10, left_indicator_symbol)
				draw.Color(107, 107, 107, 150)
				draw.Text(right_indicator_position+aa_indicator_offset:GetValue(), screenheight/2-10, right_indicator_symbol)
			else
				draw.Color(107, 107, 107, 150)
				draw.Text(left_indicator_position-aa_indicator_offset:GetValue(), screenheight/2-10, left_indicator_symbol)
				draw.Text(right_indicator_position+aa_indicator_offset:GetValue(), screenheight/2-10, right_indicator_symbol)
			end
		end
    end
end

callbacks.Register("Draw", AAInverter)

aa_toggle:SetDescription("Enable anti-aim inverter.")
aa_inverter_keybox:SetDescription("Choose the inverter keybind.")
aa_indicator_box:SetDescription("Enable anti-aim side indicator.")
aa_indicator_offset:SetDescription("Adjust horizontal indicator position.")
