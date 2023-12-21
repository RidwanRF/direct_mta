local inventoryScrolls = {}

function drawGridInventory(unique, x, y, w, h, xc, yc, gap, items)
    local itemW = (w - gap * (xc - 1)) / xc
    local itemH = (h - gap * (yc - 1)) / yc

    for xc = 1, xc do
        for yc = 1, yc do
            dxDrawImage(x + (xc - 1) * (itemW + gap), y + (yc - 1) * (itemH + gap), itemW, itemH, 'data/item.png')
        end
    end

    local itemInnerSize = math.min(itemW, itemH) * 0.6
    local scroll = inventoryScrolls[unique] or 0
    
    local mxc, myc = xc, yc
    local xc, yc = 0, 0
    local hovered = false
    for k,v in pairs(items) do
        local itemData = getItemInfo(v.name)
        if itemData and (k-1) >= scroll * mxc then
            if v.active then
                dxDrawImage(x + xc * (itemW + gap), y + yc * (itemH + gap), itemW, itemH, 'data/item.png')
                dxDrawImage(x + xc * (itemW + gap), y + yc * (itemH + gap), itemW, itemH, 'data/item.png')
            end
            dxDrawImage(x + xc * (itemW + gap), y + yc * (itemH + gap), itemW, itemH, 'data/item_shadow.png',0,0,0,tocolor(unpack(classes[itemData.class].color)))
            dxDrawImage(x + xc * (itemW + gap) + itemW/2 - itemInnerSize/2, y + yc * (itemH + gap) + itemH/2 - itemInnerSize/2, itemInnerSize, itemInnerSize, 'data/' .. itemData.icon .. '.png')
            if v.amount then
                dxDrawText('x' .. v.amount, x + xc * (itemW + gap) + itemW - 10/zoom, y + yc * (itemH + gap) + 10/zoom, nil, nil, 0x99FFFFFF, 1, regular4, 'right', 'top')
            elseif v.price then
                dxDrawText('$' .. v.price, x + xc * (itemW + gap) + itemW/2, y + yc * (itemH + gap) + itemH - 10/zoom, nil, nil, 0x99FFFFFF, 1, regular4, 'center', 'bottom')
            end

            if isMouseInPosition(x + xc * (itemW + gap) + itemW/2 - itemInnerSize/2, y + yc * (itemH + gap) + itemH/2 - itemInnerSize/2, itemInnerSize, itemInnerSize) then
                hovered = v
            end

            xc = xc + 1
            if xc > mxc - 1 then
                xc = 0
                yc = yc + 1

                if yc > myc - 1 then
                    break
                end
            end
        end
    end

    if hovered then
        local itemData = getItemInfo(hovered.name)
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy

        local w = dxGetTextWidth(itemData.name, 1, regular2)
        if itemData.description then
            w = math.max(w, dxGetTextWidth(itemData.description, 1, regular4))
        end
        w = math.max(w, dxGetTextWidth('Rzadkosc: '..classes[itemData.class].name, 1, regular4))
        local h = dxGetFontHeight(1, regular2)
        h = h + dxGetFontHeight(1, regular4)
        if itemData.description then
            h = h + dxGetFontHeight(1, regular4)
        end

        local textY = 0
        if (itemData.description) then
            textY = textY + dxGetFontHeight(1, regular4)
        end
        if (itemData.progress) then
            h = h + 15/zoom
        end
        
        dxDrawRectangle(cx + 5/zoom, cy + 15/zoom, w + 10/zoom, h + 10/zoom, 0x99222222)
        dxDrawText(itemData.name, cx + 10/zoom, cy + 20/zoom, nil, nil, white, 1, regular2)
        dxDrawText('Rzadkosc: '..rgbToHex(unpack(classes[itemData.class].color))..''..classes[itemData.class].name..'\n\n\ntoken: ' ..hovered.token, cx + 10/zoom, cy + 20/zoom + dxGetFontHeight(1, regular4) + 3/zoom, nil, nil, tocolor(230,230,230), 1, regular4,'left','top',false,false,false,true)
        if itemData.description then
            dxDrawText(itemData.description, cx + 10/zoom, cy + 20/zoom + dxGetFontHeight(1, regular4) + 3/zoom + dxGetFontHeight(1, regular4), nil, nil, 0xAAFFFFFF, 1, regular4)
        end

        if (itemData.progress) then
            dxDrawImage(cx + 10/zoom, cy + 20/zoom + dxGetFontHeight(1, regular4) + 3/zoom + dxGetFontHeight(1, regular4) + 3/zoom + textY,w - 1/zoom, 10/zoom, "data/level_progress.png",0,0,0,tocolor(71,71,71,150))
            dxDrawImageSection(cx + 10/zoom, cy + 20/zoom + dxGetFontHeight(1, regular4) + 3/zoom + dxGetFontHeight(1, regular4) + 3/zoom + textY,(w - 1/zoom)*hovered.progress/100, 10/zoom, 0, 0, 122*hovered.progress/100, 8, "data/level_progress.png",0,0,0,tocolor(unpack(classes[hovered.class].color)))
        end
    end

    local rows = math.ceil(#items / mxc)
    drawScrollbar(x + w + 5/zoom, y, h, rows, myc, scroll)
end

function renderInventory()
    dxDrawImage(sx - 550/zoom, sy/2 - 605/2/zoom, 500/zoom, 605/zoom, 'data/background.png')
    dxDrawText('Ekwipunek', sx - 532/zoom, sy/2 - 280/zoom, nil, nil, white, 1, regular)
    -- drawEditbox('amount-1', 'Amount', sx - 300/zoom, sy/2 - 307/zoom, 235/zoom, 40/zoom)

    drawGridInventory('inventory', sx - 532/zoom, sy/2 - 232/zoom, 460/zoom, 515/zoom, 5, 5, 10/zoom, getPlayerInventory())

    local used = 0

    for k,v in pairs(getPlayerInventory()) do
        local itemData = getItemInfo(v.name)
        if itemData then
            used = used + itemData.weight * v.amount
        end
    end

    -- local capacity = 90
    -- local progress = used/capacity
    
    -- dxDrawText('Inventory level', sx - 532/zoom, sy/2 + 285/zoom, nil, nil, white, 1, regular2)
    -- dxDrawText(('%.1f/%.1fKG'):format(used, capacity), sx - 72/zoom, sy/2 + 285/zoom, nil, nil, white, 1, regular2, 'right')
    -- dxDrawImage(sx - 532/zoom, sy/2 + 318/zoom, 464/zoom, 10/zoom, 'data/progress-bg.png')
    -- dxDrawImageSection(sx - 532/zoom, sy/2 + 318/zoom, 464/zoom * progress, 10/zoom, 0, 0, 640 * progress, 12, 'data/progress.png')
end

function useInventoryScroll(unique, x, y, w, h, xc, yc, items, key)
    if isMouseInPosition(x, y, w, h) then
        if not inventoryScrolls[unique] then
            inventoryScrolls[unique] = 0
        end
        if key == 'mouse_wheel_up' then
            inventoryScrolls[unique] = math.max(inventoryScrolls[unique] - 1, 0)
        elseif key == 'mouse_wheel_down' then
            inventoryScrolls[unique] = math.min(inventoryScrolls[unique] + 1, math.ceil(#items / xc) - yc)
        end
    end
end

function clickInventory(unique, x, y, w, h, xc, yc, gap, items, callback)
    local itemW = (w - gap * (xc - 1)) / xc
    local itemH = (h - gap * (yc - 1)) / yc

    local itemInnerSize = math.min(itemW, itemH) * 0.6
    local scroll = inventoryScrolls[unique] or 0
    
    local mxc, myc = xc, yc
    local xc, yc = 0, 0
    for k,v in pairs(items) do
        local itemData = getItemInfo(v.name)
        if itemData and (k-1) >= scroll * mxc then
            if isMouseInPosition(x + xc * (itemW + gap) + itemW/2 - itemInnerSize/2, y + yc * (itemH + gap) + itemH/2 - itemInnerSize/2, itemInnerSize, itemInnerSize) then
                callback({
                    name = v.name,
                    amount = v.amount,
                    price = v.price,
                    id = k,
                    nid = v.nid,
                    class = v.class,
                    progress = v.progress,
                    token = v.token,
                }, itemData)
            end

            xc = xc + 1
            if xc > mxc - 1 then
                xc = 0
                yc = yc + 1

                if yc > myc - 1 then
                    break
                end
            end
        end
    end
end

function itemUnderCursor(unique, x, y, w, h, xc, yc, gap, items, callback)
    local itemW = (w - gap * (xc - 1)) / xc
    local itemH = (h - gap * (yc - 1)) / yc

    local itemInnerSize = math.min(itemW, itemH) * 0.6
    local scroll = inventoryScrolls[unique] or 0
    
    local mxc, myc = xc, yc
    local xc, yc = 0, 0
    for k,v in pairs(items) do
        local itemData = getItemInfo(v.name)
        if itemData and (k-1) >= scroll * mxc then
            if isMouseInPosition(x + xc * (itemW + gap) + itemW/2 - itemInnerSize/2, y + yc * (itemH + gap) + itemH/2 - itemInnerSize/2, itemInnerSize, itemInnerSize) then
                callback(k)
                return k
            end

            xc = xc + 1
            if xc > mxc - 1 then
                xc = 0
                yc = yc + 1

                if yc > myc - 1 then
                    break
                end
            end
        end
    end
end

local function inventoryClickCallback(btn, state)
    if btn ~= 'left' or state ~= 'down' then return end

    clickInventory('inventory', sx - 532/zoom, sy/2 - 232/zoom, 460/zoom, 515/zoom, 5, 5, 10/zoom, getPlayerInventory(), function(item, itemData)
        useItem(item)
    end)
end

local function scrollCallback(key)
    useInventoryScroll('inventory', sx - 532/zoom, sy/2 - 252/zoom, 460/zoom, 515/zoom, 5, 5, getPlayerInventory(), key)
end

local function keyCallback(key, state)
    if not state or not tonumber(key) or tonumber(key) > 6 or tonumber(key) < 1 then return end

    local under = itemUnderCursor('inventory', sx - 532/zoom, sy/2 - 252/zoom, 460/zoom, 515/zoom, 5, 5, 10/zoom, getPlayerInventory(), function(id)
        local quickItem = getItemOnQuickSlot(tonumber(key))
        local inventory = getPlayerInventory()

        if quickItem then
            for k,v in pairs(inventory) do
                if k == quickItem.id and k ~= id then
                    v.quickslot = nil
                    break
                end
            end
        end

        for k,v in pairs(inventory) do
            if k == id then
                if v.quickslot ~= tonumber(key) then
                    v.quickslot = tonumber(key)
                else
                    v.quickslot = nil
                end
                break
            end
        end

        setPlayerInventory(inventory)
    end)

    if not under then
        local inventory = getPlayerInventory()
        local quickItem = getItemOnQuickSlot(tonumber(key))

        if quickItem then
            for k,v in pairs(inventory) do
                if k == quickItem.id then
                    v.quickslot = nil
                    break
                end
            end
        end

        setPlayerInventory(inventory)
    end
end

local inventoryVisible = false

function toggleInventory(visible)
    if not getElementData(localPlayer, 'player:spawn') then return end
    if inventoryVisible == visible then return end
    inventoryVisible = visible

    local eventCallback = visible and addEventHandler or removeEventHandler
    local bindCallback = visible and bindKey or unbindKey

    eventCallback('onClientRender', root, renderInventory)
    eventCallback('onClientClick', root, inventoryClickCallback)
    eventCallback('onClientKey', root, keyCallback)
    bindCallback('mouse_wheel_up', 'down', scrollCallback)
    bindCallback('mouse_wheel_down', 'down', scrollCallback)
    showCursor(visible, false)
end

function isInventoryVisible()
    return inventoryVisible
end

bindKey('i', 'down', function()
    if getElementData(localPlayer, 'trade') then return end
    toggleInventory(not inventoryVisible)
end)