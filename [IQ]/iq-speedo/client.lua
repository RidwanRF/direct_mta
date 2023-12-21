local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local main = {
    ['textures'] = {
        ['bg'] = dxCreateTexture('data/images/bg.png','argb',false,'clamp'),
        ['mask'] = dxCreateTexture('data/images/mask.png','argb',false,'clamp'),
        ['bg_circle'] = dxCreateTexture('data/images/bg_circle.png','argb',false,'clamp'),
        ['mask2'] = dxCreateTexture('data/images/mask2.png','argb',false,'clamp'),
        ['fill'] = dxCreateTexture('data/images/fill.png','argb',false,'clamp'),
        ['bg_fuel'] = dxCreateTexture('data/images/bg_fuel.png','argb',false,'clamp'),
        ['fuel'] = dxCreateTexture('data/images/fuel.png','argb',false,'clamp'),
        ['fuel_full'] = dxCreateTexture('data/images/fuel_full.png','argb',false,'clamp')
    },
    ['rt'] = dxCreateRenderTarget(350, 324.51, true),
    ['shader'] = dxCreateShader('data/fx/mask.fx'),
    ['fonts'] = {
        [1] = dxCreateFont('data/fonts/digitalnumbers-regular.ttf',11/zoom),
        [2] = dxCreateFont('data/fonts/digitalnumbers-regular.ttf',29/zoom),
        [3] = exports['iq-fonts']:getFont('medium',15/zoom),
        [4] = dxCreateFont('data/fonts/digitalnumbers-regular.ttf',14/zoom),
        [5] = exports['iq-fonts']:getFont('bold',10/zoom),
    },
    ['checks'] = {
        {
            icon = dxCreateTexture('data/images/lock.png','argb',false,'clamp'),
            check = function (veh) return isVehicleLocked(veh) end
        },
        {
            icon = dxCreateTexture('data/images/lights.png','argb',false,'clamp'),
            check = function (veh) return true end
        },
        {
            icon = dxCreateTexture('data/images/engine.png','argb',false,'clamp'),
            check = function (veh) return getVehicleEngineState(veh) end
        },
        {
            icon = dxCreateTexture('data/images/brake.png','argb',false,'clamp'),
            check = function (veh) return isElementFrozen(veh) end
        }
    }
}

dxSetShaderValue(main['shader'], "sPicTexture", main['textures']['mask2'])
dxSetShaderValue(main['shader'], "sMaskTexture", main['rt'])
dxSetShaderValue(main['shader'], 'gUVScale', 1, 1)

function updateRenderTarget()
    if main['rt'] then
        local rpm = getVehicleRPM(getPedOccupiedVehicle(localPlayer))/100
        dxSetRenderTarget(main['rt'], true)
        dxDrawCircle(175, 265.255 - 50, 500, 130, 130+rpm*3, tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255))
        dxSetRenderTarget()
    end
end

function getPointFromCircleRotation(x, y, radius, rotation)
    local rad = math.rad(rotation)
    local nx = x + math.cos(rad) * radius
    local ny = y + math.sin(rad) * radius
    return nx, ny
end

function render()
    if not getPedOccupiedVehicle(localPlayer) then return end
    if (getElementModel(getPedOccupiedVehicle(localPlayer)) == 448) then return end
    exports['iq-blur']:dxDrawBlur(sx-360/zoom,sy-340/zoom,350/zoom,324.51/zoom, main['textures']['mask'])
    dxDrawImage(sx-360/zoom,sy-340/zoom,350/zoom,324.51/zoom, main['textures']['bg'])
    dxDrawImage(sx-360/zoom + 20/zoom/2,sy-340/zoom + 17/zoom/2,350/zoom - 20/zoom,324.51/zoom - 20/zoom, main['textures']['bg_circle'], 0, 0, 0, tocolor(255, 255, 255, 100))
    dxDrawImage(sx-360/zoom + 20/zoom/2,sy-340/zoom + 17/zoom/2,350/zoom - 20/zoom,324.51/zoom - 20/zoom, main['shader'], 0, 0, 0, tocolor(255, 255, 255, 225))
    updateRenderTarget()
    local xd = 45/zoom
    local xd2 = 65/zoom
    local sxx, syx, szx = getElementVelocity(getPedOccupiedVehicle(localPlayer))
    for i = 9, 18 do
        local speed = i - 9
        local x, y = getPointFromCircleRotation(sx - 185/zoom, sy - 160/zoom, 130/zoom, (i - 4.15) * 29)

        dxDrawText(speed, x, y, x, y, tocolor(255, 255, 255, 175), 1, main['fonts'][4], 'center', 'center', false, false, false, false, false)
    end
    
    dxDrawText(math.ceil(((sxx^2+syx^2+szx^2)^(0.5)) * 150), sx-360/zoom + 350/zoom/2,sy-310/zoom + 324.51/zoom/2, nil, nil, tocolor(238, 242, 239, 255), 1, main['fonts'][2], 'center', 'bottom')
    dxDrawText('km/h', sx-360/zoom + 350/zoom/2,sy-310/zoom + 324.51/zoom/2, nil, nil, tocolor(255, 183, 98, 255), 1, main['fonts'][3], 'center', 'top')
    local mileage = (getElementData(getPedOccupiedVehicle(localPlayer),'vehicle:data') and getElementData(getPedOccupiedVehicle(localPlayer),'vehicle:data').mileage or 0)
    dxDrawText(string.format("%07d", mileage)..' km', sx-360/zoom + 350/zoom/2,sy-280/zoom + 334.51/zoom/2, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][1], 'center', 'top')
    
    local fuel = (getElementData(getPedOccupiedVehicle(localPlayer),'vehicle:fuel') and getElementData(getPedOccupiedVehicle(localPlayer),'vehicle:fuel').count or 0)
    if not fuel then fuel = 0 end
    dxDrawText(string.format("%.2f", fuel)..' L', sx-360/zoom + 350/zoom/2,sy-280/zoom + 482/zoom/2, nil, nil, tocolor(255,255,255,175), 1, main['fonts'][5], 'center', 'bottom')

    local offset = 0
    for i,v in pairs(main['checks']) do
        offset = offset + 30/zoom
        dxDrawImage(sx-360/zoom+offset - 30/zoom + 350/zoom/2 - (#main['checks'] ) * 30/zoom / 2,sy-230/zoom,20/zoom,20/zoom,v.icon,0,0,0,tocolor(255,255,255,(v.check(getPedOccupiedVehicle(localPlayer)) and 255 or 150)))
    end

    dxDrawImage(sx-360/zoom + 350/zoom/2 - 178/zoom/2,sy-35/zoom, 178/zoom, 12/zoom, main['textures']['bg_fuel'])
    dxDrawImage(sx-360/zoom + 350/zoom/2 - 170/zoom/2,sy-35/zoom, 170/zoom, 8/zoom, main['textures']['fuel'])
    dxDrawImage(sx-360/zoom + 350/zoom/2 - 170/zoom/2,sy-35/zoom, 170/zoom*fuel/100, 8/zoom, main['textures']['fuel_full'])
end



function createSpeedo(bool)
    if (bool) then
        addEventHandler('onClientRender',root,render)
    end
end

createSpeedo(true)