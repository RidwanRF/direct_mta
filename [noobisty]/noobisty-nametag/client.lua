local fonts = {

    [1] = exports['iq-fonts']:getFont('medium', 12),
    [2] = exports['iq-fonts']:getFont('regular', 9),
    [3] = exports['iq-fonts']:getFont('extrabold', 12),

}

function renderNametag(player)
    local x, y, z = getPedBonePosition(player, 8)
    local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(x, y, z)) - 5, 0)
    local x, y = getScreenFromWorldPosition(x, y, z + 0.4)
    if not x or not y then return end

    local scale = 1 - dist / 20
    if scale < 0.2 then return end

    local playerID = getElementData(player, 'id') or "---"
    local organization = 'borsuczy gaj'

    dxDrawImage(x - 15*scale - 15*scale, y - 54*scale, 30*scale, 30*scale, 'img/4.png', 0, 0, 0, tocolor(255, 225, 155, 200))
    dxDrawImage(x - 15 + 35*scale - 15*scale, y - 54*scale, 30*scale, 30*scale, 'img/premium.png', 0, 0, 0, tocolor(255, 225, 100, 200))
    -- dxDrawImage(x - 15 - 35*scale, y - 54*scale, 30*scale, 30*scale, 'img/voice.png', 0, 0, 0, tocolor(125, 165, 225, 200))
    dxDrawText('( '..organization..' )', x + 1, y + 1, nil, nil, tocolor(0,0,0,155), scale, fonts[2], 'center', 'top', false, false, false, false, true)
    dxDrawText('( '..organization..' )', x, y, nil, nil, tocolor(200,200,200,225), scale, fonts[2], 'center', 'top', false, false, false, true, true)
    dxDrawText(''..playerID..' '..getPlayerName(player), x + 1, y + 1, nil, nil, tocolor(0,0,0,155), scale, fonts[1], 'center', 'bottom', false, false, false, false, true)
    dxDrawText(''..playerID..' #ffffff'..getPlayerName(player), x, y, nil, nil, tocolor(255,215,125,225), scale, fonts[1], 'center', 'bottom', false, false, false, true, true)
end


function renderNametags()
    local x, y, z = getElementPosition(getCamera())
    for _,player in pairs(getElementsWithinRange(x, y, z, 20, 'player')) do
        --if player ~= localPlayer then
            renderNametag(player)
        --end
    end

    for k,v in pairs(getElementsByType('player')) do
        setPlayerNametagShowing(v, false)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    addEventHandler('onClientRender', root, renderNametags)
end)

