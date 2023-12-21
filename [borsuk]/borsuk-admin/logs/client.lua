local syncer = getElementByID('admin:logs')
local window = {sx - 705/zoom, sy/2 - 150/zoom, 700/zoom, 300/zoom}
local holding = false
local logsVisible = true
local lfs = 12/zoom

addCommandHandler('logs', function()
    if not getAdmin(localPlayer) then return end
    logsVisible = not logsVisible
end)

addCommandHandler('lfs', function(cmd, n)
    if not getAdmin(localPlayer) then return end
    if not tonumber(n) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Użycie: /lfs [wielkość czcionki]') end
    lfs = tonumber(n)
end)

local reversePairs = function ( aTable )
	local keys = {}

	for k,v in pairs(aTable) do keys[#keys+1] = k end
	table.sort(keys, function (a, b) return a>b end)

	local n = 0

	return function ( )
		n = n + 1
		return keys[n], aTable[keys[n] ]
	end
end

addEventHandler('onClientRender', root, function()
    if not getAdmin(localPlayer) or not logsVisible then return end

    local alpha = isCursorShowing() and 200 or 0
    local top = dxGetFontHeight(1, getFigmaFont('Inter-Medium', lfs)) + 5/zoom
    dxDrawRectangle(window[1], window[2], window[3], window[4], tocolor(25, 25, 25, alpha/4))
    dxDrawRectangle(window[1], window[2], window[3], top, tocolor(25, 25, 25, alpha))
    dxDrawText('/logs | /lfs [n]', window[1] + window[3] - 6/zoom, window[2] + 2.5/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', lfs), 'right', 'top')

    -- add window resizing
    if holdingAny ~= 'reports' then
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
        elseif isMouseInPosition(window[1], window[2], window[3], top) then
            dxDrawRectangle(window[1], window[2], window[3], top, tocolor(255, 255, 255, 55))
            
            if not holding and getKeyState('mouse1') then
                local cx, cy = getCursorPosition()
                cx, cy = cx * sx, cy * sy
                holding = {window[1] - cx, window[2] - cy}
            end
        end

        if holding then holdingAny = 'logs' end
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

        window[3] = math.max(window[3], dxGetTextWidth('/logs | /lfs [n]', 1, getFigmaFont('Inter-Medium', lfs)) + lfs)
        window[4] = math.max(window[4], 25/zoom)
    end

    local logs = getElementData(syncer, 'logs')
    local rfh = dxGetFontHeight(1, getFigmaFont('Inter-Medium', lfs))
    local y = window[4] - rfh - 20/zoom
    local fh = rfh + 4/zoom
    local tooltip = false
    local min = rfh - 25/zoom

    for k,v in reversePairs(logs) do
        local x = window[3] - 8/zoom - fh

        local function drawIcon(image, tooltipText)
            drawImageWithClip(window[1] + x, window[2] + 34/zoom + y - fh, fh, fh, window[1], window[2] + top, window[3], window[4], image)
            if isMouseInPosition(window[1] + x, window[2] + 34/zoom + y - fh, fh, fh) and isMouseInPosition(window[1], window[2], window[3], window[4]) then
                tooltip = tooltipText
            end

            x = x - fh - 4/zoom
        end

        local timestamp = getRealTime(v.sendTime)
        if v.type == 'chat' then
            drawIcon('data/chat.png', 'Chat lokalny, wysłano o ' .. timestamp.hour .. ':' .. timestamp.minute .. ':' .. timestamp.second)
            drawIcon('data/teleport.png', 'Teleportuj do gracza')
        elseif v.type == 'command' then
            drawIcon('data/command.png', 'Komenda wywołana o ' .. timestamp.hour .. ':' .. timestamp.minute .. ':' .. timestamp.second)
            drawIcon('data/teleport.png', 'Teleportuj do gracza')
        end

        x = x + fh + 2/zoom
        
        local w = dxGetTextWidth(v.textNoHex, 1, getFigmaFont('Inter-Medium', lfs))
        dxDrawText(v.textNoHex, window[1], window[2] + top, window[1] + x - 2/zoom + 1, window[2] + 30/zoom + y + fh/2 - rfh/2 + 1, black, 1, getFigmaFont('Inter-Medium', lfs), 'right', 'bottom', true)
        local cx = 0
        for _,text in reversePairs(v.text) do
            local w = dxGetTextWidth(text[2], 1, getFigmaFont('Inter-Medium', lfs))
            dxDrawText(text[2], window[1], window[2] + top, window[1] + x - 2/zoom + cx, window[2] + 30/zoom + y + fh/2 - rfh/2, text[1], 1, getFigmaFont('Inter-Medium', lfs), 'right', 'bottom', true)
            cx = cx - w
        end
        y = y - fh - 4/zoom
        if y < min then break end
    end

    if tooltip then
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy
        local w = dxGetTextWidth(tooltip, 1, getFigmaFont('Inter-Medium', lfs)) + 8/zoom
        local h = dxGetFontHeight(1, getFigmaFont('Inter-Medium', lfs)) + 8/zoom
        local x = math.max(math.min(cx - w/2, window[1] + window[3] - w), 10/zoom)
        dxDrawRectangle(x, cy - h - 4/zoom, w, h, 0xFF1A1A1A)
        dxDrawText(tooltip, x, cy - h - 4/zoom + 4/zoom, x + w, cy - 4/zoom, white, 1, getFigmaFont('Inter-Medium', lfs), 'center', 'center', true)
    end
end)

addEventHandler('onClientClick', root, function(button, state)
    if button ~= 'left' or state ~= 'down' then return end

    local logs = getElementData(syncer, 'logs')
    local rfh = dxGetFontHeight(1, getFigmaFont('Inter-Medium', lfs))
    local fh = rfh + 4/zoom
    local y = window[4] - rfh - 20/zoom
    local min = rfh - 25/zoom

    for k,v in pairs(logs) do
        local x = window[3] - 8/zoom - fh

        local function drawIcon(callback)
            if isMouseInPosition(window[1] + x, window[2] + 34/zoom + y - fh, fh, fh) and isMouseInPosition(window[1], window[2], window[3], window[4]) then
                callback()
            end

            x = x - fh - 4/zoom
        end

        if v.type == 'chat' then
            drawIcon(function()
                local timestamp = getRealTime(v.sendTime)
                exports['borsuk-notyfikacje']:addNotification('info', 'Informacja', 'Wiadomość została wysłana na chacie lokalnym o ' .. timestamp.hour .. ':' .. timestamp.minute .. ':' .. timestamp.second)
            end)
            drawIcon(function()
                local player = getPlayerBySid(v.player)
                if not isElement(player) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Gracz, który wysłał wiadomość nie jest już na serwerze') end
                local x, y, z = getElementPosition(player)
                setElementPosition(localPlayer, x, y, z + 1)
                exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Teleportowałeś się do gracza')
            end)
        elseif v.type == 'command' then
            drawIcon(function()
                local timestamp = getRealTime(v.sendTime)
                exports['borsuk-notyfikacje']:addNotification('info', 'Informacja', 'Komenda została wywołana o ' .. timestamp.hour .. ':' .. timestamp.minute .. ':' .. timestamp.second)
            end)
            drawIcon(function()
                local player = getPlayerBySid(v.player)
                if not isElement(player) then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Gracz, który wywołał komendę nie jest już na serwerze') end
                local x, y, z = getElementPosition(player)
                setElementPosition(localPlayer, x, y, z + 1)
                exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Teleportowałeś się do gracza')
            end)
        end

        y = y - fh - 4/zoom
        if y < min then break end
    end
end)

addEventHandler('onClientConsole', root, function(command)
    triggerServerEvent('admin:logConsole', resourceRoot, command)
end)