local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

setPlayerHudComponentVisible('all',false)

local main = {
    ['textures'] = {
        ['border'] = dxCreateTexture('data/images/border.png','argb',false,'clamp'),
        ['level_bg'] = dxCreateTexture('data/images/level_bg.png','argb',false,'clamp'),
        ['money_bg'] = dxCreateTexture('data/images/money_bg.png','argb',false,'clamp')
    },
    ['fonts'] = {
        [1] = exports['iq-fonts']:getFont('bold',9/zoom),
        [2] = exports['iq-fonts']:getFont('medium',12/zoom)
    }
}

local fps = 0
local timer = 0
local currentFPS = 0

function getCurrentFPS()
	timer = timer + 1

	if timer >= 30 then
		timer = 0
        currentFPS = fps
    	return currentFPS
	end
end

local function updateFPS(msSinceLastFrame)
    fps = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

addEventHandler('onClientRender',root,function ()
    if not getElementData(localPlayer, 'player:spawn') or getElementData(localPlayer, 'player:hudof') then
        return
    end
    local exp = 40
    local lvl = getElementData(localPlayer,'player:level') or 0
    local health = getElementHealth(localPlayer)
    dxDrawImage(sx - 183.999/zoom, 40.000/zoom, 149/zoom, 149/zoom, main['textures']['border'])
    dxDrawImage(sx - 183.999/zoom + 10/zoom/2, 40.000/zoom + 10/zoom/2, 139/zoom, 139/zoom, exports['iq-avatars']:getCircleAvatar(getElementData(localPlayer,'player:sid')))
    dxCircle(sx - 108/zoom - 6.5/zoom, 114/zoom + 2/zoom, 154.5/zoom, 150.5/zoom, tocolor(42, 42, 42), 90, 120, 7/zoom, 1)
    dxCircle(sx - 108/zoom - 6.5/zoom, 114/zoom + 2/zoom, 154.5/zoom, 150.5/zoom, tocolor(218, 74, 74), 90, 120*health/100, 7/zoom, 1)
    dxCircle(sx - 109.5/zoom, 114/zoom, 150.5/zoom, 150.5/zoom, tocolor(255, 177, 85), 90, 360*exp/100, 7/zoom, 1)
    dxDrawImage(sx - 183.999/zoom + 149/zoom/2 - 30/zoom/2, 40.000/zoom + 134/zoom, 30/zoom, 30/zoom, main['textures']['level_bg'])
    dxDrawText(lvl,sx - 185/zoom + 149/zoom/2 - 30/zoom/2 + 33/zoom/2, 41.000/zoom + 134/zoom + 30/zoom/2, nil, nil, white, 1, main['fonts'][1],'center','center')
    local money = addCommas(getPlayerMoney(localPlayer))
    local w = 25/zoom + dxGetTextWidth(money, 1, main['fonts'][2])
    dxDrawImage(sx - 184/zoom + 149/zoom/2 - w/2, 208/zoom, w, 19/zoom, main['textures']['money_bg'])
    dxDrawText(money..' #D69547$',sx - 183.999/zoom + 149/zoom/2, 215/zoom, nil, nil, tocolor(255,255,255,200),1,main['fonts'][2],'center','center',false,false,false,true)
    
    local shaders = getElementData(localPlayer, 'player:shaders') or {}
    if shaders['fps'] then
        local actualFPS = math.floor(getCurrentFPS() or currentFPS)
    
        dxDrawText(""..actualFPS.."\nFPS", sx - 9/zoom, 12/zoom, nil, nil, tocolor(0, 0, 0, 225), 1, main['fonts'][1], "right", "top", false, false, false, true)
        dxDrawText("#FFB470"..actualFPS.."#ffffff\nFPS", sx - 10/zoom, 10/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, main['fonts'][1], "right", "top", false, false, false, true)
    end
end)