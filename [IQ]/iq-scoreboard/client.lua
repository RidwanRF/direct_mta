local main = {
    ['textures'] = {},
    ['fonts'] = {},
    ['elements'] = {},
    ['toggle'] = false,
    ['players'] = {}
}

local renderTarget, scroll = nil, 0
local scrollSmooth = 0

function render()
    local difference = math.abs(scroll - scrollSmooth)
    scrollSmooth = scrollSmooth + (scroll - scrollSmooth) * 0.1
    if difference > 1 then
        updateRenderTarget()
    end

    dxDrawImage(sx/2-770/zoom/2, sy/2-832/zoom/2, 770/zoom, 832/zoom, main['textures']['bg'])
    dxDrawImage(sx/2 + -361/zoom, sy/2 + -385/zoom, 158/zoom, 29/zoom, main['textures']['logo'])
    dxDrawText(#getElementsByType('player'), sx/2 + 273/zoom, sy/2 + -389/zoom, (sx/2 + 273/zoom) + (64/zoom), (sy/2 + -389/zoom) + (36/zoom), tocolor(255, 255, 255, 229), 1, main['fonts'][2], 'right', 'center')
    dxDrawImage(sx/2 + 345/zoom, sy/2 + -389/zoom + dxGetFontHeight(1,main['fonts'][2])/2 - 15/zoom/2, 20/zoom, 20/zoom, main['textures']['circle'])
    dxDrawImage(sx/2-385/zoom, sy/2-325/zoom, 770/zoom, 735/zoom, renderTarget)
end

function updateRenderTarget()
    if not renderTarget then return end
    dxSetRenderTarget(renderTarget, true)
    dxSetBlendMode('modulate_add')
    table.sort(main['players'], function(a, b)
        return a.id < b.id
    end)
    local offset = 0 - scrollSmooth
    for i,v in pairs(main['players']) do
        offset = offset + 75
        local x, y, w, h = 0,0 - 75 + offset ,770,72
        dxDrawImage(x, y, w, h,main['textures']['player_bg'])
        dxDrawText(v.id, x + 75 / 2, y + 75 / 2, nil, nil, tocolor(255,255,255),1,main['fonts'][3],'center','center')
        dxDrawImage(x + 125 / 2, y + 72 / 2 - 52 / 2, 52, 52, v.avatar)
        dxDrawImage(x + 125 / 2, y + 72 / 2 - 52 / 2, 52, 52, main['textures']['border'], 0,0,0,tocolor(unpack(getRankColor(v.rank))))
        dxDrawText(v.name, x + 129, y + 64 / 2, nil, nil, tocolor(255,255,255),1,main['fonts'][4],'left','center')
        dxDrawImage(x + 129, y + 84 / 2, 13, 13, main['textures'][getStatusIcon(v)])
        dxDrawText(getStatusText(v),x + 145, y + 98 / 2, nil, nil, tocolor(255,255,255,200),1,main['fonts'][5],'left','center')
        dxDrawImage(x + w - 50, y + 72 / 2 - 30 / 2, 26, 20, main['textures']['ping_icon'])
        dxDrawText(v.ping..' ms', x + w - 50 + 26 / 2, y + 72 / 2 + 13, nil, nil, tocolor(255,255,255,230),1,main['fonts'][5],'center','center')
        if (v.spawn) then
            dxDrawText('LEVEL', x + w - 110 + 26 / 2, y + 72 / 2 + 13, nil, nil, tocolor(255,255,255,230),1,main['fonts'][5],'center','center')
            dxDrawText(v.lvl, x + w - 110 + 26 / 2, y + 40 / 2 + 13, nil, nil, tocolor(255,255,255,230),1,main['fonts'][4],'center','center')
        end
        if (v.rank and main['textures'][v.rank]) then
            dxDrawImage(x + 104 / 2, y + 72 / 2 - 52 / 2, 26, 26, main['textures'][v.rank])
        end
    end

    dxSetBlendMode('blend')
    dxSetRenderTarget()
end

function scrollKey(key)
    local maxh = #main['players'] * 75 - 735

    if key == 'mouse_wheel_up' then
        scroll = math.max(0, scroll - 125)
    else
        scroll = math.max(math.min(maxh, scroll + 125), 0)
    end

    updateRenderTarget()
end

bindKey('tab','down',function ()
    if not getElementData(localPlayer,'player:spawn') then return end
    
    if (main['toggle']) then
        main['toggle'] = false
        removeEventHandler('onClientRender',root,render)
        for i,v in pairs(main['textures']) do
            if (isElement(v)) then
                destroyElement(v)
            end
        end
        if (main['elements'][1]) then
            exports['iq-gui']:destroyUIElement(main['elements'][1])
        end
        if (renderID) then
            exports['iq-renders']:destroyTarget(renderID)
            renderData = false
        end

        unbindKey('mouse_wheel_up','down',scrollKey)
        unbindKey('mouse_wheel_down','down',scrollKey)
    else
        main['toggle'] = true
        local c = {
            ['bg'] = true,
            ['logo'] = true,
            ['editbox'] = true,
            ['circle'] = true,
            ['player_bg'] = true,
            ['test_avatar'] = true,
            ['border'] = true,
            ['circle2'] = true,
            ['afk'] = true,
            ['ping_icon'] = true,
            [4] = true,
            [1] = true,
            [3] = true
        }
        scroll = 0
        scroolSmooth = 0

        for i,v in pairs(c) do
            main['textures'][i] = dxCreateTexture('data/images/'..i..'.png','argb',false,'clamp')
        end

        main['fonts'][1] = exports['iq-fonts']:getFont('medium',12/zoom)
        main['fonts'][2] = exports['iq-fonts']:getFont('bold',18/zoom)
        main['fonts'][3] = exports['iq-fonts']:getFont('bold',14)
        main['fonts'][4] = exports['iq-fonts']:getFont('extrabold',11)
        main['fonts'][5] = exports['iq-fonts']:getFont('bold',10)
        main['fonts'][6] = exports['iq-fonts']:getFont('bold',11)
        
        main['players'] = {}

        for i,v in pairs(getElementsByType('player')) do
            table.insert(main['players'], {
                name = getPlayerName(v),
                ping = getPlayerPing(v),
                rank = (getElementData(v,'player:admin') and getElementData(v,'player:admin') or 0),
                id = getElementData(v,'id'),
                afk = getElementData(v, 'user:afk'),
                sid = getElementData(v,'player:sid'),
                lvl = getElementData(v,'player:level'),
                avatar = exports['iq-avatars']:getCircleAvatar((getElementData(v,'player:sid') and getElementData(v,'player:sid') or 0)),
                spawn = getElementData(v,'player:spawn')
            })
        end

        addEventHandler('onClientRender',root,render)
        bindKey('mouse_wheel_up','down',scrollKey)
        bindKey('mouse_wheel_down','down',scrollKey)
        renderTarget = dxCreateRenderTarget(770,735,true)
        updateRenderTarget()

        main['elements'][1] = exports['iq-gui']:createEditbox('Wpisz nick lub ID...', sx/2 + -178/zoom, sy/2 + -393/zoom, 438/zoom, 43/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 15/zoom,
            caretColor = {255, 255, 255, 50},
            caretWidth = 2,
            font = main['fonts'][1],
            image = main['textures']['editbox'],
            placeholderColor = {198, 198, 198},
            specialCharacters = '.*[_].*'
        })
    end
end)

addEventHandler('onClientResourceStop',resourceRoot,function ()
    if (main['elements'][1]) then
        exports['iq-gui']:destroyUIElement(main['elements'][1])
    end
    if (renderID) then
        exports['iq-renders']:destroyTarget(renderID)
        renderData = false
    end
end)

local rankColors = {}
for i = 1, 4 do
    rankColors[i] = exports['borsuk-admin']:getRankRGB(i)
end

function getRankColor(c)
    if not c then return {136, 157, 177} end
    if not rankColors[c] then
        rankColors[c] = exports['borsuk-admin']:getRankRGB(c)
    end

    return rankColors[c] or {136, 157, 177}
end

function getStatusIcon(data)
    return data.afk and 'afk' or 'circle2'
end

function getStatusText(data)
    if (data.working) then
        return 'W pracy'
    elseif (data.afk) then
        return 'AFK'
    elseif ((data.rank and data.rank or 0) > 0) then
        return 'Służba administracyjna'
    elseif (not data.sid) then
        return 'Loguje się'
    else
        return 'W grze'
    end
end

function sort(parametr1, parametr2)
	if isElement(parametr1) and isElement(parametr2) then
		return (parametr1.id or 0) < (parametr2.id or 0)
	end
end
