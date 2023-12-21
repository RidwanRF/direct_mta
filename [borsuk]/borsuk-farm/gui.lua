local selectedPlayer = false
local questionBox

function getFarmMarker()
    local marker = false
    for k,v in pairs(getElementsByType('marker', resourceRoot)) do
        if isElementWithinMarker(localPlayer, v) then
            marker = v
        end
    end
    if not marker then return end
    local data = getElementData(marker, 'barn:data')
    if not data then return end
    return marker, data
end

function renderQuestionBox()
    local marker, data = getFarmMarker()
    if not marker then return toggleQuestionBox(false) end

    dxDrawImage(sx/2 - 250/zoom, sy/2 - 60/zoom, 500/zoom, 120/zoom, 'data/background3.png')
    dxDrawText(questionBox.title, sx/2 - 240/zoom, sy/2 - 50/zoom, nil, nil, white, 1, bold)
    dxDrawText(questionBox.description, sx/2 - 240/zoom, sy/2 - 25/zoom, nil, nil, tocolor(255,255,255,200), 1, regular)

    drawButton(questionBox.button, sx/2 - 155/zoom, sy/2 + 10/zoom, 150/zoom, 35/zoom, regular)
    drawButton('Cancel', sx/2 + 5/zoom, sy/2 + 10/zoom, 150/zoom, 35/zoom, regular)
end

function clickQuestionBox(btn, state)
    local marker, data = getFarmMarker()
    if not marker then return toggleQuestionBox(false) end
    if btn ~= 'left' or state ~= 'down' then return end

    if isMouseInPosition(sx/2 + 5/zoom, sy/2 + 10/zoom, 150/zoom, 35/zoom) then
        toggleQuestionBox(false)
    elseif isMouseInPosition(sx/2 - 155/zoom, sy/2 + 10/zoom, 150/zoom, 35/zoom) then
        questionBox.callback()
        toggleQuestionBox(false)
    end
end

function toggleQuestionBox(b)
    local eventCallback = b and addEventHandler or removeEventHandler
    if not b then questionBox = false end

    eventCallback('onClientRender', root, renderQuestionBox)
    eventCallback('onClientClick', root, clickQuestionBox)
    showCursor(b, false)
end

function showQuestionBox(title, description, button, callback)
    if questionBox then return end
    questionBox = {
        title = title,
        description = description,
        callback = callback,
        button = button
    }

    toggleQuestionBox(true)
end

function renderFarmInteraction()
    local marker, data = getFarmMarker()
    if not marker then return toggleFarmInteraction(false) end

    dxDrawImage(sx - 430/zoom, sy/2 - 250/zoom, 400/zoom, 500/zoom, 'data/background2.png')
    dxDrawText('Farm', sx - 415/zoom, sy/2 - 240/zoom, nil, nil, white, 1, bold)
    dxDrawText('You own this farm', sx - 415/zoom, sy/2 - 215/zoom, nil, nil, tocolor(255,255,255,200), 1, regular)
    
    dxDrawText('Want to transfer farm?', sx - 230/zoom, sy/2 - 175/zoom, nil, nil, tocolor(255,255,255,200), 1, regular, 'center')
    dxDrawImage(sx - 410/zoom, sy/2 - 150/zoom, 360/zoom, 255/zoom, 'data/background2.png', 0, 0, 0, tocolor(0, 0, 0, 40))

    local nearbyPlayers = getNearbyPlayers(5)
    if #nearbyPlayers == 0 then
        dxDrawText('There are no any players nearby', sx - 230/zoom, sy/2 - 30/zoom, nil, nil, tocolor(255,255,255,100), 1, regular, 'center')
    else
        for i = 1, math.min(7, #nearbyPlayers) do
            local inside = isMouseInPosition(sx - 410/zoom, sy/2 - 150/zoom + (i-1)*37/zoom, 360/zoom, 33/zoom)
            dxDrawRectangle(sx - 410/zoom, sy/2 - 150/zoom + (i-1)*37/zoom, 360/zoom, 33/zoom, (selectedPlayer == i) and tocolor(255, 255, 255, 10) or (inside and tocolor(255, 255, 255, 5) or tocolor(0, 0, 0, 20)))
            dxDrawText(getPlayerName(nearbyPlayers[i]), sx - 400/zoom, sy/2 - 132/zoom + (i-1)*37/zoom, nil, nil, tocolor(255, 255, 255, 155), .9, regular, 'left', 'center')

            if inside and getKeyState('mouse1') then
                selectedPlayer = i
            end
        end
    end

    drawButton('Transfer', sx - 315/zoom, sy/2 + 120/zoom, 170/zoom, 35/zoom, regular)
    dxDrawRectangle(sx - 410/zoom, sy/2 + 172/zoom, 360/zoom, 2/zoom, tocolor(255, 255, 255, 10))

    drawButton('Enter', sx - 410/zoom, sy/2 + 190/zoom, 170/zoom, 35/zoom, regular)
    drawButton('Close', sx - 220/zoom, sy/2 + 190/zoom, 170/zoom, 35/zoom, regular)
end

function clickFarmInteraction(btn, state)
    local marker, data = getFarmMarker()
    if not marker then return clickFarmInteraction(false) end
    if btn ~= 'left' or state ~= 'down' then return end

    if isMouseInPosition(sx - 220/zoom, sy/2 + 190/zoom, 170/zoom, 35/zoom) then
        toggleFarmInteraction(false)
    elseif isMouseInPosition(sx - 410/zoom, sy/2 + 190/zoom, 170/zoom, 35/zoom) then
        local x, y, z = getElementPosition(localPlayer)
        setElementData(localPlayer, 'farm:exit', {x, y, z})
        triggerServerEvent('farm:enter', resourceRoot, data, marker)
        loadBarn(data)
        toggleFarmInteraction(false)
    elseif isMouseInPosition(sx - 315/zoom, sy/2 + 120/zoom, 170/zoom, 35/zoom) and selectedPlayer then
        local nearbyPlayers = getNearbyPlayers(5)
        local player = nearbyPlayers[selectedPlayer]
        if not player then return end
        showQuestionBox('Free farm', 'Are you sure you want to transferm this farm to ' .. getPlayerName(player) .. '?', 'Transfer', function()
            triggerServerEvent('farm:transfer', resourceRoot, data, marker, player)
        end)
    end
end

function toggleFarmInteraction(b)
    local eventCallback = b and addEventHandler or removeEventHandler

    selectedPlayer = false
    eventCallback('onClientRender', root, renderFarmInteraction)
    eventCallback('onClientClick', root, clickFarmInteraction)
    showCursor(b, false)
end

function renderUI()
    local marker, data = getFarmMarker()
    if not marker then return end

    dxDrawImage(sx/2 - 250/zoom, sy - 100/zoom, 500/zoom, 80/zoom, 'data/background.png')
    dxDrawImage(sx/2 - 235/zoom, sy - 85/zoom, 50/zoom, 50/zoom, 'data/barn.png')

    local bigText = 'Free farm'
    local smallText = 'Press #77ff77E #ffffffto buy farm - #77ff77$#ffffff' .. data.cost
    if data.owner then
        bigText = 'Farm'
        smallText = 'Owned by #77ff77' .. data.ownerName

        if data.owner == getElementData(localPlayer, 'player:sid') then
            smallText = smallText .. ' #ffffff- Press #77ff77E #ffffffto start interaction'
        end
    end

    dxDrawText(bigText, sx/2 - 170/zoom, sy - 57/zoom, nil, nil, white, 1, bold, 'left', 'bottom')
    dxDrawText(smallText, sx/2 - 170/zoom, sy - 57/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, regular, 'left', 'top', false, false, false, true)
end

bindKey("E", "down", function()
    local marker, data = getFarmMarker()
    if not marker then return end

    if not data.owner then
        showQuestionBox('Free farm', 'Are you sure you want to buy this farm for $' .. data.cost .. '?', 'Buy', function()
            triggerServerEvent('farm:buy', resourceRoot, data, marker)
        end)
    elseif data.owner == getElementData(localPlayer, 'player:sid') then
        toggleFarmInteraction(true)
    end
end)
addEventHandler('onClientRender', root, renderUI)