local currentEvent = false
local prevEvent = {}

for k,v in pairs(getElementsByType("player")) do
    setElementDimension(v, 0)
end

function startEvent()
    currentEvent.started = true
    currentEvent.task = "Przeżyj"
    triggerClientEvent(root, "startEvent", root, currentEvent)

    if currentEvent.name == "tron" then
        currentEvent.vehicles = {}

        local data = events[currentEvent.name]
        for k,v in pairs(currentEvent.zapisani) do
            if v and isElement(v) then
                local x, y, z = getElementPosition(v)
                prevEvent[v] = {
                    pos = {x, y, z},
                    dim = getElementDimension(v),
                    int = getElementInterior(v),
                }

                local spawn = data.spawny[k]
                local r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
                local veh = createVehicle(522, spawn[1], spawn[2], spawn[3], 0, 0, spawn[4])
                setElementData(veh, "vehicle:model", 619)
                setVehicleColor(veh, 0, 0, 0, r, g, b)
                local vx, vy = getPointFromDistanceRotation(0, 0, 0.1, spawn[4])
                local _, _, vz = getElementVelocity(veh)
                setElementVelocity(veh, vx, vy, vz)
                warpPedIntoVehicle(v, veh)
                setElementInterior(v, 15)
                setElementInterior(veh, 15)
                table.insert(currentEvent.vehicles, veh)

                setElementFrozen(v, false)
                setElementData(v, "player:event", true)
                setElementData(v, "player:event:lost", false)
                setElementData(v, "player:event:color", {r,g,b})
            end
        end
    elseif currentEvent.name == "ztp" then
        currentEvent.objects = {}

        local data = events[currentEvent.name]
        for k,v in pairs(currentEvent.zapisani) do
            if v and isElement(v) then
                local x, y, z = getElementPosition(v)
                prevEvent[v] = {
                    pos = {x, y, z},
                    dim = getElementDimension(v),
                    int = getElementInterior(v),
                }

                local spawn = data.spawny[k]
                setElementDimension(v, 699)
                setElementPosition(v, spawn[1], spawn[2], spawn[3]+8.5)

                setElementFrozen(v, false)
                setElementData(v, "player:event", true)
                setElementData(v, "player:event:points", 0)
            end
        end
    end
end

addCommandHandler("event", function(plr)
    if not currentEvent or currentEvent.start < getTickCount() then
        exports["noobisty-notyfikacje"]:createNotification(plr, "Event", "Aktualnie nie trwają zapisy na event", {255, 0, 0}, "sighter")
        return
    end

    if #currentEvent.zapisani >= events[currentEvent.name].maxOsob then
        exports["noobisty-notyfikacje"]:createNotification(plr, "Event", "Na event zapisała sie już maksymalna ilość osób", {255, 0, 0}, "sighter")
        return
    end

    if getElementInterior(plr) ~= 0 or getElementDimension(plr) ~= 0 or getElementData(plr, "player:job") then
        exports["noobisty-notyfikacje"]:createNotification(plr, "Event", "Musisz być na zewnątrz i nie pracować!", {255, 0, 0}, "sighter")
        return
    end

    for k,v in pairs(currentEvent.zapisani) do
        if plr == v then
            exports["noobisty-notyfikacje"]:createNotification(plr, "Event", "Już jesteś zapisany na event", {255, 0, 0}, "sighter")
            return
        end
    end

    table.insert(currentEvent.zapisani, plr)
    triggerClientEvent(root, "startEvent", root, currentEvent)
end)

addCommandHandler("startev", function(plr, cmd, event)
    local level = getElementData(plr, "player:level")
    if level == 0 then return end

    if not event or not events[event] then
        local dostepne = {}
        for k,v in pairs(events) do
            if level >= v.level then
                table.insert(dostepne, "- " .. k)
            end
        end
        exports["noobisty-notyfikacje"]:createNotification(plr, "System eventów", "Nie znaleziono podanego eventu. Dostępne eventy: \n" .. table.concat(dostepne, "\n"), {255, 0, 0}, "sighter")
        return
    end

    if level < events[event].level then
        exports["noobisty-notyfikacje"]:createNotification(plr, "System eventów", "Nie możesz rozpocząć tego eventu", {255, 0, 0}, "sighter")
        return
    end

    exports["noobisty-notyfikacje"]:createNotification(plr, "System eventów", "Rozpoczęto event " .. events[event].name, {0, 255, 0}, "sight")

    local time = 60000

    currentEvent = {
        name = event,
        start = getTickCount() + time,
        zapisani = {},
        started = false,
    }

    triggerClientEvent(root, "startEvent", root, currentEvent)
    setTimer(startEvent, time, 1)
    setTimer(executeCommandHandler, 500, 1, "event", plr)
end)

addEvent("getServerTickEvent", true)
addEventHandler("getServerTickEvent", root, function()
    triggerClientEvent(client, "returnServerTickEvent", client, getTickCount())
end)

function stillPlaying()
    local t = {}
    for k,v in pairs(currentEvent.zapisani) do
        if not getElementData(v, "player:event:lost") then
            table.insert(t, v)
        end
    end
    return t
end

function despawnEvent(v)
    setElementData(v, "player:event", false)
    setElementData(v, "player:event:lost", false)
    setElementFrozen(v, false)
    setElementInterior(v, 0)
    setElementDimension(v, 0)
    setElementPosition(v, prevEvent[v].pos[1], prevEvent[v].pos[2], prevEvent[v].pos[3])
end

addEvent("przegralemWTron", true)
addEventHandler("przegralemWTron", root, function()
    if not source or not isElement(source) then return end
    local x, y, z = getElementPosition(source)
    local driver = getVehicleOccupant(source, 0)
    setElementFrozen(driver, true)
    setElementData(driver, "player:event:lost", true)
    setElementData(driver, "player:event", false)
    destroyElement(source)
    createExplosion(x, y, z, 2)
    exports["noobisty-notyfikacje"]:createNotification(driver, "Linia śmierci", "Przegrywasz event!", {255, 0, 0}, "sighter")

    setTimer(despawnEvent, 1000, 1, driver)
    for k,v in pairs(currentEvent.zapisani) do
        if v == driver then
            table.remove(currentEvent.zapisani, k)
        end
    end

    local playing = stillPlaying()
    if #playing <= 1 then
        if playing[1] then
            exports["noobisty-notyfikacje"]:createNotification(root, "Linia śmierci", "Event Linia śmierci wygrywa " .. getPlayerName(playing[1]), {255, 255, 0}, "sight")
        end
        triggerClientEvent(root, "koniecEventuTron", root)
        for k,v in pairs(currentEvent.vehicles) do
            if v and isElement(v) then
                destroyElement(v)
            end
        end
        for k,v in pairs(currentEvent.zapisani) do
            if v and isElement(v) then
                setTimer(despawnEvent, 1000, 1, v)
            end
        end
    end
end)

addEvent("przegralemWZTP", true)
addEventHandler("przegralemWZTP", root, function()
    if not source or not isElement(source) then return end
    exports["noobisty-notyfikacje"]:createNotification(source, "Zrób to pierwszy", "Przegrywasz event!", {255, 0, 0}, "sighter")

    setTimer(despawnEvent, 1000, 1, source)
    for k,v in pairs(currentEvent.zapisani) do
        if v == source then
            table.remove(currentEvent.zapisani, k)
        end
    end

    local playing = stillPlaying()
    if #playing <= 1 then
        if playing[1] then
            exports["noobisty-notyfikacje"]:createNotification(root, "Zrób to pierwszy", "Event Zrób to pierwszy wygrywa " .. getPlayerName(playing[1]), {255, 255, 0}, "sight")
        end
        triggerClientEvent(root, "koniecEventuTron", root)

        for k,v in pairs(currentEvent.zapisani) do
            if v and isElement(v) then
                setTimer(despawnEvent, 1000, 1, v)
            end
        end
    end
end)

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy
end