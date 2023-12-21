if getPlayerName(localPlayer) ~= 'borsuczyna' then return end
local currentJob = false
local topList = false
local myPosition = false
local history = false
local historyChart = false

local topListUI = {
	{sx/2 - 321/zoom, sy/2 - 175/zoom, 1.0, 0xFFFFE500},
	{sx/2 - 441/zoom, sy/2 - 175/zoom, 0.9, 0xFFFFA800},
	{sx/2 - 211/zoom, sy/2 - 175/zoom, 0.9, 0xFFFF4D00},
}

function drawLoading(x, y, text)
	local a1 = interpolateBetween(0.5, 0, 0, 1, 0, 0, ((getTickCount()+400)%1000)/1000, 'CosineCurve')
	local a2 = interpolateBetween(0.5, 0, 0, 1, 0, 0, ((getTickCount()+200)%1000)/1000, 'CosineCurve')
	local a3 = interpolateBetween(0.5, 0, 0, 1, 0, 0, ((getTickCount()+00)%1000)/1000, 'CosineCurve')
	dxDrawImage(x - 30/zoom - 10/zoom*a1, y - 10/zoom*a1, 20/zoom*a1, 20/zoom*a1, 'data/circle.png', 0, 0, 0, tocolor(255, 255, 255, 255*a1))
	dxDrawImage(x - 10/zoom*a2, y - 10/zoom*a2, 20/zoom*a2, 20/zoom*a2, 'data/circle.png', 0, 0, 0, tocolor(255, 255, 255, 255*a2))
	dxDrawImage(x + 30/zoom - 10/zoom*a3, y - 10/zoom*a3, 20/zoom*a3, 20/zoom*a3, 'data/circle.png', 0, 0, 0, tocolor(255, 255, 255, 255*a3))
	dxDrawText('Wczytywanie...', x, y + 40/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Bold', 13/zoom), 'center', 'bottom')
	dxDrawText('Pobieranie ' .. text .. ' z bazy danych', x, y + 40/zoom, nil, nil, tocolor(255, 255, 255, 180), 1, getFigmaFont('Inter-Medium', 11/zoom), 'center', 'top')
end

function createHistory(data)
	history = data
	if not history then
		history = {0, 0, 0, 0, 0, 0, 0}
	end

	local max = (math.max(unpack(data)) or 100) * 1.2 + 1
	historyChart = exports['borsuk-charts']:createChart({
		x = sx/2 - 88/zoom,
		y = sy/2 - 240/zoom,
		w = 583/zoom,
		h = 160/zoom,
		radius = 10/zoom,
		blur = false,
		type = 'line',
		background = tocolor(65, 65, 65, 150),
		color = 0xAAff962e,
		bottomColor = 0x77ff962e,
		line = 0xFFff962e,
		point = 0xFFffa024,
		pointSize = 13/zoom,
		min = 0,
		max = max,
		width = 5/zoom,
		round = 10/zoom,
		marginHorizontal = 10/zoom,
		marginVertical = 10/zoom,
		tipMargin = 20/zoom,
		tipReverse = true,
		tipgsub = {'(%d%d%d)','%1,'},
		tipFormat = '$%s',
		tipgsub2 = {'$,', '$'},
		font = exports['figma']:getFont('Inter-Medium', 8),
		data = data
		-- labels = {
		-- 	horizontalPosition = 'left',
		-- 	verticalPosition = 'bottom',
		-- 	horizontal = false,
		-- 	vertical = 5000
		-- }
	})
end

addEvent('requestJobData:callback', true)
addEventHandler('requestJobData:callback', resourceRoot, function(topListData, myPositionData, history)
    topList = topListData
	myPosition = myPositionData

	for k,v in pairs(topList) do
		v.avatar = exports['iq-avatars']:getCircleAvatar(v.uid)
	end

	createHistory(history)
end)

function drawButton(x, y, w, h, image)
	local inside = isMouseInPosition(x, y, w, h)
	dxDrawImage(x, y, w, h, image, 0, 0, 0, tocolor(255, 255, 255, inside and 255 or 200))
end

function renderUI()
	local job = jobs[currentJob]
	if not job then return end

	dxDrawImage(sx/2 - 540/zoom, sy/2 - 304/zoom, 1080/zoom, 610/zoom, 'data/background.png')
	dxDrawImage(sx/2 - 104/zoom, sy/2 - 282/zoom, 617/zoom, 216/zoom, 'data/history-bg.png')
	
	dxDrawImage(sx/2 - 519/zoom, sy/2 - 282/zoom, 396/zoom, 216/zoom, 'data/top-bg.png')
	dxDrawText('TOP TYGODNIA', sx/2 - 321/zoom, sy/2 - 275/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Black', 18/zoom), 'center', 'top')
	
	if not topList then
		drawLoading(sx/2 - 321/zoom, sy/2 - 190/zoom, 'topki')
	else
		dxDrawText('Twoja pozycja: ' .. (myPosition or 'Brak'), sx/2 - 321/zoom, sy/2 - 248/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Medium', 11/zoom), 'center', 'top')

		for i = 1, 3 do
			local data = topList[i]
			if data then
				local ui = topListUI[i]
				dxDrawImage(ui[1] - 40/zoom * ui[3], ui[2] - 40/zoom * ui[3], 80/zoom * ui[3], 80/zoom * ui[3], data.avatar, 0, 0, 0, tocolor(255, 255, 255, 255))

				local w = dxGetTextWidth(data.points .. ' pkt.', 1, getFigmaFont('Inter-Bold', 10/zoom)) + 12/zoom
				dxDrawImage(ui[1] - w/2, ui[2] + 75/zoom * ui[3], w, 23/zoom, 'data/points-bg.png', 0, 0, 0, ui[4])

				dxDrawText(data.points .. ' pkt.', ui[1] + 1, ui[2] + 75/zoom * ui[3] + 11.5/zoom + 1, nil, nil, tocolor(0, 0, 0, 85), 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')
				dxDrawText(data.points .. ' pkt.', ui[1], ui[2] + 75/zoom * ui[3] + 11.5/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')

				dxDrawText(data.name, ui[1], ui[2] + 72/zoom * ui[3], nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 10/zoom), 'center', 'bottom')
			end
		end
	end

	-- dxDrawText('Twoja pozycja: 1', sx/2 - 321/zoom, sy/2 - 248/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Medium', 11/zoom), 'center', 'top')
	
	-- dxDrawText('zexty', sx/2 - 321/zoom, sy/2 - 96/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 12/zoom), 'center', 'bottom')
	-- dxDrawImage(sx/2 - 351/zoom, sy/2 - 95/zoom, 61/zoom, 23/zoom, 'data/points-bg.png', 0, 0, 0, 0xFFFFE500)
	-- dxDrawText('352 pkt.', sx/2 - 319.5/zoom, sy/2 - 83/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')

	-- dxDrawText('IQ', sx/2 - 452.5/zoom, sy/2 - 102/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 12/zoom), 'center', 'bottom')
	-- dxDrawImage(sx/2 - 483/zoom, sy/2 - 100/zoom, 61/zoom, 23/zoom, 'data/points-bg.png', 0, 0, 0, 0xFFFFA800)
	-- dxDrawText('211 pkt.', sx/2 - 452/zoom, sy/2 - 88/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')
	
	-- dxDrawText('borsuczyna', sx/2 - 188.5/zoom, sy/2 - 102/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 12/zoom), 'center', 'bottom')
	-- dxDrawImage(sx/2 - 219/zoom, sy/2 - 100/zoom, 61/zoom, 23/zoom, 'data/points-bg.png', 0, 0, 0, 0xFFFF4D00)
	-- dxDrawText('122 pkt.', sx/2 - 187.5/zoom, sy/2 - 88/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')
	
	dxDrawImage(sx/2 - 519/zoom, sy/2 - 49/zoom, 306/zoom, 81/zoom, 'data/boost-bg.png')
	
	job.multiplier = job.multiplier or 1
	if job.multiplier then
		local mult = (job.multiplier - 1)*100
		if mult > 0 then
			dxDrawImage(sx/2 - 519/zoom, sy/2 - 49/zoom, 80/zoom, 80/zoom, 'data/Star.png')
			dxDrawText('Zwiększona premia', sx/2 - 438/zoom, sy/2 - 13/zoom, nil, nil, tocolor(255, 192, 99, 255), 1, getFigmaFont('Inter-Black', 13/zoom), 'left', 'bottom')
			dxDrawText('Praca posiada włączony mnożnik\nwynagrodzenia', sx/2 - 438/zoom, sy/2 - 13/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', 10/zoom), 'left', 'top')
			dxDrawImage(sx/2 - 201/zoom, sy/2 - 50/zoom, 78/zoom, 80/zoom, 'data/_single_boost.png')
			dxDrawText('+' .. mult .. '%', sx/2 - 162/zoom, sy/2 + 10/zoom, nil, nil, tocolor(171, 255, 179, 255), 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')
		elseif mult < 0 then
			dxDrawImage(sx/2 - 519/zoom, sy/2 - 49/zoom, 80/zoom, 80/zoom, 'data/sad.png', 0, 0, 0, 0xFFFF4040)
			dxDrawText('Zmniejszona premia', sx/2 - 438/zoom, sy/2 - 13/zoom, nil, nil, 0xFFFF4040, 1, getFigmaFont('Inter-Black', 13/zoom), 'left', 'bottom')
			dxDrawText('Praca posiada zmniejszony mnożnik\nwynagrodzenia', sx/2 - 438/zoom, sy/2 - 13/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', 10/zoom), 'left', 'top')
			dxDrawImage(sx/2 - 201/zoom, sy/2 - 50/zoom, 78/zoom, 80/zoom, 'data/minus-boost.png')
			dxDrawText(mult .. '%', sx/2 - 162/zoom, sy/2 + 10/zoom, nil, nil, 0xFFFFABAB, 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')
		else
			dxDrawImage(sx/2 - 519/zoom, sy/2 - 49/zoom, 80/zoom, 80/zoom, 'data/normal.png')
			dxDrawText('Zwykła premia', sx/2 - 438/zoom, sy/2 - 13/zoom, nil, nil, 0xFFC9C9C9, 1, getFigmaFont('Inter-Black', 13/zoom), 'left', 'bottom')
			dxDrawText('Praca nie posiada mnożnika\nwynagrodzenia', sx/2 - 438/zoom, sy/2 - 13/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', 10/zoom), 'left', 'top')
			dxDrawImage(sx/2 - 201/zoom, sy/2 - 50/zoom, 78/zoom, 80/zoom, 'data/average.png')
		end
	end
	
	dxDrawImage(sx/2 - 519/zoom, sy/2 + 48/zoom, 396/zoom, 235/zoom, 'data/upgrades-bg.png')
	dxDrawText('ULEPSZENIA', sx/2 - 320.5/zoom, sy/2 + 55/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Black', 18/zoom), 'center', 'top')
	dxDrawText('Twoje punkty ulepszeń: ' .. getUpgradePoints(currentJob), sx/2 - 320.5/zoom, sy/2 + 88.5/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, getFigmaFont('Inter-Medium', 10/zoom), 'center', 'center')
	
	for k,v in pairs(job.upgrades) do
		local y = (k-1)*58/zoom - 3/zoom

		dxDrawImage(sx/2 - 504/zoom, sy/2 + 104/zoom + y, 307/zoom, 52/zoom, 'data/upgrade-bg.png')
		dxDrawImage(sx/2 - 500/zoom, sy/2 + 105/zoom + y, 45/zoom, 50/zoom, 'data/_single_bolt.png')
		dxDrawText(v[1], sx/2 - 454/zoom, sy/2 + 132/zoom + y, nil, nil, tocolor(162, 210, 255, 255), 1, getFigmaFont('Inter-Black', 12/zoom), 'left', 'bottom')
		dxDrawText(v[2], sx/2 - 454/zoom, sy/2 + 132/zoom + y, nil, nil, 0xCCFFFFFF, 1, getFigmaFont('Inter-Medium', 9/zoom), 'left', 'top')
		drawButton(sx/2 - 190/zoom, sy/2 + 104/zoom + y, 52/zoom, 52/zoom, 'data/_single_buy.png')
		dxDrawText(v[3] .. ' pkt.', sx/2 - 203/zoom, sy/2 + 130/zoom + y, nil, nil, tocolor(255, 255, 255, 191), 1, getFigmaFont('Inter-Black', 10/zoom), 'right', 'center')
	end

	dxDrawText('HISTORIA ZAROBKU', sx/2 + 203/zoom, sy/2 - 275/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Black', 18/zoom), 'center', 'top')
	if not history then
		drawLoading(sx/2 + 203/zoom, sy/2 - 190/zoom, 'historii')
	end

	dxDrawImage(sx/2 - 104/zoom, sy/2 - 50.145/zoom, 617/zoom, 333.145/zoom, 'data/_single_job-image.png')
	dxDrawText('PRACA DORYWCZA', sx/2 - 86/zoom, sy/2 - 5/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Black', 18/zoom), 'left', 'bottom')
	dxDrawText(job.name, sx/2 - 86/zoom, sy/2 - 7/zoom, nil, nil, tocolor(255, 255, 255, 204), 1, getFigmaFont('Inter-Medium', 12/zoom), 'left', 'top')
	dxDrawText('OPIS PRACY', sx/2 + 494/zoom, sy/2 - 5/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, getFigmaFont('Inter-Black', 18/zoom), 'right', 'bottom')
	dxDrawText(job.description, sx/2 + 150/zoom, sy/2 - 7/zoom, sx/2 + 494/zoom, sy/2 + 227/zoom, tocolor(255, 255, 255, 204), 1, getFigmaFont('Inter-Medium', 10.2/zoom), 'right', 'top', false, true)
	
	drawButton(sx/2 - 85/zoom, sy/2 + 19/zoom, 183/zoom, 33/zoom, 'data/button.png')
	local workingHere = getElementData(localPlayer, 'player:job') == currentJob
	dxDrawText(workingHere and 'Zakończ prace' or 'Rozpocznij prace', sx/2 + 8/zoom, sy/2 + 36/zoom, nil, nil, tocolor(255, 255, 255, 204), 1, getFigmaFont('Inter-Bold', 10/zoom), 'center', 'center')
	
	dxDrawImage(sx/2 + 78/zoom, sy/2 + 141/zoom, 254/zoom, 87/zoom, 'data/_single_help.png')
	dxDrawText('Wielkość grzybów', sx/2 + 204.5/zoom, sy/2 + 256/zoom, nil, nil, tocolor(255, 200, 136, 255), 1, getFigmaFont('Inter-Bold', 12/zoom), 'center', 'bottom')
	dxDrawText('Wielkość grzyba wpływa na twoje wynagrodzenie', sx/2 + 204.5/zoom, sy/2 + 257/zoom, nil, nil, tocolor(255, 255, 255, 216), 1, getFigmaFont('Inter-Medium', 11/zoom), 'center', 'top')
end

addEvent('onJobStart', true)
addEvent('onJobFinish', true)

function clickUI(button, state)
	if button ~= 'left' or state ~= 'down' then return end

	if isMouseInPosition(sx/2 - 85/zoom, sy/2 + 19/zoom, 183/zoom, 33/zoom) then
		local workingHere = getElementData(localPlayer, 'player:job') == currentJob
		if workingHere then
			local notCancelled = triggerEvent('onJobFinish', root, currentJob)
			if notCancelled then
				exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Zakończono prace')
				setElementData(localPlayer, 'player:job', false)
			end
		elseif not getElementData(localPlayer, 'player:job') then
			if getElementData(localPlayer, 'scooter:rented') then return exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Musisz zwrócić hulajnogę elektryczną przed rozpoczęciem pracy') end
			local notCancelled = triggerEvent('onJobStart', root, currentJob)
			if notCancelled then
				exports['borsuk-notyfikacje']:addNotification('success', 'Sukces', 'Rozpoczęto prace')
				setElementData(localPlayer, 'player:job', currentJob)
				toggleUI(false)
			end
		else
			exports['borsuk-notyfikacje']:addNotification('error', 'Błąd', 'Posiadasz już aktywną prace')
		end
	end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
	eventCallback('onClientClick', root, clickUI)
	showCursor(visible, false)

	if not visible and historyChart and isElement(historyChart) then
		destroyElement(historyChart)
	end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
	if historyChart and isElement(historyChart) then
		destroyElement(historyChart)
	end
end)

function showJobGui(name)
	currentJob = name
	toggleUI(true)

	setTimer(triggerServerEvent, 500, 1, 'requestJobData', resourceRoot, name)
end

-- showJobGui('grzybiarz')