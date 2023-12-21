local actions = {
    {
        title = "Kupno usługi Premium",
        description = "Zakupiono produkt: Usługa premium (7 dni) za 200 Punktów premium"
    },
    {
        title = "Kupno usługi Premium",
        description = "Zakupiono produkt: Usługa premium (7 dni) za 200 Punktów premium"
    },
    {
        title = "Kupno usługi Premium",
        description = "Zakupiono produkt: Usługa premium (7 dni) za 200 Punktów premium"
    },
    {
        title = "Kupno usługi Premium",
        description = "Zakupiono produkt: Usługa premium (7 dni) za 200 Punktów premium"
    },
    {
        title = "Kupno usługi Premium",
        description = "Zakupiono produkt: Usługa premium (7 dni) za 200 Punktów premium"
    }
}

preview = {}

pages = {
    {
        name = "Strona główna",
        icon = 'main',
        enter = function ()
            local x1, y1, z1 = getCameraMatrix()
            preview['ped'] = createPed(getElementModel(localPlayer), x1, y1, z1, 0)
			preview['dashboardPed'] = exports['object_preview']:createObjectPreview(preview['ped'], 0, 0, 180, sx / 2 + 230/zoom, 0-110/zoom, 800/zoom - 190/zoom, 1000/zoom - 190/zoom, false, true, true)
        end,
        leave = function ()
            if isElement(preview['dashboardPed']) then
                destroyElement(preview['dashboardPed'])
            end
        
            if isElement(preview['ped']) then
                destroyElement(preview['ped'])
            end
        end,
        render = function ()
            dxDrawImage(sx/2 - 493/zoom, sy/2 - 488/zoom, 680/zoom, 500/zoom, main['textures']['account_data_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Informacje o koncie', sx/2 + -440/zoom, sy/2 + -475/zoom + 7/zoom/2, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][3], 'left', 'top')
            dxDrawText('Organizacja', sx/2 + -451/zoom, sy/2 + -378/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('Nie należysz', sx/2 + -451/zoom, sy/2 + -380/zoom, nil, nil, tocolor(255, 157, 157, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Punkty premium', sx/2 + -451/zoom, sy/2 + -325/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('2 812', sx/2 + -451/zoom, sy/2 + -327/zoom, nil, nil, tocolor(231, 198, 114, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Status konta', sx/2 + -451/zoom, sy/2 + -272/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('Diamond', sx/2 + -451/zoom, sy/2 + -274/zoom, nil, nil, tocolor(139, 213, 255, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Frakcja', sx/2 + -451/zoom, sy/2 + -219/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('SAPD', sx/2 + -451/zoom, sy/2 + -222/zoom, nil, nil, tocolor(106, 184, 255, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Liczba znajomych', sx/2 + -451/zoom, sy/2 + -166/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('41', sx/2 + -451/zoom, sy/2 + -169/zoom, nil, nil, tocolor(244, 174, 255, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Przepracowany czas', sx/2 + -451/zoom, sy/2 + -113/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('2 godz. 42 min.', sx/2 + -451/zoom, sy/2 + -116/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Aktualne kary', sx/2 + -451/zoom, sy/2 + -60/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'left', 'bottom')
            dxDrawText('Brak', sx/2 + -451/zoom, sy/2 + -63/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('Stan portfela', sx/2 + 138/zoom + 10/zoom, sy/2 + -378/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('2000 $', sx/2 + 138/zoom + 10/zoom, sy/2 + -380/zoom, nil, nil, tocolor(174, 255, 192, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawText('Stan konta bankowego', sx/2 + 138/zoom + 10/zoom, sy/2 + -325/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('200 000 $', sx/2 + 138/zoom + 10/zoom, sy/2 + -325/zoom, nil, nil, tocolor(174, 255, 192, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawText('Data rejestracji', sx/2 + 138/zoom + 10/zoom, sy/2 + -272/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('2023-07-19 10:15:51', sx/2 + 138/zoom + 10/zoom, sy/2 + -272/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawText('W grze od', sx/2 + 138/zoom + 10/zoom, sy/2 + -219/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('1 godz. 5 min.', sx/2 + 138/zoom + 10/zoom, sy/2 + -219/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawText('Łączny czas gry', sx/2 + 138/zoom + 10/zoom, sy/2 + -166/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('121 godz. 14 min.', sx/2 + 138/zoom + 10/zoom, sy/2 + -166/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawText('Ogół zarobków', sx/2 + 138/zoom + 10/zoom, sy/2 + -113/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('2 000 000 $', sx/2 + 138/zoom + 10/zoom, sy/2 + -113/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawText('Liczba pojazdów', sx/2 + 138/zoom + 10/zoom, sy/2 + -60/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText('3/10', sx/2 + 138/zoom + 10/zoom, sy/2 + -60/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*0.8), 1, main['fonts'][5], 'right', 'top')
            dxDrawImage(sx/2 - 493/zoom, sy/2 + 40/zoom, 680/zoom, 210/zoom,main['textures']['task_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Zadanie dzienne', sx/2 + -441.9998564720154/zoom, sy/2 + 57/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][3], 'left', 'top')
            dxDrawText('Postęp dzisiejszego zadania', sx/2 + -461/zoom, sy/2 + 114/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][6], 'left', 'top')
            dxDrawImage(sx/2 - 461/zoom, sy/2 + 144/zoom, 615/zoom, 25/zoom, main['textures']['task_progress_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawImageSection(sx/2 - 461/zoom, sy/2 + 144/zoom, 615/zoom/100*50, 25/zoom, 0, 0, 615/100*50, 25, main['textures']['task_progress'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('250 / 500', sx/2 + 156/zoom, sy/2 + 114/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][6], 'right', 'top')
            dxDrawText('Zbierz 20 kłód dębu na pracy drwala w ciągu 24 godzin\nużywając wyłącznie kamiennej siekiery.', sx/2 + -152.5/zoom, sy/2 + 180/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*08), 1, main['fonts'][6], 'center', 'top')
            dxDrawImage(sx/2 - 493/zoom, sy/2 + 278/zoom, 680/zoom, 210/zoom, main['textures']['level_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Zadanie dzienne', sx/2 + -441.9998564720154/zoom, sy/2 + 57/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][3], 'left', 'top')
            dxDrawText('Postęp poziomu', sx/2 + -442/zoom, sy/2 + 292/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][3], 'left', 'top')
            dxDrawImage(sx/2 - 461/zoom, sy/2 + 382/zoom, 615/zoom, 25/zoom, main['textures']['task_progress_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawImageSection(sx/2 - 461/zoom, sy/2 + 382/zoom, 615/zoom/100*50, 25/zoom, 0, 0, 615/200*152, 25, main['textures']['level_progress'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Poziom konta', sx/2 + -461/zoom, sy/2 + 352/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][7], 'left', 'top')
            dxDrawText('#F4AEFF152#ffffff / 200', sx/2 + 156/zoom, sy/2 + 352/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][7], 'right', 'top',false,false,false,true)
            dxDrawText('EXP możesz zdobywać np. #F4AEFFpracując na pracach dorywczych#ffffff,#F4AEFF frakcji #fffffflub\nwykonując zadania dzienne.', sx/2 + -152.5/zoom, sy/2 + 415/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']*08), 1, main['fonts'][6], 'center', 'top',false,false,false,true)
            dxDrawImage(sx/2 + 215/zoom, sy/2 + 40/zoom, 680/zoom, 448/zoom,main['textures']['actions_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
            dxDrawText('Ostatnie akcje', sx/2 + 268/zoom, sy/2 + 57/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][3], 'left', 'top')
            local offset = 0
            for i,v in pairs(actions) do
                offset = offset + 75/zoom
                dxDrawImage(sx/2 + 229/zoom, sy/2 + 104/zoom - 75/zoom + offset, 640/zoom, 60/zoom, main['textures']['action_bg'],0,0,0,tocolor(255,255,255,main['alpha']))
                dxDrawText(v.title, sx/2 + 243/zoom, sy/2 + 138/zoom - 75/zoom + offset, nil, nil, tocolor(255, 255, 255, main['alpha']*0.7), 1, main['fonts'][3], 'left', 'bottom')
                dxDrawText(v.description, sx/2 + 243/zoom, sy/2 + 136/zoom - 75/zoom + offset, nil, nil, tocolor(255, 255, 255, main['alpha']*0.7), 1, main['fonts'][8], 'left', 'top')
            end
            dxDrawText('2', sx/2 + -454/zoom, sy/2 + 385/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')
            dxDrawText('3', sx/2 + 128/zoom, sy/2 + 385/zoom, nil, nil, tocolor(232, 232, 232, main['alpha']), 1, main['fonts'][5], 'left', 'top')
        end
    },
    {
        name = "Zadania dzienne",
        icon = 'dailyTask',
        enter = function ()
        end,
        leave = function ()
        end,
        render = function ()
        end
    },
    {
        name = "Nagroda dzienna",
        icon = 'dailyAward',
        enter = function ()
        end,
        leave = function ()
        end,
        render = function ()
        end
    }
}