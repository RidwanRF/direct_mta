local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 18/zoom)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 12/zoom)
local font3 = exports["borsuk-gui"]:getFont("Lato-Regular", 14/zoom)
local font4 = exports["borsuk-gui"]:getFont("Lato-Regular", 11/zoom)
local font5 = exports["borsuk-gui"]:getFont("Lato-Bold", 25, true)
local font6 = exports["borsuk-gui"]:getFont("Lato-Bold", 20, true)
local font7 = exports["borsuk-gui"]:getFont("Lato-Bold", 18, true)
local font8 = exports["borsuk-gui"]:getFont("Lato-Bold", 18, true)
local font9 = exports["borsuk-gui"]:getFont("Lato-Bold", 15, true)
local font10 = exports["borsuk-gui"]:getFont("Lato-Regular", 13, false)
local page = 1
local rt = dxCreateRenderTarget(500, 300, true)
local prices = {}
local col = createColCuboid(-2039.77, -959.38, 31.68, 35.2, 199.3, 10)

addEventHandler("onClientColShapeLeave", col, function(element)
    if element ~= localPlayer then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    setElementData(veh, "vehicle:gielda", false)
end)

local gieldy = {

    {
        pos = {-2022.02, -850.32, 32.15-1},
        name = "Giełda pojazdów",
        prices = {10000, 1000000},
    },

    {
        pos = {-2022.32, -869.48, 32.15-1},
        name = "Giełda pojazdów",
        prices = {10000, 1000000},
    },

}

function renderGieldaGui()
    dxDrawRectangle(sx/2 - 190/zoom, sy/2 - 70/zoom, 380/zoom, 250/zoom, tocolor(20,20,20))
    dxDrawText("Giełda", sx/2, sy/2 - 98/zoom, sx/2, sy/2, tocolor(255,255,255,155), 1, font1, "center", "center")
    dxDrawText(prices[1] .. " PLN - " .. prices[2] .. " PLN", sx/2, sy/2 + 98/zoom, sx/2, sy/2, tocolor(255,255,255,155), 1, font2, "center", "center")
    dxDrawText("Administracja nie odpowiada za pojazdy\nwystawione za złą cenę", sx/2, sy/2 + 400/zoom, sx/2, sy/2, tocolor(255,255,255,155), 1, font4, "center", "center")
end

setDevelopmentMode(true)

addEvent("onButtonClick", true)
addEventHandler("onButtonClick", root, function(button, c, s)
	if c ~= "left" or s ~= "down" then 
		return 
	end
    guiSetInputEnabled(false)
	if button == anuluj then
        hideGieldaGui()
    elseif button == wystaw then
        local cost = tonumber(exports['borsuk-gui']:getEditboxText(cost)) or 0
        if cost < prices[1] or cost > prices[2] then
            exports["noobisty-notyfikacje"]:createNotification("Giełda", "Nie możesz wystawić pojazdu za tą cenę!", {255, 50, 50}, "sighter")
            return
        end
        veh = getPedOccupiedVehicle(localPlayer)
        tableDodatki = {}
        vehicleData = getElementData(veh, "vehicle:upgrades")

        if vehicleData["gz"] then
            table.insert(tableDodatki, "Gwintowane zawieszenie")
        end

        if vehicleData["lpg"] then
            table.insert(tableDodatki, "Instalacja LPG")
        end

        if vehicleData["abs"] then
            table.insert(tableDodatki, "System ABS")
        end

        if vehicleData["nitro"] then
            table.insert(tableDodatki, "Nitro")
        end

        if vehicleData["taxi"] then
            table.insert(tableDodatki, "Taksometr")
        end
        
        if vehicleData["widewheels"] then
            table.insert(tableDodatki, "Szerokie opony")
        end

        if #tableDodatki > 0 then
            tableDodatki = table.concat(tableDodatki,", ")
        else
            tableDodatki = "Brak"
        end

        setElementData(veh, "vehicle:gielda", {price=cost, nick=getPlayerName(localPlayer):gsub("#%x%x%x%x%x%x", ""), vehicleID=getElementData(veh, "vehicle:id"), dodatki=tableDodatki, sid=getElementData(localPlayer, "player:sid")})
        exports["noobisty-notyfikacje"]:createNotification("Giełda", "Wystawiono pojazd na giełde za cenę " .. cost .. " PLN", {50, 255, 50}, "sight")

        hideGieldaGui()
	end
end)

function hitGielda(plr)
    if plr ~= localPlayer then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    
    local owned = getElementData(veh, "vehicle:ownedPlayer")
    if not owned or getElementData(localPlayer, "player:sid") ~= owned then
        exports['noobisty-notyfikacje']:createNotification("Giedła", "Nie jesteś właścicielem tego pojazdu", {255, 50, 50}, "sighter")
        return
    end

    showGieldaGui()
end

function showGieldaGui()
    cost = exports["borsuk-gui"]:createEditbox("Kwota", sx/2-150/zoom, sy/2-25/zoom, 300/zoom, 50/zoom, font1, nil, false, 2)
    wystaw = exports["borsuk-gui"]:createButton("Wystaw", sx/2-75/zoom, sy/2 + 70/zoom, 150/zoom, 45/zoom, font3)
    anuluj = exports["borsuk-gui"]:createButton("Anuluj", sx/2-75/zoom, sy/2 + 120/zoom, 150/zoom, 45/zoom, font3)
    showCursor(true)
    prices = getElementData(source, "gielda:prices")

    addEventHandler("onClientRender", root, renderGieldaGui)
end

function hideGieldaGui()
    cost = exports['borsuk-gui']:destroyEditbox(cost)
    wystaw = exports['borsuk-gui']:destroyButton(wystaw)
    anuluj = exports['borsuk-gui']:destroyButton(anuluj)
    removeEventHandler("onClientRender", root, renderGieldaGui)
    showCursor(false)
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	hideGieldaGui()
end)

function getNearestGieldaCar()
    local x, y, z = getElementPosition(localPlayer)
    local nearest = {false, math.huge}
    for k,v in pairs(getElementsWithinRange(x, y, z, 5, "vehicle")) do
        if getElementData(v, "vehicle:gielda") then
            local dist = getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(v)))
            if dist < nearest[2] then
                nearest = {v, dist}
            end
        end
    end

    return nearest[1]
end

addEventHandler("onClientPreRender", root, function()
    local veh = getNearestGieldaCar()
    if not veh then return end

    local x, y, z = getElementPosition(veh)
    dxSetRenderTarget(rt, true)
    dxDrawRoundedRectangle(0, 43, 500, 222, 20, tocolor(100,100,100,200))
    dxDrawRoundedRectangle(2, 45, 496, 218, 20, tocolor(45,45,45,255))

    local name = exports["pystories-vehicles"]:getVehicleName(veh)
    dxDrawText(name, 17, 2, 500, 300, tocolor(0, 0, 0, 255), 1, font5, "left", "top")
    dxDrawText(name, 15, 0, 500, 300, tocolor(255, 255, 255, 255), 1, font5, "left", "top")

    local textWidth = dxGetTextWidth(name, 1, font5)

    dxDrawText("("..getElementData(veh, "vehicle:id")..")", 22 + textWidth, 2, 500, 300, tocolor(0, 0, 0, 255), 1, font9, "left", "top")
    dxDrawText("("..getElementData(veh, "vehicle:id")..")", 20 + textWidth, 0, 500, 300, tocolor(200, 200, 200, 255), 1, font9, "left", "top")

    local price = getElementData(veh, "vehicle:gielda").price
    dxDrawText(price .. " PLN", 17, 7, 482, 300, tocolor(0, 0, 0, 255), 1, font6, "right", "top")
    dxDrawText(price .. " PLN", 15, 5, 480, 300, tocolor(50, 225, 50, 255), 1, font6, "right", "top")


    

    if page == 1 then
        dxDrawText("Pojemność silnika", 20, 55, 500, 300, tocolor(255, 255, 255, 255), 1, font8, "left", "top")
        dxDrawText(("%.1f dm³"):format(getElementData(veh, "vehicle:engine") or "1.2"), 20, 55, 500-20, 300, tocolor(255, 255, 255, 255), 1, font8, "right", "top")

        dxDrawText("Rodzaj paliwa", 20, 95, 500, 300, tocolor(255, 255, 255, 255), 1, font8, "left", "top")
        dxDrawText(("%s"):format(getElementData(veh, "vehicle:silnik") or "Diesel"), 20, 95, 500-20, 300, tocolor(255, 255, 255, 255), 1, font8, "right", "top")

        dxDrawText("Pojemność baku", 20, 135, 500, 300, tocolor(255, 255, 255, 255), 1, font8, "left", "top")
        dxDrawText(("%d L"):format(getElementData(veh, "vehicle:bak") or "25"), 20, 135, 500-20, 300, tocolor(255, 255, 255, 255), 1, font8, "right", "top")
    elseif page == 2 then
        local upgrades = getElementData(veh, "vehicle:upgrades")

        dxDrawText("MK1", 22, 55, 500, 300, tocolor(255, 255, 255, 255), 1, font8, "left", "top")
        dxDrawText("MK2", 22, 95, 500, 300, tocolor(255, 255, 255, 255), 1, font8, "left", "top")
        dxDrawText("Turbo", 22, 135, 500, 300, tocolor(255, 255, 255, 255), 1, font8, "left", "top")
        dxDrawText(("%s"):format(upgrades["mk1"] and "Tak" or "Nie"), 20, 55, 500-20, 300, tocolor(255, 255, 255, 255), 1, font8, "right", "top")
        dxDrawText(("%s"):format(upgrades["mk2"] and "Tak" or "Nie"), 20, 95, 500-20, 300, tocolor(255, 255, 255, 255), 1, font8, "right", "top")
        dxDrawText(("%s"):format(upgrades["turbo"] and "Tak" or "Nie"), 20, 135, 500-20, 300, tocolor(255, 255, 255, 255), 1, font8, "right", "top")
    elseif page == 3 then
        local dodatki = getElementData(veh, "vehicle:gielda").dodatki
        local r1, g1, b1, r2, g2, b2 = getVehicleColor(veh, true)
        dxDrawText("Kolor pierwszy: " .. RGBToHex(r1, g1, b1) .. "█████", 22, 55, 500, 300, tocolor(255, 255, 255, 255), 1, font9, "left", "top", false, false, false, true)
        dxDrawText("Kolor drugi: " .. RGBToHex(r2, g2, b2) .. "█████",   22, 85, 500, 300, tocolor(255, 255, 255, 255), 1, font9, "left", "top", false, false, false, true)
        dxDrawText("Dodatki: "..dodatki, 22, 115, 500, 300, tocolor(255, 255, 255, 255), 1, font10, "left", "top", false, true, false, false)
    end

    dxDrawRoundedRectangle(60, 188, 50, 50, 10, tocolor(75,75,75,255))
    dxDrawRoundedRectangle(62, 190, 46, 46, 10, tocolor(50,50,50,255))
    dxDrawRoundedRectangle(390, 188, 50, 50, 10, tocolor(75,75,75,255))
    dxDrawRoundedRectangle(392, 190, 46, 46, 10, tocolor(50,50,50,255))

    dxDrawRoundedRectangle(215-85, 210, 70, 5, 2, page == 1 and tocolor(35, 165, 255, 255) or tocolor(75, 75, 75, 255))
    dxDrawRoundedRectangle(215, 210, 70, 5, 2, page == 2 and tocolor(35, 165, 255, 255) or tocolor(75, 75, 75, 255))
    dxDrawRoundedRectangle(215+85, 210, 70, 5, 2, page == 3 and tocolor(35, 165, 255, 255) or tocolor(75, 75, 75, 255))

    dxDrawText("Q", 60, 185, 110, 238, white, 1, font6, "center", "center")
    dxDrawText("E", 390, 185, 440, 238, white, 1, font6, "center", "center")

    dxDrawText("Naciśnij K aby kupić pojazd", 0, 272, 497, 245, tocolor(0, 0, 0, 255), 1, font9, "right", "top")
    dxDrawText("Naciśnij #00c3ffK#ffffff aby kupić pojazd", 0, 270, 495, 245, white, 1, font9, "right", "top", false, false, false, true)

    local nick = getElementData(veh, "vehicle:gielda").nick
    local playerOnline = findPlayer(getElementData(veh, "vehicle:gielda").sid)

    if playerOnline == true then
        dxDrawRoundedRectangle(10, 278, 10, 10, 5, tocolor(0,200,0,255))
    else
        dxDrawRoundedRectangle(10, 278, 10, 10, 5, tocolor(255,0,0,255))
    end
    
    dxDrawText(nick, 32, 272, 497, 247, tocolor(0, 0, 0, 255), 1, font9, "left", "top")
    dxDrawText(nick, 30, 270, 495, 245, white, 1, font9, "left", "top", false, false, false, true)
    dxSetRenderTarget()

    local _, _, _, _, by = getElementBoundingBox(veh)
    local x, y, z = getPositionFromElementOffset(veh, 0, by, 1.5)
    local lx, ly, lz = getPositionFromElementOffset(veh, 0, 5, 0)
    dxDrawMaterialLine3D(x, y, z + 0.35, x, y, z-0.75, rt, 2, tocolor(255,255,255,255), false, lx, ly, lz)
end)

function findPlayer(sid)
    for i,v in ipairs(getElementsByType("player")) do
        if sid == getElementData(v, "player:sid") then
            return true
        end
    end
    return false
end

bindKey("K", "down", function()
    local veh = getNearestGieldaCar()
    if not veh then return end

    triggerServerEvent("buyGieldaCar", localPlayer, veh)
end)

bindKey("Q", "down", function()
    local veh = getNearestGieldaCar()
    if not veh then return end

    page = math.max(page - 1, 1)
end)

bindKey("E", "down", function()
    local veh = getNearestGieldaCar()
    if not veh then return end

    page = math.min(page + 1, 3)
end)

for k,v in pairs(gieldy) do
    v.marker = createMarker(v.pos[1], v.pos[2], v.pos[3], "cylinder", 4, 255, 140, 0)
    setElementData(v.marker, "marker:title", v.name)
    setElementData(v.marker, "marker:desc", "Wystawianie pojazdu")
    setElementData(v.marker, "gielda:prices", v.prices)
    setElementData(v.marker, "marker:icon", "salon")
    addEventHandler("onClientMarkerHit", v.marker, hitGielda)
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

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function RGBToHex(red, green, blue, alpha)
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end