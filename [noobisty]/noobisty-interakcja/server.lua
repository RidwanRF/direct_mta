local kabriolety = {

    [429] = {

        {1, 1, 2, 2},

    },

    [410] = {

        {2, 2, 1, 1},

    },

}

addEvent("vehicleEngine", true)
addEventHandler("vehicleEngine", root, function(veh)
    if getVehicleEngineState(veh) == false then
        if getElementHealth(veh) < 400 then
            local randomize = math.random(1, 10)
            if randomize <= 2 or randomize >= 4 then
                return exports["noobisty-notyfikacje"]:createNotification(client, "Silnik", "Silnik jest uszkodzony, spróbuj ponownie", {255, 50, 50}, "sighter")
            end
        end
    end

    if getVehicleEngineState(veh) == false then
        if (getElementData(veh, "vehicle:battery") or 100) <= 0 then
            return exports["noobisty-notyfikacje"]:createNotification(client, "Akumulator", "Akumulator w pojeździe jest rozładowany, udaj się do jednego ze sklepów bądź stacji aby zakupić nowy", {255, 50, 50}, "sighter")
        end
    end

    setVehicleEngineState(veh, not getVehicleEngineState(veh))
end)

addEvent("vehicleLights", true)
addEventHandler("vehicleLights", root, function(veh)
    setVehicleOverrideLights(veh, (getVehicleOverrideLights(veh) == 2) and 1 or 2)
end)

addEvent("vehicleHandbrake", true)
addEventHandler("vehicleHandbrake", root, function(veh)
    if getElementModel(veh) == 444 then return end
    setElementFrozen(veh, not isElementFrozen(veh))
end)

addEvent("vehicleDoors", true)
addEventHandler("vehicleDoors", root, function(veh)
    setVehicleLocked(veh, not isVehicleLocked(veh))
end)

addEvent("vehicleABS", true)
addEventHandler("vehicleABS", root, function(veh)
    setElementData(veh, "vehicle:toggleABS", not getElementData(veh, "vehicle:toggleABS"))
end)

addEvent("vehicleLPG", true)
addEventHandler("vehicleLPG", root, function(veh)
    setElementData(veh, "vehicle:togglelpg", not getElementData(veh, "vehicle:togglelpg"))
end)

addEvent("vehicleNitro", true)
addEventHandler("vehicleNitro", root, function(veh)
    setElementData(veh, "vehicle:toggleNitro", not getElementData(veh, "vehicle:toggleNitro"))
end)

addEvent("toggleZaladunek", true)
addEventHandler("toggleZaladunek", root, function(veh)
    if getElementData(veh, "zaladowane") then
        triggerEvent("rozladujPojazd", client, client)
    else
        triggerEvent("zaladujPojazd", client, client)
    end
end)

addEvent("vehicleSwitchVariant", true)
addEventHandler("vehicleSwitchVariant", root, function(veh)
    local var1, var2 = getVehicleVariant(veh)

    if kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2] == var2 then
        ifKabrio = 1
    elseif kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4] == var2 then
        ifKabrio = 2
    else
        ifKabrio = false
    end

    if kabriolety[getVehicleModelFromName(getVehicleName(veh))] and ifKabrio ~= false then
        if ifKabrio == 2 then
            setVehicleVariant(veh, kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1], kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2])
        else
            setVehicleVariant(veh, kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3], kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4])
        end
    end
end)

addEvent("kickPassengers", true)
addEventHandler("kickPassengers", root, function(veh)
    for seat,plr in pairs(getVehicleOccupants(veh)) do
        if seat ~= 0 then
            removePlayerFromVehicle(plr)
        end
    end
end)

addEvent("suspensionRegulate", true)
addEventHandler("suspensionRegulate", root, function(veh, state)
    if state == "down" then
        local getSuspension = getVehicleHandlingProperty(veh, "suspensionForceLevel")
        
        setVehicleHandling(veh, "suspensionForceLevel", tonumber(getSuspension) - 0.10)
    elseif state == "up" then
        local getSuspension = getVehicleHandlingProperty(veh, "suspensionForceLevel")
        
        setVehicleHandling(veh, "suspensionForceLevel", tonumber(getSuspension) + 0.10)
    end
end)

addEvent("regulateMK1", true)
addEventHandler("regulateMK1", root, function(veh, state)
    if state == "down" then
        local getmaxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(getmaxVelocity) - 5)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 0.5)
    elseif state == "up" then
        local getmaxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(getmaxVelocity) + 5)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 0.5)
    end
end)

addEvent("regulateMK2", true)
addEventHandler("regulateMK2", root, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 1.5)
        setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) - 0.05)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 1.5)
	    setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) + 0.05)
    end
end)

local napedy = {

    [0] = "awd",
    [1] = "rwd",
    [2] = "fwd",
    ["awd"] = 0,
    ["rwd"] = 1,
    ["fwd"] = 2,

}

addEvent("regulateMK3", true)
addEventHandler("regulateMK3", root, function(veh, state)
    local actualDrive = getVehicleHandlingProperty(veh, "driveType")
    if not getElementData(veh, "vehicle:mk3") then setElementData(veh, "vehicle:mk3", napedy[actualDrive]) end

    if state == "down" then
        local actualDrive = getElementData(veh, "vehicle:mk3") or 0
        if 0 >= actualDrive then return end

        setElementData(veh, "vehicle:mk3", tonumber(actualDrive) - 1)
    elseif state == "up" then
        local actualDrive = getElementData(veh, "vehicle:mk3") or 0
        if actualDrive >= 2 then return end
        
        setElementData(veh, "vehicle:mk3", tonumber(actualDrive) + 1)
    end
    local actualDrive = getElementData(veh, "vehicle:mk3") or 0
    setVehicleHandling(veh, "driveType", napedy[actualDrive])
end)

addEventHandler("onVehicleEnter", root, function(plr, seat)
	if seat == 0 then
        local actualDrive = getVehicleHandlingProperty(source, "driveType")
        if not (getElementData(source, "vehicle:mk3") or false) then setElementData(source, "vehicle:mk3", napedy[actualDrive]) end

        local nitro = getElementData(source, "vehicle:id")
        if nitro then
            if getElementData(source, "vehicle:upgrades")["nitro"] then
                if not getElementData(source, "vehicle:nitroCount") then setElementData(source, "vehicle:nitroCount", 100); addVehicleUpgrade(source, 1010) end
            end
        end
    end
end)

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element ) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
 
    return false
end