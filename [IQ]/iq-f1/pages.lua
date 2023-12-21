startGuide = "Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris. Maecenas vitae mattis tellus. Nullam quis imperdiet augue. Vestibulum auctor ornare leo, non suscipit magna interdum eu. Curabitur pellentesque nibh nibh, at maximus ante fermentum sit amet. Pellentesque commodo lacus at sodales sodales. Quisque sagittis orci ut diam condimentum, vel euismod erat placerat. In iaculis arcu eros, eget tempus orci facilisis id. Praesent lorem orci, mattis non efficitur id, ultricies vel. Phasellus ultricies dignissim nibh ut cursus. Nam et quam sit amet turpis finibus maximus tempor eget augue. Aenean at ultricies lorem. Sed egestas ligula tortor, sit amet mattis ex feugiat non. Duis purus diam, dictum et ante. Phasellus ultricies dignissim nibh ut cursus. Nam et quam sit amet turpis finibus maximus tempor eget augue. Aenean at ultricies lorem. Sed egestas ligula tortor, sit amet mattis ex feugiat non. Duis purus diam, dictum et ante. sit amet mattis ex feugiat non. Duis purus diam, dictum et ante. sit amet mattis ex feugiat non. Duis purus diam, dictum et"

pages = {
    {
        name = "Przewodnik",
        description = "Podstawowe informacje",
        icon = 'info',
        render = function ()
            dxDrawImage(sx/2 - 134/zoom, sy/2 - 215/zoom, 547/zoom, 310/zoom, main['textures']['bg_howstart'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Jak zacząć?', sx/2 + -90/zoom, sy/2 + -202/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')
            if (not wrapGuide) then
                wrapGuide = wordWrap(startGuide, 530/zoom, 1, main['fonts'][5])
            end

            local offset = 0
            for i=1,#wrapGuide do
                offset = offset + dxGetFontHeight(1,main['fonts'][5])
                dxDrawText(wrapGuide[i],sx/2 + -123/zoom, sy/2 + -161/zoom + offset - dxGetFontHeight(1,main['fonts'][5]), nil,nil,tocolor(255,255,255,main['alpha']*0.9),1,main['fonts'][5],'left','center')
            end

            dxDrawImage(sx/2 - 134/zoom, sy/2 + 107/zoom, 547/zoom, 106/zoom, main['textures']['work_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Prace dorywcze', sx/2 + -90/zoom, sy/2 + 120/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')
            dxDrawText('Na naszym serwerze znajdziecie prace np: karmienia zuzi oraz wiele wiecej', sx/2 + -123/zoom, sy/2 + 161/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')
        end
    },
    {
        name = "Premium",
        description = "Informacje o statusie premium",
        icon = 'premium',
        render = function ()
            dxDrawImage(sx/2 - 134/zoom, sy/2 - 215/zoom, 547/zoom, 310/zoom, main['textures']['premium_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Cennik punktow premium', sx/2 + -90/zoom, sy/2 + -202/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')

            if (not wrapGuide) then
                wrapGuide = wordWrap(startGuide, 530/zoom, 1, main['fonts'][5])
            end

            local offset = 0
            for i=1,#wrapGuide do
                offset = offset + dxGetFontHeight(1,main['fonts'][5])
                dxDrawText(wrapGuide[i],sx/2 + -123/zoom, sy/2 + -161/zoom + offset - dxGetFontHeight(1,main['fonts'][5]), nil,nil,tocolor(255,255,255,main['alpha']*0.9),1,main['fonts'][5],'left','center')
            end
        end
    },
    {
        name = "Autorzy",
        description = "Autorzy serwera",
        icon = 'authors',
        render = function ()
            dxDrawImage(sx/2 - 134/zoom, sy/2 + 107/zoom - 325/zoom, 547/zoom, 82/zoom, main['textures']['authors_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Programisci', sx/2 + -90/zoom, sy/2 + 120/zoom - 321/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')
            dxDrawText('IQ, borsuk, zexty', sx/2 + -123/zoom, sy/2 + 161/zoom - 322/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')

            dxDrawImage(sx/2 - 134/zoom, sy/2 + 107/zoom - 325/zoom + 100/zoom, 547/zoom, 82/zoom, main['textures']['authors_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Mapperzy', sx/2 + -90/zoom, sy/2 + 120/zoom - 321/zoom + 100/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')
            dxDrawText('zevy', sx/2 + -123/zoom, sy/2 + 161/zoom - 322/zoom + 100/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')

            dxDrawImage(sx/2 - 134/zoom, sy/2 + 107/zoom - 325/zoom + 100/zoom + 100/zoom, 547/zoom, 82/zoom, main['textures']['authors_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Graficy', sx/2 + -90/zoom, sy/2 + 120/zoom - 321/zoom + 100/zoom + 100/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')
            dxDrawText('zexty, zevy', sx/2 + -123/zoom, sy/2 + 161/zoom - 322/zoom + 100/zoom + 100/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')
            
            dxDrawImage(sx/2 - 134/zoom, sy/2 + 107/zoom - 325/zoom + 100/zoom + 100/zoom + 100/zoom, 547/zoom, 82/zoom, main['textures']['authors_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Modelerzy', sx/2 + -90/zoom, sy/2 + 120/zoom - 321/zoom + 100/zoom + 100/zoom + 100/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][4], 'left', 'top')
            dxDrawText('zevy', sx/2 + -123/zoom, sy/2 + 161/zoom - 322/zoom + 100/zoom + 100/zoom + 100/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')
        end
    }
}