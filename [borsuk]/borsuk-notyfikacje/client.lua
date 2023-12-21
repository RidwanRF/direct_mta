local notifications = {}
local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local bold = dxCreateFont('data/Inter-Bold.ttf', 16/zoom)
local medium = dxCreateFont('data/Inter-Medium.ttf', 12.8/zoom)
local mediumHeight = dxGetFontHeight(1, medium)
local boldHeight = dxGetFontHeight(1, bold)

local settings = {
    showTime = 800,
    transparencyOffset = sy - 400/zoom
}

local data = {
    info = {{129, 194, 255}, 'Informacja'},
    success = {{199, 255, 129}, 'Sukces'},
    error = {{255, 78, 78}, 'Błąd'},
    warning = {{255, 152, 78}, 'Ostrzeżenie'},
}

function addNotification(type, title, text, duration, unique)
    -- if there is notification with same unique, dont add it
    if unique then
        for k,v in pairs(notifications) do
            if v.unique == unique then
                return false
            end
        end
    end

    local y = 270/zoom
    if not getElementData(localPlayer, 'player:spawn') or getElementData(localPlayer, 'player:hudof') then
        y = 10/zoom
    end

    for k,v in pairs(notifications) do
        local h = boldHeight + #v.text * mediumHeight + 20/zoom
        y = y + h + 5/zoom
    end

    local token = md5(tostring(getTickCount()) .. text .. type)
    local notification = {
        type = type,
        title = title or data[type][2],
        text = wordWrap(text, 420/zoom, 1, medium, true),
        duration = duration or 5000,
        time = getTickCount(),
        token = token,
        timer = text:match('{timer:(%d+)}') or false,
        timerElement = false,
        y = y,
        unique = unique
    }

    if notification.timer then
        notification.original = text
        notification.text = wordWrap(text:gsub('{timer:%d+}', notification.timer), 420/zoom, 1, medium, true)
        notification.timerElement = setTimer(function()
            notification.timer = notification.timer - 1
            notification.text = wordWrap(notification.original:gsub('{timer:%d+}', notification.timer), 420/zoom, 1, medium, true)

            if notification.timer <= 0 then
                notification.duration = getTickCount() - notification.time + 1000
                if notification.timerElement and isTimer(notification.timerElement) then
                    killTimer(notification.timerElement)
                end
            end
        end, 1000, 0)
        notification.duration = duration or math.huge
    end

    table.insert(notifications, notification)

    return token
end

addEvent('addNotification', true)
addEventHandler('addNotification', root, addNotification)

function setNotificationText(token, text)
    for k,v in pairs(notifications) do
        if v.token == token then
            v.text = wordWrap(text, 430/zoom, 1, medium, true)
            v.duration = getTickCount() - v.time + 1000
            break
        end
    end
end

function deleteNotification(token)
    for k,v in pairs(notifications) do
        if v.token == token then
            table.remove(notifications, k)
            if isTimer(v.timerElement) then
                killTimer(v.timerElement)
            end
            break
        end
    end
end

-- addNotification('error', 'Błąd', 'Nie jesteś właścicielem tego pojazdu', 5000)
-- local token = addNotification('warning', 'Zwolnij', 'Odczekaj #FF984E{timer:10} sekund #ffffffprzed ponowną wiadomością', 5000)
-- addNotification('success', 'Sukces', 'Pojazd został pomyślnie wyjęty z parkingu policyjnego dsa udihsaui dgsauy gdsyuag duisag dyusag yudsga uidgsau idgsaui dgsuay gdyusag dusag duysag dyusag dyusag dyusag dyusag dyusag ydusag yudsay udsfayu dfsayu dfsayu dfsayu dsai dgsau dhsuia gd', 5000)
-- addNotification('info', 'Informacja', 'Report na gracza #81C2FFborsuczyna #ffffffzostał wysłany pomyślnie', 5000)
-- addNotification('info', 'Informacja', 'test\nnowej\nlini', 5000)

addEventHandler('onClientRender', root, function()
    for k,v in pairs(notifications) do
        if getTickCount() > v.time + settings.showTime * 2 + v.duration then
            table.remove(notifications, k)
            if isTimer(v.timerElement) then
                killTimer(v.timerElement)
            end
        end
    end

    local y = 270/zoom
    if not getElementData(localPlayer, 'player:spawn') or getElementData(localPlayer, 'player:hudof') then
        y = 10/zoom
    end
    for k,v in pairs(notifications) do
        v.y = interpolateBetween(v.y, 0, 0, y, 0, 0, 0.1, 'Linear')
        local isTransparent = v.y > settings.transparencyOffset

        local x, alpha = 0, 1
        if getTickCount() < v.time + settings.showTime then
            x, alpha = interpolateBetween(460/zoom, 0, 0, 0, 1, 0, (getTickCount() - v.time)/settings.showTime, 'InOutQuad')
        elseif getTickCount() > v.time + settings.showTime + v.duration then
            x, alpha = interpolateBetween(0, 1, 0, 460/zoom, 0, 0, (getTickCount() - v.time - settings.showTime - v.duration)/settings.showTime, 'InOutQuad')
        else
            x = 0
        end

        local color = data[v.type][1]
        local h = boldHeight + #v.text * mediumHeight + 20/zoom
        dxDrawImage(sx - 460/zoom + x, v.y, 450/zoom, h, 'data/background-' .. v.type .. '.png', 0, 0, 0, tocolor(255, 255, 255, 255 * (isTransparent and 0.3 or 1) * alpha),true)
        dxDrawText(v.title, sx - 35/zoom + x, v.y + 10/zoom, nil, nil, tocolor(color[1], color[2], color[3], 255 * (isTransparent and 0.3 or 1) * alpha), 1, bold, 'right', 'top', false, false, true, true)
        dxDrawText(table.concat(v.text, '\n'), sx - 35/zoom + x, v.y + 10/zoom + boldHeight, nil, nil, tocolor(255, 255, 255, 192 * (isTransparent and 0.3 or 1) * alpha), 1, medium, 'right', 'top', false, false, true, true)

        y = y + h + 5/zoom
    end
end)