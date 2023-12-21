--if getElementData(localPlayer, "player:sid") ~= 3 then return end

local serverTick = {
    current = 0,
    startClient = getTickCount(),
    startServer = 0,
}
eventData = false
local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 20/zoom)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom)
local font3 = exports["borsuk-gui"]:getFont("Lato-Regular", 12/zoom)

addEventHandler("onClientRender", root, function()
    serverTick.current = serverTick.startServer + (getTickCount() - serverTick.startClient)

    if eventData then
        local data = events[eventData.name]
        local seconds = math.floor((eventData.start - serverTick.current)/1000)
        local minutes = math.max(math.floor(seconds/60), 0)
        seconds = math.max(seconds - minutes*60, 0)
        if seconds > 0 or minutes > 0 then
            dxDrawRoundedRectangle(sx/2 - 250/zoom-1, 20/zoom-1, 500/zoom+2, 130/zoom+2, 15/zoom, tocolor(75,75,75,100))
            dxDrawRoundedRectangle(sx/2 - 250/zoom, 20/zoom, 500/zoom, 130/zoom, 15/zoom, tocolor(15,15,15))
            dxDrawText(data.name, sx/2, 28/zoom, sx/2, nil, tocolor(100,200,255,200), 1, font1, "center", "top")
            dxDrawRectangle(sx/2 - 250/zoom, math.floor(66/zoom), 500/zoom, 1, tocolor(100,200,255,200))

            dxDrawText(("Zapisanych: %02d/%02d\nPozostały czas: %02d:%02d"):format(#eventData.zapisani, data.maxOsob, minutes, seconds), sx/2, 70/zoom, sx/2, nil, tocolor(255,255,255,200), 1, font2, "center", "top")
            dxDrawText("/event", sx/2, 122/zoom, sx/2, nil, tocolor(255,255,255,200), 1, font3, "center", "top")
        end

        if getElementData(localPlayer, "player:event") and eventData.started then
            if eventData.name == "tron" and (eventData.start - serverTick.current) < -5000 then
                updateTron()
            elseif eventData.name == "ztp" then
                updateZtp()
            end
        end
    end
end)

function stillPlaying()
    local t = {}
    for k,v in pairs(eventData.zapisani) do
        if not getElementData(v, "player:event:lost") then
            table.insert(t, v)
            table.insert(t, v)
            table.insert(t, v)
            table.insert(t, v)
        end
    end
    return t
end

addEvent("koniecEventuTron", true)
addEventHandler("koniecEventuTron", root, function()
    eventData = nil
    setCameraTarget(localPlayer)
end)

addEvent("startEvent", true)
addEventHandler("startEvent", root, function(data)
    eventData = data

    if data.name == "tron" then
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh then
            local _, _, rot = getElementRotation(veh)
            local vx, vy = getPointFromDistanceRotation(0, 0, 0.5, -rot)
            setElementVelocity(veh, vx, vy, 0)
        end
    end
end)

triggerServerEvent("getServerTickEvent", localPlayer)

addEvent("returnServerTickEvent", true)
addEventHandler("returnServerTickEvent", root, function(tick)
    serverTick = {
        current = 0,
        startClient = getTickCount(),
        startServer = tick,
    }
end)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end