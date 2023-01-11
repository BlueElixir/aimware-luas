local screen_x, screen_y = draw.GetScreenSize()
local oldscreen_x, oldscreen_y = screen_x, screen_y

local res_modifier = 1 - ((1920 - screen_x) / 1920)
local time_offset = 85*res_modifier

local fonts = {
    f1 = draw.CreateFont("Verdana", 30*res_modifier, 700),
    f2 = draw.CreateFont("Verdana", 13*res_modifier, 200),
    f3 = draw.CreateFont("Verdana", 16*res_modifier)
}

local frame_rate = 0.0
    local get_abs_fps = function()
        frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
        return math.floor((1.0 / frame_rate) + 0.5)
end

local function drawrect()

    --aw

    draw.Color(44, 42, 99, 200) --thicc outline color
    draw.FilledRect(screen_x*0.84167 + time_offset*res_modifier, screen_y*0.01111, screen_x*0.87552 + time_offset*res_modifier, screen_y*0.05278) --outline rect
    draw.Color(34, 29, 70, 160) --inside rect color 
    draw.FilledRect(screen_x*0.84427 + time_offset*res_modifier, screen_y*0.01574, screen_x*0.87240 + time_offset*res_modifier, screen_y*0.04815) --inside rect
    draw.Color(18, 12, 38, 255) --inside rect outline color
    draw.OutlinedRect(screen_x*0.84375 + time_offset*res_modifier, screen_y*0.01481, screen_x*0.87292 + time_offset*res_modifier, screen_y*0.04907) --inside rect outline
    draw.OutlinedRect(screen_x*0.84115 + time_offset*res_modifier, screen_y*0.01019, screen_x*0.87552 + time_offset*res_modifier, screen_y*0.05370) --outside rect outline

    --info

    draw.Color(44, 42, 99, 200) --thicc outline color
    draw.FilledRect(screen_x*0.87656 + time_offset*res_modifier, screen_y*0.01111, screen_x*0.94740 + time_offset*res_modifier, screen_y*0.05278) --outline rect
    draw.Color(34, 29, 70, 160) --inside rect color 
    draw.FilledRect(screen_x*0.87917 + time_offset*res_modifier, screen_y*0.01574, screen_x*0.94427 + time_offset*res_modifier, screen_y*0.04815) --inside rect
    draw.Color(18, 12, 38, 255) --inside rect outline color
    draw.OutlinedRect(screen_x*0.87865 + time_offset*res_modifier , screen_y*0.01481, screen_x*0.94479 + time_offset*res_modifier, screen_y*0.04907) --inside rect outline
    draw.OutlinedRect(screen_x*0.87604 + time_offset*res_modifier , screen_y*0.01019, screen_x*0.94740 + time_offset*res_modifier, screen_y*0.05370) --outside rect outline

    --time

    --draw.Color(44, 42, 99, 200) --thicc outline color
    --draw.FilledRect(1821, 12, 1906, 57) --outline rect
    --draw.Color(34, 29, 70, 160) --inside rect color 
    --draw.FilledRect(1826, 17, 1902, 52) --inside rect
    --draw.Color(18, 12, 38, 255) --inside rect outline color
    --draw.OutlinedRect(1825, 17, 1902, 53) --inside rect outline
    --draw.OutlinedRect(1820, 11, 1907, 58) --outside rect outline

end

local function drawtext()

    local latency = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())

    --name

    draw.SetFont(fonts.f1)
    draw.Color(255, 255, 255, 255)
    draw.TextShadow(screen_x*0.84740 + time_offset*res_modifier, screen_y*0.02315, "A")
    draw.Color(201, 47, 96, 255)
    draw.TextShadow(screen_x*0.85625 + time_offset*res_modifier, screen_y*0.02315, "W")

    --info

    --fps
    draw.SetFont(fonts.f2)
    draw.Color(255, 255, 255, 255)
    draw.Text(screen_x*0.88385 + time_offset*res_modifier + ((1 - res_modifier) * draw.GetTextSize("FPS")/2.5), screen_y*0.03611, "FPS")
    draw.SetFont(fonts.f3)

    local v = get_abs_fps()

    if v < 30 then draw.Color(255, 0, 0, 255)
    elseif v < 100 then draw.Color(255, 255, 0, 255)
    else draw.Color(126, 183, 50, 255)
    end
    draw.TextShadow(screen_x*0.88906 + time_offset*res_modifier - draw.GetTextSize(tostring(get_abs_fps()))/2, screen_y*0.02130, tostring(get_abs_fps()))

    --ping
    draw.SetFont(fonts.f2)
    draw.Color(255, 255, 255, 255)
    draw.Text(screen_x*0.90156 + time_offset*res_modifier + ((1 - res_modifier) * draw.GetTextSize("PING")/2.5), screen_y*0.03611, "PING") 
    draw.SetFont(fonts.f3)
    draw.Color(126, 183, 50, 255)
    draw.TextShadow(screen_x*0.90938 + time_offset*res_modifier - draw.GetTextSize(tostring(latency))/2, screen_y*0.02130, tostring(latency))

    --speed
    draw.SetFont(fonts.f2)
    draw.Color(255, 255, 255, 255)
    draw.Text(screen_x*0.92135 + time_offset*res_modifier + ((1 - res_modifier) * draw.GetTextSize("SPEED")/2.5), screen_y*0.03611, "SPEED")
    draw.SetFont(fonts.f3)
    local player = entities.GetLocalPlayer()

    local velocity = {x = 0, y = 0, final = 0}
    velocity.x = player:GetPropFloat("localdata", "m_vecVelocity[0]")
    velocity.y = player:GetPropFloat("localdata", "m_vecVelocity[1]")
    velocity.final = math.sqrt(velocity.x^2 + velocity.y^2)

    local speed = ""
    if (player:IsAlive()) then
        speed = tostring(math.floor(velocity.final))
    end

    draw.Color(126, 183, 50, 255)
    draw.TextShadow(screen_x*0.93125 + time_offset*res_modifier - draw.GetTextSize(speed)/2, screen_y*0.02130, speed)

    --time
    --draw.SetFont(fonts.f2)
    --draw.Color(255, 255, 255, 255)
    --draw.Text(1848, 39, "TIME")
    --draw.SetFont(t) 
    --draw.Color(0, 170, 255, 255)
    --draw.TextShadow(1830, 22, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))

end

local function wm()
    
    if entities.GetLocalPlayer() then
        screen_x, screen_y = draw.GetScreenSize()
        if oldscreen_x ~= screen_x or oldscreen_y ~= screen_y then
            oldscreen_x = screen_x
            oldscreen_y = screen_y
            res_modifier = 1 - ((1920 - screen_x) / 1920)
            time_offset = 85*res_modifier

            fonts.f1 = draw.CreateFont("Verdana", 30*res_modifier, 700)
            fonts.f2 = draw.CreateFont("Verdana", 13*res_modifier, 200)
            fonts.f3 = draw.CreateFont("Verdana", 16*res_modifier)

        end
        drawrect()
		drawtext()
    end

end

callbacks.Register('Draw', 'wm', wm)
