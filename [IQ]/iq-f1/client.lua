sx,sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

main = {
    ['textures'] = {},
    ['fonts'] = {},
    ['toggle'] = false,
    ['page'] = false,
    ['pages'] = pages,
    ['y'] = sy/2 - 131/zoom - 47/zoom,
    ['animation'] = false,
    ['alpha'] = 255
}


function render()
    dxDrawImage(sx/2-900/zoom/2,sy/2-480/zoom/2,900/zoom,480/zoom,main['textures']['bg'])
    dxDrawText('directMTA | '..main['pages'][main['page']].name..'', sx/2 + -416/zoom, sy/2 + -225/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][1], 'left', 'top')
    local offset = 0
    for i,v in pairs(main['pages']) do
        offset = offset + 47/zoom
        dxDrawImage(sx/2 - 425/zoom, sy/2 - 131/zoom + offset - 47/zoom * 2, 230/zoom, 40/zoom, main['textures']['page_bg'])
        dxDrawImage(sx/2 - 425/zoom, main['y'], 230/zoom, 40/zoom, main['textures']['page_selected'])
        dxDrawImage(sx/2 + -416/zoom, sy/2 + -170/zoom + offset - 47/zoom, 24/zoom, 24/zoom,main['textures'][v.icon],0,0,0,white,true)
        dxDrawText(v.name, sx/2 + -382/zoom, sy/2 + -172/zoom + offset - 47/zoom, nil, nil, tocolor(232, 232, 232, 255), 1, main['fonts'][2], 'left', 'top',false,false,true)
        dxDrawText(v.description, sx/2 + -382/zoom, sy/2 + -159/zoom + offset - 47/zoom, nil, nil, tocolor(232, 232, 232, 255), 1, main['fonts'][3], 'left', 'top',false,false,true)
    end
    main['pages'][main['page']].render()
end

function click(btn,state)
    if (btn == 'left' and state == 'down' and not main['animation']) then
        local offset = 0
        for i,v in pairs(main['pages']) do
            offset = offset + 47/zoom
            if (isMouseInPosition(sx/2 - 425/zoom, sy/2 - 131/zoom + offset - 47/zoom * 2, 230/zoom, 40/zoom) and main['page'] ~= i) then
                main['animation'] = true
                animate(255,0,'InOutQuad',200,function (c)
                    main['alpha'] = c
                end,function ()
                    main['page'] = i
                    animate(0,255,'InOutQuad',200,function (c)
                        main['alpha'] = c
                    end)
                end)
                animate(main['y'],sy/2 - 131/zoom - 47/zoom + 47/zoom * (i - 1),'InOutQuad',400,function (c)
                    main['y'] = c
                end,function ()
                    main['animation'] = false
                end)
            end
        end
    end
end

bindKey('f1','down',function ()
    if (main['animation']) then return end
    if not getElementData(localPlayer,'player:spawn') then return end
    
    if (main['toggle']) then
        main['toggle'] = false
        removeEventHandler('onClientRender',root,render)
        removeEventHandler('onClientClick',root,click)
        showCursor(false)
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
        main['alpha'] = 255
        main['page'] = 1
        main['y'] = sy/2 - 131/zoom - 47/zoom
        local c = {
            ['bg'] = true,
            ['page_bg'] = true,
            ['page_selected'] = true,
            ['info'] = true,
            ['premium'] = true,
            ['authors'] = true,
            ['bg_howstart'] = true,
            ['work_bg'] = true,
            ['premium_bg'] = true,
            ['authors_bg'] = true
        }
        for i,v in pairs(c) do
            main['textures'][i] = dxCreateTexture('data/images/'..i..'.png','argb',false,'clamp')
        end
        main['fonts'][1] = exports['iq-fonts']:getFont('bold',12/zoom)
        main['fonts'][2] = exports['iq-fonts']:getFont('bold',9.333333333333334/zoom)
        main['fonts'][3] = exports['iq-fonts']:getFont('medium',9/zoom)
        main['fonts'][4] = exports['iq-fonts']:getFont('bold',11/zoom)
        main['fonts'][5] = exports['iq-fonts']:getFont('medium',10/zoom)
        main['toggle'] = true
        addEventHandler('onClientRender',root,render)
        addEventHandler('onClientClick',root,click)
        showCursor(true)
    end
end)