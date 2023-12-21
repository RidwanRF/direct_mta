local obiekty = {}
local akumulatory = {}

addEvent("uderzenieAuta", true)
addEventHandler("uderzenieAuta", root, function()
    setVehicleEngineState(source, false)
end)

addEvent("equipToolbox", true)
addEventHandler("equipToolbox", root, function(equipped)
    if obiekty[source] and isElement(obiekty[source]) then
        triggerClientEvent(root, "stopBoomboxSound", root, obiekty[source])
        destroyElement(obiekty[source])
    end

    setElementData(source, "player:toolbox", equipped)
    
    if equipped then
        exports["noobisty-notyfikacje"]:createNotification(source, "Zestaw naprawczy", "Wyjęto zestaw naprawczy, użyj E przy pojeździe aby go użyć", {50, 255, 50}, "sight")
        obiekty[source] = createObject(1921, 0, 0, 0)
        exports["borsuk-pattach"]:attach(obiekty[source], source, 24, 0, 0, 0.25, -90)
    end
end)

addEvent("equipBattery", true)
addEventHandler("equipBattery", root, function(equipped)
    if akumulatory[source] and isElement(akumulatory[source]) then
        destroyElement(akumulatory[source])
    end

    setElementData(source, "player:battery", equipped)
    
    if equipped then
        exports["noobisty-notyfikacje"]:createNotification(source, "Akumulator", "Wyjęto akumulator, użyj E przy pojeździe aby go użyć", {50, 255, 50}, "sight")
        akumulatory[source] = createObject(1920, 0, 0, 0)
        exports["borsuk-pattach"]:attach(akumulatory[source], source, 24, 0, 0, 0.25, -90)
    end
end)

function endVehicleFix(plr, veh)
    setPedAnimation(plr, nil, nil)
    toggleAllControls(plr, true)
    setElementHealth(veh, 1000)
    fixVehicle(veh)
    setElementData(plr, "player:toolboxuse", false)
    exports["noobisty-notyfikacje"]:createNotification(plr, "Zestaw naprawczy", "Pomyślnie naprawiono pojazd " .. exports["pystories-vehicles"]:getVehicleName(veh), {50, 255, 50}, "sight")
end

setTimer(function()
    for k,v in pairs(getElementsByType("vehicle")) do
        local lights = getVehicleOverrideLights(v)
        local engine = getVehicleEngineState(v)
        local battery = getElementData(v, "vehicle:battery") or 100
        local velocity = Vector3(getElementVelocity(v)).length

        if lights == 2 and (not engine or velocity < 0.05) then
            setElementData(v, "vehicle:battery", math.max(battery - 0.03, 0))
        elseif engine and velocity > 0.05 and battery > 0.25 then
            setElementData(v, "vehicle:battery", math.min(battery + 0.035, 100))
        end

        if battery <= 0 then
            setVehicleOverrideLights(v, 1)
        end
    end
end, 5000, 0)

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

addEvent("toolboxFixCar", true)
addEventHandler("toolboxFixCar", root, function(veh)
    if obiekty[source] and isElement(obiekty[source]) then
        destroyElement(obiekty[source])
    end

    toggleAllControls(source, false)
    exports["noobisty-notyfikacje"]:createNotification(source, "Zestaw naprawczy", "Rozpoczęto naprawę pojazdu " .. exports["pystories-vehicles"]:getVehicleName(veh), {50, 255, 50}, "sight")
    triggerClientEvent(root, "playRepairSound", root, veh)
    setElementData(source, "player:toolbox", false)

    local x, y = getElementPosition(source)
    local vx, vy = getElementPosition(veh)
    local rot = findRotation(x, y, vx, vy)
    setPedRotation(source, rot+180)

    local x, y, z = getPositionFromElementOffset(source, 0, 0.5, 0)
    setElementPosition(source, x, y, z)

    setPedAnimation(source, "CAR", "Fixn_Car_Loop", -1, true, false)

    setTimer(endVehicleFix, 15000, 1, source, veh)
end)

addEventHandler("onPlayerQuit", root, function()
    if obiekty[source] and isElement(obiekty[source]) then
        destroyElement(obiekty[source])
    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end