local screenW, screenH = guiGetScreenSize()
-- pozycje 
local baseX = 2048
zoom = 1 
local selectedBlip = false
local minZoom = 2.2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 
local mapPos = {x=351/zoom + 50/zoom, y=0, w=sx - 351/zoom + 30/zoom, h=sy}
zoom = zoom * 0.9
local showing = false 
local textures = {}
local playerX, playerY = 0, 0
local sW, sH = guiGetScreenSize()

local mapUnit = 2048/6000 -- rozmiar mapki / 6000
local mapZoom = 2
local mapIsMoving, mapOffsetX, mapOffsetY = false, 0, 0
local wasMapMoved = true 

local guiInfo = {

	pos = {x = 0, y = 0},
	selected = false,

}

local blipOptions = {
	-- return false: znika menu, true: nie znika
	{
		name = 'Nawiguj',
		use = function(blip)
			local x, y = getElementPosition(blip)
			exports['iq-radar']:findBestWay(x, y)
			exports['borsuk-notyfikacje']:addNotification('success', 'Nawigacja', 'Ustawiono trasę GPS!', 6000);
			return false
		end
	},
	-- {
	-- 	name = 'Następny',
	-- 	use = function(blip) end
	-- },
	-- {
	-- 	name = 'Następny',
	-- 	use = function(blip) end
	-- },
	-- {
	-- 	name = 'Następny',
	-- 	use = function(blip) end
	-- },
	-- {
	-- 	name = 'Następny',
	-- 	use = function(blip) end
	-- },
}

-- nazwy tekstur z radar_c.lua
local blips = {
	-- [id blipu z gta] = dane
	[0] = {name="Gracz", texture="player"},
	[1] = {name="Pojazd", texture="radar_gangB"},
	[45] = {name="Przebieralnia", texture="radar_tshirt"},
	[35] = {name="Przechowalnia", texture="radar_saveGame"},
	[55] = {name="Salon pojazdów / Giełda", texture="radar_impound"},
	[30] = {name="San Andreas Police Department", texture="radar_police"},
	[11] = {name="San Andreas Road Assistance", texture="radar_bulldozer"},
	[22] = {name="San Andreas Medical Center", texture="radar_hostpital"},
	[36] = {name="Szkoła jazdy", texture="radar_school"},
	[27] = {name="Mechanik", texture="radar_modGarage"},
	[39] = {name="Urząd miasta", texture="radar_tattoo"},
	[56] = {name="Stacja benzynowa", texture="radar_light"},
	[46] = {name="Praca dorywcza", texture="radar_WOOZIE"},
	[52] = {name="Bankomat", texture="radar_cash"},
	[23] = {name="Tuner / Stacja diagnostyczna", texture="radar_LocoSyndicate"},
	[29] = {name="Wynajem hulajnóg", texture="scooter"},
	
}

local main = {
    ['textures'] = {},
    ['fonts'] = {},
    ['toggle'] = false,
    ['colors'] = {
        {
            name = 'Twoja lokalizacja',
            icon = 'my_locate',
            color = {255,255,255}
        },
        {
            name = 'Gracz',
            icon = 'circle',
            color = {255,255,255}
        },
        {
            name = 'Twój znajomy',
            icon = 'circle',
            color = {90,187,133}
        },
        {
            name = 'San Andreas Police Department',
            icon = 'circle',
            color = {99,186,215}
        },
        {
            name = 'San Andreas Road Assistance',
            icon = 'circle',
            color = {215,170,99}
        },
        {
            name = 'San Andreas Medical Center',
            icon = 'circle',
            color = {253,157,255}
        },
        {
            name = 'Transport of San Andreas',
            icon = 'circle',
            color = {215,208,99}
        },
        {
            name = 'San Andreas Fire Department',
            icon = 'circle',
            color = {215,99,99}
        }
    }
}

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function drawLine(x, y, tx, ty, color, width)
    local angle = findRotation(x, y, tx, ty)
    local dist = getDistanceBetweenPoints2D(x, y, tx, ty)
    local w, h = dist, width
    dxDrawImage(x, y-h/2, w, h, 'images/rectangle.png', angle+90, -w/2, 0, color)
end

local blipSize = 30/zoom

local memoryButton = nil 
local memoryCheckbox = false 
local blipsNames = {}
local target = false

function setMapTarget(x, y)
	target = {x, y}
end

function renderBigMap()	
	if not wasMapMoved then 
		playerX, playerY = getElementPosition(localPlayer)
	end 
	
	local absoluteX, absoluteY = 0, 0
	local cursorX, cursorY = getCursorPosition()

	if target then
		playerX = playerX + (target[1] - playerX) / 20
		playerY = playerY + (target[2] - playerY) / 20
	end
			
	if (getKeyState('mouse1')) and mapIsMoving then
		target = false

		absoluteX = (cursorX * screenW)
		absoluteY = (cursorY * screenH)
		
		playerX = -(absoluteX * mapZoom / mapUnit - mapOffsetX)
		playerY = (absoluteY * mapZoom / mapUnit - mapOffsetY)
						
		playerX = math.max(-3000, math.min(3000, playerX))
		playerY = math.max(-3000, math.min(3000, playerY))
	end

	local mapX = (((3000 + playerX) * mapUnit) - (mapPos.w / 2) * mapZoom)
	local mapY = (((3000 - playerY) * mapUnit) - (mapPos.h / 2) * mapZoom)
	local mapWidth, mapHeight = mapPos.w * mapZoom, mapPos.h * mapZoom
	local offset = 0


	--dxDrawRectangleLined(mapPos.x, mapPos.y, mapPos.w, mapPos.h, tocolor(125, 125, 125, 255), 1)
	exports['iq-blur']:dxDrawBlur(0, 0, sx, sy, 200)
    dxDrawImage(0,0,sx,sy,main['textures']['bg'])
    dxDrawImage(0,0,351/zoom,sy,main['textures']['left_panel'])
    dxDrawImage(0,85/zoom,351/zoom,3/zoom,main['textures']['header_line'])
    dxDrawText('MAPA SERWERA', 0 + 351/2/zoom, 17/zoom, nil, (17/zoom) + (32/zoom), tocolor(215, 215, 215, 255), 1, main['fonts'][1], 'center', 'top')
    dxDrawText('Legenda mapy', 0 + 351/2/zoom, 43/zoom, nil, (43/zoom) + (26/zoom), tocolor(215, 215, 215, 255), 1, main['fonts'][2], 'center', 'top')
    -- dxDrawImage(335/zoom, 98/zoom, 4.000000000000057/zoom, 595/zoom, main['textures']['scroll'])
    -- dxDrawImage(334/zoom, 98/zoom, 6/zoom, 50/zoom, main['textures']['scroll2'])
    local offset = 0
    for i,v in pairs(blips) do
        offset = offset + 40/zoom
		local inside = isMouseIn(20/zoom, 98/zoom - 40/zoom + offset, 311/zoom, 35/zoom)
        dxDrawImage(20/zoom, 98/zoom - 40/zoom + offset, 311/zoom, 35/zoom, main['textures']['blip_bg'], 0, 0, 0, inside and 0xFFFFFFFF or 0xFFAFAFAF)
        dxDrawImage(28/zoom, 104/zoom - 40/zoom + offset, 20/zoom, 23/zoom, "images/radar/blips/"..v.texture..".png")
        dxDrawText(v.name,58/zoom, 104/zoom - 40/zoom + offset + 25/2/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, main['fonts'][3], 'left', 'center')
    end
    dxDrawImage(0,110/zoom + offset,351/zoom,3/zoom,main['textures']['header_line'])
    dxDrawText('Kolory graczy na mapie',0 + 351/2/zoom, 120/zoom + offset, nil, (711/zoom) + (26/zoom),tocolor(215, 215, 215, 255),1,main['fonts'][2],'center','top')
    for i,v in pairs(main['colors']) do
        offset = offset + 30/zoom
        dxDrawImage(20/zoom,120/zoom + offset, 311/zoom, 25/zoom, main['textures']['colors_bg'])
        dxDrawImage(20/zoom + 15/zoom/2,120/zoom + offset + 25/zoom/2 - 15/zoom/2, 15/zoom, 15/zoom, main['textures'][v.icon],0,0,0,tocolor(unpack(v.color)))
        dxDrawText(v.name, 42/zoom + 15/zoom/2,120/zoom + offset + 25/zoom/2 - 15/zoom/2 + 18/zoom/2, nil, nil, tocolor(255, 255, 255, 191),1,main['fonts'][3],'left','center')
    end
	dxDrawImageSection(mapPos.x, mapPos.y, mapPos.w, mapPos.h, mapX, mapY, mapWidth, mapHeight, textures.map, 0, 0, 0, tocolor(255, 255, 255, 255)) -- mapka

	local GPS = exports["iq-radar"]:getGPS()

	local startRGB = {255, 192, 98}
	local endRGB = {255, 143, 95}
	if GPS and GPS.road then
        if #GPS.road > 0 then
            for i = #GPS.road, 1, -1 do
                if (GPS.road[i + 1] ~= nil) then
                    local x, y = getMapFromWorldPosition(GPS.road[i].posX, GPS.road[i].posY)
                    local ex, ey = getMapFromWorldPosition(GPS.road[i + 1].posX, GPS.road[i + 1].posY)
					if (x > mapPos.x or ex > mapPos.x) and (x < mapPos.x + mapPos.w or ex < mapPos.x + mapPos.w) and (y > mapPos.y or ey > mapPos.y) and (y < mapPos.y + mapPos.h or ey < mapPos.y + mapPos.h) then
						x = math.min(math.max(x, mapPos.x), mapPos.x + mapPos.w)
						ex = math.min(math.max(ex, mapPos.x), mapPos.x + mapPos.w)
						y = math.min(math.max(y, mapPos.y), mapPos.y + mapPos.h)
						ey = math.min(math.max(ey, mapPos.y), mapPos.y + mapPos.h)

						local prg = (i / #GPS.road)
						local r, g, b = interpolateBetween(startRGB[1], startRGB[2], startRGB[3], endRGB[1], endRGB[2], endRGB[3], 1-prg, "Linear")
						drawLine(x, y, ex, ey, tocolor(r, g, b, 255), 5/mapZoom)
					end
                end
            end
        end
    end
	
	for k,v in ipairs(getElementsByType("radararea")) do
		local x, y = getElementPosition(v)
		local w, h = getRadarAreaSize(v)
		local r, g, b = getRadarAreaColor(v)

		x, y = getMapFromWorldPosition(x, y)
		w, h = getMapFromWorldPosition(w, h)
		_w, _h = getMapFromWorldPosition(0, 0)
		w, h = w - _w, h - _h
        x = x + w
        w = -w

		if (x + w > mapPos.x and x < mapPos.x + mapPos.w) and (y > mapPos.y and y + h < mapPos.y + mapPos.h) then
			if x < mapPos.x then
				w = w - (mapPos.x - x)
				x = mapPos.x
			end
			if y < mapPos.y then
				h = h - (mapPos.y - y)
				y = mapPos.y
			end
			if x + w > mapPos.x + mapPos.w then
				w = mapPos.x + mapPos.w - x
			end
			if y + h > mapPos.y + mapPos.h then
				h = mapPos.y + mapPos.h - y
			end
			dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 155))
		end
	end
	
	local blipSize = 35/zoom - math.max(math.min(mapZoom, 2), 1)
	for _, blip in ipairs(getElementsByType("blip")) do
		if getElementInterior(blip) == getElementInterior(localPlayer) and getElementDimension(blip) == getElementDimension(localPlayer) then 
			local icon = getBlipIcon(blip)
			if blips[icon] then
				local blipX, blipY, blipZ = getElementPosition(blip)
				local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
				local leftFrame = (centerX - mapPos.w / 2) + (blipSize/ 2)
				local rightFrame = (centerX + mapPos.w / 2) - (blipSize/ 2)
				local topFrame = (centerY - mapPos.h / 2) + (blipSize/ 2)
				local bottomFrame = (centerY + mapPos.h / 2) - (blipSize/ 2)
				local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
								
				centerX = math.max(leftFrame, math.min(rightFrame, blipX))
				centerY = math.max(topFrame, math.min(bottomFrame, blipY))

				if selectedBlip and not isElement(selectedBlip) then selectedBlip = nil end
				local alpha = (selectedBlip and getBlipIcon(selectedBlip) == getBlipIcon(blip)) and 255 or (not selectedBlip and 255 or 0)

				if selectedBlip and selectedBlip == blip then
					local text = blips[icon].name
					local description = getElementData(blip, "blip:description")
					local width = dxGetTextWidth(text, 1, font3) + 15/zoom
					local descriptionWidth = 0
					if description then
						width = dxGetTextWidth(text, 1, font4) + 15/zoom
						descriptionWidth = dxGetTextWidth(description, 1, font4) + 15/zoom
					end
					width = math.max(width, descriptionWidth)

					local height = #blipOptions * (dxGetFontHeight(1, font4) + 7/zoom) + 35/zoom
					dxDrawRectangle(centerX - (blipSize/2) - 5/zoom, centerY - (blipSize/2) - 5/zoom, blipSize + 5/zoom + width, blipSize + 10/zoom + height, tocolor(25, 25, 25, 240), true)
					dxDrawRectangle(centerX - (blipSize/2) - 5/zoom, centerY - 10/zoom + blipSize, blipSize + 5/zoom + width, 1, tocolor(45, 45, 45, 240), true)
					
					if not description then
						dxDrawText(text, centerX + blipSize/2 + 5/zoom, centerY, nil, nil, white, 1, font3, 'left', 'center', false, false, true)
					else
						dxDrawText(text, centerX + blipSize/2 + 10/zoom, centerY, nil, nil, white, 1, font4, 'left', 'bottom', false, false, true)
						dxDrawText(description, centerX + blipSize/2 + 10/zoom, centerY, nil, nil, tocolor(255, 255, 255, 170), 1, font5, 'left', 'top', false, false, true)
					end

					local y = 0
					for k,v in pairs(blipOptions) do
						local gx, gy, gw, gh = centerX - (blipSize/2) - 5/zoom, centerY + (blipSize/2) + 10/zoom + y, blipSize + 5/zoom + width, dxGetFontHeight(1, font4) + 7/zoom - 1
						local inside = isMouseIn(gx, gy, gw, gh)
						dxDrawRectangle(gx, gy, gw, gh, tocolor(55, 55, 55, inside and 200 or 50), true)
						dxDrawText(v.name, centerX - (blipSize/2), centerY + (blipSize/2) + 13/zoom + y, nil, nil, white, 1, font4, 'left', 'top', false, false, true)

						if k ~= #blipOptions then
							y = y + dxGetFontHeight(1, font4) + 7/zoom
						else
							y = y + 25/zoom
						end
					end

					local insideArrowLeft = isMouseIn(centerX - (blipSize/2), centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom)
					local insideArrowRight = isMouseIn(centerX + (blipSize/2) + width - 27/zoom, centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom)
					dxDrawImage(centerX - (blipSize/2), centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom, 'images/arrow.png', 0, 0, 0, tocolor(255, 255, 255, insideArrowLeft and 255 or 150), true)
					dxDrawImage(centerX + (blipSize/2) + width - 5/zoom, centerY + (blipSize/2) + 15/zoom + y, -22/zoom, 22/zoom, 'images/arrow.png', 0, 0, 0, tocolor(255, 255, 255, insideArrowRight and 255 or 150), true)
				end

				if icon == 1 then
					local r, g, b = getBlipColor(blip)
					dxDrawImage(centerX - (blipSize/2), centerY - (blipSize/ 2), blipSize - 5/zoom, blipSize, BLIP_TEXTURES[blips[icon].texture], 0, 0, 0, tocolor(r, g, b, alpha))
				else
					local x, y, w, h = centerX - (blipSize/2), centerY - (blipSize/ 2), blipSize - 5/zoom, blipSize
					if isMouseIn(x, y, w, h) then
						x = x - w * 0.1
						y = y - h * 0.1
						w = w * 1.2
						h = h * 1.2
					end

					dxDrawImage(x, y, w, h, BLIP_TEXTURES[blips[icon].texture], 0, 0, 0, tocolor(255, 255, 255, alpha), selectedBlip == blip)
				end
			end
		end
	end
	
	local localX, localY, localZ = getElementPosition(localPlayer)
	local blipX, blipY = getMapFromWorldPosition(localX, localY)
	if not selectedBlip and (blipX >= mapPos.x and blipX <= mapPos.x + mapPos.w) and (blipY >= mapPos.y and blipY <= mapPos.y + mapPos.h) then
		local _, _, playerRotation = getElementRotation(localPlayer)
		dxDrawImage(blipX - 10, blipY - 10, 20, 20, BLIP_TEXTURES["radar_centre"], 360 - playerRotation)
	end

	--dxDrawImage(mapPos.x - 1/zoom, mapPos.y - 1/zoom, mapPos.w + 2/zoom, mapPos.h + 2/zoom, vignette, 0, 0, 0, tocolor(255, 255, 255, 180))

	-- x = 0
	-- for i = 1, 70 do
	-- 	if blips[i] then
	-- 		x = x + 1
	-- 		offsetY = (42/zoom)*(x-1)

	-- 		local name = blips[i].name or "Brak"
	-- 		local textWidth = dxGetTextWidth(name, 1, font2)
	-- 		dxDrawRectangle(mapPos.x + 5/zoom, mapPos.y + 5/zoom + offsetY, 60/zoom + textWidth, 40/zoom, tocolor(35, 35, 35, 200))
	-- 		dxDrawImage(mapPos.x + 12/zoom, mapPos.y + 12/zoom + offsetY, 28/zoom, 28/zoom, BLIP_TEXTURES[blips[i].texture], 0, 0, 0, tocolor(255, 255, 255, 255))
	-- 		dxDrawText(name, mapPos.x + 55/zoom, mapPos.y + 25/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 200), 1, font2, "left", "center", false, false, false, false, false)
	-- 	end
	-- end
end 

function getMapPositionFromWorld(x, y, w, h)
	return (x+3000)/6000*w, (3000-y)/6000*h
end

function moveBigMap(button, state, cursorX, cursorY)
	if (button == 'left' and state == 'down') then
		local offset = 0
		for i,v in pairs(blips) do
			offset = offset + 40/zoom
			if isMouseIn(20/zoom, 98/zoom - 40/zoom + offset, 311/zoom, 35/zoom) then
				for k,v in pairs(getElementsByType("blip")) do
					if getBlipIcon(v) == i then
						selectedBlip = v
						local x, y, z = getElementPosition(v)
						setMapTarget(x, y)
						break
					end
				end
				return
			end
		end

		if (cursorX >= mapPos.x and cursorX <= mapPos.x + mapPos.w) and (cursorY >= mapPos.y and cursorY <= mapPos.y + mapPos.h)  then
			-- if is cursor over any blip
			for _, blip in ipairs(getElementsByType("blip")) do
				-- check if it's not localplayers blip
				if selectedBlip and not isElement(selectedBlip) then selectedBlip = nil end
				local alpha = (selectedBlip and getBlipIcon(selectedBlip) == getBlipIcon(blip)) or (not selectedBlip)
				if getElementInterior(blip) == getElementInterior(localPlayer) and getElementDimension(blip) == getElementDimension(localPlayer) and alpha then 
					local icon = getBlipIcon(blip)
					if blips[icon] and icon ~= 0 then
						local blipX, blipY, blipZ = getElementPosition(blip)
						local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
						local leftFrame = (centerX - mapPos.w / 2) + (blipSize/ 2)
						local rightFrame = (centerX + mapPos.w / 2) - (blipSize/ 2)
						local topFrame = (centerY - mapPos.h / 2) + (blipSize/ 2)
						local bottomFrame = (centerY + mapPos.h / 2) - (blipSize/ 2)
						local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
										
						centerX = math.max(leftFrame, math.min(rightFrame, blipX))
						centerY = math.max(topFrame, math.min(bottomFrame, blipY))

						if selectedBlip == blip then
							local text = blips[icon].name
							local width = dxGetTextWidth(text, 1, font3) + 15/zoom
							local height = #blipOptions * (dxGetFontHeight(1, font4) + 7/zoom) + 35/zoom
		
							local y = 0
							for k,v in pairs(blipOptions) do
								if isMouseIn(centerX - (blipSize/2) - 5/zoom, centerY + (blipSize/2) + 10/zoom + y, blipSize + 5/zoom + width, dxGetFontHeight(1, font4) + 7/zoom - 1) then
									local result = v.use(blip)
									if not result then selectedBlip = nil end
									return
								end
		
								if k ~= #blipOptions then
									y = y + dxGetFontHeight(1, font4) + 7/zoom
								else
									y = y + 25/zoom
								end
							end
		
							if isMouseIn(centerX - (blipSize/2), centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom) then
								local previousBlip = false
								for k,v in pairs(getElementsByType("blip")) do
									if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
										if not firstBlip then
											firstBlip = v
										end
										if v == blip then
											break
										else
											previousBlip = v
										end
									end
								end

								if not previousBlip then
									for k,v in pairs(getElementsByType("blip")) do
										if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
											previousBlip = v
										end
									end
								end

								if previousBlip then
									selectedBlip = previousBlip
									local blipX, blipY, blipZ = getElementPosition(previousBlip)
									setMapTarget(blipX, blipY)
									return
								end
							end
							if isMouseIn(centerX + (blipSize/2) + width - 27/zoom, centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom) then
								local nextBlip = false
								local nextBlipElement = false
								for k,v in pairs(getElementsByType("blip")) do
									if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
										if v == blip then
											nextBlip = true
										elseif nextBlip then
											nextBlipElement = v
											break
										end
									end
								end

								if not nextBlipElement then
									for k,v in pairs(getElementsByType("blip")) do
										if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
											nextBlipElement = v
											break
										end
									end
								end

								if nextBlipElement then
									selectedBlip = nextBlipElement
									local blipX, blipY, blipZ = getElementPosition(nextBlipElement)
									setMapTarget(blipX, blipY)
									return
								end
							end

							if isMouseIn(centerX - (blipSize/2) - 5/zoom, centerY - (blipSize/2) - 5/zoom, blipSize + 5/zoom + width, blipSize + 10/zoom + height) then
								return
							end
						end

						local r, g, b = getBlipColor(blip)
						if cursorX >= centerX - (blipSize/2) and cursorX <= centerX + (blipSize/2) and cursorY >= centerY - (blipSize/2) and cursorY <= centerY + (blipSize/2) then
							selectedBlip = blip
							local blipX, blipY = getElementPosition(blip)
							setMapTarget(blipX, blipY)
							return
						end
					end
				end
			end

			selectedBlip = nil

			mapOffsetX = (cursorX * mapZoom / mapUnit + playerX)
			mapOffsetY = (cursorY * mapZoom / mapUnit - playerY)
			mapIsMoving = true
			wasMapMoved = true
		end
	elseif (button == 'left' and state == 'up') then
		mapIsMoving = false
	end
end

function dxDrawRectangleLined( x, y, width, height, color, _width, postGUI )
    local _width = _width or 1
    dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
    dxDrawLine ( x, y, x, y+height, color, _width, postGUI ) -- Left
    dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
    dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end

function scrollBigMap(key)
	if key == "mouse_wheel_down" then 
		mapZoom = math.min(mapZoom+0.3, 3)
	elseif key == "mouse_wheel_up" then 
		mapZoom = math.max(0.75, mapZoom-0.3)
	end
end 

function showBigMap()
	if not getElementData(localPlayer, "player:spawn") then return end
	showing = not showing
	showCursor(showing)
	selectedBlip = nil
	
	if showing then 
		main['fonts'][1] = exports['iq-fonts']:getFont('bold',16.666666666666668/zoom)
		main['fonts'][2] = exports['iq-fonts']:getFont('medium',13.333333333333334/zoom)
		main['fonts'][3] = exports['iq-fonts']:getFont('medium',10/zoom)

		local c = {
			['bg'] = true,
			['left_panel'] = true,
			['header_line'] = true,
			['blip_bg'] = true,
			['scroll'] = true,
			['scroll2'] = true,
			['blip'] = true,
			['colors_bg'] = true,
			['my_locate'] = true,
			['circle'] = true,
			['map'] = true,
			['mask'] = true
		}
		for i,v in pairs(c) do
			main['textures'][i] = dxCreateTexture('images/map/'..i..'.png','argb',false,'clamp')
		end
		playerX, playerY = getElementPosition(localPlayer)
		wasMapMoved = false 
		
		if not memoryCheckbox then
			textures.map = dxCreateTexture("images/map/map.png")
			dxSetTextureEdge(textures.map, 'clamp')
		end 
		
		showChat(false)
		setElementData(localPlayer, "player:hudof", true)
		bindKey("mouse_wheel_up", "down", scrollBigMap)
		bindKey("mouse_wheel_down", "down", scrollBigMap)
		
		addEventHandler("onClientRender", root, renderBigMap)
		addEventHandler("onClientClick", root, moveBigMap)
	else 
		for i,v in pairs(main['fonts']) do
			if (isElement(v)) then
				destroyElement(v)
			end
		end
		for i,v in pairs(main['textures']) do
			if (isElement(v)) then
				destroyElement(v)
			end
		end
		unbindKey("mouse_wheel_up", "down", scrollBigMap)
		unbindKey("mouse_wheel_down", "down", scrollBigMap)
		removeEventHandler("onClientRender", root, renderBigMap)
		removeEventHandler("onClientClick", root, moveBigMap)

		showChat(true)
		setElementData(localPlayer, "player:hudof", false)
		
		if not memoryCheckbox then
			for k, v in pairs(textures) do 
				if isElement(v) then 
					destroyElement(v)
				end
			end
			textures = {}
		end
		if isElement(vignette) then
			destroyElement(vignette)
		end
	end
end 

function isBigMapShowing()
	return showing
end

addEventHandler("onClientKey", root, function(key, state)
	if key == "F11" and state then
		cancelEvent()
		forcePlayerMap(false)
		showBigMap()
		vignette = dxCreateTexture("images/winieta.png", "argb", true, "clamp")
	end
end)

function getWorldFromMapPosition(centerX, centerY)
	local worldX = screenW/2
	local worldY = screenH/2
	worldX = ((playerX + centerX) * mapZoom * mapUnit)
	
	return worldX, worldY
end

function getMapFromWorldPosition(worldX, worldY)
	local worldX, worldY = worldX + 3000, (worldY + 3000)
	local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
	local playerX, playerY = (playerX + 3000), (playerY + 3000)
	centerX = centerX - ((playerX - worldX) / mapZoom * mapUnit)
	centerY = centerY - ((worldY - playerY) / mapZoom * mapUnit)
	
	return centerX, centerY
end

--[[function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
	local mapLeftFrame = centerX - ((playerX - worldX) / mapZoom * mapUnit)
	local mapRightFrame = centerX + ((worldX - playerX) / mapZoom * mapUnit)
	local mapTopFrame = centerY - ((worldY - playerY) / mapZoom * mapUnit)
	local mapBottomFrame = centerY + ((playerY - worldY) / mapZoom * mapUnit)
	
	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX))
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY))
	
	return centerX, centerY
end]]

function isMouseIn(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end

    cx,cy = getCursorPosition()
    cx,cy = cx*sW, cy*sH
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true, cx, cy
    else
        return false
    end
end