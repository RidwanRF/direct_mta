local h = dxGetFontHeight(1, getFigmaFont('Inter-Black', 18)) + dxGetFontHeight(1, getFigmaFont('Inter-Bold', 17))*2 + 5
local fh = dxGetFontHeight(1, getFigmaFont('Inter-Black', 18))
local aspectRatio = 400/h
local rt = dxCreateRenderTarget(400, h, true)
local lastScooter = false
local lastRenderTargetUpdate = getTickCount()
local black = tocolor(0, 0, 0, 255)
local serverTick = {
    start = 0,
    startClient = getTickCount(),
}

setmetatable(serverTick, {
    __index = function(self, key)
        if key == 'current' then
            return self.start + (getTickCount() - self.startClient)
        end
    end
})

function renderUI()
	dxDrawImage(sx/2 - 170/zoom, sy/2 - 75/zoom, 340/zoom, 150/zoom, 'data/background.png')

    local isNew = (getElementData(localPlayer, 'player:hours') or 0) < 120 and ' (dostępne)' or ''
    local inside = isMouseInPosition(sx/2 - 79/zoom, sy/2 + 28/zoom, 158/zoom, 26/zoom)
	dxDrawImage(sx/2 - 79/zoom, sy/2 + 33/zoom, 158/zoom, 26/zoom, 'data/button.png', 0, 0, 0, tocolor(255, 255, 255, inside and 255 or 200))
	dxDrawText('Wynajmowanie hulajnogi', sx/2, sy/2 - 55/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Bold', 11/zoom), 'center', 'center')
	dxDrawText('Koszt wypożyczenia hulajnogi wynosi\n#5BF157$4 za minutę#ffffff, wypożyczalnia jest\n#FFA800darmowa#ffffff dla graczy poniżej #FFA8002 godzin gry'..isNew..'\n#ff3333Hulajnogę można zwrócić tylko w punkcie!', sx/2, sy/2 - 9/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, getFigmaFont('Inter-Medium', 9/zoom), 'center', 'center', false, false, false, true)
	
    local rented = getElementData(localPlayer, 'scooter:rented')
    dxDrawText(rented and 'Zwróć' or 'Wypożycz', sx/2 - 1/zoom, sy/2 + 46.5/zoom, nil, nil, tocolor(255, 255, 255, inside and 255 or 200), 1, getFigmaFont('Inter-Medium', 8/zoom), 'center', 'center')
end

function clickUI(button, state)
    if button ~= 'left' or state ~= 'down' then return end
    
    if isMouseInPosition(sx/2 - 79/zoom, sy/2 + 28/zoom, 158/zoom, 26/zoom) then
        if getElementData(localPlayer, 'player:job') then return exports['borsuk-notyfikacje']:addNotification('error', 'Wypożyczalnia', 'Nie możesz wypożyczyć hulajnogi będąc w pracy!') end
        triggerServerEvent('scooter:rent', resourceRoot)
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, clickUI)
    showCursor(visible, false)
end

addEventHandler('onClientColShapeHit', resourceRoot, function(element)
    if element ~= localPlayer or not getElementData(source, 'scooter:rental') or getPedOccupiedVehicle(localPlayer) then return end
    toggleUI(true)
end)

addEventHandler('onClientColShapeLeave', resourceRoot, function(element)
    if element ~= localPlayer or not getElementData(source, 'scooter:rental') then return end
    toggleUI(false)
end)

bindKey('H', 'down', function()
    local rented = getElementData(localPlayer, 'scooter:rented')
    if not rented then return end
    if not isPedOnGround(localPlayer) then return end

    if getElementType(rented) == 'object' then
        triggerServerEvent('scooter:fold', resourceRoot)
    elseif not getPedOccupiedVehicle(localPlayer) and getDistanceBetweenPoints3D(Vector3(getElementPosition(rented)), Vector3(getElementPosition(localPlayer))) < 2 then
        triggerServerEvent('scooter:fold', resourceRoot)
    end
end)

addEventHandler('onClientVehicleStartEnter', root, function(player, seat)
	local rented = getElementData(localPlayer, 'scooter:rented')
    if not rented then return end
    if getElementType(rented) == 'object' and player == localPlayer then return cancelEvent() end
end)

function updateRenderTarget(scooter)
    lastRenderTargetUpdate = getTickCount() + 1000

    dxSetRenderTarget(rt, true)
    -- dxDrawRectangle(0, 0, 400, h, tocolor(255, 255, 255, 255))

    dxDrawText('HULAJNOGA ELEKTRYCZNA', 203, fh + 3, nil, nil, black, 1, getFigmaFont('Inter-Black', 18), 'center', 'bottom')
    dxDrawText('HULAJNOGA ELEKTRYCZNA', 200, fh, nil, nil, white, 1, getFigmaFont('Inter-Black', 18), 'center', 'bottom')

    local time = getElementData(scooter, 'scooter:rented:time')
    local seconds = (serverTick.current - time)/1000
    local minutes = math.floor(seconds/60)
    local seconds = math.floor(seconds - minutes*60)
    local hours = math.floor(minutes/60)
    local minutes = math.floor(minutes - hours*60)
    local owner = getElementData(scooter, 'scooter:owner')
    dxDrawText(('Czas wynajmu: %02d:%02d\nWłaściciel: %s'):format(minutes, seconds, getPlayerName(owner)), 202, fh + 2, nil, nil, black, 1, getFigmaFont('Inter-Bold', 17), 'center', 'top')
    dxDrawText(('Czas wynajmu: #FFA800' .. (hours > 0 and ('%02d:'):format(hours) or '') .. '%02d:%02d\n#ffffffWłaściciel: #FFA800%s'):format(minutes, seconds, getPlayerName(owner)), 200, fh, nil, nil, white, 1, getFigmaFont('Inter-Bold', 17), 'center', 'top', false, false, false, true)
    dxSetRenderTarget()
end

addEventHandler('onClientRender', root, function()
    local rented = getElementData(localPlayer, 'scooter:rented')
    if not rented or not isElement(rented) then return end

    local px, py, pz = getCameraMatrix()
    local x, y, z = getElementPosition(rented)
    local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
    if distance > 20 then
        x, y = getScreenFromWorldPosition(x, y, z)
        if x and y then
            dxDrawImage(x - 15/zoom, y - 15/zoom, 30/zoom, 30/zoom, 'data/my-scooter.png')
        end
    end

    -- foreach all colspheres with elementdata scooter:rental and draw image data/rent-point.png
    for k,v in pairs(getElementsByType('colshape', resourceRoot)) do
        if getElementData(v, 'scooter:rental') then
            local x, y, z = getElementPosition(v)
            local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
            if distance > 20 then
                x, y = getScreenFromWorldPosition(x, y, z)
                if x and y then
                    local size = distance < 200 and 30/zoom or 15/zoom
                    dxDrawImage(x - size/2, y - size/2, size, size, 'data/rent-point.png')
                end
            end
        end
    end
end)

addEventHandler('onClientPreRender', root, function()
    local nearest = {false, 20}
    local px, py, pz = getCameraMatrix()

    for k,v in pairs(getElementsWithinRange(px, py, pz, 20, 'vehicle')) do
        local owner = getElementData(v, 'scooter:owner')
        if owner then
            local x, y, z = getElementPosition(v)
            local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
            if distance < nearest[2] then
                nearest = {v, distance}
            end
        end
    end

    if nearest[1] ~= false then
        if lastScooter ~= nearest[1] or lastRenderTargetUpdate < getTickCount() then
            updateRenderTarget(nearest[1])
        end

        local alpha = (1-nearest[2]/20)*255
        local x, y, z = getPositionFromElementOffset(nearest[1], 0, -0.5, -0.3)
        local lx, ly, lz = getPositionFromElementOffset(nearest[1], 0, -1, -0.3)
        dxDrawMaterialLine3D(x, y, z + 1.2 / aspectRatio, x, y, z, rt, 1.2, tocolor(255, 255, 255, alpha), lx, ly, lz)
    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

addEventHandler('onClientVehicleExit', root, function(player)
    if player ~= localPlayer then return end
    if getElementData(source, 'scooter:owner') ~= localPlayer then return end
    exports['borsuk-notyfikacje']:addNotification('warning', 'Wynajem hulajnogi', 'Pamiętaj, że musisz zwrócić hulajnogę do miejsca wynajmu, aby przestać płacić za wynajem')
end)

triggerServerEvent('scooter:fetchTickCount', resourceRoot)

addEvent('scooter:fetchTickCount', true)
addEventHandler('scooter:fetchTickCount', resourceRoot, function(tick)
	serverTick.start = tick
    serverTick.startClient = getTickCount()
end)

setElementData(localPlayer, 'scooter:rented', false)
-- triggerServerEvent('scooter:rent', resourceRoot)