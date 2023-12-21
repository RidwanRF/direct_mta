local circles = {

    [1] = dxCreateTexture("data/circle1.png"),
    [2] = dxCreateTexture("data/circle2.png"),
    [3] = dxCreateTexture("data/circle3.png"),
    [4] = dxCreateTexture("data/circle4.png"),

}

local circlesRot = {

    [1] = 1.75,
    [2] = 1.5,
    [3] = 1.25,
    [4] = 1,

}

local rotations = {

    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,

}

local targets = {}
local tick = getTickCount()
local rotX, rotY = {}, {}

local marker = createMarker(-2542.45, -19.83, 15.82, "cylinder", 1.4, 255, 255, 255, 255)

function createTextTarget(marker)
    if targets[marker] and not tonumber(targets[marker]) and isElement(targets[marker]) then return end
    targets[marker] = dxCreateRenderTarget(512, 512, true)
    dxSetRenderTarget(targets[marker])

    local title = getElementData(marker, "marker:title") or "Przechowalnia"
    local icon = getElementData(marker, "marker:icon") or "default"
    local desc = getElementData(marker, "marker:desc") or "Odbiór pojazdów"
    local r, g, b = getMarkerColor(marker)

    if fileExists("data/"..icon..".png") then
        dxDrawImage(124, 125, 256, 256, "data/" .. icon .. ".png", 0, 0, 0, tocolor(r, g, b, 255))
    else
        dxDrawImage(124, 125, 256, 256, "data/default.png", 0, 0, 0, tocolor(r, g, b, 255))
    end

    dxDrawText(title, 256 + 1, 430 + 1, nil, nil, tocolor(0, 0, 0, 255), 1, font1, "center", "bottom")
    dxDrawText(desc, 256 + 1, 430 + 1, nil, nil, tocolor(0, 0, 0, 255), 1, font2, "center", "top")
    dxDrawText(title, 256, 430, nil, nil, tocolor(r, g, b, 255), 1, font1, "center", "bottom")
    dxDrawText(desc, 256, 430, nil, nil, tocolor(225, 225, 225, 255), 1, font2, "center", "top")
    dxSetRenderTarget()
end

function renderMarkers(table)
    for k,v in pairs(table) do
        if (getElementDimension(v) == -1 or getElementDimension(v) == getElementDimension(localPlayer)) and getElementInterior(v) == getElementInterior(localPlayer) and getMarkerType(v) == "cylinder" then
            local r, g, b = getMarkerColor(v)
            setMarkerColor(v, r, g, b, 0)
            local size = getMarkerSize(v) /2

            if not (getElementData(v,'marker:visible')) then
                createTextTarget(v)
                local x, y, z = getElementPosition(v)
                local z = z -0.15
                local x2, y2, z2 = getElementPosition(localPlayer)
                local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
                    
    
                if 50 >= distance then
                gz = getGroundPosition(x, y, z + 1) + 0.01
                
                for i, v in pairs(circles) do
                    local rotSpeed = circlesRot[i]
                    if i == 1 and i == 3 then
                        rotations[i] = rotations[i] + i/75 * rotSpeed
                    else
                        rotations[i] = rotations[i] - i/75 * rotSpeed
                    end
                    
                    rotX[i], rotY[i] = math.cos(rotations[i]) * size,  math.sin(rotations[i]) * size
    
                    dxDrawMaterialLine3D(x + rotX[i], y + rotY[i], gz, x - rotX[i], y - rotY[i], gz, circles[i], 2 * size, tocolor(r, g, b, 175), false, x, y, z + 1)
                end
                
    
                z = interpolateBetween((z-0.2), 0, 0, (z-0.1), 0, 0, ( getTickCount() - tick ) / 2500, 'SineCurve' );
    
                if targets[v] ~= 1 and tonumber(targets[v]) ~= 1 and isElement(targets[v]) then
                    dxDrawMaterialLine3D(x, y, z + 2.5, x, y, z + 1, targets[v], 1.6, white, false)
                else
                    if targets[v] then
                        destroyElement(targets[v])
                        targets[v] = nil
                    end     
                    createTextTarget(v)
                end
            end
            end
        end
    end
end

addEventHandler("onClientRestore", root, function()
    targets = {}
end)

addEventHandler("onClientPreRender", root, function()
    for k,v in pairs(targets) do
        if not isElement(k) then
            destroyElement(targets[k])
            targets[k] = nil
        end
    end

    local x, y, z = getElementPosition(localPlayer)
    local markers = getElementsWithinRange(x, y, z, 50, "marker")

    if #markers > 0 then
        renderMarkers(markers)
    end
end)