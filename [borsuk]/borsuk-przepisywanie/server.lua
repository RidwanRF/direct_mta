addEvent("getMyVehiclesPrzepisywanie", true)
addEventHandler("getMyVehiclesPrzepisywanie", root, function()
    local sid = getElementData(source, "player:sid")
    local q = exports["iq-db"]:query("SELECT * FROM `iq-vehicles` WHERE `owner`=?", sid)
    triggerClientEvent(source, "returnMyVehiclesPrzepisywanie", source, q)
end)

function changeVehicleOwnedGroup(id, group)
    for k,v in pairs(getElementsByType("vehicle")) do
        if tonumber(getElementData(v, "vehicle:id")) == tonumber(id) then
            setElementData(v, "vehicle:ownedGroup", tonumber(group))
        end
    end
end

addEvent("przepiszPojazd", true)
addEventHandler("przepiszPojazd", root, function(id, group)
    local q = exports["iq-db"]:query("UPDATE `iq-vehicles` SET `ownedGroup`=? WHERE `id`=?", group, id)
    exports["noobisty-notyfikacje"]:createNotification(source, "Przepisywanie pojazdu", "Przepisano pojazd na organizację", {50, 255, 50}, "sight")
    triggerEvent("getMyVehiclesPrzepisywanie", source)
    changeVehicleOwnedGroup(id, group)
end)

addEvent("wypiszPojazd", true)
addEventHandler("wypiszPojazd", root, function(id)
    local q = exports["iq-db"]:query("UPDATE `iq-vehicles` SET `ownedGroup`='0' WHERE `id`=?", id)
    exports["noobisty-notyfikacje"]:createNotification(source, "Przepisywanie pojazdu", "Wypisano pojazd z organizacji", {50, 255, 50}, "sight")
    triggerEvent("getMyVehiclesPrzepisywanie", source)
    changeVehicleOwnedGroup(id, 0)
end)