local data = {

    togglePanel = false,
    scrollPos = {k=1, m=15, n=15},
    markerPos = createMarker(212.93, -41.59, 1001.52-1, "cylinder", 2, 255, 175, 0, 55),

}

local skins = {

    {0, "Skin domyślny", 0},
    {1, nil, 100},
    {2, nil, 100},
    {7, nil, 100},
    {11, nil, 100},
    {12, nil, 100},
    {14, nil, 100},
    {15, nil, 100},
    {17, nil, 100},
    {18, nil, 100},
    {19, nil, 100},
    {21, nil, 100},
    {23, nil, 100},
    {24, nil, 100},
    {25, nil, 100},
    {28, nil, 100},
    {29, nil, 100},
    {30, nil, 100},
    {32, nil, 100},
    {40, nil, 100},
    {41, nil, 100},
    {46, nil, 100},
    {47, nil, 100},
    {57, nil, 100},
    {59, nil, 100},
    {61, nil, 100},
    {67, nil, 100},
    {66, nil, 100},
    {68, nil, 100},
    {73, nil, 100},
    {78, nil, 100},
    {91, nil, 100},
    {93, nil, 100},
    {97, nil, 100},
    {98, nil, 100},
    {136, nil, 100},
    {137, nil, 100},
    {146, nil, 100},
    {216, nil, 100},
    {228, nil, 100},
    {230, nil, 100},
    {242, nil, 100},
    {249, nil, 100},
    {250, nil, 100},
    {292, nil, 100},
    {293, nil, 100},
    {294, nil, 100},
    {299, nil, 100},
    {306, nil, 100},
   
    {81, nil, 220, true},
    {50, nil, 320, true},
    {83, nil, 120, true},
    {84, nil, 175, true},
    {48, nil, 195, true},
    {80, nil, 125, true},
    {51, nil, 200, true},
    {52, nil, 300, true},
    {145, nil, 300, true},

}
local _temp = createPed(0, 0, 0, 3000)
setElementFrozen(_temp, true)

local _dxDrawImage = dxDrawImage
function dxDrawImage(x, ...)
    return _dxDrawImage(x+sx/2-230/zoom,...)
end

local _dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, ...)
    return _dxDrawRectangle(x+sx/2-230/zoom,...)
end

local _dxDrawText = dxDrawText
function dxDrawText(text, x, ...)
    return _dxDrawText(text, x+sx/2-230/zoom,...)
end

function doIOwnSkin(skinid)
    local data = getElementData(localPlayer, "player:skinShop") or {}
    return data[skinid]
end

function renderWindow()
    dxDrawRectangle(sx/2-200/zoom, sy/2-300/zoom, 410/zoom, 655/zoom, tocolor(25, 25, 25, 255))

    x = 0
    for i,v in ipairs(skins) do
        if i >= data.scrollPos.k and i <= data.scrollPos.n then 
            x = x + 1
            offsetY = (40/zoom)*(x-1)

            dxDrawRectangle(sx/2-190/zoom, sy/2-290/zoom+offsetY, 380/zoom, 35/zoom, tocolor(35, 35, 35, 255))

            if v[4] then
                dxDrawImage(sx/2-180/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/shirt.png", 0, 0, 0, tocolor(255, 200, 0, 200))
            else
                dxDrawImage(sx/2-180/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/shirt.png", 0, 0, 0, tocolor(255, 255, 255, 200))
            end

            if v[2] ~= nil then
                if v[4] then
                    dxDrawText("" .. v[2].." #ffc800★", sx/2 - 150/zoom, sy/2 - 280/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 255), 1, font5, "left", "center", false, false, false, true, false)
                else
                    dxDrawText("" .. v[2], sx/2 - 150/zoom, sy/2 - 280/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 255), 1, font5, "left", "center", false, false, false, false, false)
                end
            else
                if v[4] then
                    dxDrawText("Skin ID " .. v[1].." #ffc800★", sx/2 - 150/zoom, sy/2 - 280/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 255), 1, font5, "left", "center", false, false, false, true, false)
                else
                    dxDrawText("Skin ID " .. v[1], sx/2 - 150/zoom, sy/2 - 280/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 255), 1, font5, "left", "center", false, false, false, false, false)
                end
            end
            
            
            if v[5] then
                dxDrawText("W posiadaniu", sx/2 - 150/zoom, sy/2 - 265/zoom + offsetY, nil, nil, tocolor(200, 200, 55, 255), 1, font7, "left", "center", false, false, false, false, false)
            elseif v[3] and v[3] ~= 0 then
                dxDrawText(""..v[3].." PLN", sx/2 - 150/zoom, sy/2 - 265/zoom + offsetY, nil, nil, tocolor(55, 200, 55, 255), 1, font7, "left", "center", false, false, false, false, false)
            else
                dxDrawText("Skin jest darmowy", sx/2 - 150/zoom, sy/2 - 265/zoom + offsetY, nil, nil, tocolor(25, 144, 255, 255), 1, font7, "left", "center", false, false, false, false, false)
            end
            
            if doIOwnSkin(v[1]) or v[3] == 0 then
                if isMouseIn(sx/2+65/zoom, sy/2-290/zoom+offsetY, 125/zoom, 35/zoom) then
                    dxDrawRectangle(sx/2+65/zoom, sy/2-290/zoom+offsetY, 125/zoom, 35/zoom, tocolor(45, 45, 45, 175))
                    dxDrawImage(sx/2+75/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/take.png", 0, 0, 0, tocolor(255, 255, 25, 175))
                    dxDrawText("Zmień skin", sx/2 + 105/zoom, sy/2 - 274/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 175), 1, font6, "left", "center", false, false, false, false, false)

                    if getKeyState("mouse1") then
                        setElementModel(localPlayer, v[1])
                        triggerServerEvent("przebieralniaZmienSkina", localPlayer, v[1])
                    end
                else
                    dxDrawRectangle(sx/2+65/zoom, sy/2-290/zoom+offsetY, 125/zoom, 35/zoom, tocolor(45, 45, 45, 255))
                    dxDrawImage(sx/2+75/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/take.png", 0, 0, 0, tocolor(255, 255, 25, 255))
                    dxDrawText("Zmień skin", sx/2 + 105/zoom, sy/2 - 274/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 255), 1, font6, "left", "center", false, false, false, false, false)
                end
            else
                if isMouseIn(sx/2+65/zoom, sy/2-290/zoom+offsetY, 125/zoom, 35/zoom) then
                    dxDrawRectangle(sx/2+65/zoom, sy/2-290/zoom+offsetY, 125/zoom, 35/zoom, tocolor(45, 45, 45, 175))
                    dxDrawImage(sx/2+75/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/buy.png", 0, 0, 0, tocolor(55, 255, 55, 175))
                    dxDrawText("Zakup skin", sx/2 + 105/zoom, sy/2 - 274/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 175), 1, font6, "left", "center", false, false, false, false, false)
                
                    if getKeyState("mouse1") and getPlayerMoney(localPlayer) >= v[3] and not getElementData(localPlayer, "buywait") then
                        if v[4] then
                            if getElementData(localPlayer, "player:premiumplus") then
                                triggerServerEvent("przebieralniaKupSkina", localPlayer, v[3], v[1])
                                setElementData(localPlayer, "buywait", true)
                            end
                        else
                            triggerServerEvent("przebieralniaKupSkina", localPlayer, v[3], v[1])
                            setElementData(localPlayer, "buywait", true)
                        end
                    end
                else
                    dxDrawRectangle(sx/2+65/zoom, sy/2-290/zoom+offsetY, 125/zoom, 35/zoom, tocolor(45, 45, 45, 255))
                    dxDrawImage(sx/2+75/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/buy.png", 0, 0, 0, tocolor(55, 255, 55, 255))
                    dxDrawText("Zakup skin", sx/2 + 105/zoom, sy/2 - 274/zoom + offsetY, nil, nil, tocolor(200, 200, 200, 255), 1, font6, "left", "center", false, false, false, false, false)
                end
            end
            
            if isMouseIn(sx/2+35/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom) then
                dxDrawImage(sx/2+35/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/eye.png", 0, 0, 0, tocolor(25, 175, 255, 175))
                cposX, cposY = getCursorPosition()
                cposX, cposY = cposX*sx, cposY*sy

                if getKeyState("mouse1") then
                    setElementModel(localPlayer, v[1])
                end

                dxDrawRectangle(cposX + 20/zoom, cposY + 20/zoom, 95/zoom, 25/zoom, tocolor(75, 75, 75, 255), true)
                dxDrawText("Podgląd skina", cposX + 25/zoom, cposY + 30/zoom, nil, nil, tocolor(200, 200, 200, 255), 1, font6, "left", "center", false, false, true, false, false)
            else
                dxDrawImage(sx/2+35/zoom, sy/2-283/zoom+offsetY, 20/zoom, 20/zoom, "data/eye.png", 0, 0, 0, tocolor(25, 175, 255, 255))
            end
        end
    end
    drawScrollbar(skins, sx/2+195/zoom, sy/2-290/zoom, 595/zoom, data.scrollPos.m, data.scrollPos.k)

    if isMouseIn(sx/2 - 190/zoom, sy/2+315/zoom, 390/zoom, 30/zoom) then
        dxDrawRectangle(sx/2 - 190/zoom, sy/2+315/zoom, 390/zoom, 30/zoom, tocolor(125, 0, 0, 175))
        dxDrawText("Zamknij okno", sx/2 + 10/zoom, sy/2+328/zoom, nil, nil, tocolor(200, 200, 200, 175), 1, font6, "center", "center", false, false, false, false, false)
    else
        dxDrawRectangle(sx/2 - 190/zoom, sy/2+315/zoom, 390/zoom, 30/zoom, tocolor(125, 0, 0, 255))
        dxDrawText("Zamknij okno", sx/2 + 10/zoom, sy/2+328/zoom, nil, nil, tocolor(200, 200, 200, 200), 1, font6, "center", "center", false, false, false, false, false)
    end
end

function openWindow(el)
    if el ~= getLocalPlayer() then return end

    addEventHandler("onClientRender", root, renderWindow)
    addEventHandler("onClientClick", root, onClick)
    showCursor(true)
    data.togglePanel = true
end

function closeWindow(el)
    if el ~= getLocalPlayer() then return end

    removeEventHandler("onClientRender", root, renderWindow)
    removeEventHandler("onClientClick", root, onClick)
    showCursor(false)
    data.togglePanel = false
    setElementModel(localPlayer, getElementData(localPlayer, "player:skin"))
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    addEventHandler("onClientMarkerHit", data.markerPos, openWindow)
    addEventHandler("onClientMarkerLeave", data.markerPos, closeWindow)

    setElementData(data.markerPos, "marker:title", "Przebieralnia")
    setElementData(data.markerPos, "marker:desc", "Ubierz się człowieku!")
    setElementData(data.markerPos, "marker:icon", "tshirt")
    setElementInterior(data.markerPos, 1)
end)

function onClick(btn, state)
    if btn == 'left' and state == 'down' and data.togglePanel == true then
        if isMouseIn(sx/2 - 190/zoom, sy/2+315/zoom, 390/zoom, 30/zoom) then
            removeEventHandler("onClientRender", root, renderWindow)
            removeEventHandler("onClientClick", root, onClick)
            showCursor(false)
            data.togglePanel = false
            setElementModel(localPlayer, getElementData(localPlayer, "player:skin"))
        end
    end
end

bindKey("mouse_wheel_down", "both", function()
    if data.togglePanel == true then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if data.togglePanel == true then
        scrollDown()
    end
end)

function scrollDown()
    if data.scrollPos.n == data.scrollPos.m then return end
    data.scrollPos.k = data.scrollPos.k-1
    data.scrollPos.n = data.scrollPos.n-1
end

function scrollUp()
    if data.scrollPos.n >= #skins then return end
    data.scrollPos.k = data.scrollPos.k+1
    data.scrollPos.n = data.scrollPos.n+1
end

function isMouseIn(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    psx = psx + sx/2 - 230/zoom

    cx,cy = getCursorPosition()
    cx,cy = cx*sx, cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true, cx, cy
    else
        return false
    end
end

function drawScrollbar(table, x, y, height, m_, k_)
    dxDrawRectangle(x, y, 4, height, tocolor(255, 175, 0, 55))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 1 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end

        dxDrawRectangle(x, scrollbarPos, 4, scrollbarHeight*(m_-1), tocolor(255, 175, 0, 125))
    else
        dxDrawRectangle(x, y, 4, height, tocolor(255, 175, 0, 125))
	end
end
