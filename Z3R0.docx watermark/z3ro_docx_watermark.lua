local f = draw.CreateFont("Verdana", 30, 700);
local i = draw.CreateFont("Verdana", 13, 200);
local val = draw.CreateFont("Verdana", 16);
local t = draw.CreateFont("Verdana", 16);

function wm()
    
    if entities.GetLocalPlayer() then
        drawrect();
		drawtext();
    end

end

local frame_rate = 0.0
    local get_abs_fps = function()
        frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
        return math.floor((1.0 / frame_rate) + 0.5)
end

function drawrect()

    --aw

    draw.Color(44, 42, 99, 200); --thicc outline color
    draw.FilledRect(1616, 12, 1681, 57); --outline rect  ------
    draw.Color(34, 29, 70, 160); --inside rect color 
    draw.FilledRect(1621, 17, 1675, 52); --inside rect  ------
    draw.Color(18, 12, 38, 255); --inside rect outline color
    draw.OutlinedRect(1620, 16, 1676, 53); --inside rect outline  ------
    draw.OutlinedRect(1615, 11, 1681, 58); --outside rect outline  ------

    --info

    draw.Color(44, 42, 99, 200); --thicc outline color
    draw.FilledRect(1683, 12, 1819, 57); --outline rect  ------
    draw.Color(34, 29, 70, 160); --inside rect color 
    draw.FilledRect(1688, 17, 1813, 52); --inside rect  ------
    draw.Color(18, 12, 38, 255); --inside rect outline color
    draw.OutlinedRect(1687, 16, 1814, 53); --inside rect outline  ------
    draw.OutlinedRect(1682, 11, 1819, 58); --outside rect outline  ------

    --time

    draw.Color(44, 42, 99, 200); --thicc outline color
    draw.FilledRect(1821, 12, 1906, 57); --outline rect  ------
    draw.Color(34, 29, 70, 160); --inside rect color 
    draw.FilledRect(1826, 17, 1902, 52); --inside rect  ------
    draw.Color(18, 12, 38, 255); --inside rect outline color
    draw.OutlinedRect(1825, 17, 1902, 53); --inside rect outline  ------
    draw.OutlinedRect(1820, 11, 1907, 58); --outside rect outline  ------

end

function drawtext()

    local rw,rh;

    local speed = 0;
    local latency= 0;
     if entities.FindByClass( "CBasePlayer" )[1] ~= nil then
        latency=entities.GetPlayerResources():GetPropInt( "m_iPing", client.GetLocalPlayerIndex() )
     end

    --name

    draw.SetFont(f);
    draw.Color(255, 255, 255, 255);
    draw.TextShadow(1627, 25, "A");
    draw.Color(201, 47, 96, 255);
    draw.TextShadow(1644, 25, "W");

    --info

    --fps
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1697, 39, "FPS");
    draw.SetFont(val);
    if (get_abs_fps() < 30) then
        draw.Color(255, 0, 0);
    else
        draw.Color(126, 183, 50);
    end
    rw,rh = draw.GetTextSize(get_abs_fps());
    draw.TextShadow(1707 - (rw/2), 23, get_abs_fps());

    --ping
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1731, 39, "PING"); 
    draw.SetFont(val);
    draw.Color(126, 183, 50);
    rw,rh = draw.GetTextSize(latency);
    draw.TextShadow(1746 - (rw/2), 23, latency);

    --speed
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1769, 39, "SPEED");
    draw.SetFont(val);
    if entities.GetLocalPlayer() ~= nil then

        local Entity = entities.GetLocalPlayer();
        local Alive = Entity:IsAlive();
        local velocityX = Entity:GetPropFloat( "localdata", "m_vecVelocity[0]" );
        local velocityY = Entity:GetPropFloat( "localdata", "m_vecVelocity[1]" );
        local velocity = math.sqrt( velocityX^2 + velocityY^2 );
        local FinalVelocity = math.min( 9999, velocity ) + 0.2;
        if ( Alive == true ) then
          speed= math.floor(FinalVelocity) ;
        else
          speed=0;
        end
    end
    rw,rh = draw.GetTextSize(speed)
    draw.Color(126, 183, 50);
    draw.TextShadow(1788 - (rw/2), 23, speed);

    --time
    draw.SetFont(i);
    draw.Color(255, 255, 255, 255);
    draw.Text(1848, 39, "TIME");
    draw.SetFont(t); 
    draw.Color(0, 170, 255, 255);
    --draw.TextShadow(1830, 22, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec));

end

callbacks.Register('Draw', 'wm', wm);
client.AllowListener( "client_disconnect" );
client.AllowListener( "begin_new_match" );
