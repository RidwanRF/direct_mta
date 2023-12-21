local cuboid = createColSphere(-2052.46, 183.89, 27.70, 6.7)

addEvent("takeSprayLakiernia", true)
addEventHandler("takeSprayLakiernia", root, function()
    if getPlayerMoney(client) < 1000 then
        exports["noobisty-notyfikacje"]:createNotification(source, "Lakiernia", "Nie posiadasz 1000 PLN", {255, 0, 0}, "sighter")
        return
    end
    takePlayerMoney(client, 1000)
    giveWeapon(source, 41, 99999)
    exports["noobisty-notyfikacje"]:createNotification(source, "Lakiernia", "Otrzymujesz spray", {255, 155, 0}, "sight")
end)

addEvent("slowlyChangeVehicleColor", true)
addEventHandler("slowlyChangeVehicleColor", root, function(vehicle, rgb, id)
    local r, g, b = {}, {}, {}
    r[1], g[1], b[1], r[2], g[2], b[2], r[3], g[3], b[3], r[4], g[4], b[4] = getVehicleColor(vehicle, true)
    
    local dx, dy, dz = (rgb[1] - r[id])*0.02, (rgb[2] - g[id])*0.02, (rgb[3] - b[id])*0.02
    if dx < 0 then dx = math.max(dx, -1.5) else dx = math.min(dx, 1.5) end
    if dy < 0 then dy = math.max(dy, -1.5) else dy = math.min(dy, 1.5) end
    if dz < 0 then dz = math.max(dz, -1.5) else dz = math.min(dz, 1.5) end
    r[id], g[id], b[id] = r[id] + dx, g[id] + dy, b[id] + dz

    setVehicleColor(vehicle, r[1], g[1], b[1], r[2], g[2], b[2], r[3], g[3], b[3], r[4], g[4], b[4])
end)

addEventHandler("onColShapeLeave", cuboid, function(plr)
    if getPedWeapon(plr, 9) == 41 then
        takeWeapon(plr, 41)
        exports["noobisty-notyfikacje"]:createNotification(plr, "Lakiernia", "Spray został ci zabrany", {255, 155, 0}, "sight")
        setElementData(plr, "player:spray1", nil)
        setElementData(plr, "player:spray2", nil)
        setElementData(plr, "player:spray3", nil)
    end
end)