local maxUpdates = 3
local loading = {
	progress = 0.4,
	update = 1,
	reason = false,
	description = false,
}
a.progress = {0, 0, 100}

local updatesInfos = {
	{
		title = 'Serwis pojazdów',
		description = wordWrap('Pamiętaj o regularnym serwisowaniu swoich pojazdów, wymieniaj w nich płyn chłodniczy, hamulcowy oraz staraj się nie przegrzewać silnika, gdyż może spowodować to jego uszkodzenie!', 560/zoom, 1, getFigmaFont('Inter-Medium', 13.4/zoom)),
	},
	{
		title = 'Zabezpiecz swoje konto',
		description = wordWrap('Uruchom weryfikację dwuetapową w ustawieniach swojego konta w dashboardzie (F5) poprzez Google Authenticator w celu zabezpieczenia swojego konta, przy każdym logowaniu będzie od ciebie wymagany 6-cyfrowy kod', 560/zoom, 1, getFigmaFont('Inter-Medium', 13.4/zoom)),
	},
	{
		title = 'Jazda po zmroku',
		description = wordWrap('Po zmroku uważaj na zwierzęta pojawiające się na drodze, twój pojazd może uledz uszkodzeniu podczas kolizji!', 560/zoom, 1, getFigmaFont('Inter-Medium', 13.4/zoom)),
	},
}

function renderUI()
	if not loading.reason or not loading.description then return end
	showChat(false)

	local function drawDot(x, y, active)
		local size = active and 15/zoom or 11/zoom
		dxDrawImage(x - size/2, y - size/2, size, size, active and textures.dotActive.texture or textures.dot.texture, 0, 0, 0, tocolor(255, 255, 255, 255*a['opacity']), true)
	end

	local function drawUpdate(x, y, w, h, id, opacity, op)
		dxSetShaderValue(loading.shader, 'sPicTexture', textures[tostring(id)].texture)
		dxDrawImage(x, y, w, h, loading.shader, 0, 0, 0, tocolor(255, 255, 255, 255*a['opacity'] * (op or 1)), true)
		dxDrawImage(x, y, w, h, textures[tostring(id)].texture, 0, 0, 0, tocolor(255, 255, 255, 255*a['opacity']*opacity * (op or 1)), true)

		local update = updatesInfos[id]
		if not update then return end
		local description = update.description
		local size = 0.8 + opacity*0.2
		dxDrawText(update.title, x + 18/zoom, y - 12/zoom + h - #description * (22/zoom*size), nil, nil, tocolor(0,0,0,100*opacity*a['opacity']), size, getFigmaFont('Inter-Bold', 19/zoom), 'left', 'bottom', false, false, true)
		dxDrawText(update.title, x + 15/zoom, y - 15/zoom + h - #description * (22/zoom*size), nil, nil, tocolor(255,255,255,255*opacity*a['opacity']), size, getFigmaFont('Inter-Bold', 19/zoom), 'left', 'bottom', false, false, true)
		for k,v in pairs(description) do
			dxDrawText(v, x + 16/zoom, y - 14/zoom + h - #description * (22/zoom*size) + (k-1)*(22/zoom*size), nil, nil, tocolor(0,0,0,100*opacity*a['opacity']), size, getFigmaFont('Inter-Medium', 13.4/zoom), nil, nil, false, false, true)
			dxDrawText(v, x + 15/zoom, y - 15/zoom + h - #description * (22/zoom*size) + (k-1)*(22/zoom*size), nil, nil, tocolor(255,255,255,200*opacity*a['opacity']), size, getFigmaFont('Inter-Medium', 13.4/zoom), nil, nil, false, false, true)
		end
	end

	dxDrawImage(0, 0, sx, sy, textures.background.texture, 0, 0, 0, tocolor(255, 255, 255, 255*a['opacity']), true)
	dxDrawText(loading.reason, sx/2, sy - 100/zoom, nil, nil, tocolor(255, 255, 255, 255*a['opacity']), 1, getFigmaFont('Inter-Regular', 13.3/zoom), 'center', 'bottom', false, true, true)
	dxDrawText(loading.description, sx/2, sy - 75/zoom, nil, nil, tocolor(255, 255, 255, 255*a['opacity']), 1, getFigmaFont('Inter-Regular', 13.3/zoom), 'center', 'bottom', false, true, true, true)
	dxDrawImage(sx/2 + -324/zoom, sy - 60/zoom, 648/zoom, 25/zoom, textures.barbackground.texture, 0, 0, 0, tocolor(255, 255, 255, 255*a['opacity']), true)
	dxDrawImageSection(sx/2 + -321/zoom, sy - 57/zoom, 642/zoom*a.progress, 19/zoom, 0, 0, 642*a.progress, 19, textures.bar.texture, 0, 0, 0, tocolor(255, 255, 255, 255*a['opacity']), true)

	drawDot(sx/2 - 21/zoom, sy/2 + 200/zoom, loading.update == 1)
	drawDot(sx/2, sy/2 + 200/zoom, loading.update == 2)
	drawDot(sx/2 + 21/zoom, sy/2 + 200/zoom, loading.update == 3)
	
	drawUpdate(sx/2 - 850/zoom - 350/zoom*a['update'], sy/2 - 150/zoom + 25/zoom*a['update'], 500/zoom - 100/zoom*a['update'], 300/zoom - 50/zoom*a['update'], (loading.update-1)%maxUpdates+1, 0, 1 - a['update'])
	drawUpdate(sx/2 - 300/zoom - 550/zoom*a['update'], sy/2 - 175/zoom + 25/zoom*a['update'], 600/zoom - 100/zoom*a['update'], 350/zoom - 50/zoom*a['update'], loading.update%maxUpdates+1, 1-a['update'])
	drawUpdate(sx/2 + 350/zoom - 650/zoom*a['update'], sy/2 - 150/zoom - 25/zoom*a['update'], 500/zoom + 100/zoom*a['update'], 300/zoom + 50/zoom*a['update'], (loading.update+1)%maxUpdates+1, a['update'])
	drawUpdate(sx/2 + 700/zoom - 350/zoom*a['update'], sy/2 - 125/zoom - 25/zoom*a['update'], 400/zoom + 100/zoom*a['update'], 250/zoom + 50/zoom*a['update'], (loading.update+2)%maxUpdates+1, 0, a['update'])
end

function nextUpdate()
	a['update'] = {0, 1, 900, 'InOutQuad'}
	loading.update = loading.update + 1
	if loading.update > maxUpdates then
		loading.update = 1
	end
end

function updateVolume()
	if loading.music and isElement(loading.music) then
		local volume = getSoundVolume(loading.music)
		setSoundVolume(loading.music, volume + loading.volumeChange)
	end
end

function toggleUI(visible)
	loading.visible = visible
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI, true, 'low-9999')
	showCursor(visible)
	showChat(not visible)

    if visible then
		loadTextures({
			{'background', 'data/background.png'},
			{'barbackground', 'data/bar-background.png'},
			{'bar', 'data/bar.png'},
			{'dotActive', 'data/dot-active.png'},
			{'dot', 'data/dot.png'},
			{'mask', 'data/mask.png'},
			{'1', 'data/1.png'},
			{'3', 'data/3.png'},
			{'2', 'data/2.png'},
		})

		loading.shader = dxCreateShader('data/mask.fx')
		dxSetShaderValue(loading.shader, 'sMaskTexture', textures.mask.texture)

		a['opacity'] = {0, 1, 500, 'OutQuad'}
		loading.updateTimer = setTimer(nextUpdate, 4000, 0)
		loading.music = playSound('data/music.mp3', true)
		setSoundVolume(loading.music, 0)
		loading.volumeChange = 0.3
		loading.volumeTimer = setTimer(updateVolume, 100, 10)
		nextUpdate()
    else
        unloadTextures()
		if loading.shader and isElement(loading.shader) then destroyElement(loading.shader) end
		if loading.music and isElement(loading.music) then destroyElement(loading.music) end
		if loading.updateTimer and isTimer(loading.updateTimer) then killTimer(loading.updateTimer) end
		if loading.volumeTimer and isTimer(loading.volumeTimer) then killTimer(loading.volumeTimer) end
    end
end

function hideLoading()
	a['opacity'] = {a['opacity'] or 1, 0, 500, 'OutQuad'}
	setTimer(toggleUI, 500, 1, false)
	setSoundVolume(loading.music, 3)
	loading.volumeChange = -0.3
	loading.volumeTimer = setTimer(updateVolume, 100, 10)
end

function showLoading(reason, description, time)
	loading.reason = reason
	loading.description = description
	if not loading.visible then
		toggleUI(true)
	end

	if loading.hideTimer and isTimer(loading.hideTimer) then
		killTimer(loading.hideTimer)
	end

	if time then
		loading.hideTimer = setTimer(hideLoading, time, 1)
	end
end

function isActive()
	return loading.visible
end

function setText(a, b)
	loading.reason = a
	if b then loading.description = b end
end

function setProgress(progress)
	a.progress = {a.progress or 0, progress, 300, 'OutQuad'}
end

local download = {
	last = false,
	speed = 0,
	current = false
}

setTimer(function()
	download.current = download.speed*2
	download.speed = 0
end, 500, 0)

addEventHandler("onClientTransferBoxProgressChange", root, function(downloadedSize, totalSize)
	if not loading.visible then
		showLoading('', '')
	end

    local progress = math.min(downloadedSize / totalSize, 1)
    setProgress(progress)
	loading.reason = 'Trwa pobieranie zasobów'

	if download.current then
		loading.description = ('Zasoby są pobieranie z prędkością #E8C773%.2fmb/s'):format(download.current/1024/1024)
	else
		loading.description = 'Trwa obliczanie prędkości pobierania...'
	end

	download.last = download.last or downloadedSize
	download.speed = download.speed + (downloadedSize - download.last)
	download.last = downloadedSize

	setTransferBoxVisible(false)
end)

addEventHandler("onClientTransferBoxVisibilityChange", root, function(isVisible)
    if loading.visible and loading.reason == 'Trwa pobieranie zasobów' and not isVisible then
		hideLoading()
	end
end)

-- showLoading('Ładowanie...', 'Trwa wczytywanie interioru', 2500)