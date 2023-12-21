local font = getFigmaFont('Inter-Medium', 18/zoom)

addEventHandler("onClientRender", root, function()
	local x, y, z = getCameraMatrix()
	local dimension = getElementDimension(localPlayer)
	local interior = getElementInterior(localPlayer)

	for k,v in pairs(getElementsByType('text')) do
		if dimension == getElementDimension(v) and interior == getElementInterior(v) then
			local dist = getDistanceBetweenPoints3D(x, y, z, getElementPosition(v))
			if dist < 20 then
				local sx, sy = getScreenFromWorldPosition(getElementPosition(v))
				if sx and sy then
					local name = getElementData(v, 'name')
					if name then
						if isLineOfSightClear(x, y, z, getElementPosition(v)) then
							dxDrawText(name:gsub("#%x%x%x%x%x%x",""), sx + 1, sy + 1, sx + 1, sy + 1, tocolor(0,0,0,255), 1-dist/20, font, "center", "center", false)
							dxDrawText(name, sx, sy, sx, sy, tocolor(255,255,255,255), 1-dist/20, font, "center", "center", false)
						end
					end
				end
			end
		end
	end
end)