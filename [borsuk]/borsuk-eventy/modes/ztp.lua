local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()*0.5
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 8/zoom)
local arena = createObject(17511, 464.669983,-2501.499268,-0.550000)
setElementDimension(arena, 699)

function lostZtp()
    if (lastTron or 0) > getTickCount() then return end
    triggerServerEvent("przegralemWZTP", localPlayer)
    lastTron = getTickCount()+1000
    setElementData(localPlayer, "player:event", false)
end

function updateZtp()
    local x, y, z = getElementPosition(localPlayer)
    if z < 1 then
        lostZtp()
    end

    local playing = stillPlaying()
    local h = 0
    table.sort(playing, function(a, b)
        return (getElementData(a, "player:event:points") or 0) > (getElementData(b, "player:event:points") or 0)
    end)
    for k,v in pairs(playing) do
        if k <= 10 then
            h = h + 27/zoom
        end
    end
    local y = sy/2 - h/2
    for k,v in pairs(playing) do
        if k <= 10 then
            dxDrawRoundedRectangle(sx - 150/zoom - 1, y - 1, 140/zoom + 2, 23/zoom + 2, 10/zoom, tocolor(0, 0, 0, 200))
            dxDrawRoundedRectangle(sx - 150/zoom, y, 140/zoom, 23/zoom, 10/zoom, tocolor(25, 25, 25, 255))
            dxDrawText(getPlayerName(v), sx - 140/zoom, y, sx - 10/zoom, y+23/zoom, white, 1, font1, "left", "center")
            dxDrawText((getElementData(a, "player:event:points") or 0), sx - 140/zoom, y, sx - 20/zoom, y+23/zoom, white, 1, font1, "right", "center")

            y = y + 27/zoom
        end
    end
end

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