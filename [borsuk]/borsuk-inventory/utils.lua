sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
bold = dxCreateFont('data/Inter-Bold.ttf', 17/zoom)
regular = dxCreateFont('data/Inter-Medium.ttf', 17/zoom)
regular2 = dxCreateFont('data/Inter-Medium.ttf', 14/zoom)
regular3 = dxCreateFont('data/Inter-Medium.ttf', 13/zoom)
regular4 = dxCreateFont('data/Inter-Medium.ttf', 12/zoom)
regular5 = dxCreateFont('data/Inter-Medium.ttf', 15/zoom)
bold = dxCreateFont('data/Inter-Bold.ttf', 14/zoom)
bold2 = dxCreateFont('data/Inter-Bold.ttf', 15/zoom)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function drawScrollbar(x, y, height, max, visibleCount, pos)
    dxDrawRectangle(x, y, 4, height, tocolor(65, 65, 65, 155))

	local scrollHeight = visibleCount / max
	local progress = pos / (max - visibleCount)
	if scrollHeight > 1 then return end
	if scrollHeight ~= scrollHeight then return end
	if progress ~= progress then return end
	dxDrawRectangle(x, y + (height * (1-scrollHeight)) * progress, 4, height * scrollHeight, tocolor(119, 119, 119))
end

function drawButton(text, x, y, w, h, font, color, colorInactive, textColor)
    local inside = isMouseInPosition(x, y, w, h)
    dxDrawImage(x, y, w, h, 'data/button.png', 0, 0, 0, inside and color or colorInactive)
    dxDrawText(text, x + w/2, y + h/2, nil, nil, inside and 0xFFFFFFFF or (textColor or 0x88FFFFFF), 1, font, 'center', 'center')
end

function rgbToHex(r, g, b)
    -- Ensure the RGB values are within the valid range (0-255)
    r, g, b = math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b))
    
    -- Convert each component to a two-digit hexadecimal string
    local hexString = string.format("#%02X%02X%02X", r, g, b)
    return hexString
end