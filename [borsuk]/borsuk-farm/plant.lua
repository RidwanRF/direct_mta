local selectedPlant

function getPlants()
    local plants = {}
    for k,v in pairs(PLANTS) do
        local count = getItemsCount(v.seeds)
        if count > 0 then
            table.insert(plants, {
                name = k,
                count = count,
            })
        end
    end
    return plants
end

function renderPlantUI()
    dxDrawImage(sx/2 - 200/zoom, sy/2 - 250/zoom, 400/zoom, 500/zoom, 'data/background2.png')
    dxDrawText('What do you want to plant?', sx/2, sy/2 - 240/zoom, nil, nil, tocolor(255,255,255,200), 1, regular, 'center')
    dxDrawImage(sx/2 - 180/zoom, sy/2 - 200/zoom, 360/zoom, 380/zoom, 'data/background2.png', 0, 0, 0, tocolor(0, 0, 0, 40))

    local plants = getPlants()
    if #plants > 0 then
        for k,v in pairs(plants) do
            local x, y, w, h = sx/2 - 178/zoom, sy/2 - 198/zoom + (k-1)*38/zoom, 356/zoom, 35/zoom
            local inside = isMouseInPosition(x, y, w, h)
            dxDrawRectangle(x, y, w, h, (selectedPlant == k) and tocolor(255, 255, 255, 10) or (inside and tocolor(255, 255, 255, 5) or tocolor(0, 0, 0, 20)))
            dxDrawText(v.name, x + 5/zoom, y + h/2, nil, nil, (selectedPlant == k) and 0xFFFFFFFF or (inside and tocolor(255, 255, 255, 239) or tocolor(255, 255, 255, 155)), 1, regular, 'left', 'center')
            dxDrawText(v.count, x + w - 5/zoom, y + h/2, nil, nil, (selectedPlant == k) and 0xFFFFFFFF or (inside and tocolor(255, 255, 255, 239) or tocolor(255, 255, 255, 155)), 1, regular, 'right', 'center')

            if inside and getKeyState('mouse1') then
                selectedPlant = k
            end
        end
    else
        dxDrawText('You don\'t have any seeds', sx/2, sy/2 + 20/zoom, nil, nil, tocolor(255,255,255,100), 1, regular, 'center', 'center')
    end

    drawButton('Plant', sx/2 - 180/zoom, sy/2 + 195/zoom, 175/zoom, 35/zoom, regular)
    drawButton('Cancel', sx/2 + 5/zoom, sy/2 + 195/zoom, 175/zoom, 35/zoom, regular)
end

function clickPlantUI(btn, state)
    if btn ~= 'left' or state ~= 'down' then return end

    if isMouseInPosition(sx/2 + 5/zoom, sy/2 + 195/zoom, 175/zoom, 35/zoom) then
        togglePlantUI(false)
    elseif isMouseInPosition(sx/2 - 180/zoom, sy/2 + 195/zoom, 175/zoom, 35/zoom) and selectedPlant then
        togglePlantUI(false)

        local plants = getPlants()
        local plant = plants[selectedPlant]
        if not plant then return end
        plantSeed(plant.name)
    end
end

function togglePlantUI(b)
    local eventCallback = b and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderPlantUI)
    eventCallback('onClientClick', root, clickPlantUI)
    showCursor(b)

    if not b then
        stopPlantUI()
    end
end