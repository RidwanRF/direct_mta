local airBreak = false

bindKey('x', 'down', function()
    if getAdmin(localPlayer) then
        airBreak = not airBreak
        local element = getPedOccupiedVehicle(localPlayer) or localPlayer
        setElementFrozen(element, airBreak)
        setElementCollisionsEnabled(element, not airBreak)
    end
end)

addEventHandler('onClientRender', root, function()
    if not airBreak then return end

    local element = getPedOccupiedVehicle(localPlayer) or localPlayer
    local x, y, z = getElementPosition(element)
    local rx, ry, rz = getElementRotation(getCamera())
    rz = rz + 90
    
    local speed = getKeyState('lctrl') and 8 or (getKeyState('lalt') and 0.5 or 2)
    if getKeyState('w') then
        x = x + math.cos(math.rad(rz)) * speed
        y = y + math.sin(math.rad(rz)) * speed
    elseif getKeyState('s') then
        x = x - math.cos(math.rad(rz)) * speed
        y = y - math.sin(math.rad(rz)) * speed
    end

    if getKeyState('d') then
        x = x + math.cos(math.rad(rz - 90)) * speed
        y = y + math.sin(math.rad(rz - 90)) * speed
    elseif getKeyState('a') then
        x = x + math.cos(math.rad(rz + 90)) * speed
        y = y + math.sin(math.rad(rz + 90)) * speed
    end

    if getKeyState('space') then
        z = z + speed
    elseif getKeyState('lshift') then
        z = z - speed
    end

    setElementPosition(element, x, y, z)
    setElementRotation(element, 0, 0, rz - 90, 'default', true)

    local rx, ry, rz = getElementRotation(element)
    dxDrawText(('%.3f, %.3f, %.3f\n%.3f, %.3f, %.3f'):format(x, y, z, rx, ry, rz), sx/2 + 1, sy - 110/zoom + 1, nil, nil, black, 1, getFigmaFont('Inter-Medium', 13/zoom), 'center', 'bottom')
    dxDrawText(('%.3f, %.3f, %.3f\n%.3f, %.3f, %.3f'):format(x, y, z, rx, ry, rz), sx/2, sy - 110/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', 13/zoom), 'center', 'bottom')
end)