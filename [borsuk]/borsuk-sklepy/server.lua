addEvent("buyRepairKit", true)
addEventHandler("buyRepairKit", root, function()
    if getPlayerMoney(client) < 2500 then
        return exports["noobisty-notyfikacje"]:createNotification(client, "Sklep 24/7", "Nie posiadasz tyle gotówki", {255,0,0}, "sighter")
    end
    takePlayerMoney(client, 2500)
    exports["borsuk-inventory"]:addPlayerItem(client, "toolbox")
    exports["noobisty-notyfikacje"]:createNotification(client, "Sklep 24/7", "Zakupiono zestaw naprawczy", {0,255,0}, "sight")
end)

addEvent("buyBattery", true)
addEventHandler("buyBattery", root, function()
    if getPlayerMoney(client) < 1500 then
        return exports["noobisty-notyfikacje"]:createNotification(client, "Sklep 24/7", "Nie posiadasz tyle gotówki", {255,0,0}, "sighter")
    end
    takePlayerMoney(client, 1500)
    exports["borsuk-inventory"]:addPlayerItem(client, "battery")
    exports["noobisty-notyfikacje"]:createNotification(client, "Sklep 24/7", "Zakupiono akumulator", {0,255,0}, "sight")
end)