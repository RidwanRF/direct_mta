function fromcolor(color)
	if color then
		local blue = bitExtract(color, 0, 8)
		local green = bitExtract(color, 8, 8)
		local red = bitExtract(color, 16, 8)
		local alpha = bitExtract(color, 24, 8)
		
		return { red, green, blue, alpha }
	end
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

if localPlayer then
    local figmaFonts = {}
    sx, sy = guiGetScreenSize()
    zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

    function getFigmaFont(font, size)
        if not figmaFonts[font..size] then
            figmaFonts[font..size] = exports['figma']:getFont(font, size)
        end

        return figmaFonts[font..size]
    end

    black = 0xFF000000

    function isMouseInPosition ( x, y, width, height )
        if ( not isCursorShowing( ) ) then
            return false
        end
        local sx, sy = guiGetScreenSize ( )
        local cx, cy = getCursorPosition ( )
        local cx, cy = ( cx * sx ), ( cy * sy )
        
        return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
    end
end