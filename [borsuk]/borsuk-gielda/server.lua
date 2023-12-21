addEvent("buyGieldaCar", true)
addEventHandler("buyGieldaCar", root, function(veh)
    local price = getElementData(veh, "vehicle:gielda").price
    if getPlayerMoney(source) < price then
        exports["noobisty-notyfikacje"]:createNotification(source, "Giełda", "Nie posiadasz tyle pieniędzy", {255, 50, 50}, "sighter")
        return
    end

    local sid = getElementData(source, "player:sid")
    local owner = getElementData(veh, "vehicle:ownedPlayer")
    if not owner then return end
    if not sid then return end

    if sid == owner then
        exports["noobisty-notyfikacje"]:createNotification(source, "Giełda", "Nie możesz kupić swojego pojazdu", {255, 50, 50}, "sighter")
        return
    end

    setElementData(veh, "vehicle:ownedPlayer", sid)
    setElementData(veh, "vehicle:gielda", false)
    takePlayerMoney(source, price)
    exports["iq-db"]:query("UPDATE `iq-users` SET `bankMoney`=`bankMoney`+"..(tonumber(price) or 0).." WHERE id="..tonumber(owner).."")
    exports["noobisty-notyfikacje"]:createNotification(source, "Giełda", "Zakupiłeś pojazd " .. getVehicleName(veh) .. " za " .. price .. " PLN", {50, 255, 50}, "sight")

    local plr = findPlayerBySid(owner)
    if plr then
        exports["noobisty-notyfikacje"]:createNotification(plr, "Giełda", "Twój pojazd " .. getVehicleName(veh) .. " sprzedał się za " .. price .. " PLN", {50, 255, 50}, "sight")
    end

    warpPedIntoVehicle(source, veh)
end)

function findPlayerBySid(sid)
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v, "player:sid") == sid then
            return v
        end
    end
end