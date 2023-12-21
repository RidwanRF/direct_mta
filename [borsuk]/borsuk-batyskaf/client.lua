local batyskaf = 493
local batyskafSpeed = 0
local _temp = createObject(2000, 0, 0, 0)
setElementAlpha(_temp, 0)

addEventHandler("onClientPreRender", root, function(dt)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or getElementModel(veh) ~= batyskaf then batyskafSpeed = 0 return end

    if getPedControlState(localPlayer, "accelerate") then
        batyskafSpeed = math.min(batyskafSpeed + 0.002*dt/3, 0.6)
    elseif getPedControlState(localPlayer, "brake_reverse") then
        batyskafSpeed = math.max(batyskafSpeed - 0.0015*dt/3, 0)
    else
        batyskafSpeed = math.max(batyskafSpeed - 0.001*dt/3, 0)
    end

    local rx, ry, rz = getElementRotation(veh)
    if getKeyState("arrow_d") then
        rx = rx+0.04*dt
    elseif getKeyState("arrow_u") then
        rx = rx-0.04*dt
    end
    if rx > 250 then
        rx = math.max(rx, 340)
    else
        rx = math.min(rx, 20)
    end
    setElementRotation(veh, rx, ry, rz)

    setPedOxygenLevel(localPlayer, 100)
    setElementRotation(_temp, rx, ry, rz)
    local x, y, z = getPositionFromElementOffset(_temp, 0, batyskafSpeed, 0)
    setElementVelocity(veh, x, y, z)

    local x, y, z = getElementPosition(veh)
    if z > 0 then
        z = 0
        setElementPosition(veh, x, y, z)
    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end