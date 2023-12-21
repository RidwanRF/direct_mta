addEvent('buyVehicleHeadlights', true)
addEventHandler('buyVehicleHeadlights', root, function(plr, data)
    local name, color, cost = data[1], {data[2], data[3], data[4]}, data[5]

    local veh = getPedOccupiedVehicle(plr)
    if veh then
        setVehicleHeadLightColor(veh, color[1], color[2], color[3])
        takePlayerMoney(plr, cost)
        exports["noobisty-notyfikacje"]:createNotification(plr, "Montaż świateł", "Zamontowano światłą do pojazdu ("..name..") za kwotę "..cost.." PLN", {color[1], color[2], color[3]}, "sight")
    end
end)