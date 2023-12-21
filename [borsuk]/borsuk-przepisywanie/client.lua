local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 18/zoom)
local font3 = exports["borsuk-gui"]:getFont("Lato-Regular", 13/zoom)
local myGroup = -1
local pojazdy = {}

local marker2 = createMarker(2848.49, -1129.42, 113.33-1, "cylinder", 1, 50, 170, 255)
setElementDimension(marker2, 1)
setElementData(marker2, "marker:title", "Organizacja")
setElementData(marker2, "marker:desc", "Przepisywanie pojazdów")

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    showPrzepisywanie()
    scrollPos = {k = 1, n = 11, m = 11}
end)

addEventHandler("onClientMarkerHit", marker2, function(plr)
    if plr ~= localPlayer then return end
    showPrzepisywanie()
    scrollPos = {k = 1, n = 11, m = 11}
end)

addEventHandler("onClientMarkerLeave", marker, function(plr)
    if plr ~= localPlayer then return end
    hidePrzepisywanie()
end)

addEventHandler("onClientMarkerLeave", marker2, function(plr)
    if plr ~= localPlayer then return end
    hidePrzepisywanie()
end)

function renderPrzepisywanie()
    dxDrawRoundedRectangle(sx/2 - 155/zoom - 1, sy/2 - 200/zoom - 1, 320/zoom + 2, 430/zoom + 2, 20/zoom, tocolor(45,45,45))
    dxDrawRoundedRectangle(sx/2 - 155/zoom, sy/2 - 200/zoom, 320/zoom, 430/zoom, 20/zoom, tocolor(25,25,25))
    dxDrawRectangle(sx/2 - 155/zoom, sy/2 - 158/zoom, 320/zoom, 1, tocolor(45,45,45))
    dxDrawRectangle(sx/2 - 155/zoom, sy/2 + 163/zoom, 320/zoom, 1, tocolor(45,45,45))
    dxDrawText("Przepisywanie", sx/2, sy/2 - 180/zoom, sx/2, sy/2 - 173/zoom, tocolor(255,255,255,105), 1, font2, "center", "center")

    x = 0
    local selected = false
    for i,v in ipairs(pojazdy) do
        if i >= scrollPos.k and i <= scrollPos.n then
            x = x + 1
            offsetY = (28/zoom)*(x-1)

            dxDrawRectangle(sx/2 - 148/zoom, sy/2 - 178/zoom + 28/zoom + offsetY, 304/zoom, 26/zoom, v.selected and tocolor(35,55,65) or tocolor(30, 30, 30))
            dxDrawText(exports["pystories-vehicles"]:getVehicleName(v.model), sx/2 - 142/zoom, sy/2 - 153/zoom + 28/zoom + offsetY, sx/2, sy/2 - 176/zoom + 28/zoom+offsetY, tocolor(255,255,255,155), 1, font3, "left", "center")
            dxDrawText(v.id, sx/2, sy/2 - 153/zoom + 28/zoom + offsetY, sx/2 + 152/zoom, sy/2 - 176/zoom + 28/zoom+offsetY, tocolor(255,255,255,155), 1, font3, "right", "center")
        
            if v.selected then selected = v end
        end
    end

    local isIn = isMouseInPosition(sx/2 - 60/zoom, sy/2 + 182/zoom, 120/zoom, 30/zoom)
    dxDrawRoundedRectangle(sx/2 - 60/zoom, sy/2 + 182/zoom, 120/zoom, 30/zoom, 10/zoom, isIn and tocolor(35,35,35) or tocolor(30,30,30))
    dxDrawText((selected and tonumber(selected.ownedGroup) == tonumber(myGroup)) and "Wypisz" or "Przepisz", sx/2, sy/2 + 200/zoom, sx/2, sy/2 + 193/zoom, tocolor(255,255,255,isIn and 200 or 105), 1, font3, "center", "center")

    drawScrollbar(pojazdy, sx/2 + 160/zoom, sy/2 - 150/zoom, 310/zoom, scrollPos.m, scrollPos.k)
end

function clickPrzepisywanie(btn, state)
    if btn ~= "left" or state ~= "down" then return end

    x = 0
    local selected = false
    for i,v in ipairs(pojazdy) do
        if i >= scrollPos.k and i <= scrollPos.n then
            x = x + 1
            offsetY = (28/zoom)*(x-1)

            if isMouseInPosition(sx/2 - 148/zoom, sy/2 - 178/zoom + 28/zoom + offsetY, 304/zoom, 26/zoom) then
                for d,c in pairs(pojazdy) do
                    c.selected = false
                end
                v.selected = true
            end
        end
    end

    for i,v in ipairs(pojazdy) do
        if v.selected then
            selected = v
        end
    end

    if isMouseInPosition(sx/2 - 60/zoom, sy/2 + 182/zoom, 120/zoom, 30/zoom) and selected then
        triggerServerEvent((selected and tonumber(selected.ownedGroup) == tonumber(myGroup)) and "wypiszPojazd" or "przepiszPojazd", localPlayer, selected.id, myGroup)
    end
end

function showPrzepisywanie()
    if not getElementData(localPlayer, "player:organization") then return end

    triggerServerEvent("getMyVehiclesPrzepisywanie", localPlayer)
    hidePrzepisywanie()
    addEventHandler("onClientRender", root, renderPrzepisywanie)
    addEventHandler("onClientClick", root, clickPrzepisywanie)
    showCursor(true, false)

    myGroup = getElementData(localPlayer, "player:organization:data").id
end

addEvent("returnMyVehiclesPrzepisywanie", true)
addEventHandler("returnMyVehiclesPrzepisywanie", root, function(t)
    pojazdy = t
end)

function hidePrzepisywanie()
    removeEventHandler("onClientRender", root, renderPrzepisywanie)
    removeEventHandler("onClientClick", root, clickPrzepisywanie)

    showCursor(false)
end

addEvent("onButtonClick", true)
addEventHandler("onButtonClick", root, function(button, c, s)
	if c ~= "left" or s ~= "down" then 
		return 
	end
	if button == anuluj then
        hidePrzepisywanie()
    elseif button == stworz then
        local name = exports["borsuk-gui"]:getEditboxText(nazwa)
        local tag_ = exports["borsuk-gui"]:getEditboxText(tag)
        local hex_ = exports["borsuk-gui"]:getEditboxText(hex)
        if name:len() < 3 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nazwa organizacji musi być dłuższa", {255, 50, 50}, "sighter")
        elseif getElementData(localPlayer, "player:organization") then
            --return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Już posiadasz organizację", {255, 50, 50}, "sighter")
        elseif name:len() > 16 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nazwa organizacji musi być krótsza", {255, 50, 50}, "sighter")
        elseif hex_:gsub("#", ""):len() ~= 6 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "HEX jest nie prawidłowy", {255, 50, 50}, "sighter")
        elseif tag_:len() ~= 4 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "TAG jest nie prawidłowy (4 znaki)", {255, 50, 50}, "sighter")
        elseif name:len() > 16 then 
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nazwa organizacji musi być krótsza", {255, 50, 50}, "sighter")
        elseif tonumber(getElementData(localPlayer, "player:lvl")) < 15 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nie posiadasz 15 poziomu", {255, 50, 50}, "sighter")
        elseif getPlayerMoney() < 200000 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nie posiadasz 200,000 PLN", {255, 50, 50}, "sighter")
        end

        local r, g, b = hex2rgb(hex_)
        if not r or not g or not b then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "HEX jest nie prawidłowy", {255, 50, 50}, "sighter")
        end

        triggerServerEvent("createOrg", localPlayer, name, tag_, r, g, b)
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    hidePrzepisywanie()
end)

function hex2rgb(hex) 
    hex = hex:gsub("#","") 
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
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

function drawScrollbar(table, x, y, height, m_, k_)
    dxDrawRectangle(x, y, 2/zoom, height, tocolor(65, 65, 65, 55))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 1 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end

        dxDrawRectangle(x, scrollbarPos, 2/zoom, scrollbarHeight*(m_-1), tocolor(0, 195, 255, 125))
    else
        dxDrawRectangle(x, y, 2/zoom, height, tocolor(0, 195, 255, 125))
	end
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