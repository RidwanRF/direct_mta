local tradeActive = false
local grabItem = false

function getTradeItems()
    local inventory = getPlayerInventory()
    local available = {}
    local trade = getElementData(localPlayer, "trade")

    local function getTradeAmountByID(id)
        for k,v in pairs(trade.items) do
            if v.nid == id then
                return v.amount
            end
        end
        return 0
    end

    for k,v in pairs(inventory) do
        local itemData = getItemInfo(v.name)
        if not itemData.cantTrade then 
            local amount = v.amount - getTradeAmountByID(k)
            -- if not amount then amount = 1 end
            if amount > 0 then
                table.insert(available, {
                    nid = k,
                    name = v.name,
                    amount = amount,
                    class = v.class,
                    progress = v.progress,
                    token = v.token
                })
            end
        end
    end

    return available
end

function addTradeItem(item)
    local trade = getElementData(localPlayer, "trade")

    -- if there is item in trade with item.id then add amount
    local added = false
    for k,v in pairs(trade.items) do
        if v.nid == item.nid then
            v.amount = v.amount + item.amount
            added = true
        end
    end

    -- if there is no item in trade with item.id then add item
    if not added then
        table.insert(trade.items, item)
    end

    setElementData(localPlayer, "trade", trade)
end

function removeTradeItem(item)
    local trade = getElementData(localPlayer, "trade")

    for k,v in pairs(trade.items) do
        if v.nid == item.nid then
            v.amount = v.amount - item.amount
            if v.amount <= 0 then
                table.remove(trade.items, k)
            end
        end
    end

    setElementData(localPlayer, "trade", trade)
end

local function renderTrade()
    local trade = getElementData(localPlayer, "trade")
    if not trade or not isElement(trade.player) then return stopTrade() end
    local tradeB = getElementData(trade.player, "trade")
    if not tradeB or not isElement(tradeB.player) then return stopTrade() end
    local available = getTradeItems()

    dxDrawImage(sx/2 + 113/zoom, sy/2 - 325/zoom, 500/zoom, 670/zoom, 'data/background.png')
    dxDrawText('Ekwipunek', sx/2 + 132/zoom, sy/2 - 305/zoom, nil, nil, white, 1, regular)
    drawEditbox('amount', 'Ilosc', sx/2 + 360/zoom, sy/2 - 307/zoom, 235/zoom, 40/zoom)

    drawGridInventory('inventory', sx/2 + 132/zoom, sy/2 - 252/zoom, 460/zoom, 515/zoom, 5, 5, 10/zoom, available)

    dxDrawImage(sx/2 - 567/zoom, sy/2 - 327/zoom, 25/zoom, 25/zoom, 'data/dot.png', 0, 0, 0, tocolor(187, 148, 47))
    dxDrawText('Twoja oferta', sx/2 - 530/zoom, sy/2 - 315/zoom, nil, nil, white, 1, regular2, 'left', 'center')
    drawGridInventory('my-trade', sx/2 - 567/zoom, sy/2 - 292/zoom, 460/zoom, 205/zoom, 5, 2, 10/zoom, trade.items)

    dxDrawImage(sx/2 - 567/zoom, sy/2 - 8/zoom, 25/zoom, 25/zoom, 'data/dot.png', 0, 0, 0, tocolor(220, 96, 78))
    dxDrawText('Oferta gracza '..getPlayerName(trade.player), sx/2 - 530/zoom, sy/2 + 4/zoom, nil, nil, white, 1, regular2, 'left', 'center')
    drawGridInventory('they-trade', sx/2 - 567/zoom, sy/2 + 27/zoom, 460/zoom, 205/zoom, 5, 2, 10/zoom, tradeB.items)

    drawButton('Anuluj', sx/2 - 567/zoom, sy/2 - 75/zoom, 225/zoom, 50/zoom, regular2, tocolor(28, 28, 28, 77), tocolor(28, 28, 28, 60))
    drawButton(trade.state == 'waiting' and 'Akceptuj' or 'Anuluj', sx/2 - 332/zoom, sy/2 - 75/zoom, 225/zoom, 50/zoom, regular2, tocolor(231, 120, 77), tocolor(220, 96, 78), tocolor(255, 255, 255, 180))

    dxDrawImage(sx/2 - 567/zoom, sy/2 + 245/zoom, 460/zoom, 100/zoom, 'data/info.png')
    dxDrawText('Wymienianie', sx/2 - 555/zoom, sy/2 + 255/zoom, nil, nil, white, 1, regular2, 'left', 'top')
    
    if trade.state == 'waiting' then
        dxDrawText('Aby przeprowadzić wymianę, konieczne jest przeciągnięcie przedmiotu z twojego ekwipunku na handel', sx/2 - 555/zoom, sy/2 + 255/zoom + dxGetFontHeight(1,regular2), sx/2 - 120/zoom, sy/2 + 353/zoom, 0xAAFFFFFF, 1, regular2, 'left', 'top', false, true)
    elseif trade.state == 'accept' then
        if tradeB.state ~= 'accept' then
            dxDrawText('Czekanie na zaakceptowanie wymiany przez drugiego gracza, proszę czekać.', sx/2 - 555/zoom, sy/2 + 282/zoom, sx/2 - 110/zoom, sy/2 + 353/zoom, 0xAAFFFFFF, 1, regular2, 'left', 'top', false, true)
        else
            dxDrawText('Obaj gracze zaakceptowali wymianę.', sx/2 - 555/zoom, sy/2 + 282/zoom, sx/2 - 110/zoom, sy/2 + 353/zoom, 0xAAFFFFFF, 1, regular2, 'left', 'top', false, true)
            local fontHeight = dxGetFontHeight(1, regular2)
            local w = dxGetTextWidth('Prosze czekac ', 1, regular2)
            local time = 3 - (getTickCount() - trade.start)/1000
            local seconds = ('%.1f'):format(math.max(time, 0))
            dxDrawText('Prosze czekac ', sx/2 - 555/zoom, sy/2 + 282/zoom + fontHeight, sx/2 - 110/zoom, sy/2 + 353/zoom, 0xAAFFFFFF, 1, regular2, 'left', 'top', false, false, false, true)
            dxDrawText(seconds .. ' sekund', sx/2 - 554/zoom + w, sy/2 + 283/zoom + fontHeight, sx/2 - 109/zoom, sy/2 + 354/zoom, 0xAA000000, 1, bold, 'left', 'top', false, false, false, true)
            dxDrawText(seconds .. ' sekund', sx/2 - 555/zoom + w, sy/2 + 282/zoom + fontHeight, sx/2 - 110/zoom, sy/2 + 353/zoom, 0xAAFF0000, 1, bold, 'left', 'top', false, false, false, true)
            local w = w + dxGetTextWidth(seconds .. ' sekund ', 1, bold)
            dxDrawText('do zakonczenia wymiany', sx/2 - 554/zoom + w, sy/2 + 283/zoom + fontHeight, sx/2 - 109/zoom, sy/2 + 354/zoom, 0xAA0FFFFFF, 1, regular2, 'left', 'top', false, false, false, true)

            if time <= 0 and trade.owner then
                triggerServerEvent('trade:done', resourceRoot, trade.player, trade.items, tradeB.items)
                trade.state = 'done'
                tradeB.state = 'done'
                trade.start = nil
                tradeB.start = nil
                setElementData(localPlayer, 'trade', nil)
                setElementData(trade.player, 'trade', nil)
            end
        end
    end

    local used = 0

    for k,v in pairs(getPlayerInventory()) do
        local itemData = getItemInfo(v.name)
        if itemData then
            used = used + itemData.weight * v.amount
        end
    end

    local capacity = 90
    local progress = used/capacity
    

    if grabItem then
        if trade.state ~= 'waiting' then
            grabItem = nil
            return
        end

        local cx, cy = getCursorPosition()
        if not cx then return end
        cx, cy = cx*sx, cy*sy

        local itemData = getItemInfo(grabItem.name)

        dxDrawImage(cx - 32/zoom, cy - 32/zoom,  64/zoom, 64/zoom, 'data/' .. itemData.icon .. '.png')
        dxDrawText('x' .. grabItem.amount, cx + 32/zoom, cy + 32/zoom, nil, nil, white, 1, regular2, 'right', 'bottom')

        if not getKeyState('mouse1') then
            if isMouseInPosition(sx/2 - 567/zoom, sy/2 - 292/zoom, 460/zoom, 205/zoom) and grabItem.from == 'inventory' then
                addTradeItem(grabItem)
            elseif isMouseInPosition(sx/2 + 132/zoom, sy/2 - 252/zoom, 460/zoom, 515/zoom) and grabItem.from == 'my-trade' then
                removeTradeItem(grabItem)
            end

            grabItem = nil
        end
    end
end

local function clickInventoryCallback(btn, state)
    if btn ~= 'left' or state ~= 'down' then return end

    local available = getTradeItems()
    local trade = getElementData(localPlayer, "trade")

    if trade.state == 'waiting' then
        clickInventory('inventory', sx/2 + 132/zoom, sy/2 - 252/zoom, 460/zoom, 515/zoom, 5, 5, 10/zoom, available, function(item, itemData)
            local amount = getEditboxText('amount')
            if not amount or #amount == 0 then
                amount = item.amount
            end
            if tonumber(amount) > item.amount then
                amount = item.amount
            end

            grabItem = {
                name = item.name,
                amount = tonumber(amount),
                nid = item.nid,
                from = 'inventory',
                class = item.class,
                progress = item.progress,
                token = item.token
            }
        end)

        clickInventory('my-trade', sx/2 - 567/zoom, sy/2 - 292/zoom, 460/zoom, 205/zoom, 5, 2, 10/zoom, trade.items, function(item, itemData)
            grabItem = {
                name = item.name,
                amount = item.amount,
                nid = item.nid,
                from = 'my-trade',
                class = item.class,
                progress = item.progress,
                token = item.token
            }
        end)
    end

    if isMouseInPosition(sx/2 - 567/zoom, sy/2 - 75/zoom, 225/zoom, 50/zoom) then
        stopTrade()
    elseif isMouseInPosition(sx/2 - 332/zoom, sy/2 - 75/zoom, 225/zoom, 50/zoom) then
        local trade = getElementData(localPlayer, "trade")
        if trade.state == 'accept' then
            trade.state = 'waiting'
            setElementData(localPlayer, "trade", trade)
        else
            local tradeB = getElementData(trade.player, "trade")
            if tradeB.state == 'accept' then
                tradeB.start = getTickCount()
                tradeB.owner = false
                setElementData(trade.player, "trade", tradeB)
            end

            trade.state = 'accept'
            trade.start = getTickCount()
            trade.owner = true
            setElementData(localPlayer, "trade", trade)
        end
    end
end

local function scrollCallback(key)
    local trade = getElementData(localPlayer, "trade")
    if not trade or not isElement(trade.player) then return stopTrade() end
    local tradeB = getElementData(trade.player, "trade")
    if not tradeB or not isElement(tradeB.player) then return stopTrade() end

    local available = getTradeItems()
    useInventoryScroll('inventory', sx/2 + 132/zoom, sy/2 - 252/zoom, 460/zoom, 515/zoom, 5, 5, available, key)
    useInventoryScroll('my-trade', sx/2 - 567/zoom, sy/2 - 292/zoom, 460/zoom, 205/zoom, 5, 2, trade.items, key)
    useInventoryScroll('they-trade', sx/2 - 567/zoom, sy/2 + 27/zoom, 460/zoom, 205/zoom, 5, 2, tradeB.items, key)
end

function startTrade()
    if tradeActive then return end
    tradeActive = true

    addEventHandler("onClientRender", root, renderTrade)
    addEventHandler("onClientClick", root, clickInventoryCallback)
    bindKey('mouse_wheel_up', 'down', scrollCallback)
    bindKey('mouse_wheel_down', 'down', scrollCallback)
    showCursor(true)

    toggleInventory(false)
end

function stopTrade()
    removeEventHandler("onClientRender", root, renderTrade)
    removeEventHandler("onClientClick", root, clickInventoryCallback)
    unbindKey('mouse_wheel_up', 'down', scrollCallback)
    unbindKey('mouse_wheel_down', 'down', scrollCallback)
    showCursor(false)
    tradeActive = false

    local trade = getElementData(localPlayer, "trade")
    if trade and isElement(trade.player) then
        triggerServerEvent('trade:stop', resourceRoot, trade.player)
    end

    setElementData(localPlayer, "trade", false)
end

addEvent('trade:start', true)
addEventHandler('trade:start', resourceRoot, startTrade)
addEvent('trade:stop', true)
addEventHandler('trade:stop', resourceRoot, stopTrade)

-- if (getPlayerName(localPlayer):find("IQ")) then
--     startTrade()
-- end