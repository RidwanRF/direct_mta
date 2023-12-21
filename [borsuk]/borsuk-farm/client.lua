local barnData

local _createObject = createObject
function createObject(...)
    local uid = getElementData(localPlayer, 'player:sid') or 0
    local object = _createObject(...)
    setElementDimension(object, uid)
    return object
end

local _createMarker = createMarker
function createMarker(...)
    local uid = getElementData(localPlayer, 'player:uid') or 0
    local object = _createMarker(...)
    setElementDimension(object, uid)
    return object
end

function attachHoe()
    if barnData.items.usingCan then return end

    barnData.items.usingHoe = not barnData.items.usingHoe
    if barnData.items.usingHoe then
        exports['borsuk-pattach']:attach(barnData.hoe, localPlayer, 25, 0.05, 0, -.2, 0, -90, -70)
        showNotification("Use E to put hoe down")
    else
        exports['borsuk-pattach']:detach(barnData.hoe, localPlayer)

        local x, y, z, rx, ry, rz = unpack(HOE_POSITION)
        setElementPosition(barnData.hoe, x, y, z)
        setElementRotation(barnData.hoe, rx, ry, rz)
    end
end

function attachCan()
    if barnData.items.usingHoe then return end

    barnData.items.usingCan = not barnData.items.usingCan
    if barnData.items.usingCan then
        exports['borsuk-pattach']:attach(barnData.can, localPlayer, 25, 0, 0, 0, -90, 0, 90)
        showNotification("Use E to put can down")
    else
        exports['borsuk-pattach']:detach(barnData.can, localPlayer)

        local x, y, z, rx, ry, rz = unpack(CAN_POSITION)
        setElementPosition(barnData.can, x, y, z)
        setElementRotation(barnData.can, rx, ry, rz)
    end
end

function keyDetach()
    if barnData.interacting then return end
    if barnData.items.usingHoe then attachHoe() end
    if barnData.items.usingCan then attachCan() end
end

function clickElement(btn, state, x, y, wx, wy, wz, element)
    if btn ~= 'left' or state ~= 'down' then return end

    if element and element == barnData.hoe then
        attachHoe()
    elseif element and element == barnData.can then
        attachCan()
    end
end

function updateBones()
    if barnData.items.usingCan then
        if not barnData.items.canInUse then
            setElementBoneRotation(localPlayer, 22, 0, 0, -75)
            local rx, ry, rz = getElementBoneRotation(localPlayer, 23)
            setElementBoneRotation(localPlayer, 23, rx * 0.3, ry * 0.3, rz * 0.3)
            setElementBoneRotation(localPlayer, 24, 90, 0, 0)
        end
        
        setElementBoneRotation(localPlayer, 25, 0, 0, 0)

        updateElementRpHAnim(localPlayer)
    end
end

function getField()
    local x, y, z = getPositionFromElementOffset(localPlayer, 0, 1, -1)
    local object = findClosestElement(x, y, z, 'object', function(element)
        return getElementModel(element) == 1901
    end, 1)
    if not object then return end
    local field = getFieldByObject(object)
    if not field or field.texture == 'walk' then return end
    local data = barnData.data.fields[field.id]
    return object, field, data
end

function updateFarm()
    local object, field, data = getField()
    if not field then return end

    local size = 1.09
    local x, y, z = getElementPosition(object)
    dxDrawLine3D(x - size/2, y - size/2, z, x - size/2, y + size/2, z, 0xFF00FF00, 3)
    dxDrawLine3D(x + size/2, y - size/2, z, x + size/2, y + size/2, z, 0xFF00FF00, 3)
    dxDrawLine3D(x - size/2, y - size/2, z, x + size/2, y - size/2, z, 0xFF00FF00, 3)
    dxDrawLine3D(x - size/2, y + size/2, z, x + size/2, y + size/2, z, 0xFF00FF00, 3)

    if data.planted then
        local z = z + .6
        local x, y = getScreenFromWorldPosition(x, y, z)
        if x and y then
            x, y = math.floor(x), math.floor(y)
            local plantData = PLANTS[data.planted.name]
            local prg = math.min(data.planted.time/plantData.growTime, 1)

            dxDrawText(data.planted.name, x + 1, y + 1, nil, nil, 0xFF000000, 1, regular, 'center', 'center')
            dxDrawText(data.planted.name, x, y, nil, nil, white, 1, regular, 'center', 'center')
            
            if prg >= 1 then
                dxDrawText('ready to harvest', x + 1, y + 28/zoom + 1, nil, nil, 0xFF000000, 1, regularSmall, 'center', 'top')
                dxDrawText('ready to harvest', x, y + 28/zoom, nil, nil, white, 1, regularSmall, 'center', 'top')
            end

            dxDrawRectangle(x - 50/zoom, y + 12/zoom, 100/zoom, 15/zoom, tocolor(25, 25, 25, 230))
            dxDrawRectangle(x - 48/zoom, y + 14/zoom, 96/zoom * prg, 11/zoom, tocolor(25, 255, 25, 230))
        end
    end
end

function updateBarnData()
    triggerServerEvent('farm:update', resourceRoot, barnData.data)
end

function plantSeed(name)
    barnData.interacting = false
    local object, field, data = getField()
    if not field then return end

    if data.state == 'plowed' and not barnData.items.usingHoe and not barnData.items.usingCan then
        local plantData = PLANTS[name]
        giveItem(plantData.seeds, -1)

        setPedAnimation(localPlayer, 'BOMBER', 'BOM_Plant', -1, true, false)
        toggleAllControls(false)
        interpolateField(field, data, 'planted', 2700, function()
            field:plant(name)
        end)
    end
end

function stopPlantUI()
    barnData.interacting = false
end

function interpolateField(field, data, texture, time, callback)
    field:setTargetTexture(texture)
    field:setInterpolation(0)

    local n = 0
    local times = time / 100
    setTimer(function()
        field:setInterpolation(n)
        n = n + 1/times
    end, 100, times)

    setTimer(function()
        local x, y, z = getElementPosition(localPlayer)
        setElementPosition(localPlayer, x, y, z + .1)
        toggleAllControls(true)
        barnData.interacting = false
        data.state = texture
        field:setTexture(texture)
        field:setInterpolation(0)
        updateBarnData()
        if callback then callback() end
    end, time, 1)
end

function fieldInteraction()
    if barnData.interacting then return false end
    local object, field, data = getField()
    if not field then return end

    if data.state == 'default' and barnData.items.usingHoe then
        setPedAnimation(localPlayer, 'BASEBALL', 'Bat_4', -1, true, false)
        toggleAllControls(false)
        barnData.sound = playSound('data/shovel.mp3', true)
        interpolateField(field, data, 'plowed', 5000, function()
            destroyElement(barnData.sound)
        end)

        barnData.interacting = true
    elseif data.state == 'plowed' and not barnData.items.usingHoe and not barnData.items.usingCan then
        togglePlantUI(true)
        barnData.interacting = true
    elseif data.state == 'planted' and barnData.items.usingCan then
        setPedAnimation(localPlayer, 'SWORD', 'sword_idle', -1, true, false)
        toggleAllControls(false)
        barnData.items.canInUse = true
        barnData.interacting = true

        local x, y, z = getPositionFromElementOffset(localPlayer, 0.1, 1.2, 0.25)
        local rx, ry, rz = getElementRotation(localPlayer)
        barnData.effect = createEffect('coke_trail', x, y, z, 0, -45, -rz-90)
        barnData.sound = playSound('data/watercan.mp3', true)

        interpolateField(field, data, 'wet', 10000, function()
            destroyElement(barnData.effect)
            destroyElement(barnData.sound)
            barnData.items.canInUse = false
        end)
    elseif data.planted then
        local plantData = PLANTS[data.planted.name]
        if data.planted.time < plantData.growTime then return end
        if not barnData.items.usingHoe then return showNotification('You need hoe to start harvesting') end
        barnData.interacting = true
        
        setPedAnimation(localPlayer, 'BOMBER', 'BOM_Plant', -1, true, false)
        toggleAllControls(false)
        barnData.sound = playSound('data/harvest.mp3', true)
        
        interpolateField(field, data, 'default', 2700, function()
            destroyElement(barnData.sound)
            giveItem(plantData.finalItem, plantData.finalItemCount)
            field:removePlant()
        end)
    end
end

function exitBarn(plr)
    if plr ~= localPlayer then return end
    unloadBarn()
    triggerServerEvent('farm:exit', resourceRoot)
end

function getFieldByObject(object)
    if barnData and barnData.fieldObjects then
        for _, field in ipairs(barnData.fieldObjects) do
            if field.object == object then
                return field
            end
        end
    end

    return nil
end

local uk = 0
function updateGrow()
    for k,v in pairs(barnData.fieldObjects) do
        if v.data.planted then
            v.data.planted.time = v.data.planted.time + (v.data.state == 'wet' and 1 or 0.2)

            local plantData = PLANTS[v.data.planted.name]
            local prg = math.min(v.data.planted.time/plantData.growTime, 1)
            setObjectScale(v.plantObject, prg)
        end
    end

    uk = uk + 1
    if uk >= 10 then
        updateBarnData()
        uk = 0
    end
end

function addGrowTime(time)
    for k,v in pairs(barnData.fieldObjects) do
        if v.data.planted then
            v.data.planted.time = v.data.planted.time + time * (v.data.state == 'wet' and 1 or 0.3)

            local plantData = PLANTS[v.data.planted.name]
            local prg = math.min(v.data.planted.time/plantData.growTime, 1)
            setObjectScale(v.plantObject, prg)
        end
    end

    updateBarnData()
end
addEvent('farm:addGrowTime', true)
addEventHandler('farm:addGrowTime', resourceRoot, addGrowTime)

function loadBarn(data)
    barnData = {}
    barnData.data = data
    barnData.object = createObject(1899, 0, 0, 250)
    barnData.door = createObject(1497, -.7, -8.6, 250)
    barnData.hoe = createObject(1900, unpack(HOE_POSITION))
    barnData.can = createObject(1902, unpack(CAN_POSITION))
    barnData.exit = createMarker(0, -8, 250, 'cylinder', 1, 55, 100, 255, 55)
    setElementDoubleSided(barnData.can, true)
    setElementFrozen(barnData.door, true)

    barnData.items = {
        usingHoe = false,
        usingCan = false,
    }
    
    setElementPosition(localPlayer, 0, -8, 251)
    setElementRotation(localPlayer, 0, 0, 0)
    setCameraTarget(localPlayer)

    barnData.fieldObjects = {}

    local x = 0
    local y = -5.07
    local id = 0
    local n = 1

    local function createField()
        if not data.fields[n] then
            data.fields[n] = {
                state = 'default'
            }
        end

        local data = data.fields[n]

        local nx, ny = -1.09 * 2 + x, y
        local object = createObject(1901, nx, ny, 249.95)
        local shader = dxCreateShader('data/shader.fx')
        engineApplyShaderToWorldTexture(shader, '*', object)

        x = x + 1.09
        id = id + 1
        if id >= 5 then
            id = 0
            x = 0
            y = y + 1.09
        end

        local field = {
            object = object,
            id = n,
            x = nx,
            y = ny,
            z = 249.95,
            texture = false,
            tTexture = false,
            interpolation = false,
            data = data,

            setTexture = function(self, texture)
                dxSetShaderValue(shader, 'Tex0', getTexture(texture))
                self.texture = texture
            end,
            
            setTargetTexture = function(self, texture)
                dxSetShaderValue(shader, 'Tex1', getTexture(texture))
                self.tTexture = texture
            end,
            
            setInterpolation = function(self, value)
                dxSetShaderValue(shader, 'interpolation', value)
                self.interpolation = value
            end,

            plant = function(self, name, time)
                data.planted = {
                    name = name,
                    time = (time or 0),
                }

                local plantData = PLANTS[name]
                self.plantObject = createObject(plantData.object, self.x, self.y, self.z, 0, 0, math.random(0, 360))
                setElementDoubleSided(self.plantObject, true)

                local prg = math.min(data.planted.time/plantData.growTime, 1)
                setObjectScale(self.plantObject, prg)

                updateBarnData()
            end,

            removePlant = function(self)
                if self.plantObject and isElement(self.plantObject) then
                    destroyElement(self.plantObject)
                end
                data.planted = false

                updateBarnData()
            end
        }

        if id == 3 then
            field:setTexture('walk')
        else
            field:setTexture(data.state)

            if data.planted then
                field:plant(data.planted.name, data.planted.time)
            end
        end

        table.insert(barnData.fieldObjects, field)

        n = n + 1
    end

    for i = 1, 60 do
        createField()
    end

    addEventHandler('onClientRender', root, updateFarm)
    addEventHandler('onClientClick', root, clickElement)
    addEventHandler('onClientPedsProcessed', root, updateBones)
    bindKey('e', 'down', keyDetach)
    bindKey('mouse1', 'down', fieldInteraction)

    addEventHandler('onClientMarkerHit', barnData.exit, exitBarn)
    toggleControl('fire', false)

    barnData.growTimer = setTimer(updateGrow, 1000, 0)
end

function unloadBarn()
    removeEventHandler('onClientRender', root, updateFarm)
    removeEventHandler('onClientClick', root, clickElement)
    removeEventHandler('onClientPedsProcessed', root, updateBones)
    unbindKey('e', 'down', keyDetach)
    unbindKey('mouse1', 'down', fieldInteraction)
    killTimer(barnData.growTimer)

    if barnData then
        for _, field in ipairs(barnData.fieldObjects) do
            destroyElement(field.object)

            if field.plantObject and isElement(field.plantObject) then
                destroyElement(field.plantObject)
            end
        end

        destroyElement(barnData.object)
        destroyElement(barnData.door)
        destroyElement(barnData.hoe)
        destroyElement(barnData.can)
        destroyElement(barnData.exit)

        barnData = nil
    end

    toggleControl('fire', true)
end