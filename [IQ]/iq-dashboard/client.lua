sx,sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

main = {
    ['textures'] = {},
    ['fonts'] = {},
    ['toggle'] = false,
    ['page'] = false,
    ['avatar'] = false,
    ['y'] = 0,
    ['animation'] = false,
    ['alpha'] = 0
}

function render()
    exports['iq-blur']:dxDrawBlur(0,0,sx,sy,main['textures']['mask'])
    dxDrawImage(0,0,sx,sy,main['textures']['background'])
    dxDrawImage(53/zoom, sy/2-(sy - 100/zoom)/2, 350.000/zoom, sy - 100/zoom,main['textures']['pages_bg'])
    dxDrawImage(80/zoom, sy/2-(sy - 100/zoom)/2 + 54/zoom/2, 81/zoom, 81/zoom, main['avatar'])
    dxDrawText(getPlayerName(localPlayer),80/zoom + 95/zoom, sy/2-(sy - 100/zoom)/2 + 54/zoom/2 + 81/zoom/2 - dxGetFontHeight(1,main['fonts'][2])/2, nil, nil, white, 1, main['fonts'][2], 'left', 'center')
    dxDrawText((getElementData(localPlayer,'player:admin') and exports['borsuk-admin']:getRankName(getElementData(localPlayer,'player:admin')) or 'Gracz'),80/zoom + 95/zoom, sy/2-(sy - 100/zoom)/2 + 54/zoom/2 + 81/zoom/2 + dxGetFontHeight(1,main['fonts'][2])/2, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center')
    local offset = 0
    for i,v in pairs(main['pages']) do
        offset = offset + 75/zoom
        dxDrawImage(80/zoom, 115/zoom + offset, 295/zoom, 60/zoom, main['textures']['page'])
        dxDrawImage(80/zoom, main['y'], 295/zoom, 60/zoom, main['textures']['button_hovered'])
        dxDrawImage(80/zoom, 115/zoom + offset, 295/zoom, 60/zoom, main['textures']['button_hovered'],0,0,0,tocolor(255,255,255,v.alpha)) 
        if (main['page'] ~= i) then
            if not v.alpha then v.alpha = 0 end
            if (isMouseInPosition(80/zoom, 115/zoom + offset, 295/zoom, 60/zoom) and not v.animation) then
                animate(v.alpha,200,'InOutQuad',70,function (c)
                    v.alpha = c
                end)
            else
                if (v.alpha > 0) then
                    animate(v.alpha,0,'InOutQuad',70,function (c)
                        v.alpha = c
                    end)
                end
            end
        end
        dxDrawImage(85/zoom + 24/zoom/2, 115/zoom + offset + 60/zoom/2 - 24/zoom/2, 24/zoom, 24/zoom, main['textures'][v.icon],0,0,0,white,true)
        dxDrawText(v.name, 85/zoom + 24/zoom/2 + 31/zoom, 115/zoom + offset + 60/zoom/2 - 24/zoom/2 + 26/zoom/2, nil, nil, tocolor(255,255,255),1,main['fonts'][1],'left','center',false,false,true)
    end
    main['pages'][main['page']].render()
end

function click(btn,state)
    if (btn == 'left' and state == 'down') then
        local offset = 0
        for i,v in pairs(main['pages']) do
            offset = offset + 75/zoom
            if (isMouseInPosition(80/zoom, 115/zoom + offset, 295/zoom, 60/zoom) and not main['animation'] and main['page'] ~= i) then
                main['animation'] = true
                animate(main['alpha'],0,'InOutQuad',200,function (c)
                    main['alpha'] = c
                end,function ()
                    main['page'] = i
                    animate(main['alpha'],255,'InOutQuad',200,function (c)
                        main['alpha'] = c
                    end)
                end)
                animate(main['y'],115/zoom + 75/zoom * (i),'InOutQuad',400,function (c)
                    main['y'] = c
                end,function ()
                    main['animation'] = false
                end)
            end
        end
    end
end

bindKey('f5','down',function ()
    if not getElementData(localPlayer,'player:spawn') then return end
    if (main['toggle']) then
        main['toggle'] = false
        showChat(true)
        showCursor(false)
        removeEventHandler('onClientRender',root,render)
        removeEventHandler('onClientClick',root,click)
        main['pages'][main['page']].leave()
        for i,v in pairs(main['textures']) do
            if (isElement(v)) then
                destroyElement(v)
            end
        end
        for i,v in pairs(main['fonts']) do
            if (isElement(v)) then
                destroyElement(v)
            end
        end
    else
        main['avatar'] = exports['iq-avatars']:getCircleAvatar(getElementData(localPlayer,'player:sid'))
        showChat(false)
        showCursor(true)
        local c = {
            ['background'] = true,
            ['mask'] = true,
            ['pages_bg'] = true,
            ['page'] = true,
            ['main'] = true,
            ['dailyTask'] = true,
            ['button_hovered'] = true,
            ['dailyAward'] = true,
            ['account_data_bg'] = true,
            ['task_bg'] = true,
            ['task_progress_bg'] = true,
            ['task_progress'] = true,
            ['level_bg'] = true,
            ['level_progress'] = true,
            ['actions_bg'] = true,
            ['action_bg'] = true,
            ['skin_mask'] = true
        }
        for i,v in pairs(c) do
            main['textures'][i] = dxCreateTexture('data/images/'..i..'.png','argb',false,'clamp')
        end
        main['alpha'] = 255
        main['fonts'][1] = exports['iq-fonts']:getFont('medium',14/zoom)
        main['fonts'][2] = exports['iq-fonts']:getFont('medium',13/zoom)
        main['fonts'][3] = exports['iq-fonts']:getFont('bold',13.333333333333334/zoom)
        main['fonts'][4] = exports['iq-fonts']:getFont('bold',14.666666666666666/zoom)
        main['fonts'][5] = exports['iq-fonts']:getFont('medium',10.666666666666666/zoom)
        main['fonts'][6] = exports['iq-fonts']:getFont('medium',11.333333333333334/zoom)
        main['fonts'][7] = exports['iq-fonts']:getFont('bold',11.333333333333334/zoom)
        main['fonts'][8] = exports['iq-fonts']:getFont('medium',9.333333333333334/zoom)
        main['toggle'] = true
        addEventHandler('onClientRender',root,render)
        addEventHandler('onClientClick',root,click)
        main['pages'] = pages
        main['page'] = 1
        main['pages'][main['page']].enter()
        main['y'] = 115/zoom + 74/zoom
    end
end)

addEventHandler('onClientResourceStop',resourceRoot,function ()
    if (main['toggle']) then
        main['pages'][main['page']].leave()
    end
end)
