local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local main = {
    ['toggled'] = false,
    ['tasks'] = {},
    ['fonts'] = {
        [1] = exports['iq-fonts']:getFont('bold',14/zoom),
        [2] = exports['iq-fonts']:getFont('medium',12/zoom)
    },
    ['textures'] = {
        [1] = dxCreateTexture('data/images/bg.png','argb',false,'clamp')
    }
}

function render()
    -- dxDrawImage(sx-40/zoom - 225/zoom,250/zoom,225/zoom,219/zoom,main['textures'][1])
    dxDrawText('Cele',sx-40/zoom,300/zoom,nil,nil,tocolor(255,180,98),1,main['fonts'][1],'right','center')
    local offset = 0
    for i,v in pairs(main['tasks']) do
        offset = offset + dxGetFontHeight(1,main['fonts'][2])
        dxDrawText(v.name,sx-40/zoom,300/zoom+offset,nil,nil,tocolor(unpack((v.actived and {200,200,200} or {255,255,255}))),1,main['fonts'][2],'right','center')
        if not v.w then v.w = 0 end
        dxDrawRectangle(sx-40/zoom - v.w, 300/zoom+offset + dxGetFontHeight(1,main['fonts'][2]) - dxGetFontHeight(1,main['fonts'][2]), v.w, 1,tocolor(255,255,255,200))
    end
end

function setTaskActived(id, bool)
    if (bool and main['tasks'][id]) then
        main['tasks'][id].actived = true
        animate(0,dxGetTextWidth(main['tasks'][id].name, 1, main['fonts'][2]),'InOutQuad',300,function (c)
            main['tasks'][id].w = c
        end)
    end
end

function createTask(data)
    if not main['toggle'] then
        main['toggle'] = true
        addEventHandler('onClientRender',root,render)
    end
    main['tasks'] = data
end

-- createTask({
--     {
--         name = "Wejdz w marker"
--     },
--     {
--         name = "Wyruchaj zuzie borsuka"
--     },
--     {
--         name = "huj"
--     }
-- })

-- local marker = createMarker(2891.02, -654.28, 10.84 - 1, 'cylinder', 2.5, 255,255,255,50)
-- setElementData(marker,'marker:desc','Wejdz w marker')
-- setElementData(marker,'marker:title','Kurwo zadanie')

-- addEventHandler('onClientMarkerHit',marker,function (plr)
--     if (plr ~= localPlayer) then return end
--     setTaskActived(1,true)
-- end)

-- local marker2 = createMarker(2893.16, -648.97, 10.84 - 1, 'cylinder', 2.5, 255,255,255,50)
-- setElementData(marker,'marker:desc','Wejdz w marker')
-- setElementData(marker,'marker:title','Kurwo zadanie')

-- addEventHandler('onClientMarkerHit',marker2,function (plr)
--     if (plr ~= localPlayer) then return end
--     setTaskActived(2,true)
-- end)

-- local marker3 = createMarker(2893.68, -641.72, 10.84 - 1, 'cylinder', 2.5, 255,255,255,50)
-- setElementData(marker,'marker:desc','Wejdz w marker')
-- setElementData(marker,'marker:title','Kurwo zadanie')

-- addEventHandler('onClientMarkerHit',marker3,function (plr)
--     if (plr ~= localPlayer) then return end
--     setTaskActived(3,true)
-- end)