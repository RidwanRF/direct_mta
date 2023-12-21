function renderQuickInventory()
    if not getElementData(localPlayer, 'player:spawn') then return end

    local w = 6 * 70/zoom + 5 * 5/zoom
    dxDrawImage(sx/2 - w/2 - 5/zoom, sy - 105/zoom, w + 10/zoom, 80/zoom, 'data/quick-background.png')
    
    for i = 1, 6 do
        local x = sx/2 - w/2 + (i - 1) * 70/zoom + (i - 1) * 5/zoom
        local y = sy - 100/zoom
        local w = 70/zoom
        local h = 70/zoom

        local over = isInventoryVisible()
        dxDrawImage(x, y, w, h, 'data/quick-item.png', 0, 0, 0, tocolor(255, 255, 255, over and 255 or 155))
        
        local item = getItemOnQuickSlot(i)
        if item then
            local itemData = getItemInfo(item.name)
            if itemData then
                local classColor = tocolor(unpack(classes[itemData.class].color))
                dxDrawImage(x, y, w, h, 'data/item_shadow.png', 0, 0, 0, classColor)
                dxDrawImage(x + 10/zoom, y + 10/zoom, 50/zoom, 50/zoom, 'data/' .. itemData.icon .. '.png')
                dxDrawText('x'..item.amount, x + w - 5/zoom, y + h - 5/zoom, nil, nil, tocolor(255, 255, 255, 155), 0.9, regular3, 'right', 'bottom')

                if item.progress then
                    dxDrawImage(x + w*0.1, y + h * 1.1, w * 0.8, h * 0.1, 'data/level_progress.png',0,0,0,tocolor(71,71,71,150))
                    dxDrawImageSection(x + w*0.1, y + h * 1.1, w * 0.8*item.progress/100, h * 0.1, 0, 0, 122*item.progress/100, 8, 'data/level_progress.png',0,0,0,classColor)
                end
            end
        end

        if isInventoryVisible() then
            dxDrawText(i, x + 5/zoom, y + 5/zoom, nil, nil, tocolor(255, 255, 255, 70), 1, regular3, 'left', 'top')
        end
    end

    if isInventoryVisible() then
        dxDrawText('Najedź myszka na item oraz nacisnij przycisk 1-6 aby dodac go do szybkiego wyboru', sx/2, sy - 110/zoom, nil, nil, tocolor(255, 255, 255, 155), 1, regular3, 'center', 'bottom')
    end
end

function getItemOnQuickSlot(id)
    local items = getPlayerInventory()
    for k,v in pairs(items) do
        if v.quickslot == id then
            return {
                id = k,
                name = v.name,
                amount = v.amount,
                token = v.token,
                progress = v.progress,
            }
        end
    end
end

function useQuickSlot(id)
    if isInventoryVisible() or getElementData(localPlayer, 'trade') then return end
    id = tonumber(id)

    local item = getItemOnQuickSlot(id)
    if not item then return end

    useItem(item)
end

for i = 1, 6 do
    bindKey(tostring(i), 'down', useQuickSlot)
end

addEventHandler("onClientRender", root, renderQuickInventory)