local vehicles = {}

function findNeon(veh)
    for i = 1, #vehicles do
        v = vehicles[i]
        if v.vehicle == veh then
            return true
        end
    end
    return false
end

addEventHandler( "onClientElementStreamIn", root, function()
    if getElementType(source)  == 'vehicle' and getElementData(source, "vehicle:id") and (not findNeon(source)) then
        if getElementData(source, "vehicle:upgrades")['neon'] then
            vehicles[#vehicles + 1] = {
                vehicle = source,
            }
            
            if #vehicles > 0 then
                if not isEventHandlerAdded("onClientPreRender", root, renderNeons) then
                    addEventHandler("onClientPreRender", root, renderNeons)
                end
            end
        end
    end
end)
 
addEventHandler( "onClientElementStreamOut", root, function()
    if getElementType(source)  == 'vehicle' then
        for i = 1,#vehicles do
            local v = vehicles[i];
            if not v then return end

            if(source == v.vehicle)then
                table.remove(vehicles, i);
            end;
        end

        if #vehicles == 0 then
            if isEventHandlerAdded("onClientPreRender", root, renderNeons) then
                removeEventHandler("onClientPreRender", root, renderNeons)
            end
        end
    end
end)

for i,v in ipairs(getElementsByType("vehicle")) do
    if getElementData(v, "vehicle:id") and (not findNeon(v)) then
        if getElementData(v, "vehicle:upgrades")['neon'] then
            vehicles[#vehicles + 1] = {
                vehicle = v,
            }
        end
    end
end

setTimer(function()
    if #vehicles > 0 then
        if not isEventHandlerAdded("onClientPreRender", root, renderNeons) then
            addEventHandler("onClientPreRender", root, renderNeons)
        end
    end
end, 1000, 1)

local textures = {

    [1] = dxCreateTexture("neons/1.png"),

}

addEventHandler( "onResourceStop", resourceRoot, function( resource )
    for i,v in ipairs(textures) do
        if isElement(textures[i]) then
            destroyElement(textures[i])
        end
    end
end)

function renderNeons()
    for i = 1, #vehicles do
        local v = vehicles[i]
        if isElement(v.vehicle) then
            if isElementStreamedIn(v.vehicle) then
                if isVehicleOnGround(v.vehicle) and isElementOnScreen(v.vehicle) then
                    local rootx, rooty, rootz = getCameraMatrix()
                    local x, y, z = getElementPosition(v.vehicle)
                    local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
                    if isLineOfSightClear(rootx, rooty, rootz, x, y, z, false, false, false) and 30 >= distance then  
                        local vehicleFront = v.vehicle.matrix.forward*3
                        local x1, y1, z1 = x+vehicleFront['x'], y+vehicleFront['y'], z+vehicleFront['z']
                        local x2, y2, z2 = x-vehicleFront['x'], y-vehicleFront['y'], z-vehicleFront['z']

                        r, g, b = getVehicleHeadLightColor(v.vehicle)

                        g1 = getGroundPosition(x1, y1, z1)
                        g2 = getGroundPosition(x2, y2, z2)
                            
                        dxDrawMaterialLine3D(x1, y1, g1+0.03, x2, y2, g2+0.03, textures[1], 2.75, tocolor(r, g, b, 100), x1+0.01, y1+0.01, g1-1.5)
                    end
                end
            end
        end
    end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end