local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 18/zoom)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom)
local sklepy = {
    {993.34, -1710.02, -82.03},
    {-1675.79, 431.92, 7.18},
    {-2419.90, 969.87, 45.30},
    {-1465.73, 1873.42, 32.63},
}

function renderShopGui()
    dxSetBlendMode("modulate_add")
    dxDrawRoundedRectangle(sx/2 - 340/zoom, sy/2 - 260/zoom, 680/zoom, 520/zoom, 25/zoom, tocolor(25,25,25,250))

    local isIn = isMouseInPosition(sx/2 - 315/zoom, sy/2 - 235/zoom, 300/zoom, 470/zoom, 25/zoom)
    dxDrawRoundedRectangle(sx/2 - 315/zoom, sy/2 - 235/zoom, 300/zoom, 470/zoom, 25/zoom, tocolor(20,20,20,isIn and 240 or 155))
    dxDrawImage(sx/2 - 280/zoom, sy/2 - 140/zoom, 240/zoom, 240/zoom, "data/toolbox.png", 0, 0, 0, isIn and tocolor(100,100,100,255) or tocolor(55,55,55,200))
    dxDrawText("Zestaw naprawczy", sx/2 - 280/zoom, sy/2 + 60/zoom, sx/2 - 40/zoom, nil, isIn and tocolor(100,100,100,255) or tocolor(55,55,55,200), 1, font1, "center", "top")
    dxDrawText("2500 PLN", sx/2 - 280/zoom, sy/2 + 90/zoom, sx/2 - 40/zoom, nil, isIn and tocolor(100,100,100,255) or tocolor(55,55,55,200), 1, font2, "center", "top")

    local isIn = isMouseInPosition(sx/2 + 15/zoom, sy/2 - 235/zoom, 300/zoom, 470/zoom, 25/zoom)
    dxDrawRoundedRectangle(sx/2 + 15/zoom, sy/2 - 235/zoom, 300/zoom, 470/zoom, 25/zoom, tocolor(20,20,20,isIn and 240 or 155))
    dxDrawImage(sx/2 + 40/zoom, sy/2 - 140/zoom, 240/zoom, 240/zoom, "data/battery.png", 0, 0, 0, isIn and tocolor(100,100,100,255) or tocolor(55,55,55,200))
    dxDrawText("Akumulator", sx/2 + 40/zoom, sy/2 + 60/zoom, sx/2 + 280/zoom, nil, isIn and tocolor(100,100,100,255) or tocolor(55,55,55,200), 1, font1, "center", "top")
    dxDrawText("1500 PLN", sx/2 + 40/zoom, sy/2 + 90/zoom, sx/2 + 280/zoom, nil, isIn and tocolor(100,100,100,255) or tocolor(55,55,55,200), 1, font2, "center", "top")
    dxSetBlendMode("blend")
end

function clickShopGui(btn, state)
    if btn ~= "left" or state ~= "up" then return end
    if isMouseInPosition(sx/2 - 315/zoom, sy/2 - 235/zoom, 300/zoom, 470/zoom, 25/zoom) then
        triggerServerEvent("buyRepairKit", localPlayer)
    elseif isMouseInPosition(sx/2 + 15/zoom, sy/2 - 235/zoom, 300/zoom, 470/zoom, 25/zoom) then
        triggerServerEvent("buyBattery", localPlayer)
    end
end

function showShopGui()
    addEventHandler("onClientRender", root, renderShopGui)
    addEventHandler("onClientClick", root, clickShopGui)
    showCursor(true, false)
end

function hideShopGui()
    removeEventHandler("onClientRender", root, renderShopGui)
    removeEventHandler("onClientClick", root, clickShopGui)
    showCursor(false)
end

function hitMarker(plr)
    if plr ~= localPlayer then return end
    showShopGui()
end

function leaveMarker(plr)
    if plr ~= localPlayer then return end
    hideShopGui()
end

for k,v in pairs(sklepy) do
    local marker = createMarker(v[1], v[2], v[3]-1.4, "cylinder", 1.2, 0, 200, 255)
    setElementInterior(marker, v[4] or 0)
    setElementData(marker, "marker:title", "Sklep 24/7")
    setElementData(marker, "marker:desc", "Miłych zakupów")
    addEventHandler("onClientMarkerHit", marker, hitMarker)
    addEventHandler("onClientMarkerLeave", marker, leaveMarker)
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

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end