local reason = ''
local admin = ''

local function renderUI()
	dxDrawImage(0, 0, sx, sy, 'data/overlay.png')

	dxDrawText('OTRZYMAŁEŚ OSTRZEŻENIE!', sx/2 + 3, sy/2 - 47/zoom + 3, nil, nil, 0x99000000, 1, getFigmaFont('Inter-Black', 54/zoom), 'center', 'bottom')
	dxDrawText('Powód: ' .. reason .. '\nAdministrator: ' .. admin, sx/2 + 2, sy/2 + 36/zoom + 2, nil, nil, 0x44000000, 1, getFigmaFont('Inter-Bold', 23.333/zoom), 'center', 'center')
	dxDrawText('Nie stosowanie się do ostrzeżeń może skutkować kickiem lub banem!', sx/2 + 2, sy/2 + 113/zoom + 2, nil, nil, 0x44000000, 1, getFigmaFont('Inter-Bold', 16.666/zoom), 'center', 'top')

	dxDrawText('OTRZYMAŁEŚ OSTRZEŻENIE!', sx/2, sy/2 - 47/zoom, nil, nil, white, 1, getFigmaFont('Inter-Black', 54/zoom), 'center', 'bottom')
	dxDrawText('Powód: ' .. reason .. '\nAdministrator: ' .. admin, sx/2, sy/2 + 36/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 23.333/zoom), 'center', 'center')
	dxDrawText('Nie stosowanie się do ostrzeżeń może skutkować kickiem lub banem!', sx/2, sy/2 + 113/zoom, nil, nil, white, 1, getFigmaFont('Inter-Bold', 16.666/zoom), 'center', 'top')

	dxDrawImage(sx/2 - 594/zoom, sy/2 - 54/zoom, 1187/zoom, 5/zoom, 'data/bar.png')
end

local function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI, true, 'low-99999')
end

function showWarn(adminText, reasonText)
    reason = reasonText
    admin = adminText

    toggleUI(true)
    playSound('data/warn.mp3')

    setTimer(toggleUI, 10000, 1, false)
end

addEvent('onClientShowWarn', true)
addEventHandler('onClientShowWarn', resourceRoot, showWarn)