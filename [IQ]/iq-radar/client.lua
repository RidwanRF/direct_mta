sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.95
    font1 = exports["borsuk-gui"]:getFont("Roboto", 15/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 12/zoom, false)
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function drawLine(x, y, tx, ty, color, width)
    local angle = findRotation(x, y, tx, ty)
    local dist = getDistanceBetweenPoints2D(x, y, tx, ty)
    local w, h = dist, width
    dxDrawImage(x, y-h/2, w, h, 'data/rectangle.png', angle+90, -w/2, 0, color)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)
local font = dxCreateFont("data/font.ttf", 16/zoom)
local hudMaskShader = dxCreateShader("data/hud_mask.fx")
local radarTexture = dxCreateTexture("data/world.png")
local radarRT = dxCreateRenderTarget(2048, 2048, true)
local maskTexture1 = dxCreateTexture("data/circle_mask.png")
dxSetShaderValue(hudMaskShader, "sPicTexture", radarRT)
dxSetShaderValue(hudMaskShader, "sMaskTexture", maskTexture1)
local lastGPS = ""

function getMapPositionFromWorld(x, y, w, h)
	return (x+3000)/6000*w, (3000-y)/6000*h
end

function updateRadarTexture()
	dxSetRenderTarget(radarRT, true)
	dxDrawImage(0, 0, 2048, 2048, radarTexture)

	for k,v in pairs(getElementsByType("radararea")) do
		local x, y = getElementPosition(v)
		local w, h = getRadarAreaSize(v)
		local dim = getElementDimension(v)
		local int = getElementInterior(v)

		if getElementDimension(localPlayer) == dim and getElementInterior(localPlayer) == int then
			local x, y = getMapPositionFromWorld(x, y, 2048, 2048)
			w, h = w * (2048/6000), h * (2048/6000)
			local r, g, b = getRadarAreaColor(v)
			dxDrawRectangle(x, y, w, -h, tocolor(r, g, b, 155))
		end
	end

	if GPS and GPS.road then
        if #GPS.road > 0 then
            for i = #GPS.road, 1, -1 do
                if (GPS.road[i + 1] ~= nil) then
                    local x, y = getMapPositionFromWorld(GPS.road[i].posX, GPS.road[i].posY, 2048, 2048)
                    local ex, ey = getMapPositionFromWorld(GPS.road[i + 1].posX, GPS.road[i + 1].posY, 2048, 2048)
                    drawLine(x, y, ex, ey, tocolor(255, 143, 95, 255), 6)
                end
            end
        end
    end

	dxSetRenderTarget()
end

updateRadarTexture()
setTimer(updateRadarTexture, 500, 0)

addEventHandler("onClientRestore", root, updateRadarTexture)

function renderCrosshair()
	local weap = getPedWeapon(localPlayer)
	if true then
		local hX, hY, hZ = getPedTargetEnd(localPlayer)
		local screen1, screen2 = getScreenFromWorldPosition(hX,hY,hZ)
		if (screen1 and screen2) then
			dxDrawImage(screen1-15/zoom/2, screen2-15/zoom/2, 15/zoom, 15/zoom, "data/crosshair.png")
		end
	end
end

function isPedAiming (thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end


local blipSize = 35/zoom
addEventHandler("onClientRender", root, function()
	if not getElementData(localPlayer, "player:spawn") or getElementData(localPlayer, "player:hudof") or getElementData(localPlayer, "player:radaroff") then return end
	setPlayerHudComponentVisible("radar", false)
	setPlayerHudComponentVisible("crosshair", false)

	if isPedAiming(localPlayer) and getKeyState("mouse2") then
		renderCrosshair()
	end

	local px,py,pz = getElementPosition(localPlayer)
	local street = getZoneName(px, py, pz)
	local city = getZoneName(px, py, pz, true)
	local x = (px) / 6000
	local y = (py) / -6000
	local speedZoom = 1

	if getPedOccupiedVehicle(localPlayer) then
		speedZoom = 1+getElementSpeed(getPedOccupiedVehicle(localPlayer), 'km/h')/1000
	else
		speedZoom = 1
	end
	speedZoom = math.min(math.max(speedZoom, 1), 1.35)

	dxSetShaderValue(hudMaskShader, "gUVPosition", x, y)
	dxSetShaderValue(hudMaskShader, "gUVScale", 0.1*speedZoom, 0.1*speedZoom)

	if GPS and GPS.road and #GPS.road ~= lastGPS then
		updateRadarTexture()
		lastGPS = #GPS.road
	end

	local _,_,camrot = getElementRotation(getCamera())
	dxSetShaderValue(hudMaskShader, "gUVRotAngle", math.rad(-camrot))

	local shaders = getElementData(localPlayer, 'player:shaders') or {}
	if shaders['actualhud'] then offset = 50/zoom else offset = 0 end

	--dxDrawImage(65/zoom, sy - 375/zoom + offset, 300/zoom, 300/zoom, "data/circle_mask.png", 0, 0, 0, tocolor(255,255,255,200))
	exports['iq-blur']:dxDrawBlur(22/zoom, sy - 328/zoom + offset, 307/zoom, 307/zoom, maskTexture1)
	dxDrawImage(22/zoom, sy - 328/zoom + offset, 307/zoom, 307/zoom, "data/bg.png", 0, 0, 0, tocolor(255,255,255,125))
	dxDrawImage(25/zoom, sy - 325/zoom + offset, 300/zoom, 300/zoom, hudMaskShader, 0,0,0, tocolor(255,255,255,245))

	local blips = getElementsByType("blip")
	-- first draw blips with icon 29!! others draw later
	table.sort(blips, function(a, b)
		local aIcon = getBlipIcon(a)
		local bIcon = getBlipIcon(b)
		if aIcon == 29 and bIcon ~= 29 then
			return true
		elseif aIcon ~= 29 and bIcon == 29 then
			return false
		else
			return false
		end
	end)
	for k,v in pairs(blips) do
		local bx, by, bz = getElementPosition(v)
		local dist = getDistanceBetweenPoints2D(px, py, bx, by)/zoom/(2*speedZoom)
		local rot = math.atan2(bx - px, by - py) + math.rad(camrot)
		local r, g, b = getBlipColor(v)
		local blipIcon = getBlipIcon(v)
		local playerBlip = getElementData(v, "player:blip")
		local dim = getElementDimension(v)
		local int = getElementInterior(v)

		if getElementDimension(localPlayer) == dim and getElementInterior(localPlayer) == int then
			if blipIcon == 1 then
				if dist >= 140/zoom then dist = math.max(140/zoom, 1) end
	
				local x, y = 160/zoom + math.sin(rot) * dist, sy - 153/zoom + offset - math.cos(rot) * dist
	
				dxDrawImage(x - 1/zoom, y - 40/zoom, blipSize, blipSize + 5/zoom, "data/blips/" .. blipIcon .. ".png", 0, 0, 0, tocolor(255, 255, 255))
			elseif blipIcon == 0 then
				if playerBlip ~= localPlayer then
					if 300 >= dist then
						if dist >= 140/zoom then dist = math.max(140/zoom, 1) end
	
						local x, y = 160/zoom + math.sin(rot) * dist, sy - 153/zoom + offset - math.cos(rot) * dist
	
						dxDrawImage(x - 1/zoom, y - 40/zoom, blipSize, blipSize + 5/zoom, "data/blips/" .. blipIcon .. ".png", 0, 0, 0, tocolor(255, 255, 255))
					end
				end
			else
				if 180 >= dist then
					if dist >= 140/zoom then dist = math.max(140/zoom, 1) end
	
					local x, y = 160/zoom + math.sin(rot) * dist, sy - 153/zoom + offset - math.cos(rot) * dist
	
					if blipIcon ~= 1 then
						dxDrawImage(x - 1/zoom, y - 42.5/zoom, blipSize, blipSize + 5/zoom, "data/blips/" .. blipIcon .. ".png", 0, 0, 0)
					end
				end
			end
		end
	end

	local x, y = 160/zoom, sy - 153/zoom + offset
	local _,_,rz = getElementRotation(localPlayer)
	dxDrawImage(x + 5/zoom, y - 35/zoom, 20/zoom, 20/zoom, "data/player.png", camrot - rz)
	

	local x,y,z = getElementPosition(localPlayer)
	local street = getZoneName(x,y,z, false)
    local street2 = getZoneName(x,y,z, true)

	if getElementInterior(localPlayer) == 0 then
		dxDrawText(street2, 315/zoom, sy - 70/zoom + offset, nil, nil, tocolor(255, 255, 255, 225), 1, font1, 'left', 'bottom')
		dxDrawText(street, 305/zoom, sy - 72/zoom + offset, nil, nil, tocolor(225, 225, 225, 225), 1, font2, 'left', 'top')
	end	
end)

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end