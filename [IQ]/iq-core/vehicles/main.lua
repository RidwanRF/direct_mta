function createPrivateVehicle(owner, model, x, y, z, rx, ry, rz)
    local data = {
        mileage = 0,
        health = 0,
        panelstates = "",
    }
    local upgrades = {}
    local color = {
        main = {255,255,255,255,255,255},
        headlight = {255,255,255}
    }
    local position = {x, y, z, rx, ry, rz}
    local fuel = {
        type = "ON",
        count = 100
    }
    local state = 0
    exports['iq-db']:query('INSERT INTO `iq-vehicles` (`model`,`fuel`,`upgrades`,`data`,`position`,`state`,`owner`,`color`) VALUES (?,?,?,?,?,?,?,?)', model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(data), serpent.dump(position), state, owner, serpent.dump(color))
    local rows = exports['iq-db']:query('SELECT * FROM `iq-vehicles`')
    loadVehicle(rows[#rows])
end

addEventHandler('onResourceStart',resourceRoot,function ()
    local rows = exports['iq-db']:query('SELECT * FROM `iq-vehicles`')
    for i,v in pairs(rows) do
        loadVehicle(v)
    end
end)

addEventHandler('onResourceStop',resourceRoot,function ()
    for i,v in pairs(getElementsByType('vehicle')) do
        if (getElementData(v,'vehicle:id')) then
            saveVehicle(v)
        end
    end
end)