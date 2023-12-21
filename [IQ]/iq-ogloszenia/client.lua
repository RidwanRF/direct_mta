local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local main = {
    ['textures'] = {
        ['bg'] = dxCreateTexture('data/images/bg.png','argb',false,'clamp'),
        ['mask'] = dxCreateTexture('data/images/mask.png','argb',false,'clamp')
    },
    ['fonts'] = {
        [1] = exports['figma']:getFont('Inter-Black',19.333333333333332/zoom),
        [2] = exports['figma']:getFont('Inter-Medium',13/zoom),
        [3] = exports['figma']:getFont('Inter-Bold',13.333333333333334/zoom),
        [4] = exports['figma']:getFont('Inter-Medium',12/zoom)
    },
    ['data'] = {},
    ['pos'] = sy + 124/zoom
}

function render()
    dxDrawImage(sx/2 + -277/zoom, main['pos'], 553/zoom, 124/zoom, main['textures']['bg'])
    dxDrawImage(sx/2 + -277/zoom, main['pos'], 124/zoom, 124/zoom, exports['iq-avatars']:getPlayerAvatar(main['data'].sid, main['textures']['mask']))
    dxDrawText(main['data'].id, sx/2 + -277/zoom + 124/zoom/2, main['pos'] + 124/zoom/2 + 5/zoom, nil, nil, tocolor(255, 182, 97, 255), 1, main['fonts'][1], 'center', 'bottom')
    dxDrawText(main['data'].name, sx/2 + -277/zoom + 124/zoom/2, main['pos'] + 155/zoom/2 + 5/zoom, nil, nil, white, 1, main['fonts'][2], 'center', 'bottom')
    dxDrawText('Ogłoszenie premium', sx/2 + 58/zoom, main['pos'] + 35/zoom, (sx/2 + 58/zoom) + (204/zoom),nil, tocolor(255, 182, 97, 255), 1, main['fonts'][3], 'right', 'bottom')
    if (not main['data'].wrap) then
        main['data'].wrap = wordWrap(main['data'].description, 400/zoom, 1, main['fonts'][4])
    end
    local offset = 0
    for i=1,#main['data'].wrap do
        offset = offset + dxGetFontHeight(1,main['fonts'][4])
        dxDrawText(main['data'].wrap[i],sx/2 + 58/zoom,main['pos'] + 35/zoom + offset,(sx/2 + 58/zoom) + (204/zoom),nil,tocolor(255,255,255,200),1,main['fonts'][4],'right','bottom')
    end
end


function createAD(name, sid, description, id)
    main['data'] = {
        name = name,
        sid = sid,
        description = description,
        id = id
    }
    addEventHandler('onClientRender',root,render)
    animate(main['pos'],sy - 161/zoom,'InOutQuad',500, function (c)
        main['pos'] = c
    end)

    setTimer(function ()
        animate(main['pos'],sy + 124/zoom,'InOutQuad',500, function (c)
            main['pos'] = c
        end,function ()
            removeEventHandler('onClientRender',root,render)
            main['data'] = {}
        end)
    end,10000,1)
end

addEvent('createAd',true)
addEventHandler('createAd',root,function (nick,description,sid, id)
    createAD(nick,sid,description,id)
end)

-- createAD('borsuczyna',1, 'Sprzedam moje własne dziewictwo. Chętnych zapraszam do napisania wiadomości prywatnej. Nie odpisuje na wiadomości typu “pokaż cipcie” czy “hej piękna, poznamy sie?”. Z poważaniem Katarzyna S.',2)