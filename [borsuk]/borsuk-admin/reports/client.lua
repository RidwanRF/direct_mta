local syncer = getElementByID('admin:reports')
local window = {5/zoom, sy/2 - 150/zoom, 700/zoom, 300/zoom}
local holding = false
local reportsVisible = true
local rfs = 12/zoom

addCommandHandler('reports', function()
    if not getAdmin(localPlayer) then return end
    reportsVisible = not reportsVisible
end)

addCommandHandler('rfs', function(cmd, n)
    if not getAdmin(localPlayer) then return end
    if not tonumber(n) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Użycie: /rfs [wielkość czcionki]') end
    rfs = tonumber(n)
end)

local textures = {}
local _dxGetMaterialSize = dxGetMaterialSize
function dxGetMaterialSize(material)
    if type(material) == 'string' then
        if not textures[material] then
            local texture = dxCreateTexture(material)
            textures[material] = {_dxGetMaterialSize(texture)}
        end
        return unpack(textures[material])
    else
        return _dxGetMaterialSize(material)
    end
end

function drawImageWithClip(x, y, w, h, wx, wy, ww, wh, image)
    local mw, mh = dxGetMaterialSize(image)
    if x > wx and y > wy and x + w < wx + ww and y + h < wy + wh then
        dxDrawImage(x, y, w, h, image)
    elseif x > wx and y > wy and x + w > wx + ww and y + h < wy + wh and x < wx + ww then
        dxDrawImageSection(x, y, wx + ww - x, h, 0, 0, (wx + ww - x) / w * mw, mh, image)
    elseif x > wx and y > wy and x + w < wx + ww and y + h > wy + wh and y < wy + wh then
        dxDrawImageSection(x, y, w, wy + wh - y, 0, 0, mw, (wy + wh - y) / h * mh, image)
    elseif x > wx and y > wy and x + w > wx + ww and y + h > wy + wh and x < wx + ww and y < wy + wh then
        dxDrawImageSection(x, y, wx + ww - x, wy + wh - y, 0, 0, (wx + ww - x) / w * mw, (wy + wh - y) / h * mh, image)
    elseif x > wx and y < wy and x + w < wx + ww and y + h > wy then
        dxDrawImageSection(x, wy, w, h - (wy - y), 0, (wy - y) / h * mh, mw, mh - (wy - y) / h * mh, image)
    end
end

addEventHandler('onClientRender', root, function()
    if not getAdmin(localPlayer) or not reportsVisible then return end

    local alpha = isCursorShowing() and 200 or 0
    dxDrawRectangle(window[1], window[2], window[3], window[4], tocolor(25, 25, 25, alpha/4))
    dxDrawRectangle(window[1], window[2], window[3], dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) + 5/zoom, tocolor(25, 25, 25, alpha))
    dxDrawText('/reports | /rfs [n]', window[1] + 6/zoom, window[2] + 2.5/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', rfs), 'left', 'top')

    if holdingAny ~= 'logs' then
        -- add window resizing
        if isMouseInPosition(window[1] + window[3] - 5/zoom, window[2] + window[4] - 5/zoom, 10/zoom, 10/zoom) then
            dxDrawRectangle(window[1] + window[3] - 5/zoom, window[2] + window[4] - 5/zoom, 10/zoom, 10/zoom, tocolor(255, 255, 255, 55))
            
            if not holding and getKeyState('mouse1') then
                holding = 'RB'
            end
        elseif isMouseInPosition(window[1] + window[3] - 5/zoom, window[2] - 5/zoom, 10/zoom, 10/zoom) then
            dxDrawRectangle(window[1] + window[3] - 5/zoom, window[2] - 5/zoom, 10/zoom, 10/zoom, tocolor(255, 255, 255, 55))
            
            if not holding and getKeyState('mouse1') then
                holding = 'RT'
            end
        elseif isMouseInPosition(window[1] - 5/zoom, window[2] + window[4] - 5/zoom, 10/zoom, 10/zoom) then
            dxDrawRectangle(window[1] - 5/zoom, window[2] + window[4] - 5/zoom, 10/zoom, 10/zoom, tocolor(255, 255, 255, 55))
            
            if not holding and getKeyState('mouse1') then
                holding = 'LB'
            end
        elseif isMouseInPosition(window[1] - 5/zoom, window[2] - 5/zoom, 10/zoom, 10/zoom) then
            dxDrawRectangle(window[1] - 5/zoom, window[2] - 5/zoom, 10/zoom, 10/zoom, tocolor(255, 255, 255, 55))
            
            if not holding and getKeyState('mouse1') then
                holding = 'LT'
            end
        elseif isMouseInPosition(window[1], window[2], window[3], dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) + 5/zoom) then
            dxDrawRectangle(window[1], window[2], window[3], dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) + 5/zoom, tocolor(255, 255, 255, 55))
            
            if not holding and getKeyState('mouse1') then
                local cx, cy = getCursorPosition()
                cx, cy = cx * sx, cy * sy
                holding = {window[1] - cx, window[2] - cy}
            end
        end

        if holding then holdingAny = 'reports' end
    end

    if holding and isCursorShowing() then
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy
        if not getKeyState('mouse1') then
            holding = false
            holdingAny = false
        end

        if holding == 'RB' then
            window[3] = cx - window[1]
            window[4] = cy - window[2]
        elseif holding == 'RT' then
            local preY = window[2]
            window[3] = cx - window[1]
            window[2] = cy
            window[4] = window[4] + (preY - window[2])
        elseif holding == 'LB' then
            local preX = window[1]
            window[1] = cx
            window[3] = window[3] + (preX - window[1])
            window[4] = cy - window[2]
        elseif holding == 'LT' then
            local preX, preY = window[1], window[2]
            window[1] = cx
            window[2] = cy
            window[3] = window[3] + (preX - window[1])
            window[4] = window[4] + (preY - window[2])
        elseif type(holding) == 'table' then
            window[1] = cx + holding[1]
            window[2] = cy + holding[2]
        end

        window[3] = math.max(window[3], dxGetTextWidth('/reports | /rfs [n]', 1, getFigmaFont('Inter-Medium', rfs)) + rfs)
        window[4] = math.max(window[4], 25/zoom)
    end

    local reports = getElementData(syncer, 'reports')
    local y = dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) - 20/zoom
    local fh = dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) + 4/zoom
    local rfh = dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs))
    local tooltip = false

    for k,v in pairs(reports) do
        local x = 8/zoom

        local function drawIcon(image, tooltipText)
            drawImageWithClip(window[1] + x, window[2] + 30/zoom + y, fh, fh, window[1], window[2], window[3], window[4], image)
            if isMouseInPosition(window[1] + x, window[2] + 30/zoom + y, fh, fh) and isMouseInPosition(window[1], window[2], window[3], window[4]) then
                tooltip = tooltipText
            end

            x = x + fh + 4/zoom
        end

        if v.status == 'Oczekuje' then
            drawIcon('data/accept.png', 'Zaakceptuj zgłoszenie')
            drawIcon('data/x.png', 'Odrzuć zgłoszenie')
            drawIcon('data/teleport.png', 'Teleportuj do zgłaszającego')
            drawIcon('data/teleport-green.png', 'Teleportuj do zgłoszonego')
            drawIcon('data/waiting.png', 'Zgłoszenie oczekuje na rozpatrzenie')
        else
            drawIcon('data/accept.png', 'Zakończ zgłoszenie')
            drawIcon('data/teleport.png', 'Teleportuj do zgłaszającego')
            drawIcon('data/teleport-green.png', 'Teleportuj do zgłoszonego')
            drawIcon('data/in-work.png', 'Zgłoszenie przyjęte przez '..v.admin)
        end
        
        dxDrawText(v.reasonNoHex, window[1] + x + 2/zoom + 1, window[2] + 30/zoom + y + fh/2 - rfh/2 + 1, window[1] + window[3] + 1, window[2] + window[4] + 1, black, 1, getFigmaFont('Inter-Medium', rfs), 'left', 'top', true)
        local cx = 0
        for _,text in pairs(v.reason) do
            dxDrawText(text[2], window[1] + x + 2/zoom + cx, window[2] + 30/zoom + y + fh/2 - rfh/2, window[1] + window[3], window[2] + window[4], text[1], 1, getFigmaFont('Inter-Medium', rfs), 'left', 'top', true)
            cx = cx + dxGetTextWidth(text[2], 1, getFigmaFont('Inter-Medium', rfs))
        end
        y = y + fh + 4/zoom

        if y > window[4] - fh - 4/zoom then break end
    end

    if tooltip then
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy
        local w = dxGetTextWidth(tooltip, 1, getFigmaFont('Inter-Medium', rfs)) + 8/zoom
        local h = dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) + 8/zoom
        local x = math.max(math.min(cx - w/2, window[1] + window[3] - w), 10/zoom)
        dxDrawRectangle(x, cy - h - 4/zoom, w, h, 0xFF1A1A1A)
        dxDrawText(tooltip, x, cy - h - 4/zoom + 4/zoom, x + w, cy - 4/zoom, white, 1, getFigmaFont('Inter-Medium', rfs), 'center', 'center', true)
    end
end)

addEventHandler('onClientClick', root, function(button, state)
    if button ~= 'left' or state ~= 'down' then return end

    local reports = getElementData(syncer, 'reports')
    local y = 0
    local fh = dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs)) + 4/zoom
    local rfh = dxGetFontHeight(1, getFigmaFont('Inter-Medium', rfs))

    for k,v in pairs(reports) do
        local x = 8/zoom

        local function drawIcon(callback)
            if isMouseInPosition(window[1] + x, window[2] + 30/zoom + y, fh, fh) and isMouseInPosition(window[1], window[2], window[3], window[4]) then
                callback()
            end

            x = x + fh + 4/zoom
        end

        if v.status == 'Oczekuje' then
            drawIcon(function()
                triggerServerEvent('admin:acceptReport', resourceRoot, k)
            end)
            drawIcon(function()
                triggerServerEvent('admin:rejectReport', resourceRoot, k)
            end) -- reject
            drawIcon(function()
                local player = getPlayerBySid(v.sender)
                if not isElement(player) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Gracz, przez którego zostało wysłane zgłoszenie opuścił serwer') end
                local x, y, z = getElementPosition(player)
                setElementPosition(localPlayer, x, y, z + 1)
                exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Teleportowałeś się do zgłaszającego')
            end) -- teleport
            drawIcon(function()
                local player = getPlayerBySid(v.target)
                if not isElement(player) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Gracz, na którego zostało wysłane zgłoszenie opuścił serwer') end
                local x, y, z = getElementPosition(player)
                setElementPosition(localPlayer, x, y, z + 1)
                exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Teleportowałeś się do zgłoszonego')
            end) -- teleport
        else
            drawIcon(function()
                triggerServerEvent('admin:finishReport', resourceRoot, k)
            end)
            drawIcon(function()
                local player = getPlayerBySid(v.sender)
                if not isElement(player) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Gracz, na którego zostało wysłane zgłoszenie opuścił serwer') end
                local x, y, z = getElementPosition(player)
                setElementPosition(localPlayer, x, y, z + 1)
                exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Teleportowałeś się do zgłaszającego')
            end) -- teleport
            drawIcon(function()
                local player = getPlayerBySid(v.target)
                if not isElement(player) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Gracz, na którego zostało wysłane zgłoszenie opuścił serwer') end
                local x, y, z = getElementPosition(player)
                setElementPosition(localPlayer, x, y, z + 1)
                exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Teleportowałeś się do zgłoszonego')
            end) -- teleport
        end

        y = y + fh + 4/zoom

        if y > window[4] - fh - 4/zoom then break end
    end
end)