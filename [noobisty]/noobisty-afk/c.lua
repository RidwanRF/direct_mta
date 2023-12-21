data = {

    afkTimes = getTickCount(),
    kickTime = 0,
    infoTime = 0,
    afkMaxTime = (60000*10+1000),
    rankLevel = nil,

    timeTexture = dxCreateTexture('img/time.png'),

    abs = math.abs,
    floor = math.floor,
    min = math.min,

}

function isAnyKeyDown()
    for k in ("qwertyuioopasdfghjklzxcvbnm"):gmatch(".") do
        if getKeyState(k) then return true end
    end
    return false
end

function secondsToClock(seconds)
	seconds = seconds or 0
	if seconds <= 0 then
		return "0 min. 0 sek."
	else
		hours = string.format("%02.f", math.floor(seconds/3600))
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
		return mins.." min. "..secs.." sek."
	end
end

local time = 60000*5

function renderAFK()
    if data.afkTimes + time < getTickCount() and not isAnyKeyDown() then
        if data.kickTime == 0 then data.kickTime = getTickCount() end
        if data.infoTime == 0 then data.infoTime = getTickCount() end

        setElementData(localPlayer, "player:hudof", true); setElementData(localPlayer, "user:afk", true); showChat(false)

        --if data.infoTime + 30000 < getTickCount() then
            --createTrayNotification("[DirectMTA] Jesteś AFK, rusz się albo zostaniesz wyrzucony. Pozostało: "..secondsToClock(time), "warning", true)
            --data.infoTime = getTickCount()
        --end

        local timeToKick = data.abs(data.kickTime - getTickCount())
        local time = data.floor((data.afkMaxTime-timeToKick)/1000)

        if data.rankLevel and tonumber(data.rankLevel) >= 1 then
            dxDrawRectangle(0, 0, sx, sy, tocolor(25, 25, 25, 225))
            dxDrawImage(sx / 2 - 20/zoom, sy / 2 - 20/zoom, 40/zoom, 40/zoom, data.timeTexture, 0, 0, 0, tocolor(200, 200, 200, 255))

            dxDrawText("Jesteś AFK", sx / 2, sy / 2 + 50/zoom, nil, nil, tocolor(124, 157, 191, 255), 1, font1, "center", "bottom", false, false, false, false, false)
            dxDrawText("Nie afcz ino zapierdalaj z reportami", sx / 2, sy / 2 + 50/zoom, nil, nil, tocolor(200, 200, 200, 255), 1, font2, "center", "top", false, false, false, false, false)
        else
            dxDrawRectangle(0, 0, sx, sy, tocolor(25, 25, 25, 225))
            dxDrawImage(sx / 2 - 20/zoom, sy / 2 - 20/zoom, 40/zoom, 40/zoom, data.timeTexture, 0, 0, 0, tocolor(200, 200, 200, 255))

            dxDrawText("Jesteś AFK", sx / 2, sy / 2 + 50/zoom, nil, nil, tocolor(200, 55, 55, 255), 1, font1, "center", "bottom", false, false, false, false, false)
            dxDrawText("Rusz się!", sx / 2, sy / 2 + 50/zoom, nil, nil, tocolor(200, 200, 200, 255), 1, font2, "center", "top", false, false, false, false, false)
            --dxDrawRectangle(sx / 2 - 100/zoom, sy / 2 + 100/zoom, 200/zoom, 4/zoom, tocolor(55, 55, 55, 225))
            --dxDrawRectangle(sx / 2 - 100/zoom, sy / 2 + 100/zoom, data.min(200/zoom*timeToKick/data.afkMaxTime, 200/zoom), 4/zoom, tocolor(200, 55, 55, 225))

            --dxDrawText("Pozostały czas do wyrzucenia", sx / 2, sy / 2 + 125/zoom, nil, nil, tocolor(200, 55, 55, 255), 1, font3, "center", "bottom", false, false, false, false, false)
            --dxDrawText(secondsToClock(time), sx / 2, sy / 2 + 125/zoom, nil, nil, tocolor(200, 200, 200, 255), 1, font4, "center", "top", false, false, false, false, false)

            --if timeToKick >= data.afkMaxTime then
                --triggerServerEvent('kickPlayerAFK', localPlayer, localPlayer)
                --removeEventHandler('onClientRender', root, renderAFK)
                --createTrayNotification("[DirectMTA] Zostałeś wyrzucony przez system AntyAFK", "error", true)
            --end
        end
    end
end
addEventHandler('onClientRender', root, renderAFK)

addEventHandler("onClientKey", root, function()
    data.afkTimes = getTickCount()
    data.kickTime = 0
    data.infoTime = 0
    data.rankLevel = (getElementData(localPlayer, "player:level") or 0)

    if getElementData(localPlayer, "user:afk") then
        setElementData(localPlayer, "player:hudof", false)
        setElementData(localPlayer, "user:afk", false)
        showChat(true)
    end
end)