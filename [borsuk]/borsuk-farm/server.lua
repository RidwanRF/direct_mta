function farmQuery(where, ...)
    return exports['iq-db']:query('SELECT f.*, p.login AS ownerName, TIMESTAMPDIFF(SECOND, f.lastUpdate, NOW()) AS lastUpdateSeconds FROM `borsuk-farm` AS f LEFT JOIN `iq-users` AS p ON f.owner = p.uid WHERE ' .. where, ...)
end

function loadFarm(data)
    local x, y, z = unpack(fromJSON(data.position))
    local marker = createMarker(x, y, z - 1, 'cylinder', 1.3, data.owner and 255 or 75, 255, 75, 55)

    setElementData(marker, 'barn:data', {
        id = data.uid,
        owner = data.owner,
        ownerName = data.ownerName,
        cost = data.cost,
        fields = fromJSON(data.fields),
        marker = marker
    })
end

function loadFarms()
    local q = farmQuery('1')
    for k,v in pairs(q) do
        loadFarm(v)
    end
end

addEventHandler('onResourceStart', resourceRoot, loadFarms)

function respawnPlayersFromFarms()
    for k,v in pairs(getElementsByType('player')) do
        local exit = getElementData(v, 'farm:exit')
        if exit then
            setElementDimension(v, 0)
            setElementPosition(v, exit[1], exit[2], exit[3])
            setElementData(v, 'farm:exit', false)
        end
    end
end
addEventHandler('onResourceStart', resourceRoot, respawnPlayersFromFarms)

addEvent('farm:buy', true)
addEventHandler('farm:buy', resourceRoot, function(data, marker)
    local uid = getElementData(client, 'player:sid')
    if not uid then return end

    if getPlayerMoney(client) < data.cost then 
        return showNotification(client, 'You don\'t have $' .. data.cost)
    end
    takePlayerMoney(client, data.cost)

    setMarkerColor(marker, 255, 255, 75, 55)
    exports['iq-db']:query('UPDATE `borsuk-farm` SET `owner`=? WHERE `uid`=?', uid, data.id)
    destroyElement(marker)

    local q = farmQuery('f.uid=?', data.id)
    loadFarm(q[1])
end)

addEvent('farm:transfer', true)
addEventHandler('farm:transfer', resourceRoot, function(data, marker, player)
    local uid = getElementData(client, 'player:sid')
    local newuid = getElementData(player, 'player:sid')
    if not uid or not newuid then return end

    setMarkerColor(marker, 255, 255, 75, 55)
    exports['iq-db']:query('UPDATE `borsuk-farm` SET `owner`=? WHERE `uid`=?', newuid, data.id)
    destroyElement(marker)

    showNotification(client, 'Transfered farm to ' .. getPlayerName(player))
    showNotification(player, getPlayerName(client) .. ' transfered you they farm')

    local q = farmQuery('f.uid=?', data.id)
    loadFarm(q[1])
end)

addEvent('farm:enter', true)
addEventHandler('farm:enter', resourceRoot, function(data, marker)
    local uid = getElementData(client, 'player:sid')
    if not uid then return end

    local q = farmQuery('f.uid=?', data.id)
    triggerClientEvent(client, 'farm:addGrowTime', resourceRoot, q[1].lastUpdateSeconds)
    setElementDimension(client, uid)

    showNotification(client, 'To use hoe or watering can click on them')
end)

addEvent('farm:exit', true)
addEventHandler('farm:exit', resourceRoot, function()
    local exit = getElementData(client, 'farm:exit')
    setElementDimension(client, 0)
    setElementPosition(client, exit[1], exit[2], exit[3])
    setElementData(client, 'farm:exit', false)
end)

addEvent('farm:update', true)
addEventHandler('farm:update', resourceRoot, function(data)
    local fields = toJSON(data.fields)
    
    setElementData(data.marker, 'barn:data', data)

    exports['iq-db']:query('UPDATE `borsuk-farm` SET `fields`=?, `lastUpdate`=NOW() WHERE `uid`=?', fields, data.id)
end)

addCommandHandler('createfarm', function(plr, cmd, cost)
    if not cost or not tonumber(cost) then return end
    if not getPlayerAccount(plr) then return end
    local accName = getAccountName(getPlayerAccount(plr))
    if not isObjectInACLGroup("user."..accName, aclGetGroup ("Admin")) then return end

    local x, y, z = getElementPosition(plr)
    local position = toJSON({x, y, z})
    local cost = tonumber(cost)
    local _, _, id = exports['iq-db']:query('INSERT INTO `borsuk-farm`(`position`, `cost`) VALUES (?, ?)', position, cost)
    local q = farmQuery('f.uid=?', id)
    loadFarm(q[1])
end)