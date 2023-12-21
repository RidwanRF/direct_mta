local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
-- zoom = zoom * 0.9

local main = {
    ['fonts'] = {
        [1] = dxCreateFont('data/fonts/digitalnumbers-regular.ttf',16/zoom),
        [2] = dxCreateFont('data/fonts/digitalnumbers-regular.ttf',25/zoom),
        [3] = dxCreateFont('data/fonts/digitalnumbers-regular.ttf',13/zoom)
    }
}

function render()
    if not getPedOccupiedVehicle(localPlayer) then return end
    if (getElementModel(getPedOccupiedVehicle(localPlayer)) == 448) then
        local veh = getPedOccupiedVehicle(localPlayer)
        local sxx, syx, szx = getElementVelocity(veh)
        local predkosc = (sxx^2 + syx^2 + szx^2)^(0.5)
        local needle = predkosc * 107
        local predkosc1 = math.ceil(((sxx^2+syx^2+szx^2)^(0.5)) * 150)
        dxCircle(sx, sy, 400/zoom, 400/zoom, tocolor(104, 182, 238, 90), 180, 179.9, 16/zoom, 1)
        dxCircle(sx, sy, 400/zoom, 400/zoom, tocolor(104, 182, 238), needle*1.9, 179.9, 16/zoom, 1)
        dxDrawText('PREDKOSC',sx - 5/zoom,sy-25/zoom,nil,nil,white,1,main['fonts'][1],'right','center')
        dxDrawText(predkosc1,sx - 5/zoom,sy-25/zoom - dxGetFontHeight(1,main['fonts'][1]) - 3/zoom,nil,nil,tocolor(255,180,112),1,main['fonts'][2],'right','center')
        dxDrawText('km/h',sx - 5/zoom - dxGetTextWidth(predkosc1,1,main['fonts'][2]) - 3/zoom,sy-21/zoom - dxGetFontHeight(1,main['fonts'][1]) - 3/zoom,nil,nil,tocolor(255,180,112),1,main['fonts'][3],'right','center')
    end
end


addEventHandler('onClientRender',root,render)