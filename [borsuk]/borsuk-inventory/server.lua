addEvent('useItem', true)
addEventHandler('useItem', resourceRoot, function(name, token)
    local itemData = getItemInfo(name)
    if itemData and itemData.useServer then
        itemData.useServer(client, token)
    end
end)

function startTrade(playerA, playerB)
    setElementData(playerA, 'trade', {
        player = playerB,
        state = 'waiting',
        items = {},
    })

    setElementData(playerB, 'trade', {
        player = playerA,
        state = 'waiting',
        items = {},
    })

    triggerClientEvent(playerA, 'trade:start', resourceRoot)
    triggerClientEvent(playerB, 'trade:start', resourceRoot)
end

addEvent('trade:stop', true)
addEventHandler('trade:stop', resourceRoot, function(player)
    triggerClientEvent(player, 'trade:stop', resourceRoot)

    exports['borsuk-notyfikacje']:addNotification(client, 'info', 'Informacja', 'Wymiana została przerwana')
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Wymiana została przerwana')
end)

addEvent('trade:done', true)
addEventHandler('trade:done', resourceRoot, function(player, itemsA, itemsB)
    local itemsData = {}
    for _,v in pairs(itemsA) do
        local itemData = getItemDataByToken(client, v.token)
        itemsData[v.token] = itemData
    end

    for _,v in pairs(itemsB) do
        local itemData = getItemDataByToken(player, v.token)
        itemsData[v.token] = itemData
    end

    for _,v in pairs(itemsA) do
        local itemData = itemsData[v.token]
        removeItemByToken(client, v.token, v.amount)
        addPlayerItemWithData(player, v.name, v.amount, itemData)
    end
    
    for _,v in pairs(itemsB) do
        local itemData = itemsData[v.token]
        iprint(itemData, v.token)
        removeItemByToken(player, v.token, v.amount)
        addPlayerItemWithData(client, v.name, v.amount, itemData)
    end

    exports['borsuk-notyfikacje']:addNotification(client, 'success', 'Sukces', 'Wymiana zakończona pomyślnie')
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Wymiana zakończona pomyślnie')
end)

addEvent('shopBuy', true)
addEventHandler('shopBuy', resourceRoot, function(cart, total)
    if getPlayerMoney(client) < total then
        return exports['borsuk-notyfikacje']:addNotification(client, 'error', 'Błąd', 'Nie posiadasz tyle gotówki')
    end
    takePlayerMoney(client, total)

    for k,v in pairs(cart) do
        if v.amount > 0 then
            addPlayerItem(client, v.name, v.amount)
        end
    end

    exports['borsuk-notyfikacje']:addNotification(client, 'success', 'Sukces', 'Zakupiono przedmioty za $'..total)
end)

function getPlayerFromPartialName(name)
    local name = name and name:gsub('#%x%x%x%x%x%x', ''):lower()
    if not name then
        return
    end

    local players = getElementsByType('player')
    for _,player in ipairs(players) do
        local name_ = getPlayerName(player):gsub('#%x%x%x%x%x%x', ''):lower()
        if name_:find(name, 1, true) then
            return player
        end
    end
end

local waitingTrades = {}
local sentTrades = {}

addCommandHandler('trade', function(player, cmd, target)
    if not target then return end
    local targetPlayer = exports['iq-core']:findPlayer(player, target)
    if not targetPlayer then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono gracza') end
    -- if targetPlayer == player then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie możesz wymienić się sam ze sobą') end
    if getElementData(player, 'trade') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Już jesteś w trakcie wymiany') end
    if getElementData(targetPlayer, 'trade') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Ten gracz jest już w trakcie wymiany') end

    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Wymiana', 'Wysłano propozycję wymiany do '..getPlayerName(targetPlayer))
    exports['borsuk-notyfikacje']:addNotification(targetPlayer, 'info', 'Wymiana', 'Otrzymano propozycję wymiany od '..getPlayerName(player) .. ' (/acceptTrade)')

    waitingTrades[targetPlayer] = {player, getTickCount()+30000}
    sentTrades[player] = {targetPlayer, getTickCount()+30000}
end)

addCommandHandler('acceptTrade', function(player)
    local targetPlayer = waitingTrades[player]
    if not targetPlayer then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie otrzymano propozycji wymiany') end
    if sentTrades[targetPlayer[1]][1] ~= player then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie otrzymano propozycji wymiany') end
    if getTickCount() > targetPlayer[2] then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Propozycja wymiany wygasła') end
    if getElementData(player, 'trade') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Już jesteś w trakcie wymiany') end
    if getElementData(targetPlayer[1], 'trade') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Ten gracz jest już w trakcie wymiany') end

    startTrade(player, targetPlayer[1])
    waitingTrades[player] = nil
    sentTrades[targetPlayer] = nil
end)