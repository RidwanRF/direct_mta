addEventHandler("onClientVehicleDamage", root, function(_, _, loss)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or source ~= veh then return end
    if loss >= 270 then
        triggerServerEvent("uderzenieAuta", veh)
        exports["noobisty-notyfikacje"]:createNotification("Silnik", "Silnik w pojeździe gaśnie", {255, 50, 50}, "sighter")
    end
end)

addEvent("takeMyToolbox", true)
addEvent("takeMyBattery", true)

bindKey("e", "down", function()
    if getPedOccupiedVehicle(localPlayer) or not getElementData(localPlayer, "player:toolbox") or getElementData(localPlayer, "player:toolboxuse") then return end
    local near = {false, 2}
    local px, py, pz = getElementPosition(localPlayer)
    for k,v in pairs(getElementsByType("vehicle")) do
        local dist = getDistanceBetweenPoints3D(px, py, pz, Vector3(getElementPosition(v)))
        if dist < near[2] then
            near = {v, dist}
        end
    end
    if not near[1] then
        exports["noobisty-notyfikacje"]:createNotification("Zestaw naprawczy", "W pobliżu nie znajduje się żaden pojazd", {255, 50, 50}, "sighter")
        return
    end

    triggerEvent("takeMyToolbox", root)

    setElementData(localPlayer, "player:toolboxuse", true)
    triggerServerEvent("toolboxFixCar", localPlayer, near[1])
end)

bindKey("e", "down", function()
    if getPedOccupiedVehicle(localPlayer) or not getElementData(localPlayer, "player:battery") then return end
    local near = {false, 2}
    local px, py, pz = getElementPosition(localPlayer)
    for k,v in pairs(getElementsByType("vehicle")) do
        local dist = getDistanceBetweenPoints3D(px, py, pz, Vector3(getElementPosition(v)))
        if dist < near[2] then
            near = {v, dist}
        end
    end
    if not near[1] then
        exports["noobisty-notyfikacje"]:createNotification("Akumulator", "W pobliżu nie znajduje się żaden pojazd", {255, 50, 50}, "sighter")
        return
    end

    setElementData(near[1], "vehicle:battery", 100)
    exports["noobisty-notyfikacje"]:createNotification("Akumulator", "Wymieniono akumulator w pojeździe", {50, 255, 50}, "sight")
    setElementData(localPlayer, "player:battery", false)
    triggerServerEvent("equipBattery", localPlayer, false)

    triggerEvent("takeMyBattery", root)
end)