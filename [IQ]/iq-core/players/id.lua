local idTable = {}

function fetchFreePlayerID()
    local id = 1

    while idTable[id] and idTable[id] ~= nil do
        id = id + 1
    end

    return id
end

function playerJoin(player)
    if player then source = player end

    local id = getElementData(source, 'id') or fetchFreePlayerID()
    setElementData(source, 'id', id)
    idTable[id] = source
end

function playerQuit(player)
    local id = getElementData(source, 'id')

    if not id then return end
    idTable[id] = nil
end

function getPlayerByID(id)
    return idTable[id]
end

function getPlayerByPartialName(name)
    local found = {}
    for _,player in getElementsByType('player') do
        if getPlayerName(player):lower():find(name) then
            table.insert(found, player)
        end
    end

    if #name == 0 or #found == 0 then
        return false, 'Nie znaleziono gracza'
    elseif #name == 1 then
        return player, 'Znaleziono gracza'
    else
        return false, 'Znaleziono więcej niż jednego gracza'
    end
end

addEventHandler('onPlayerJoin', root, playerJoin)
addEventHandler('onPlayerQuit', root, playerQuit)

addEventHandler('onResourceStart', root, function()
    for _,player in pairs(getElementsByType('player')) do
        playerJoin(player)
    end
end)

function findPlayerByID(id)
    for k,v in pairs(getElementsByType('player')) do
        if getElementData(v, 'id') == id then
            return v
        end
    end
end

function findPlayer(player, target)
    local found = {}
    for k,v in pairs(getElementsByType('player')) do
        local id = getElementData(v, 'id')
        if tonumber(id) == tonumber(target) or getPlayerName(v):lower():find(tostring(target):lower()) then
            table.insert(found, v)
        end
    end
    if #found == 0 then
        return false
    end
    if #found > 1 then
        return false
    end
    return found[1]
end
