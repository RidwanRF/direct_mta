sx, sy = guiGetScreenSize()
zoom = exports["borsuk-gui"]:getZoom()
font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 12/zoom)
font2 = exports["borsuk-gui"]:getFont("Roboto", 12/zoom)
font3 = exports["borsuk-gui"]:getFont("Lato-Regular", 10/zoom)

local main = {

    positions = {},
    jobCuboid = createColSphere(-1428.703491, -953.550781, 200.915482, 40),
    tick = getTickCount(),
    animation = {tick=nil, time=nil},

}

local jobMarker, jobCuboid
local jobBlock = false

function convertGram(value)
    return ("%.2f"):format(value)
end

function addMarihuana()
    local ile = math.random(30, 120)/100
    local data, id = exports['borsuk-inventory']:getPlayerItemByName('Marihuana')

    if exports['borsuk-inventory']:getPlayerItemByName('Marihuana') then
        exports["borsuk-inventory"]:setItemCustomData(id, "weight", exports['borsuk-inventory']:getItemCustomData(id, 'weight')+ile)
    else
        exports["borsuk-inventory"]:addPlayerItem("weed", {weight = ile})
    end

    exports["noobisty-notyfikacje"]:createNotification("Marihuana", "Zebrano "..convertGram(ile).."g zioła", {50, 200, 50}, "sight")
end

function loadTrawa()
    for x = 0, 20 do
        for y = 0, 16 do
            table.insert(main.positions, {{-1437.106934 + x, -959.231079 + y, 200.049011}})
        end
    end

    for i, v in ipairs(main.positions) do
        trawa = createObject(325, v[1][1], v[1][2], v[1][3])
        setObjectScale(trawa, 1.25)
        setElementData(trawa, "cannabis", true)
    end
end

function destroyTrawa()
    for i, v in ipairs(getElementsByType("object", resourceRoot)) do
        if getElementData(v, "cannabis") then
            destroyElement(v)
        end
    end
    main.positions = {}
end

function animateMarkers()
    for i, v in ipairs(getElementsByType("marker", resourceRoot)) do
        if getMarkerType(v) == "corona" then
            local alpha = interpolateBetween(25, 0, 0, 125, 0, 0, (getTickCount() - main.tick) / 1000, "SineCurve")
            local r, g, b = getMarkerColor(v)
            setMarkerColor(v, r, g, b, alpha)
        end
    end
end

function drawProgress()
    local anim = interpolateBetween(300, 0, 0, 0, 0, 0, (getTickCount() - animation.tick) / animation.time, "Linear")
    dxDrawRectangle(sx / 2 - 150/zoom - 1, sy - 100/zoom - 1, 300/zoom + 2, 8/zoom + 2, tocolor(75, 75, 75))
    dxDrawRectangle(sx / 2 - 150/zoom, sy - 100/zoom, 300/zoom, 8/zoom, tocolor(35, 35, 35))
    dxDrawRectangle(sx / 2 - 150/zoom, sy - 100/zoom, anim/zoom, 8/zoom, tocolor(55, 200, 55))
    dxDrawText("Postęp zbierania", sx / 2 + 1, sy - 120/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, font1, "center", "center")
    dxDrawText("Postęp zbierania", sx / 2, sy - 120/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, font1, "center", "center")

    if (getTickCount() - animation.tick) >= (animation.time) then
        removeEventHandler("onClientRender", root, drawProgress)
    end
end

function startAnimation(time)
    animation = {tick=getTickCount(), time=time}
    addEventHandler("onClientRender", root, drawProgress)
end

function enterMarihuana(el)
    if el == localPlayer and not getPedOccupiedVehicle(localPlayer) then
        if jobBlock == true then return end
        jobBlock = true
        local time = math.random(8000, 12000)
        startAnimation(time)
        triggerServerEvent('toggleAnimation', localPlayer, localPlayer, {"COP_AMBIENT", "Copbrowse_nod"}, time)

        setTimer( function()
            local marker = getElementData(jobCuboid, "cannabis")

            if isElement(marker) then destroyElement(marker) end
            if isElement(jobCuboid) then destroyElement(jobCuboid) end

            addMarihuana()
            startJob()
        end, time, 1)
    end
end

function checkSAPD()
    local players = getElementsByType("player")
    local SAPD = 0
    for i, v in ipairs(players) do
        if getElementData(v, "player:duty") == "SAPD" then
            SAPD = SAPD + 1
        end
    end
    return SAPD
end

function startJob()
    setElementData(localPlayer, "player:job", "marihuana")
    local randomPoint = math.random(1, #main.positions)

    jobMarker = createMarker(main.positions[randomPoint][1][1], main.positions[randomPoint][1][2], main.positions[randomPoint][1][3]+0.25, "corona", 1, 55, 200, 55, 100)
    jobCuboid = createColSphere(main.positions[randomPoint][1][1], main.positions[randomPoint][1][2], main.positions[randomPoint][1][3]+0.5, 1)
    createBlipAttachedTo(jobMarker, 41)
    setElementData(jobCuboid, "cannabis", jobMarker)
    addEventHandler("onClientColShapeHit", jobCuboid, enterMarihuana)
    jobBlock = false
end

function stopJob()
    if jobCuboid then
        local marker = getElementData(jobCuboid, "cannabis")
        if isElement(marker) then destroyElement(marker) end
    end

    if isElement(jobCuboid) then destroyElement(jobCuboid) end

    setElementData(localPlayer, "player:job", false)
end

function startMarihuanaJob(theElement, matchingDimension)
    if (theElement == localPlayer) then
        --if 0 >= checkSAPD() then exports["noobisty-notyfikacje"]:createNotification("Marihuana", "Na służbie musi być minimum jeden policjant", {200, 55, 50}, "sighter") return end
        if getElementData(localPlayer, "player:faction") then exports["noobisty-notyfikacje"]:createNotification("Marihuana", "Nie możesz tutaj pracować będąc we frakcji", {200, 50, 50}, "sighter") return end
        if getElementData(localPlayer, "player:job") then exports["noobisty-notyfikacje"]:createNotification("Marihuana", "Zakończ pracę", {200, 50, 50}, "sighter") return end

        loadTrawa()
        startJob()
        addEventHandler('onClientRender', root, animateMarkers)
        exports["noobisty-notyfikacje"]:createNotification("Marihuana", "Praca została rozpoczęta - wkroczono na teren zbioru", {50, 200, 50}, "sight")
    end
end
addEventHandler("onClientColShapeHit", main.jobCuboid, startMarihuanaJob)

function stopMarihuanaJob(theElement, matchingDimension)
    if (theElement == localPlayer) then
        if getElementData(localPlayer, "player:job") == "marihuana" then
            destroyTrawa()
            stopJob()
            removeEventHandler('onClientRender', root, animateMarkers)
            exports["noobisty-notyfikacje"]:createNotification("Marihuana", "Praca została zakończona - opuszczono teren zbioru", {50, 200, 50}, "sight")
        end
    end
end
addEventHandler("onClientColShapeLeave", main.jobCuboid, stopMarihuanaJob)

function cancelPedDamage()
    if getElementData(source, "pedDealer") then
        cancelEvent()
    end
end
addEventHandler("onClientPedDamage", getRootElement(), cancelPedDamage)