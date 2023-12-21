local currentShop = false
local cart = {}
local scroll = 1
local shops = {
    {
        name = 'Sklep u dyzia',
        location = 'Los Santos',
        position = {2431.27, -1745.47, 13.66, 90},
        items = {
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'milka-snack', price = 45},
            {name = 'money-pack', price = 1000},
        }
    }
}

function createShops()
    for i, shop in ipairs(shops) do
        local ped = createPed(7, shop.position[1], shop.position[2], shop.position[3], shop.position[4])
        setElementFrozen(ped, true)
        addEventHandler('onClientPedDamage', ped, cancelEvent)
        setElementData(ped, 'shop', shop)
    end
end

addEventHandler('onClientRender', root, function()
    local x, y, z = getElementPosition(localPlayer)
    for k,v in pairs(getElementsWithinRange(x, y, z, 20, 'ped')) do
        local shop = getElementData(v, 'shop')
        if shop then
            local px, py, pz = getElementPosition(v)
            local sx, sy = getScreenFromWorldPosition(px, py, pz + 1.1)
            if sx and sy then
                dxDrawText(shop.name, sx, sy, nil, nil, tocolor(255, 255, 255), 1, regular2, 'center', 'center')
                dxDrawText('Kliknij aby rozpocząć interakcję', sx, sy + 17/zoom, nil, nil, tocolor(255, 255, 255, 155), 1, regular3, 'center', 'center')
            end
        end
    end
end)

addEventHandler('onClientClick', root, function(button, state, _, _, _, _, _, element)
    if button ~= 'left' or state ~= 'down' then return end
    if not isElement(element) then return end
    if getElementType(element) ~= 'ped' then return end
    if not getElementData(element, 'shop') then return end
    if currentShop then return end

    local shop = getElementData(element, 'shop')
    if not shop then return end
    if not shop.items then return end

    currentShop = shop
    toggleShop(true)
end)

createShops()

local function renderShop()
    local data = currentShop
    if not data then return end

    dxDrawImage(sx/2 - 450/zoom, sy/2 - 300/zoom, 900/zoom, 600/zoom, 'data/shop-background.png')

    dxDrawText(data.name, sx/2 - 430/zoom, sy/2 - 280/zoom, nil, nil, tocolor(255, 255, 255), 1, regular5, 'left', 'top')
    dxDrawText(data.location, sx/2 - 430/zoom, sy/2 - 255/zoom, nil, nil, tocolor(255, 255, 255, 155), 1, regular3, 'left', 'top')
    
    local count = 0
    for k,v in ipairs(cart) do
        count = count + v.amount
    end
    dxDrawText('Koszyk', sx/2 + 5/zoom, sy/2 - 280/zoom, nil, nil, tocolor(255, 255, 255), 1, regular5, 'left', 'top')
    dxDrawText(('Przedmioty: %d'):format(count), sx/2 + 5/zoom, sy/2 - 255/zoom, nil, nil, tocolor(255, 255, 255, 155), 1, regular3, 'left', 'top')

    local totalPrice = 0
    for k,v in ipairs(cart) do
        totalPrice = totalPrice + v.price * v.amount
    end

    dxDrawImage(sx/2 + 230/zoom, sy/2 - 280/zoom, 200/zoom, 45/zoom, 'data/editbox.png')
    dxDrawImage(sx/2 + 240/zoom, sy/2 - 268/zoom, 20/zoom, 17/zoom, 'data/cart.png')
    dxDrawText('Cena: $' .. totalPrice, sx/2 + 270/zoom, sy/2 - 258/zoom, nil, nil, tocolor(255, 255, 255, 155), 1, regular4, 'left', 'center')

    drawGridInventory('shop-' .. data.name .. data.location, sx/2 - 430/zoom, sy/2 - 220/zoom, 400/zoom, 435/zoom, 3, 3, 10/zoom, data.items)

    drawEditbox('amount-shop', 'Ilość', sx/2 - 430/zoom, sy/2 + 230/zoom, 195/zoom, 50/zoom)
    drawButton('Dodaj do koszyka', sx/2 - 225/zoom, sy/2 + 230/zoom, 195/zoom, 50/zoom, regular2, tocolor(156, 123, 39, 255), tocolor(187, 148, 47, 255))

    drawButton('Anuluj', sx/2 + 5/zoom, sy/2 + 230/zoom, 210/zoom, 50/zoom, regular2, tocolor(28, 28, 28, 77), tocolor(28, 28, 28, 60))
    drawButton('Potwierdź zakup', sx/2 + 225/zoom, sy/2 + 230/zoom, 210/zoom, 50/zoom, regular2, tocolor(31, 130, 114), tocolor(37, 155, 136), tocolor(255, 255, 255, 180))

    scroll = math.max(1, math.min(scroll, #data.items - 5))

    local y = 0
    for k,v in pairs(cart) do
        if k >= scroll and k <= scroll + 5 then
            local inside = isMouseInPosition(sx/2 + 5/zoom, sy/2 - 220/zoom + y, 420/zoom, 70/zoom)
            dxDrawImage(sx/2 + 5/zoom, sy/2 - 220/zoom + y, 420/zoom, 70/zoom, inside and 'data/cart-item-hover.png' or 'data/cart-item.png')
            local itemData = getItemInfo(v.name)

            dxDrawImage(sx/2 + 20/zoom, sy/2 - 210/zoom + y, 50/zoom, 50/zoom, 'data/' .. itemData.icon .. '.png')
            dxDrawText(itemData.name, sx/2 + 80/zoom, sy/2 - 185/zoom + y, nil, nil, tocolor(255, 255, 255, 150), 1, regular3, 'left', 'center')
            dxDrawText('x' .. v.amount, sx/2 + 355/zoom, sy/2 - 185/zoom + y, nil, nil, tocolor(255, 255, 255, 150), 1, regular3, 'right', 'center')

            dxDrawImage(sx/2 + 365/zoom, sy/2 - 210/zoom + y, 50/zoom, 50/zoom, inside and 'data/cart-remove-hover.png' or 'data/cart-remove.png')

            y = y + 74/zoom
        end
    end

    drawScrollbar(sx/2 + 435/zoom, sy/2 - 220/zoom, 440/zoom, math.max(#cart-1,0), 5, scroll-1)
end

local function scrollCallback(key)
    local data = currentShop
    if not data then return end

    useInventoryScroll('shop-' .. data.name .. data.location, sx/2 - 430/zoom, sy/2 - 220/zoom, 400/zoom, 435/zoom, 3, 3, data.items, key)

    if isMouseInPosition(sx/2 + 5/zoom, sy/2 - 220/zoom, 420/zoom, 435/zoom) then
        if key == 'mouse_wheel_down' then
            scroll = math.min(#cart - 5, scroll + 1)
        elseif key == 'mouse_wheel_up' then
            scroll = math.max(1, scroll - 1)
        end
    end
end

local function clickCallback(btn, state)
    if btn ~= 'left' or state ~= 'down' then return end
    local data = currentShop
    if not data then return end

    clickInventory('shop-' .. data.name .. data.location, sx/2 - 430/zoom, sy/2 - 220/zoom, 400/zoom, 435/zoom, 3, 3, 10/zoom, data.items, function(item, itemData)
        for i, v in ipairs(data.items) do
            v.active = i == item.id
        end
    end)

    local y = 0
    for k,v in ipairs(cart) do
        if k >= scroll and k <= scroll + 5 then
            if isMouseInPosition(sx/2 + 365/zoom, sy/2 - 210/zoom + y, 50/zoom, 50/zoom) then
                table.remove(cart, k)

                scroll = math.min(#cart - 5, scroll)
                return
            end

            y = y + 74/zoom
        end
    end

    if isMouseInPosition(sx/2 - 225/zoom, sy/2 + 230/zoom, 195/zoom, 50/zoom) then
        local amount = tonumber(getEditboxText('amount-shop')) or 1

        local item = false
        for i, v in ipairs(data.items) do
            if v.active then
                item = v
                break
            end
        end
        if not item then return end

        for k,v in ipairs(cart) do
            if v.name == item.name then
                v.amount = v.amount + amount
                return
            end
        end

        table.insert(cart, {name = item.name, price = item.price, amount = amount})
    elseif isMouseInPosition(sx/2 + 5/zoom, sy/2 + 230/zoom, 210/zoom, 50/zoom) then
        toggleShop(false)
    elseif isMouseInPosition(sx/2 + 225/zoom, sy/2 + 230/zoom, 210/zoom, 50/zoom) then
        local total = 0
        for k,v in ipairs(cart) do
            total = total + v.price * v.amount
        end
        local totalWeight = 0
        for k,v in ipairs(cart) do
            totalWeight = totalWeight + getItemInfo(v.name).weight * v.amount
        end
        local currentWeight = 0
        for k,v in ipairs(getPlayerInventory()) do
            local data = getItemInfo(v.name)
            if data then
                currentWeight = currentWeight + data.weight * v.amount
            end
        end
        if getPlayerMoney(localPlayer) < total then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Nie posiadasz tyle gotówki!') end

        triggerServerEvent('shopBuy', resourceRoot, cart, total)
        toggleShop(false)
    end
end

local shopVisible = false

function toggleShop(visible)
    if shopVisible == visible then return end

    local eventCallback = visible and addEventHandler or removeEventHandler
    local bindCallback = visible and bindKey or unbindKey

    eventCallback('onClientRender', root, renderShop)
    eventCallback('onClientClick', root, clickCallback)
    bindCallback('mouse_wheel_down', 'down', scrollCallback)
    bindCallback('mouse_wheel_up', 'down', scrollCallback)

    showCursor(visible)

    cart = {}
    shopVisible = visible
    currentShop = visible and currentShop or false
end