local marker = createMarker(-2056.75, 184.19, 27.70-1, "cylinder", 1.4, 0, 255, 255)
setElementData(marker, "marker:title", "Lakiernik")
setElementData(marker, "marker:desc", "Wybór koloru")
local palette = dxCreateTexture("data/palette.png")
local pixels = dxGetTexturePixels(palette)
local r, g, b, c = 255, 0, 0, 0
local r2, g2, b2, cx2, cy2 = 255,255,255, 0, 0
local rt = dxCreateRenderTarget(500, 500, false)
local lastSend = getTickCount()

local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom)

function takeSpray(spray)
    setElementData(localPlayer, "player:spray1", nil)
    setElementData(localPlayer, "player:spray2", nil)
    setElementData(localPlayer, "player:spray3", nil)
    setElementData(localPlayer, "player:spray4", nil)
    setElementData(localPlayer, "player:spray" .. spray, {r2, g2, b2})
    triggerServerEvent("takeSprayLakiernia", localPlayer, spray)
    hideLakierniaGui()
end

addEvent("onButtonClick", true)
addEventHandler("onButtonClick", root, function(button, c, s)
	if c ~= "left" or s ~= "up" then return end
	if button == spray1 then
        setTimer(takeSpray, 100, 1, 1)
    elseif button == spray2 then
        setTimer(takeSpray, 100, 1, 2)
    elseif button == spray3 then
        setTimer(takeSpray, 100, 1, 3)
    elseif button == spray4 then
        setTimer(takeSpray, 100, 1, 4)
	end
end)

addEventHandler("onClientPlayerWeaponFire", root, function(weapon)
    if source ~= localPlayer or weapon ~= 41 then return end
    local rgb, id
    for i = 1, 4 do
        local color = getElementData(localPlayer, "player:spray" .. i)
        if color then
            rgb = color
            id = i
        end
    end

    local x, y, z = getWorldFromScreenPosition(sx/2, sy/2, 0)
    local tx, ty, tz = getWorldFromScreenPosition(sx/2, sy/2, 10)
    --dxDrawLine3D(x, y, z, tx, ty, tz, tocolor(255,0,0),2)

    local hit, hx, hy, hz, el = processLineOfSight(x,y,z,tx,ty,tz,false,true,false,false,false,false,false)
    if el and getElementType(el) == "vehicle" and lastSend < getTickCount() and getDistanceBetweenPoints3D(Vector3(getElementPosition(el)), Vector3(getElementPosition(localPlayer))) < 6 then
        if getElementData(el, "vehicle:driver") ~= localPlayer then return end
        triggerServerEvent("slowlyChangeVehicleColor", localPlayer, el, rgb, id)
        lastSend = getTickCount()+5
    end
end)

function renderLakierniaGui()
    dxSetRenderTarget(rt, true)
    dxDrawRectangle(0,0,500,500,tocolor(255,255,255))
    dxDrawImage(0,0,500,500,"data/color.png",0,0,0,tocolor(r,g,b))
    dxDrawImage(0,0,500,500,"data/black.png")
    dxSetRenderTarget()

    dxDrawRoundedRectangle(sx/2 - 245/zoom, sy/2 - 225/zoom, 490/zoom, 580/zoom, 15/zoom, tocolor(20,20,20,255))
    dxDrawImage(sx/2 + 188/zoom, sy/2 - 205/zoom + 410/zoom*c - 8/zoom, 49/zoom, 16/zoom, "data/arrow.png", 0, 0, 0, tocolor(0,0,0))
    dxDrawImage(sx/2 + 200/zoom, sy/2 - 205/zoom, 25/zoom, 410/zoom, "data/palette.png")
    dxDrawImage(sx/2 + 190/zoom, sy/2 - 205/zoom + 410/zoom*c - 5/zoom, 45/zoom, 10/zoom, "data/arrow.png")
    dxDrawImage(math.floor(sx/2 - 225/zoom), math.floor(sy/2 - 205/zoom), math.floor(410/zoom), math.floor(410/zoom), rt)
    dxDrawImage(sx/2 - 225/zoom + 410/zoom*cx2 - 10/zoom, sy/2 - 205/zoom + 410/zoom*cy2 - 10/zoom, 20/zoom, 20/zoom, "data/pick.png")
    dxDrawRectangle(sx/2 - 225/zoom, sy/2 + 212/zoom, 450/zoom, 10/zoom, tocolor(r2,g2,b2))
    dxDrawText("Koszt malowania wynosi 1000 PLN", sx/2-1, sy/2 + 360/zoom-1, sx/2-1, nil, tocolor(0,0,0), 1, font1, "center", "top")
    dxDrawText("Koszt malowania wynosi 1000 PLN", sx/2, sy/2 + 360/zoom, sx/2, nil, white, 1, font1, "center", "top")

    if isMouseInPosition(sx/2 + 200/zoom, sy/2 - 205/zoom, 25/zoom, 410/zoom) and getKeyState("mouse1") then
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy
        cx, cy = (cx - (sx/2 + 200/zoom))/(25/zoom), (cy - (sy/2 - 205/zoom))/(410/zoom)
        r, g, b = dxGetPixelColor(pixels, 1, math.min(math.max(cy*500, 1), 499))
        c = cy

        pixels2 = dxGetTexturePixels(rt, cx2*500, cy2*500, 2, 2)
        r2, g2, b2 = dxGetPixelColor(pixels2, 1, 1)
    elseif isMouseInPosition(sx/2 - 225/zoom, sy/2 - 205/zoom, 410/zoom, 410/zoom) and getKeyState("mouse1") then
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy
        cx, cy = (cx - (sx/2 - 225/zoom))/(410/zoom), (cy - (sy/2 - 205/zoom))/(410/zoom)
        cx2, cy2 = cx, cy
        pixels2 = dxGetTexturePixels(rt, cx2*500, cy2*500, 2, 2)
        r2, g2, b2 = dxGetPixelColor(pixels2, 1, 1)
    end
end

function showLakierniaGui()
    addEventHandler("onClientRender", root, renderLakierniaGui)
    showCursor(true, false)

    spray1 = exports["borsuk-gui"]:createButton("Kolor podstawowy", sx/2-220/zoom, sy/2 + 235/zoom, 210/zoom, 45/zoom, font3)
    spray2 = exports["borsuk-gui"]:createButton("Kolor dodatkowy", sx/2+10/zoom, sy/2 + 235/zoom, 210/zoom, 45/zoom, font3)
    spray3 = exports["borsuk-gui"]:createButton("Kolor felg", sx/2-220/zoom, sy/2 + 290/zoom, 210/zoom, 45/zoom, font3)
    spray4 = exports["borsuk-gui"]:createButton("Kolor rantów", sx/2+10/zoom, sy/2 + 290/zoom, 210/zoom, 45/zoom, font3)
end

function hideLakierniaGui()
    removeEventHandler("onClientRender", root, renderLakierniaGui)
    showCursor(false)

    spray1 = exports['borsuk-gui']:destroyButton(spray1)
    spray2 = exports['borsuk-gui']:destroyButton(spray2)
    spray3 = exports['borsuk-gui']:destroyButton(spray3)
    spray4 = exports['borsuk-gui']:destroyButton(spray4)
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	hideLakierniaGui()
end)

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    showLakierniaGui()
end)

addEventHandler("onClientMarkerLeave", marker, function(plr)
    if plr ~= localPlayer then return end
    hideLakierniaGui()
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

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end