local mechy = {}
local targets = {}
local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 14)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 16/zoom)
local font3 = exports["borsuk-gui"]:getFont("Lato-Regular", 14/zoom)
local scrollPos = {k = 1, n = 11, m = 11}
local fixVehicle = false
local serverTick = {current=0, start=0, startC=0}
local fixing = {}

local doNaprawy = {
	{"Silnik", 1, fn=function(veh) if getElementHealth(veh)>=2040 then return true end; return false end, cena=65}, 
	{"Maska", 2, fn=function(veh) if getVehicleDoorState(veh, 0)==0 then return true end; return false end, cena=35},
	{"Bagażnik", 3, fn=function(veh) if getVehicleDoorState(veh, 1)==0 then return true end; return false end, cena=35},
	{"Drzwi lewy przód", 4, fn=function(veh) if getVehicleDoorState(veh, 2)==0 then return true end; return false end, cena=35},
	{"Drzwi prawy przód", 5, fn=function(veh) if getVehicleDoorState(veh, 3)==0 then return true end; return false end, cena=35},
	{"Drzwi lewy tył", 6, fn=function(veh) if getVehicleDoorState(veh, 4)==0 then return true end; return false end, cena=35},
	{"Drzwi prawy tył", 7, fn=function(veh) if getVehicleDoorState(veh, 5)==0 then return true end; return false end, cena=35},
	{"Szyba przednia", 8, fn=function(veh) if getVehiclePanelState(veh, 4)==0 then return true end; return false end, cena=35},
	{"Zderzak przedni", 9, fn=function(veh) if getVehiclePanelState(veh, 5)==0 then return true end; return false end, cena=35},
	{"Zderzak tylni", 10, fn=function(veh) if getVehiclePanelState(veh, 6)==0 then return true end; return false end, cena=35},
	{"Światło lewe przednie", 11, fn=function(veh) if getVehicleLightState(veh, 0)==0 then return true end; return false end, cena=25},
	{"Światła prawe przednie", 12, fn=function(veh) if getVehicleLightState(veh, 1)==0 then return true end; return false end, cena=25},
	{"Światła lewe tylnie", 13, fn=function(veh) if getVehicleLightState(veh, 2)==0 then return true end; return false end, cena=25},
	{"Światła prawe tylnie", 14, fn=function(veh) if getVehicleLightState(veh, 3)==0 then return true end; return false end, cena=25},
}

triggerServerEvent("getMechs", localPlayer)

addEvent("returnMechs", true)
addEventHandler("returnMechs", root, function(t, tick)
    mechy = t
    serverTick = {current=tick,start=tick,startC=getTickCount()}
    for k,v in pairs(mechy) do
        if not targets[k] then
            targets[k] = dxCreateRenderTarget(170, 50, false)
        end
    end
end)

function drawGlowText(text, x, y, w, h, color, ...)
    --[[for _x = -5, 5 do
        for _y = -5, 5 do
            dxDrawText(text, x + _x, y + _y, w + _x, h + _y, tocolor(255,255,255,2), ...)
        end
    end]]
    dxDrawText(text, x, y, w, h, color, ...)
end

addEventHandler("onClientRender", root, function()
    serverTick.current = serverTick.start + (getTickCount()-serverTick.startC)

    local x, y, z = getElementPosition(localPlayer)
    for k,v in pairs(mechy) do
        if getDistanceBetweenPoints3D(x, y, z, v.brama[2], v.brama[3], v.brama[4]) < 50 then
            dxSetRenderTarget(targets[k], true)
            dxDrawRectangle(0, 0, 170, 50, tocolor(0, 0, 0))
            if not v.used then
                local vehicles = getElementsWithinColShape(v.col, "vehicle")
                drawGlowText((#vehicles == 0 and "WOLNE" or "ZAJĘTE") .. " MIEJSCE", 0, 0, 170, 50, white, 1, font1, "center", "center")
            else
                if serverTick.current % 10000 < 3000 then
                    drawGlowText(v.owner:upper(), 0, 0, 170, 50, white, 1, font1, "center", "center")
                elseif serverTick.current % 10000 < 6000 then
                    drawGlowText(exports["pystories-vehicles"]:getVehicleName(v.used):upper(), 0, 0, 170, 50, white, 1, font1, "center", "center")
                else
                    drawGlowText(("%d SEKUND"):format(math.max(v.endTime - serverTick.current, 0)/1000), 0, 0, 170, 50, white, 1, font1, "center", "center")
                end
            end
            dxSetRenderTarget()
            
            dxDrawMaterialLine3D(v.rt[1], v.rt[2], v.rt[3], v.rt[4], v.rt[5], v.rt[6], targets[k], v.rt[7], white, v.rt[8], v.rt[9], v.rt[10])
        end
    end
end)

function renderGUI()
    dxDrawRoundedRectangle(sx/2 - 155/zoom - 1, sy/2 - 200/zoom - 1, 320/zoom + 2, 430/zoom + 2, 20/zoom, tocolor(45,45,45))
    dxDrawRoundedRectangle(sx/2 - 155/zoom, sy/2 - 200/zoom, 320/zoom, 430/zoom, 20/zoom, tocolor(25,25,25))
    dxDrawRectangle(sx/2 - 155/zoom, sy/2 - 158/zoom, 320/zoom, 1, tocolor(45,45,45))
    dxDrawRectangle(sx/2 - 155/zoom, sy/2 + 163/zoom, 320/zoom, 1, tocolor(45,45,45))
    dxDrawText("Mechanik", sx/2, sy/2 - 180/zoom, sx/2, sy/2 - 173/zoom, tocolor(255,255,255,105), 1, font2, "center", "center")

    x = 0
    local cost = 0
    for i,v in ipairs(fixing) do
        if i >= scrollPos.k and i <= scrollPos.n then
            x = x + 1
            offsetY = (28/zoom)*(x-1)

            dxDrawRectangle(sx/2 - 148/zoom, sy/2 - 178/zoom + 28/zoom + offsetY, 304/zoom, 26/zoom, v.selected and tocolor(35,55,65) or tocolor(30, 30, 30))
            dxDrawText(v.name, sx/2 - 142/zoom, sy/2 - 153/zoom + 28/zoom + offsetY, sx/2, sy/2 - 176/zoom + 28/zoom+offsetY, tocolor(255,255,255,155), 1, font3, "left", "center")
            dxDrawText(v.cost .. " PLN", sx/2, sy/2 - 153/zoom + 28/zoom + offsetY, sx/2 + 152/zoom, sy/2 - 176/zoom + 28/zoom+offsetY, tocolor(255,255,255,155), 1, font3, "right", "center")
            
            if v.selected then cost = cost + v.cost end
        end
    end

    local isIn = isMouseInPosition(sx/2 - 60/zoom, sy/2 + 192/zoom, 120/zoom, 30/zoom)
    dxDrawRoundedRectangle(sx/2 - 60/zoom, sy/2 + 192/zoom, 120/zoom, 30/zoom, 10/zoom, isIn and tocolor(35,35,35) or tocolor(30,30,30))
    dxDrawText("Koszt naprawy: " .. cost .. " PLN", sx/2, sy/2 + 150/zoom, sx/2, sy/2 + 203/zoom, tocolor(255,255,255,200), 1, font3, "center", "center")
    dxDrawText("Napraw", sx/2, sy/2 + 210/zoom, sx/2, sy/2 + 203/zoom, tocolor(255,255,255,isIn and 200 or 105), 1, font3, "center", "center")

    drawScrollbar(fixing, sx/2 + 160/zoom, sy/2 - 150/zoom, 310/zoom, scrollPos.m, scrollPos.k)
end

function clickRepairGUI(btn, state)
    if btn ~= "left" or state ~= "down" then return end

    x = 0
    local cost = 0
    local selected = {}
    for i,v in ipairs(fixing) do
        if i >= scrollPos.k and i <= scrollPos.n then
            x = x + 1
            offsetY = (28/zoom)*(x-1)

            if isMouseInPosition(sx/2 - 148/zoom, sy/2 - 178/zoom + 28/zoom + offsetY, 304/zoom, 26/zoom) then
                v.selected = not v.selected
            end

            if v.selected then
                cost = cost + v.cost
                table.insert(selected, v.name)
            end
        end
    end

    if isMouseInPosition(sx/2 - 60/zoom, sy/2 + 192/zoom, 120/zoom, 30/zoom) then
        if cost == 0 then
            exports["noobisty-notyfikacje"]:createNotification("Mechanik", "Musisz wybrać komponenty do naprawy", {255, 50, 50}, "sighter")
            return
        end
        if getPlayerMoney(localPlayer) < cost then
            exports["noobisty-notyfikacje"]:createNotification("Mechanik", "Nie posiadasz tyle gotówki", {255, 50, 50}, "sighter")
            return
        end
        triggerServerEvent("repairVehicle", localPlayer, cost, selected, fixVehicle, currentMarker)
        hideRepairGUI()
    end
end

function scrollDown()
    if scrollPos.n >= #fixing then return end
    scrollPos.k = scrollPos.k+1
    scrollPos.n = scrollPos.n+1
end

function scrollUp()
    if scrollPos.n == scrollPos.m then return end
    scrollPos.k = scrollPos.k-1
    scrollPos.n = scrollPos.n-1
end

bindKey("mouse_wheel_down", "down", scrollDown)
bindKey("mouse_wheel_up", "down", scrollUp)

function reloadTable(veh)
    doNaprawy = {
        {"Silnik", 1, fn=function(veh) if getElementHealth(veh)>=2040 then return true end; return false end, cena=65}, 
        {"Maska", 2, fn=function(veh) if getVehicleDoorState(veh, 0)==0 then return true end; return false end, cena=35},
        {"Bagażnik", 3, fn=function(veh) if getVehicleDoorState(veh, 1)==0 then return true end; return false end, cena=35},
        {"Drzwi lewy przód", 4, fn=function(veh) if getVehicleDoorState(veh, 2)==0 then return true end; return false end, cena=35},
        {"Drzwi prawy przód", 5, fn=function(veh) if getVehicleDoorState(veh, 3)==0 then return true end; return false end, cena=35},
        {"Drzwi lewy tył", 6, fn=function(veh) if getVehicleDoorState(veh, 4)==0 then return true end; return false end, cena=35},
        {"Drzwi prawy tył", 7, fn=function(veh) if getVehicleDoorState(veh, 5)==0 then return true end; return false end, cena=35},
        {"Szyba przednia", 8, fn=function(veh) if getVehiclePanelState(veh, 4)==0 then return true end; return false end, cena=35},
        {"Zderzak przedni", 9, fn=function(veh) if getVehiclePanelState(veh, 5)==0 then return true end; return false end, cena=35},
        {"Zderzak tylni", 10, fn=function(veh) if getVehiclePanelState(veh, 6)==0 then return true end; return false end, cena=35},
        {"Światło lewe przednie", 11, fn=function(veh) if getVehicleLightState(veh, 0)==0 then return true end; return false end, cena=25},
        {"Światła prawe przednie", 12, fn=function(veh) if getVehicleLightState(veh, 1)==0 then return true end; return false end, cena=25},
        {"Światła lewe tylnie", 13, fn=function(veh) if getVehicleLightState(veh, 2)==0 then return true end; return false end, cena=25},
        {"Światła prawe tylnie", 14, fn=function(veh) if getVehicleLightState(veh, 3)==0 then return true end; return false end, cena=25},
    }

    local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)

    table.insert(doNaprawy, {"Lewe przednie koło", 15, fn=function(veh) if frontLeft == 0 then return true end; return false end, cena=15})
    table.insert(doNaprawy, {"Prawe przednie koło", 16, fn=function(veh) if frontRight == 0 then return true end; return false end, cena=15})
    table.insert(doNaprawy, {"Lewe tylnie koło", 17, fn=function(veh) if rearLeft == 0 then return true end; return false end, cena=15})
    table.insert(doNaprawy, {"Prawe tylnie koło", 18, fn=function(veh) if rearRight == 0 then return true end; return false end, cena=15})

    if getElementData(veh, "vehicle:battery") < 100 then
        table.insert(doNaprawy, {"Ładowanie akumulatora", 19, fn=function(veh) if not getElementData(veh, "vehicle:battery") then return true end; return false end, cena=250})
    end
end

function showRepairGUI()
    addEventHandler("onClientRender", root, renderGUI)
    addEventHandler("onClientClick", root, clickRepairGUI)
    showCursor(true, false)
end

function hideRepairGUI()
    removeEventHandler("onClientRender", root, renderGUI)
    removeEventHandler("onClientClick", root, clickRepairGUI)
    showCursor(false)
end

addEventHandler("onClientMarkerHit", root, function(plr)
    if plr ~= localPlayer then return end
    marker = false
    for k,v in pairs(mechy) do
        if v.marker == source and not v.used then
            marker = v
            currentMarker = k
            break
        end
    end
    if not marker then return end

    local vehicles = getElementsWithinColShape(marker.col, "vehicle")
    if #vehicles == 0 then return end

    if #vehicles > 1 then
        exports["noobisty-notyfikacje"]:createNotification("Mechanik", "Na stanowisku znajduje się więcej niż jeden pojazd", {255, 50, 50}, "sighter")
        return
    end
    if getElementData(vehicles[1], "vehicle:driver") ~= localPlayer then
        exports["noobisty-notyfikacje"]:createNotification("Mechanik", "Nie jesteś ostatnim kierowcą pojazdu", {255, 50, 50}, "sighter")
        return
    end

    if #getVehicleOccupants(vehicles[1]) > 0 then
        exports["noobisty-notyfikacje"]:createNotification("Mechanik", "Samochód nie jest pusty", {255, 50, 50}, "sighter")
        return
    end

    reloadTable(vehicles[1])

    fixing = {}
    fixVehicle = vehicles[1]
    scrollPos = {k = 1, n = 11, m = 11}
    for k,v in pairs(doNaprawy) do
        if not v.fn(vehicles[1]) then
            table.insert(fixing, {name=v[1], cost=v.cena})
        end
    end
    
    showRepairGUI()
end)

addEventHandler("onClientMarkerLeave", root, function(plr)
    if plr ~= localPlayer then return end
    marker = false
    for k,v in pairs(mechy) do
        if v.marker == source then
            marker = v
            break
        end
    end
    if not marker then return end

    hideRepairGUI()
end)

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