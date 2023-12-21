addEvent("changeVariant", true)
addEventHandler("changeVariant", root, function(plr, veh, war, name, cost)
    if veh then
        if getElementData(veh, "vehicle:id") then
            exports["noobisty-notyfikacje"]:createNotification(plr, "Zmiana wariantu", "Zakupiono wariant do pojazdu ("..name..") za cenę "..cost.." PLN", {50, 200, 50}, "sight")
            setElementData(veh, "vehicle:var", {war, war})
            setVehicleVariant(veh, war, war)
            exports['pystories-db']:dbSet("UPDATE pystories_vehicles set wariant = ? where id = ?", war..", "..war, getElementData(veh, "vehicle:id"))

            takePlayerMoney(plr, cost)
        end
    end
end)