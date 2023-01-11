local f = draw.CreateFont("Verdana", 30, 700);
local i = draw.CreateFont("Verdana", 13, 200);
local val = draw.CreateFont("Verdana", 16);
local t = draw.CreateFont("Verdana", 16);

local screen_x, screen_y = draw.GetScreenSize()

local time_offset = 85

local frame_rate = 0.0
    local get_abs_fps = function()
        frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
        return math.floor((1.0 / frame_rate) + 0.5)
end

local function drawrect()

    --aw

    draw.Color(44, 42, 99, 200); --thicc outline color
    draw.FilledRect(1616+time_offset, 12, 1681+time_offset, 57); --outline rect
    draw.Color(34, 29, 70, 160); --inside rect color 
    draw.FilledRect(1621+time_offset, 17, 1675+time_offset, 52); --inside rect
    draw.Color(18, 12, 38, 255); --inside rect outline color
    draw.OutlinedRect(1620+time_offset, 16, 1676+time_offset, 53); --inside rect outline
    draw.OutlinedRect(1615+time_offset, 11, 1681+time_offset, 58); --outside rect outline



    --info

    draw.Color(44, 42, 99, 200); --thicc outline color
    draw.FilledRect(1683+time_offset, 12, 1819+time_offset, 57); --outline rect
    draw.Color(34, 29, 70, 160); --inside rect color 
    draw.FilledRect(1688+time_offset, 17, 1813+time_offset, 52); --inside rect
    draw.Color(18, 12, 38, 255); --inside rect outline color
    draw.OutlinedRect(1687+time_offset, 16, 1814+time_offset, 53); --inside rect outline
    draw.OutlinedRect(1682+time_offset, 11, 1819+time_offset, 58); --outside rect outline

    --time

    --draw.Color(44, 42, 99, 200); --thicc outline color
    --draw.FilledRect(1821, 12, 1906, 57); --outline rect
    --draw.Color(34, 29, 70, 160); --inside rect color 
    --draw.FilledRect(1826, 17, 1902, 52); --inside rect
    --draw.Color(18, 12, 38, 255); --inside rect outline color
    --draw.OutlinedRect(1825, 17, 1902, 53); --inside rect outline
    --draw.OutlinedRect(1820, 11, 1907, 58); --outside rect outline

end

local function drawtext()

    local latency = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())

    --name

    draw.SetFont(f);
    draw.Color(255, 255, 255, 255);
    draw.TextShadow(1627+time_offset, 25, "A");
    draw.Color(201, 47, 96, 255);
    draw.TextShadow(1644+time_offset, 25, "W");

    --info

    --fps
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1697+time_offset, 39, "FPS");
    draw.SetFont(val);
    if (get_abs_fps() < 30) then
        draw.Color(255, 0, 0, 255);
    else
        draw.Color(126, 183, 50, 255);
    end
    local rw = draw.GetTextSize(tostring(get_abs_fps()));
    draw.TextShadow(1707+time_offset - (rw/2), 23, tostring(get_abs_fps()));

    --ping
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1731+time_offset, 39, "PING"); 
    draw.SetFont(val);
    draw.Color(126, 183, 50, 255);
    rw = draw.GetTextSize(tostring(latency));
    draw.TextShadow(1746+time_offset - (rw/2), 23, tostring(latency));

    --speed
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1769+time_offset, 39, "SPEED");
    draw.SetFont(val);
    local player = entities.GetLocalPlayer();

    local velocity = {x = 0, y = 0, final = 0}
    velocity.x = player:GetPropFloat( "localdata", "m_vecVelocity[0]" )
    velocity.y = player:GetPropFloat( "localdata", "m_vecVelocity[1]" )
    velocity.final = math.sqrt(velocity.x^2 + velocity.y^2)

    local speed = ""
    if (player:IsAlive()) then
        speed = tostring(math.floor(velocity.final))
    end

    rw = draw.GetTextSize(speed)
    draw.Color(126, 183, 50, 255);
    draw.TextShadow(1788+time_offset - (rw/2), 23, speed);

    --time
    --draw.SetFont(i);
    --draw.Color(255, 255, 255, 255);
    --draw.Text(1848, 39, "TIME");
    --draw.SetFont(t); 
    --draw.Color(0, 170, 255, 255);
    --draw.TextShadow(1830, 22, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec));

end

local function wm()
    
    if entities.GetLocalPlayer() then
        drawrect();
		drawtext();
    end

end

callbacks.Register('Draw', 'wm', wm);
