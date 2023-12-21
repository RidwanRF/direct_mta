local sx, sy = guiGetScreenSize()

local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function getInterfaceZoom()
	return zoom
end