data = {

    blackwhite = dxCreateShader("data/blackwhite.fx"),
    screen = dxCreateScreenSource(sx, sy),
    rotation = 0,

    times = {

        bwTime = calculateTime(2),
        tick = getTickCount(),

    },

}

dxSetShaderValue(data.blackwhite, "Tex0", data.screen)

addEventHandler("onClientPreRender", root, function()
    if not data.toggleBW then return end
    dxUpdateScreenSource(data.screen)
end)

addCommandHandler('camera',function ()
    local x, y, z, lx, ly, lz = getCameraMatrix ()
    return outputChatBox(x..','..y..','..z..','..lx..','..ly..','..lz)
end)

function renderBW()
    showChat(false)
    local x, y, z = getElementPosition(localPlayer)
    data.rotation = data.rotation + 0.05
    setCameraMatrix(x, y, z + 5 + math.min(data.rotation, 10), x, y, z, data.rotation)

    dxDrawImage(0, 0, sx, sy, data.blackwhite)
    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 55))
    dxDrawImage(0, sy / 2 - 125/zoom, sx, 250/zoom, "data/background.png", 0, 0, 0, tocolor(0, 0, 0, 125))

    dxDrawText("Jesteś nieprzytomny", sx / 2, sy / 2, nil, nil, tocolor(255, 255, 255, 200), 1, font1, 'center', 'bottom')

    local time = math.floor((data.times.bwTime)/1000)
    dxDrawText("Odrodzisz się za ".. secondsToClock(time) .. "", sx / 2, sy / 2, nil, nil, tocolor(255, 100, 100, 200), 1, font2, 'center', 'top')

    if 0 >= data.times.bwTime then
        toggleBW(false)

        data.times = {

            bwTime = calculateTime(2),
            tick = getTickCount(),
    
        }

        data.rotation = 0
    else
        if data.times.tick + 1000 < getTickCount() then
            data.times.bwTime = data.times.bwTime - 1000
            data.times.tick = getTickCount()
        end
    end
end

function toggleBW(toggle)
    data.rotation = 0
    if toggle then
        addEventHandler('onClientRender', root, renderBW)
        toggleAllControls(false)
    else
        removeEventHandler('onClientRender', root, renderBW)
        triggerServerEvent('respawnPlayerBW', localPlayer, localPlayer)
        showChat(true)
        toggleAllControls(true)
    end

    data.toggleBW = toggle
end

addEvent("toggleBW", true)
addEventHandler("toggleBW", root, function(state)
	toggleBW(state)
end)