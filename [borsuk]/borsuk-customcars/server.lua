local _createVehicle = createVehicle
local vehicles = {}

addEventHandler("onResourceStop", root, function(res)
    for k,v in pairs(vehicles) do
        if v.resource == res and isElement(v.veh) then
            destroyElement(v.veh)
            table.remove(vehicles, k)
        end
    end
end, true, "low-9999")

function createVehicle(resource, model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    table.insert(vehicles, {
        veh = veh,
        resource = resource,
    })

    setElementData(veh, "vehicle:model", model)

    return veh
end

addEvent("loadVehicleHandlings", true)
addEventHandler("loadVehicleHandlings", root, function(vehicle, handling)
    if handling then
        for k, v in pairs(handling) do
            setVehicleHandling(vehicle, k, v)
            --print("Set handling: "..k)
        end
    end
end)