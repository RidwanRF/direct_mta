local main = {
    ['textures'] = {},
    ['fonts'] = {},
    ['elements'] = {},
    ['alpha'] = 0,
    ['animation'] = false,
    ['page'] = false,
    ['y'] = sy/2 + 130/zoom,
    ['text'] = 'Nie posiadasz swojego konta? Załóż je już teraz!\n#FBA44AKliknij tutaj',
    ['updates'] = {
        {
            title = 'Nowy spawn',
            description = 'jebać dyzia mefedroniarza // kry 50zł na białymstoku za 30 minut',
            texture = 'update_image1'
        },
        {
            title = 'Nowe podmianki',
            description = 'Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew Od teraz mozemy was jebac na pieniadzew',
            texture = 'update_image2'
        }
    },
    ['update'] = 1,
    ['updateProgress'] = 0,
    ['alpha2'] = 0,
    ['spawns'] = {
        {
            name = 'San Fierro, Przechowalnia',
            description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ornare ante nec lacus dapibu.',
            pos = {-2682.93, -5.42, 6.13},
            camera = {-2761.4382324219,-69.588401794434,55.189300537109,-2760.6928710938,-69.090255737305,54.746364593506}
        },
        {
            name = 'Blueberry',
            description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ornare ante nec lacus dapibus.',
            pos = {184.40, -167.43, 1.43},
            camera = {186.74240112305,-241.55340576172,42.745800018311,186.71273803711,-240.84210205078,42.043544769287}
        },
        {
            name = 'San Fierro, Przechowalnia',
            description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ornare ante nec lacus dapibus.',
            pos = {1477.64, -1703.41, 14.05},
            camera = {1478.8640136719,-1748.8618164062,28.939500808716,1478.8779296875,-1747.9526367188,28.523386001587}
        }
    },
    ['screenSource'] = false,
    ['spawn'] = 1,
}

function render()
    if isCursorShowing() then
        showChat(false)
    end
    dxDrawImage(0,0,sx,sy,main['textures']['background'])
    dxDrawImage(sx/2 + -796/zoom, sy/2 + -377/zoom, 522/zoom, 711/zoom, main['textures']['login_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
    dxDrawImage(sx/2 + -802/zoom + 522/zoom/2 - 391/zoom/2, sy/2 + -335/zoom, 391/zoom, 181/zoom/zoom, main['textures']['logo'],0,0,0,tocolor(255,255,255,main['alpha']))
    dxDrawText(main['text'], sx/2 + -713/zoom, main['y'], (sx/2 + -713/zoom) + (356/zoom), (main['y']) + (20/zoom), tocolor(255, 255, 255, main['alpha'] *0.7), 1, main['fonts'][2], 'center', 'bottom',false,false,false,true)
    dxDrawImage(sx/2 + -248/zoom, sy/2 + -377/zoom, 1040/zoom, 711/zoom, main['textures']['update_bg'], 0,0,0,tocolor(255,255,255,main['alpha']))

    local function drawUpdate(x, y, w, h, id)
        local title, description, texture = main['updates'][id].title, main['updates'][id].description, main['updates'][id].texture
        
        dxDrawImage(x,y,w,h,main['textures'][texture],0,0,0,tocolor(255,255,255,main['alpha']))
        dxDrawImage(x,y,w,h,main['textures']['update'],0,0,0,tocolor(255,255,255,main['alpha']))

        if (not main['updates'][id].wrap) then
            main['updates'][id].wrap = wordWrap(description, 1200/zoom, 1, main['fonts'][1])
        end

        local yText = y + h - dxGetFontHeight(1,main['fonts'][1]) - dxGetFontHeight(1,main['fonts'][1]) * #main['updates'][id].wrap
        local offset = 0

        for i=1,#main['updates'][id].wrap do
            offset = offset + dxGetFontHeight(1,main['fonts'][1])
            dxDrawText(main['updates'][id].wrap[i], x + dxGetFontHeight(1,main['fonts'][1]),yText - 15/zoom+offset, nil,nil, tocolor(255,255,255,main['alpha']*0.8),1,main['fonts'][2],'left','center')
        end
        
        dxDrawImage(sx/2 + -240/zoom, sy/2 + 316/zoom, 1024/zoom, 10/zoom, main['textures']['bar_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
        dxDrawImage(sx/2 + -240/zoom, sy/2 + 316/zoom, 1024/zoom * main['updateProgress'] / 100, 10/zoom, main['textures']['bar'],0,0,0,tocolor(255,255,255,main['alpha']))

        dxDrawText(title, x + dxGetFontHeight(1,main['fonts'][1]), yText - dxGetFontHeight(1,main['fonts'][3]) + 9/zoom, nil, nil, tocolor(255,255,255,main['alpha']),1,main['fonts'][3],'left','center')
    end

    drawUpdate(sx/2 + -248/zoom, sy/2 + -377/zoom, 1040/zoom, 711/zoom, main['update'])

    if (main['page'] == 3) then
        dxDrawImage(sx/2 + -796/zoom, sy/2 + -377/zoom, 522/zoom, 711/zoom, main['textures']['login_bg'],0,0,0,tocolor(255,255,255,main['alpha2']))
        dxDrawText('Gdzie lecimy?', sx/2 + -758/zoom, sy/2 + -349/zoom, (sx/2 + -758/zoom) + (153/zoom), (sy/2 + -349/zoom) + (29/zoom), tocolor(255, 255, 255, main['alpha2']*0.7), 1, main['fonts'][3], 'left', 'bottom')
        dxDrawText('Wybierz miejsce spawnu', sx/2 + -758/zoom, sy/2 + -327/zoom, (sx/2 + -758/zoom) + (213/zoom), (sy/2 + -327/zoom) + (24/zoom), tocolor(255, 255, 255, main['alpha2']*0.7), 1, main['fonts'][2], 'left', 'bottom')
        dxDrawImage(sx/2 + -248/zoom, sy/2 + -377/zoom, 1040/zoom, 711/zoom, main['textures']['update_bg'], 0,0,0,tocolor(255,255,255,main['alpha2']))
        dxDrawImage(sx/2 + -248/zoom, sy/2 + -377/zoom, 1040/zoom, 711/zoom,main['textures']['update'],0,0,0,tocolor(255,255,255,main['alpha2']))
        dxDrawImage(sx/2 + -248/zoom, sy/2 + -377/zoom, 1040/zoom, 711/zoom,main['shader'],0,0,0,tocolor(255,255,255,main['alpha2']))
        dxUpdateScreenSource(main['screenSource'])      
        local offset = 0
        for i,v in pairs(main['spawns']) do
            offset = offset + 110/zoom
            dxDrawImage(sx/2 + -758/zoom, sy/2-380/zoom+offset, 440/zoom, 100/zoom, main['textures']['item_bg'], 0,0,0,tocolor(255,255,255,(isMouseInPosition(sx/2 + -758/zoom, sy/2-380/zoom+offset, 440/zoom, 100/zoom) and main['alpha2'] or main['alpha2']*0.5)))
            dxDrawText(v.name, sx/2 + -590/zoom, sy/2-360/zoom+offset, nil, nil, tocolor(255,255,255,(isMouseInPosition(sx/2 + -758/zoom, sy/2-380/zoom+offset, 440/zoom, 100/zoom) and main['alpha2'] or main['alpha2']*0.5)),1,main['fonts'][4],'left','center')
            if (not v.wrap) then
                v.wrap = wordWrap(v.description, 250/zoom, 1, main['fonts'][2])
            end

            
            drawMarker(v.pos[1],v.pos[2],v.pos[3],v.name, 40, sx/2 + -248/zoom, sy/2 + -377/zoom, 800/zoom, 711/zoom, v.description)

            if (isMouseInPosition(sx/2 + -758/zoom, sy/2-380/zoom+offset, 440/zoom, 100/zoom) and not main['animation'] and isMTAWindowFocused() and (main['spawn'] and main['spawn'] or 0) ~= i) then
                -- main['animation'] = true
                main['spawn'] = i
                local cx,cy,cz,lx,ly,lz = getCameraMatrix(localPlayer)
                smoothMoveCamera(v.camera[1],v.camera[2],v.camera[3], v.pos[1],v.pos[3],v.pos[3])
                -- setTimer(function ()
                --     main['animation'] = false
                -- end,4005,1)
            end

            local offset2 = 0
            for k=1,#v.wrap do
                offset2 = offset2 + dxGetFontHeight(1, main['fonts'][2])
                dxDrawText(v.wrap[k], sx/2 + -590/zoom, sy/2-360/zoom+offset+offset2, nil, nil, tocolor(255,255,255,(isMouseInPosition(sx/2 + -758/zoom, sy/2-380/zoom+offset, 440/zoom, 100/zoom) and main['alpha2']*0.8 or main['alpha2']*0.5)),1,main['fonts'][2],'left','center')
            end
        end
    end
end

function saveData(login, password)
	if (fileExists('data.json')) then
        fileDelete('data.json')
    end
    local file = fileCreate('data.json')
    local data = {
        login = login,
        password = password
    }
    fileWrite(file, toJSON(data))
    fileClose(file)
end

function loadData()
    if (fileExists('data.json')) then
		local file = fileOpen('data.json')
		local data = fromJSON(fileRead(file, fileGetSize(file)))
        fileClose(file)
		return data
    end
    return false
end


function click(btn,state)
    if (btn == 'left' and state == 'down') then
        if (isMouseInPosition(sx/2 + -590/zoom, main['y'],100/zoom,30/zoom) and not main['animation'] and main['page'] == 1) then
            main['animation'] = true
            main['elements'][5] = exports['iq-gui']:createEditbox('Potworz haslo', sx/2 + -738/zoom, sy/2 + -161/zoom + 85/zoom, 407/zoom, 63/zoom, {255, 255, 255}, {
                alignX = 'left',
                paddingX = 20/zoom,
                caretColor = {255, 255, 255, 50},
                caretWidth = 2,
                font = main['fonts'][1],
                image = main['textures']['editbox'],
                placeholderColor = {198, 198, 198},
                specialCharacters = '.*[_].*',
                passworded = true
            })
            exports['iq-gui']:setElementAlpha(main['elements'][5], 0)
            exports['iq-gui']:fadeElement(main['elements'][5], 1, 300, 'InOutQuad')
            main['text'] = 'Posiadasz juz konto? Zaloguj sie tutaj!\n#FBA44AKliknij tutaj'
            exports['iq-gui']:setButtonText(main['elements'][4],'Zarejestruj sie')
            exports['iq-gui']:setCheckboxText(main['elements'][3],'Akceptuje regulamin')
            exports['iq-gui']:interpolateToPosition(main['elements'][5], sx/2 + -738/zoom, sy/2 + -161/zoom + 85/zoom + 85/zoom, 300, 'InOutQuad')
            exports['iq-gui']:interpolateToPosition(main['elements'][4], sx/2 + -738/zoom, sy/2 + 53/zoom + 85/zoom, 300, 'InOutQuad')
            exports['iq-gui']:interpolateToPosition(main['elements'][3], sx/2 + -738/zoom, sy/2 + 6/zoom + 85/zoom, 300, 'InOutQuad')
            animate(main['y'], main['y'] + 85/zoom, 'InOutQuad', 300, function (c)
                main['y'] = c
            end, function ()
                main['animation'] = false
                main['page'] = 2
            end)
        elseif (isMouseInPosition(sx/2 + -590/zoom, main['y'],100/zoom,30/zoom) and not main['animation'] and main['page'] == 2) then
            local data = loadData()
            if (data) then
                exports['iq-gui']:setEditboxText(main['elements'][1], data.login)
                exports['iq-gui']:setEditboxText(main['elements'][2], data.password)
            end
            main['animation'] = true
            main['text'] = 'Nie posiadasz swojego konta? Załóż je już teraz!\n#FBA44AKliknij tutaj'
            exports['iq-gui']:fadeElement(main['elements'][5], 0, 300, 'InOutQuad')
            exports['iq-gui']:interpolateToPosition(main['elements'][5], sx/2 + -738/zoom, sy/2 + -161/zoom + 85/zoom, 300, 'InOutQuad')
            exports['iq-gui']:interpolateToPosition(main['elements'][4], sx/2 + -738/zoom, sy/2 + 53/zoom, 300, 'InOutQuad')
            exports['iq-gui']:interpolateToPosition(main['elements'][3], sx/2 + -738/zoom, sy/2 + 6/zoom, 300, 'InOutQuad')
            exports['iq-gui']:setButtonText(main['elements'][4],'Zaloguj sie')
            exports['iq-gui']:setCheckboxText(main['elements'][3],'Zapamiętaj mnie')
            animate(main['y'], main['y'] - 85/zoom, 'InOutQuad', 300, function (c)
                main['y'] = c
            end, function ()
                main['animation'] = false
                main['page'] = 1
                exports['iq-gui']:destroyUIElement(main['elements'][5])
            end)
        elseif (isMouseInPosition(sx/2 + -743/zoom, sy/2 + 53/zoom, 415/zoom, 45/zoom) and main['page'] == 1 and not main['animation']) then
            triggerServerEvent('iq-login:tryLogin', localPlayer, localPlayer, exports['iq-gui']:getEditboxText(main['elements'][1]), exports['iq-gui']:getEditboxText(main['elements'][2]))
            saveData(exports['iq-gui']:getEditboxText(main['elements'][1]), exports['iq-gui']:getEditboxText(main['elements'][2]))
        elseif (isMouseInPosition(sx/2 + -738/zoom, sy/2 + 53/zoom + 85/zoom, 415/zoom, 45/zoom) and not main['animation'] and main['page'] == 2) then
            triggerServerEvent('iq-login:tryRegister', localPlayer, localPlayer, exports['iq-gui']:getEditboxText(main['elements'][1]), exports['iq-gui']:getEditboxText(main['elements'][2]), exports['iq-gui']:getEditboxText(main['elements'][5]))
            saveData(exports['iq-gui']:getEditboxText(main['elements'][1]), exports['iq-gui']:getEditboxText(main['elements'][2]))
        elseif (main['page'] == 3 and not main['animation']) then
            local offset = 0
            for i,v in pairs(main['spawns']) do
                offset = offset + 110/zoom
                if (isMouseInPosition(sx/2 + -758/zoom, sy/2-380/zoom+offset, 440/zoom, 100/zoom)) then
                    main['animation'] = true
                    animate(255,0,'InOutQuad', 600, function (c)
                        main['alpha2'] = c
                    end,function ()
                        main['animation'] = false
                        removeEventHandler('onClientRender',root,render)
                        removeEventHandler('onClientClick', root, click)
                        stopSmoothMoveCamera()
                        destroyElement(main['shader'])
                        destroyElement(main['screenSource'])
                        showChat(true)
                        showCursor(false)
                        setElementData(localPlayer, "player:spawn", v.pos)
                        triggerServerEvent("spawnPlayer", localPlayer, localPlayer, v.pos)
                    end)
                end
            end
        end
    end
end

addEvent('createSpawnPanel', true)
addEventHandler('createSpawnPanel',root,function ()
    exports['iq-gui']:fadeElement(main['elements'][1], 0, 600, 'InOutQuad')
    exports['iq-gui']:fadeElement(main['elements'][2], 0, 600, 'InOutQuad')
    exports['iq-gui']:fadeElement(main['elements'][3], 0, 600, 'InOutQuad')
    exports['iq-gui']:fadeElement(main['elements'][4], 0, 600, 'InOutQuad')
    main['animation'] = true
    animate(255,0,'InOutQuad', 600, function (c)
        main['alpha'] = c
    end, function ()
        if (main['elements'][1]) then
            exports['iq-gui']:destroyUIElement(main['elements'][1])
        end
        if (main['elements'][2]) then
            exports['iq-gui']:destroyUIElement(main['elements'][2])
        end
        if (main['elements'][3]) then
            exports['iq-gui']:destroyUIElement(main['elements'][3])
        end
        if (main['elements'][4]) then
            exports['iq-gui']:destroyUIElement(main['elements'][4])
        end
        if (main['elements'][5]) then
            exports['iq-gui']:destroyUIElement(main['elements'][5])
        end
        main['page'] = 3
        main['screenSource'] = dxCreateScreenSource(1040/zoom, 711/zoom)
        main['shader'] = dxCreateShader("data/fx/mask.fx")
        setCameraMatrix(main['spawns'][1].camera[1], main['spawns'][1].camera[2], main['spawns'][1].camera[3],main['spawns'][1].camera[4],main['spawns'][1].camera[5],main['spawns'][1].camera[6])
        dxSetShaderValue(main['shader'], "sPicTexture", main['screenSource'])
        dxSetShaderValue(main['shader'], "sMaskTexture", main['textures']['mask'])
        dxSetShaderValue(main['shader'], 'gUVScale', 1, 1)
        fadeCamera(true)
        animate(0,255,'InOutQuad', 600, function (c)
            main['alpha2'] = c
        end,function ()
            main['animation'] = false
        end)
    end)
end)

addEventHandler('onClientResourceStart', resourceRoot,function ()
    if (getElementData(localPlayer,'player:sid')) then return end
    main['animation'] = true
    main['page'] = 1

    local function nextUpdate()
        if main['page'] == 1 or main['page'] == 2 then
            setTimer(function ()
                if (math.floor(main['updateProgress']) > 97) then
                    if (main['update'] == #main['updates']) then
                        main['update'] = 1
                    else
                        main['update'] = main['update'] + 1
                    end
                    
                    main['updateProgress'] = 0
                    nextUpdate()
                end
                animate(main['updateProgress'], main['updateProgress'] + 1, 'Linear', 300, function (c)
                    main['updateProgress'] = c
                end)
            end, 300, 103)
        end
    end

    animate(0,255,'InOutQuad', 600, function (c)
        main['alpha'] = c
    end, function ()
        main['animation'] = false
    end)

    nextUpdate()

    addEventHandler('onClientRender',root,render)
    addEventHandler('onClientClick',root,click)
    showChat(false)
    showCursor(true)
    
    local tbl = {
        ['background'] = true,
        ['login_bg'] = true,
        ['logo'] = true,
        ['editbox'] = true,
        ['checkbox_off'] = true,
        ['checkbox_on'] = true,
        ['button'] = true,
        ['qr'] = true,
        ['update_bg'] = true,
        ['update'] = true,
        ['bar_bg'] = true,
        ['update_image1'] = true,
        ['update_image2'] = true,
        ['bar'] = true,
        ['item_bg'] = true,
        ['item_bg'] = true,
        ['mask'] = true,
        ['spawn_line'] = true
    }

    for i,v in pairs(tbl) do
        main['textures'][i] = dxCreateTexture('data/images/'..i..'.png','argb',false,'clamp')
    end

    main['fonts'][1] = exports['iq-fonts']:getFont('medium',13/zoom)
    main['fonts'][2] = exports['iq-fonts']:getFont('medium',12/zoom)
    main['fonts'][3] = exports['iq-fonts']:getFont('bold',16/zoom)
    main['fonts'][4] = exports['iq-fonts']:getFont('bold',12/zoom)

    main['elements'][1] = exports['iq-gui']:createEditbox('Login', sx/2 + -738/zoom, sy/2 + -161/zoom, 407/zoom, 63/zoom, {255, 255, 255}, {
        alignX = 'left',
        paddingX = 20/zoom,
        caretColor = {255, 255, 255, 50},
        caretWidth = 2,
        font = main['fonts'][1],
        image = main['textures']['editbox'],
        placeholderColor = {198, 198, 198},
        specialCharacters = '.*[_].*'
    })

    main['elements'][2] = exports['iq-gui']:createEditbox('Haslo', sx/2 + -738/zoom, sy/2 + -161/zoom + 85/zoom, 407/zoom, 63/zoom, {255, 255, 255}, {
        alignX = 'left',
        paddingX = 20/zoom,
        caretColor = {255, 255, 255, 50},
        caretWidth = 2,
        font = main['fonts'][1],
        image = main['textures']['editbox'],
        placeholderColor = {198, 198, 198},
        specialCharacters = '.*[_].*',
        passworded = true
    })

    main['elements'][3] = exports['iq-gui']:createCheckbox('Zapamiętaj mnie', sx/2 + -736/zoom, sy/2 + 6/zoom, 65/zoom, 25/zoom, {255, 255, 255, 200}, {
        gap = 30/zoom,
        font = main['fonts'][1],
        textColor = {100, 100, 100},
        hoverColor = {255, 255, 255, 255},
        textHoverColor = {155, 155, 155},
        image = main['textures']['checkbox_off'],
        activeImage = main['textures']['checkbox_on'],
        w = 45/zoom
    })
    
    main['elements'][4] = exports['iq-gui']:createButton('Zaloguj się', sx/2 + -743/zoom, sy/2 + 53/zoom, 415/zoom, 45/zoom, {255,255,255, 200}, {
        hoverColor = {255,255,255, 255},
        image = main['textures']['button'],
        font = main['fonts'][2],
        textColor = {255, 255, 255},
    })

    exports['iq-gui']:setElementAlpha(main['elements'][1], 0)
    exports['iq-gui']:setElementAlpha(main['elements'][2], 0)
    exports['iq-gui']:setElementAlpha(main['elements'][3], 0)
    exports['iq-gui']:setElementAlpha(main['elements'][4], 0)
    exports['iq-gui']:fadeElement(main['elements'][1], 1, 600, 'InOutQuad')
    exports['iq-gui']:fadeElement(main['elements'][2], 1, 600, 'InOutQuad')
    exports['iq-gui']:fadeElement(main['elements'][3], 1, 600, 'InOutQuad')
    exports['iq-gui']:fadeElement(main['elements'][4], 1, 600, 'InOutQuad')

    local data = loadData()
    if (data) then
        exports['iq-gui']:setEditboxText(main['elements'][1], data.login)
        exports['iq-gui']:setEditboxText(main['elements'][2], data.password)
    end
end)

addEventHandler('onClientResourceStop',resourceRoot,function ()
    if (main['elements'][1]) then
        exports['iq-gui']:destroyUIElement(main['elements'][1])
    end
    if (main['elements'][2]) then
        exports['iq-gui']:destroyUIElement(main['elements'][2])
    end
    if (main['elements'][3]) then
        exports['iq-gui']:destroyUIElement(main['elements'][3])
    end
    if (main['elements'][4]) then
        exports['iq-gui']:destroyUIElement(main['elements'][4])
    end
    if (main['elements'][5]) then
        exports['iq-gui']:destroyUIElement(main['elements'][5])
    end
end)