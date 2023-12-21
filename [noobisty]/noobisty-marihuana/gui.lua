data = {

    items = {

        {name='Marihuana', data='weight', type='weed'},
        --{name='Topy', data='weight', type='tops'},

    },

    costs = {},
    tosell = {},
    gui = false,

}

function renderGUI()
    dxDrawRoundedRectangle(sx / 2 - 300/zoom - 1, sy / 2 - 200/zoom - 1, 600/zoom + 2, 400/zoom + 2, 15, tocolor(75, 75, 75, 255))
    dxDrawRoundedRectangle(sx / 2 - 300/zoom, sy / 2 - 200/zoom, 600/zoom, 400/zoom, 15, tocolor(35, 35, 35, 255))

    offsetY = 0
    for i, v in ipairs(data.items) do
        if not data.tosell[i] then data.tosell[i] = 0 end

        drawButton("<", sx / 2 - 175/zoom, sy / 2 - 180/zoom + offsetY, 25/zoom, 25/zoom, 1, {100, 100, 100})
        drawButton(">", sx / 2 - 70/zoom, sy / 2 - 180/zoom + offsetY, 25/zoom, 25/zoom, 1, {100, 100, 100})

        local _, id = exports['borsuk-inventory']:getPlayerItemByName(v.name)

        if id then
            drawButton("Sprzedaj", sx / 2 + 150/zoom, sy / 2 - 180/zoom + offsetY, 125/zoom, 25/zoom, 1, {55, 155, 55})
        else
            drawButton("Sprzedaj", sx / 2 + 150/zoom, sy / 2 - 180/zoom + offsetY, 125/zoom, 25/zoom, 1, {155, 55, 55})
        end
        
        dxDrawText(v.name, sx / 2 - 285/zoom, sy / 2 - 168/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 175), 1, font2, "left", "center", false, false, false, false, false)
        dxDrawText(data.tosell[i], sx / 2 - 110/zoom, sy / 2 - 168/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 175), 1, font2, "center", "center", false, false, false, false, false)

        local cost = math.floor(tonumber((math.floor(exports['borsuk-inventory']:getItemCustomData(id, 'weight') or 0))) * (data.costs[v.type] or 0))
        dxDrawText(formatNumber(cost).." PLN - "..data.costs[v.type].."PLN/g", sx / 2 - 25/zoom, sy / 2 - 175/zoom + offsetY, nil, nil, tocolor(55, 195, 255, 175), 1, font3, "left", "center", false, false, false, false, false)
        local cost = math.floor(tonumber((data.tosell[i] or 0) * (data.costs[v.type] or 0)))
        dxDrawText(formatNumber(cost).." PLN", sx / 2 - 25/zoom, sy / 2 - 160/zoom + offsetY, nil, nil, tocolor(75, 200, 75, 175), 1, font3, "left", "center", false, false, false, false, false)

        offsetY = offsetY + 35/zoom
    end
end

function onClick(key, state)
    if key == 'left' and state == 'down' and data.gui then
        offsetY = 0
        for i, v in ipairs(data.items) do
            if not data.tosell[i] then data.tosell[i] = 0 end

            local _, id = exports['borsuk-inventory']:getPlayerItemByName(v.name)
            local limit = tonumber(exports['borsuk-inventory']:getItemCustomData(id, 'weight') or 0)
            
            if isMouseIn(sx / 2 - 175/zoom, sy / 2 - 180/zoom + offsetY, 25/zoom, 25/zoom) then data.tosell[i] = math.floor(math.max(0, data.tosell[i] - 1)) end
            if isMouseIn(sx / 2 - 70/zoom, sy / 2 - 180/zoom + offsetY, 25/zoom, 25/zoom) then data.tosell[i] = math.floor(math.min(limit, data.tosell[i] + 1)) end

            if isMouseIn(sx / 2 + 150/zoom, sy / 2 - 180/zoom + offsetY, 125/zoom, 25/zoom) then 
                if 9 >= data.tosell[i] then
                    return exports["noobisty-notyfikacje"]:createNotification("Diler", "Możesz sprzedać minimalnie 10g", {255, 50, 50}, "sighter")
                end

                local _, id = exports['borsuk-inventory']:getPlayerItemByName(v.name)
                local cost = math.floor(tonumber((data.tosell[i] or 0) * (data.costs[v.type] or 0)))
                
                triggerServerEvent('givePlayerMoney', localPlayer, math.floor(cost))
                exports["noobisty-notyfikacje"]:createNotification("Diler", "Sprzedałeś " .. ("%.2f"):format(exports['borsuk-inventory']:getItemCustomData(id, 'weight')) .. "g marihuany za " .. cost .. " PLN", {50, 255, 50}, "sight")

                exports["borsuk-inventory"]:setItemCustomData(id, 'weight', exports['borsuk-inventory']:getItemCustomData(id, 'weight') - data.tosell[i])
                data.tosell[i] = 0

                local _, id = exports['borsuk-inventory']:getPlayerItemByName(v.name)
                if exports['borsuk-inventory']:getItemCustomData(id, 'weight') == 0 then
                    exports["borsuk-inventory"]:removePlayerItem(id)
                end
            end
    
            offsetY = offsetY + 30
        end
    end
end

--[[if getElementData(localPlayer, "player:sid") == 1 then
    addEventHandler('onClientRender', root, renderGUI)
    addEventHandler("onClientClick", root, onClick)
   -- local cost = tonumber(exports['borsuk-inventory']:getItemCustomData(id, 'weight') * (data.costs[v.type] or 0))
end--]]

function formatNumber(amount)
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') 
			
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

addEvent('toggleGUI', true)
addEventHandler('toggleGUI', resourceRoot, function(state, costs)
    if state == true then
        data.costs = costs
        data.tosell = {}
        addEventHandler('onClientRender', root, renderGUI)
        addEventHandler("onClientClick", root, onClick)
        showCursor(true, false)
    else
        removeEventHandler('onClientRender', root, renderGUI)
        removeEventHandler("onClientClick", root, onClick)
        showCursor(false)
    end

    data.gui = state
end)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function drawButton(text, x, y, w, h, id, color)
	if isMouseIn(x, y, w, h) then
		dxDrawRoundedRectangle(x, y, w, h, 5, tocolor(color[1], color[2], color[3], 225))
		dxDrawText(text, x + 1, y, x+w, y+h, tocolor(255, 255, 255, 175), 1, font2, "center", "center", false, false, false, false, false)
	else
		dxDrawRoundedRectangle(x, y, w, h, 5, tocolor(color[1], color[2], color[3], 245))
		dxDrawText(text, x + 1, y, x+w, y+h, tocolor(255, 255, 255, 245), 1, font2, "center", "center", false, false, false, false, false)
	end
end

function isMouseIn ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end