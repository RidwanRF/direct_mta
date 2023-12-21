zoom = exports["borsuk-gui"]:getZoom()

addEventHandler("onGUISizeChanged", root, function(s)
    zoom = s
end)

hoverTexture = dxCreateTexture("data/button_hover.png", "argb", false, "clamp")

gui = {
    dt = 1,
    buttons = {},
    editboxes = {},
}

addEventHandler("onClientPreRender", root, function(dt) gui.dt = (100/dt) end)

function findFreeValue(t)
    for i = 1, 1000 do
        if not t[i] then return i end
    end
    return false
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