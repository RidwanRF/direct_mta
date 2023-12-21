function spawnPlr(player, pos)
    if not pos then pos = {0,0,0} end
    if not player then return end
    local x,y,z = unpack(pos)
    fadeCamera(player, true)
    spawnPlayer(player, x, y, z)
    setCameraTarget(player, player)
    setPlayerHudComponentVisible(player, 'all', false)
    toggleControl(plr, 'fire', false)
    exports['borsuk-cje']:randomPedClothes(player)

    loadPlayerData(player)
end

addEvent('spawnPlayer', true)
addEventHandler('spawnPlayer',root, spawnPlr)

addEvent('givePlayerMoney', true)
addEventHandler('givePlayerMoney', root, function(amount)
    if not amount or not tonumber(amount) then return end
    givePlayerMoney(client, amount)
end)