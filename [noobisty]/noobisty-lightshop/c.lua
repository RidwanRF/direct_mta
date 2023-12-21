local lights = {

    toggleGUI = false,
    selectedLights = 1,
    savedLights = nil,

    positions = {

        {93.627800, -164.757477, 2.593750},
    
    },

    list = {

        {'Czerwone', {255, 0, 0}, 65000},
        {'Zielone', {0, 255, 0}, 62500},
        {'Niebieskie', {55, 155, 255}, 70000},
        {'Żółte', {255, 255, 0}, 50000},
        {'Pomarańczowy', {255, 123, 0}, 65500},
        {'Limonkowy', {145, 255, 0}, 75000},
        {'Fioletowy', {123, 0, 255}, 82500},
        {'Różowy', {255, 0, 242}, 55000},
        {'Aqua', {0, 255, 187}, 90000},

    },

}

function drawLights()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getKeyState("mouse2") then showCursor(false) else showCursor(true) end
        local offset = -#lights.list*10 - 30/zoom
        dxDrawRectangle(sx / 2 - #lights.list*10 - 40/zoom - 1, sy - 130/zoom - 1, 30/zoom * #lights.list + 5/zoom + 2, 35/zoom + 2, tocolor(100, 100, 100, 255))
        dxDrawRectangle(sx / 2 - #lights.list*10 - 40/zoom, sy - 130/zoom, 30/zoom * #lights.list + 5/zoom, 35/zoom, tocolor(35, 35, 35, 255))
        for i, v in ipairs(lights.list) do
            if lights.selectedLights == i then
                dxDrawRectangle(sx / 2 - 2 + offset, sy - 120/zoom - 2, 15/zoom + 4, 15/zoom + 4, tocolor(v[2][1]/2, v[2][2]/2, v[2][3]/2, 255))
                dxDrawRectangle(sx / 2 + offset, sy - 120/zoom, 15/zoom, 15/zoom, tocolor(v[2][1], v[2][2], v[2][3], 255))
                dxDrawText(v[1], sx / 2 + 10/zoom + offset + 1, sy - 70/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, font1, "center", "bottom", false, false, false, false, false)
                dxDrawText(v[3].. " PLN", sx / 2 + 10/zoom + offset + 1, sy - 70/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, font2, "center", "top", false, false, false, false, false)

                dxDrawText(v[1], sx / 2 + 10/zoom + offset, sy - 70/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, font1, "center", "bottom", false, false, false, false, false)
                dxDrawText(v[3].. " PLN", sx / 2 + 10/zoom + offset, sy - 70/zoom, nil, nil, tocolor(155, 255, 155, 200), 1, font2, "center", "top", false, false, false, false, false)

                setVehicleHeadLightColor(veh, v[2][1], v[2][2], v[2][3])
            else
                dxDrawRectangle(sx / 2 - 2 + offset, sy - 120/zoom - 2, 15/zoom + 4, 15/zoom + 4, tocolor(v[2][1]/2, v[2][2]/2, v[2][3]/2, 55))
                dxDrawRectangle(sx / 2 + offset, sy - 120/zoom, 15/zoom, 15/zoom, tocolor(v[2][1], v[2][2], v[2][3], 55))
            end

            offset = (offset + 30/zoom)  
        end

        dxDrawText("Aby zakupić lampy kliknij", sx / 2 + 1, sy - 175/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, font1, "center", "bottom", false, false, false, false, false)
        dxDrawText("Enter", sx / 2 + 1, sy - 175/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, font1, "center", "top", false, false, false, false, false)
        dxDrawText("Aby zakupić lampy kliknij", sx / 2, sy - 175/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, font1, "center", "bottom", false, false, false, false, false)
        dxDrawText("Enter", sx / 2, sy - 175/zoom, nil, nil, tocolor(155, 255, 155, 200), 1, font1, "center", "top", false, false, false, false, false)
    end
end

function enterMarker(el)
    if el == localPlayer and getPedOccupiedVehicle(el) and getVehicleController(getPedOccupiedVehicle(el)) == el and getElementData(el, "player:sid") == getElementData(getPedOccupiedVehicle(el), "vehicle:ownedPlayer") then
        local r, g, b = getVehicleHeadLightColor(getPedOccupiedVehicle(el))
        lights.savedLights = {r, g, b}
        lights.selectedLights = 1

        addEventHandler("onClientRender", root, drawLights)
        showCursor(true)
        lights.toggleGUI = true
    end
end

function exitMarker(el)
    if el == localPlayer and getPedOccupiedVehicle(el) and getVehicleController(getPedOccupiedVehicle(el)) == el and getElementData(el, "player:sid") == getElementData(getPedOccupiedVehicle(el), "vehicle:ownedPlayer") then
        if lights.savedLights then
            setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), lights.savedLights[1], lights.savedLights[2], lights.savedLights[3])
        end
        
        removeEventHandler("onClientRender", root, drawLights)
        showCursor(false)
        lights.toggleGUI = false
        lights.savedLights = nil
    end
end

for i, v in ipairs(lights.positions) do
    local marker = createMarker(v[1], v[2], v[3] - 1, 'cylinder', 3, 25, 195, 255, 55)
    setElementData(marker, "marker:title", "Tuning")
    setElementData(marker, "marker:desc", "Zmiana koloru świateł")

    addEventHandler('onClientMarkerHit', marker, enterMarker)
    addEventHandler('onClientMarkerLeave', marker, exitMarker)
end

function wastedPlayer()
    if not getPedOccupiedVehicle(localPlayer) then return end
    if getElementData(localPlayer, "player:sid") ~= getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:ownedPlayer") then return end

	if lights.savedLights then
        setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), lights.savedLights[1], lights.savedLights[2], lights.savedLights[3])
    end
    removeEventHandler("onClientRender", root, drawLights)
    showCursor(false)
    lights.toggleGUI = false
    lights.savedLights = nil
end
addEventHandler("onClientPlayerWasted", getLocalPlayer(), wastedPlayer)

function quitPlayer()
    if not getPedOccupiedVehicle(localPlayer) then return end
    if getElementData(localPlayer, "player:sid") ~= getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:ownedPlayer") then return end

    if lights.savedLights then
        setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), lights.savedLights[1], lights.savedLights[2], lights.savedLights[3])
    end
    showCursor(false)
end
addEventHandler("onClientPlayerQuit", getLocalPlayer(), quitPlayer)

addEventHandler("onClientPlayerVehicleExit", getRootElement(), function(vehicle, seat)
    if seat == 0 and lights.savedLights ~= nil then
        if lights.savedLights then
            setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), lights.savedLights[1], lights.savedLights[2], lights.savedLights[3])
        end
        removeEventHandler("onClientRender", root, drawLights)
        showCursor(false)
        lights.toggleGUI = false
        lights.savedLights = nil
    end
end)

function exitingVehicle(player, seat)
	if (seat==0) and (door==0) then
		if lights.savedLights then
            setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), lights.savedLights[1], lights.savedLights[2], lights.savedLights[3])
        end
        removeEventHandler("onClientRender", root, drawLights)
        showCursor(false)
        lights.toggleGUI = false
        lights.savedLights = nil
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), exitingVehicle)

bindKey("backspace", "down", function()
    if lights.toggleGUI and getPedOccupiedVehicle(localPlayer) then
        if lights.savedLights then
            setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), lights.savedLights[1], lights.savedLights[2], lights.savedLights[3])
        end
	    removeEventHandler("onClientRender", root, drawLights)
        showCursor(false)
        lights.toggleGUI = false
        lights.savedLights = nil
    end
end)

bindKey("enter", "down", function()
    if lights.toggleGUI and getPedOccupiedVehicle(localPlayer) then
        local lightsData = lights.list[lights.selectedLights]
        if getPlayerMoney(localPlayer) >= lightsData[3] then
            triggerServerEvent('buyVehicleHeadlights', localPlayer, localPlayer, {lightsData[1], lightsData[2][1], lightsData[2][2], lightsData[2][3], lightsData[3]})
            lights.savedLights = {lightsData[2][1], lightsData[2][2], lightsData[2][3]}

            removeEventHandler("onClientRender", root, drawLights)
            showCursor(false)
            lights.toggleGUI = false
            lights.savedLights = nil
        else
            exports["noobisty-notyfikacje"]:createNotification("Montaż świateł", "Nie posiadasz tyle pieniędzy", {255, 50, 50}, "sighter")
        end
    end
end)

bindKey("arrow_l", "down", function()
    if lights.toggleGUI and getPedOccupiedVehicle(localPlayer) then
	    lights.selectedLights = math.max(lights.selectedLights - 1, 1)
    end
end)

bindKey("arrow_r", "down", function()
    if lights.toggleGUI and getPedOccupiedVehicle(localPlayer) then
	    lights.selectedLights = math.min(lights.selectedLights + 1, #lights.list)
    end
end)

sy = sy - 10/zoom