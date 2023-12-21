local lines = {}
local line = dxCreateTexture("data/line.png")
local dt = 0
local tronGod = false
local lastTron = 0

addEventHandler("onClientPreRender", root, function(e)
    dt = e
end)

function getElementSpeed(el)
    return Vector3(getElementVelocity(el)).length
end

function loseTron()
    if lastTron > getTickCount() then return end
    triggerServerEvent("przegralemWTron", getPedOccupiedVehicle(localPlayer))
    tronGod = true
    lastTron = getTickCount()+1000
    setElementData(localPlayer, "player:event:lost", true)
    setElementData(localPlayer, "player:event", false)
    setPedCanBeKnockedOffBike(localPlayer, true)
end

addEventHandler("onClientPlayerDamage", root, function()
    if source ~= localPlayer or not tronGod then return end
    cancelEvent()
end)

function updateTron()
    setPedCanBeKnockedOffBike(localPlayer, false)
    for k,v in pairs(stillPlaying()) do
        local veh = getPedOccupiedVehicle(v)
        if veh then
            local x, y, z = getElementPosition(veh)
            --dxDrawLine3D(x, y, z, x, y, z + 1, tocolor(255,0,0))

            if not lines[veh] then
                lines[veh] = {
                    last = 0,
                    draw = {},
                    color = getElementData(v, "player:event:color")
                }
            end

            if lines[veh].last < getTickCount() then
                lines[veh].last = getTickCount()+250
                table.insert(lines[veh].draw, {
                    x=x,
                    y=y,
                    z=z,
                    alpha = 255,
                })
            end
        end
    end

    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    px, py, pz = getElementPosition(veh)
    if pz > 1045 then
        pz = 1045
    end
    setElementPosition(veh, px, py, pz)

    setElementHealth(veh,10000)
    
    if getElementSpeed(veh) < 0.1 then
        local _, _, rot = getElementRotation(veh)
        local vx, vy = getPointFromDistanceRotation(0, 0, 0.1, -rot)
        setElementVelocity(veh, vx, vy, 0)
    end

    local px, py, pz = getElementPosition(veh)
    for d,c in pairs(lines) do
        if d and isElement(d) then
            local x, y, z = false, false, false
            for k,v in pairs(c.draw) do
                if x and y and z and px and py and pz and v.x and v.y and v.z then
                    local mx, my, mz = (x + v.x)/2, (y + v.y)/2, (z + v.z)/2
                    local rot = findRotation(mx, my, v.x, v.y)
                    local mx, my = getPointFromDistanceRotation(mx, my, 1, rot+90)
                    dxDrawMaterialLine3D(x, y, z, v.x, v.y, v.z, line, 0.3, tocolor(c.color[1],c.color[2],c.color[3],v.alpha), false, mx, my, mz)

                    if (getDistanceBetweenPointAndSegment3D(px, py, pz, x, y, z, v.x, v.y, v.z) or 1) < 0.2 and v.alpha < 250 then
                        loseTron()
                    end
                end
                x, y, z = v.x, v.y, v.z
                v.alpha = v.alpha - dt/10
                if v.alpha <= 0 then
                    table.remove(c.draw, k)
                end
            end

            local vx, vy, vz = getElementPosition(d)
            if x then
                local mx, my, mz = (x + vx)/2, (y + vy)/2, (z + vz)/2
                local rot = findRotation(mx, my, vx, vy)
                local mx, my = getPointFromDistanceRotation(mx, my, 1, rot+90)
                dxDrawMaterialLine3D(x, y, z, vx, vy, vz, line, 0.3, tocolor(c.color[1],c.color[2],c.color[3],255), false, mx, my, mz)
            end
        end
    end
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy
end

function getDistanceBetweenPointAndSegment3D(pointX, pointY, pointZ, x1, y1, z1, x2, y2, z2)

	local A = pointX - x1 
	local B = pointY - y1
	local C = pointZ - z1
	--

	local D = x2 - x1
	local E = y2 - y1
	local F = z2 - z1
	--
	local point = A * D + B * E + C * F
	local lenSquare = D * D + E * E + F * F
	local parameter = point / lenSquare
 
	local shortestX
	local shortestY
	local shortestZ
 
	if parameter < 0 then
		shortestX = x1
    	shortestY = y1
		shortestZ = z1
	elseif parameter > 1 then
		shortestX = x2
		shortestY = y2
		shortestZ = z2

	else
		shortestX = x1 + parameter * D
		shortestY = y1 + parameter * E
		shortestZ = z1 + parameter * F
	end

	local distance = getDistanceBetweenPoints3D(pointX, pointY,pointZ, shortestX, shortestY,shortestZ)
	--
 
	return distance
end