sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
bold = dxCreateFont('data/Inter-Bold.ttf', 17/zoom)
regular = dxCreateFont('data/Inter-Regular.ttf', 14/zoom)
regularSmall = dxCreateFont('data/Inter-Regular.ttf', 11/zoom)
local textures = {}

function getTexture(name)
    if textures[name] then return textures[name] end
    textures[name] = dxCreateTexture('data/' .. name .. '.png')
    return textures[name]
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function findClosestElement(x, y, z, type, condition, dist)
    local element = {false, dist or 100}
    for k,v in pairs(getElementsWithinRange(x, y, z, dist or 100, type)) do
        local dist = getDistanceBetweenPoints3D(Vector3(x, y, z), Vector3(getElementPosition(v)))
        if dist < element[2] and condition(v) then
            element = {v, dist}
        end
    end
    return element[1]
end

function drawButton(text, x, y, w, h, font)
    local inside = isMouseInPosition(x, y, w, h)
    dxDrawImage(x, y, w, h, inside and 'data/button-active.png' or 'data/button.png')
    dxDrawText(text, x + w/2, y + h/2, nil, nil, inside and 0xFFFFFFFF or 0x55FFFFFF, 1, font, 'center', 'center')
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function getNearbyPlayers(dist)
    local x, y, z = getElementPosition(localPlayer)
    local t = {}
    for k,v in pairs(getElementsWithinRange(x, y, z, dist, 'player')) do
        if v ~= localPlayer then table.insert(t, v) end
    end
    return t
end