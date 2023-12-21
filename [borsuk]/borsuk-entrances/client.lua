local enter = false
local eventHandled = false
local entrance = {}
local lastEnter = getTickCount()
local entrances = {
    {
        name = 'Sklep 24/7',
        description = 'Sklep całodobowy w którym możesz kupić jedzenie, napoje, pączki, i wiele innych',
        enter = {1929.843506,-1776.149048,13.346875},
        exit = {6.13, -30.68, 1003.05},
        radar = true,
        ghost = true,
        interior = {10, 0}, -- int, dim
        enterCondition = function()
            return false
        end,
        exitCondition = function()
            return false
        end,
    },
}

function renderEntrance()
    if getPedOccupiedVehicle(localPlayer) then return end
    dxDrawImage(sx/2 - 250/zoom, sy - 220/zoom, 500/zoom, 110/zoom, 'data/background.png')
    dxDrawText(entrance.text, sx/2 - 200/zoom, sy - 194/zoom, nil, nil, 0xFFD0D0D0, 1, getFigmaFont('Inter-Bold', 12.8/zoom), 'left', 'center', false, false, false, true)
    dxDrawText('Naciśnij #F3914CQ#D0D0D0, aby ' .. (entrance.enter and 'wejść do środka' or 'wyjść z zpomieszczenia'), sx/2 + 237/zoom, sy - 194/zoom, nil, nil, 0xFFD0D0D0, 1, getFigmaFont('Inter-Medium', 12/zoom), 'right', 'center', false, false, false, true)
    dxDrawText(entrance.description, sx/2 - 237/zoom, sy - 168/zoom, sx/2 + 237/zoom, sy - 114/zoom, 0xFFB5B5B5, 1, getFigmaFont('Inter-Medium', 11.7/zoom), 'center', 'center', false, true)
end

function enterExit()
    if getPedOccupiedVehicle(localPlayer) then return end
    if entrance.enter and not entrances[entrance.condition].enterCondition() then return end
    if not entrance.enter and not entrances[entrance.condition].exitCondition() then return end
    if lastEnter > getTickCount() then return end
    exports['borsuk-loading']:showLoading('Wczytywanie...', false, 3000)
    unbindKey('q', 'down', enterExit)
    lastEnter = getTickCount()+7000
    setTimer(function()
        toggleAllControls(false)
        setElementData(localPlayer, 'element:ghostmode', (entrance.enter and entrance.ghost or false))
        setElementData(localPlayer, 'player:radaroff', entrance.radar)
        
        if entrance.interior then
            triggerServerEvent('setPlayerInt', localPlayer, entrance.interior[1], entrance.interior[2])
        end
        setElementPosition(localPlayer, unpack(entrance.tpto))
    end, 1500, 1)
    setTimer(toggleAllControls, 3000, 1, true)
end

function showEntrance(plr)
    if getPedOccupiedVehicle(localPlayer) then return end
    if plr ~= localPlayer then return end
    if not eventHandled then
        addEventHandler('onClientRender', root, renderEntrance)
        eventHandled = true
        entrance.enter = getElementData(source, 'marker:enter')
        entrance.text = getElementData(source, 'marker:desc')
        entrance.description = getElementData(source, 'marker:enter:description')
        entrance.tpto = getElementData(source, 'marker:tpto')
        entrance.ghost = getElementData(source, 'marker:ghost')
        entrance.interior = getElementData(source, 'marker:interior')
        entrance.radar = getElementData(source, 'marker:radar')
        entrance.condition = getElementData(source, 'marker:condition')
        bindKey('q', 'down', enterExit)
    end
end

function hideEntrance(plr)
    if plr ~= localPlayer then return end
    if eventHandled then
        removeEventHandler('onClientRender', root, renderEntrance)
        eventHandled = false
        unbindKey('q', 'down', enterExit)
    end
end

for k,v in pairs(entrances) do
    local enter = createMarker(v.enter[1], v.enter[2], v.enter[3]-0.99, 'cylinder', 1, 255, 100, 0, 0)
    setElementData(enter, 'marker:title', 'Wejście')
    setElementData(enter, 'marker:desc', v.name)
    setElementData(enter, 'marker:enter:description', v.description)
    setElementData(enter, 'marker:enter', true)
    setElementData(enter, 'marker:icon', 'entrance')
    setElementData(enter, 'marker:tpto', v.exit)
    setElementData(enter, 'marker:ghost', v.ghost)
    setElementData(enter, 'marker:interior', v.interior)
    setElementData(enter, 'marker:radar', v.radar)
    setElementData(enter, 'marker:condition', k)
    addEventHandler('onClientMarkerHit', enter, showEntrance)
    addEventHandler('onClientMarkerLeave', enter, hideEntrance)

    local exit = createMarker(v.exit[1], v.exit[2], v.exit[3]-0.99, 'cylinder', 1, 255, 100, 0, 0)
    setElementDimension(exit, (v.interior[2] or 0))
    setElementInterior(exit, (v.interior[1] or 0))
    setElementData(exit, 'marker:title', 'Wyjście')
    setElementData(exit, 'marker:desc', v.name)
    setElementData(exit, 'marker:enter', false)
    setElementData(exit, 'marker:icon', 'entrance')
    setElementData(exit, 'marker:tpto', v.enter)
    setElementData(exit, 'marker:interior', {0,0})
    setElementData(exit, 'marker:radar', false)
    setElementData(exit, 'marker:condition', k)
    addEventHandler('onClientMarkerHit', exit, showEntrance)
    addEventHandler('onClientMarkerLeave', exit, hideEntrance)
end