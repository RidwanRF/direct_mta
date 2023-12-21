addEvent("setMyDimension2", true)
addEventHandler("setMyDimension2", root, function(dim, int)
    setElementDimension(client, dim)
    if int then setElementInterior(client, 321) setElementInterior(client, int) end
    local veh = getPedOccupiedVehicle(client)
    if not veh then return end
    setElementDimension(veh, dim)
    if int then setElementInterior(veh, int) end
end)

addEvent("buyTuningAndPay", true)
addEventHandler("buyTuningAndPay", root, function(tune, visual, tint, engine, bak, cost)
    takePlayerMoney(client, cost)
    for i = 0, 16 do
        removeVehicleUpgrade(source, getVehicleUpgradeOnSlot(source, i))
		if tune[i] then
			addVehicleUpgrade(source, tune[i])
		end
    end

    setElementData(source, "visualTuning", visual)
    setElementData(source, "vehicle:carTint", tint)
    setElementData(source, "vehicle:engine", engine)
    setElementData(source, "vehicle:bak", bak)
end)

addEvent("buyTuningCustom", true)
addEventHandler("buyTuningCustom", root, function(vehicle, name, cost)
    takePlayerMoney(client, cost)
    local ups = getElementData(vehicle, "vehicle:upgrades") or {}
    ups[name] = true

    if name == "lpg" then
        setElementData(vehicle, "vehicle:fuellpg", 100)
    elseif name == "nitro" then
        addVehicleUpgrade(vehicle, 1010)
    end

    setElementData(vehicle, "vehicle:upgrades", ups)
end)