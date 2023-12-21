function loadVehicle(data)
    local position = loadstring((data.position and #data.position > 3) and data.position or "return {}")()
    local color = loadstring((data.color and #data.color > 3) and data.color or "return {}")()
    local upgrades = loadstring((data.upgrades and #data.upgrades > 3) and data.upgrades or "return {}")()
    local fuel = loadstring((data.fuel and #data.fuel > 3) and data.fuel or "return {}")()
    local data2 = loadstring((data.data and #data.data > 3) and data.data or "return {}")()

    local vehicle = createVehicle(data.model,position[1],position[2],position[3],position[4],position[5],position[6],tostring(("%08d"):format(data.id)))
    setVehicleColor(vehicle,color.main[1],color.main[2],color.main[3],color.main[1],color.main[2],color.main[3])
    setVehicleHeadLightColor(vehicle, color.headlight[1],color.headlight[2],color.headlight[3])

    setElementData(vehicle,'vehicle:upgrades', upgrades)
    setElementData(vehicle,'vehicle:owner', data.owner)
    setElementData(vehicle,'vehicle:data', data2)
    setElementData(vehicle,'vehicle:fuel', fuel)
    setElementData(vehicle,'vehicle:id', data.id)
end

function saveVehicle(veh)
    local data = getElementData(veh,'vehicle:data')
    local owner = getElementData(veh,'vehicle:owner')
    local fuel = getElementData(veh,'vehicle:fuel')
    local id = getElementData(veh,'vehicle:id')
    local upgrades = getElementData(veh,'vehicle:upgrades')
    local r,g,b = getVehicleColor(veh)
    local h1,h2,h3 = getVehicleHeadLightColor(veh)
    local x,y,z = getElementPosition(veh)
    local rx, ry, rz = getElementRotation(veh)
    local clr = {
        main = {r,g,b},
        headlight = {h1,h2,h3}
    }
    local position = {x,y,z,rx, ry, rz}
    exports['iq-db']:query('UPDATE `iq-vehicles` SET `data` = ?, `owner` = ?, `fuel` = ?, `upgrades` = ?, `color` = ?, `position` = ? WHERE id=? ', serpent.dump(data), owner, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(clr), serpent.dump(position), id)
end

-- local rows = exports['iq-db']:query('SELECT * FROM `iq-vehicles` WHERE id=?',1)
-- loadVehicle(rows[1])

addEventHandler('onVehicleStartEnter',root,function (plr)
    -- print(source)
    if (getElementData(source,'vehicle:id')) then
        local owner = getElementData(source,'vehicle:owner')
        if (owner ~= getElementData(plr,'player:sid')) then
            cancelEvent()
            exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Kluczyki', 'Nie posiadasz kluczy do tego pojazdu!', 5000)
        end
    end
end)