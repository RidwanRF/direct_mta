local interaction = {
    current = 1,
    mask = dxCreateTexture("data/mask.png"),
    shader = dxCreateShader("data/mask.fx"),
    rt = dxCreateRenderTarget(150, 500, true),
    list = {},
    prev = false,
}

local regulations = {

    ["Regulacja zawieszenia"] = true,
    ["Moduł MK1"] = true,
    ["Moduł MK2"] = true,
    ["Moduł MK3"] = true,

}

local napedy = {

    [0] = "AWD",
    [1] = "RWD",
    [2] = "FWD",

}

local kabriolety = {

    [429] = {

        {1, 1, 2, 2},

    },

    [410] = {

        {2, 2, 1, 1},

    },

}

dxSetShaderValue(interaction.shader, "sPicTexture", interaction.rt)
dxSetShaderValue(interaction.shader, "sMaskTexture", interaction.mask)

function drawIcon(k, v, y)
    v.size = (v.size or 60)
    if interaction.current == k then
        v.size = v.size + (110-v.size)*2/delta
    else
        v.size = v.size + (60-v.size)*2/delta
    end

    dxDrawImage(75-v.size/2, 250 + y - interaction.pos - v.size/2, v.size, v.size, "data/" .. v.icon .. ".png")
    return y + 125
end

function checkDach(veh, ifKabrio) if ifKabrio == 1 then return "Zamknij dach" else return "Otwórz dach" end end

function renderInteraction()
    if not getPedOccupiedVehicle(localPlayer) then
        switchInteraction(_, false)
        return
    end

    local _y = 0
    for k,v in pairs(interaction.list) do
        if interaction.current == k then
            interaction.pos = (interaction.pos and (interaction.pos + (_y - interaction.pos)*3/delta) or _y)
        end
        _y = _y + 125
    end


    local veh = getPedOccupiedVehicle(localPlayer)
    if interaction.open and veh then
        dxSetRenderTarget(interaction.rt, true)

        --dxDrawRectangle(0, 0, 250, 500, tocolor(0, 0, 0, 155))

        local y = -_y
        for k,v in pairs(interaction.list) do
            y = drawIcon(k, v, y)
        end
        for k,v in pairs(interaction.list) do
            y = drawIcon(k, v, y)
        end
        for k,v in pairs(interaction.list) do
            y = drawIcon(k, v, y)
        end

        dxSetRenderTarget()

        dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 200))
        dxDrawImage(sx - 230/zoom,sy/2 - 250/zoom,15/zoom,500/zoom,"data/fancy-line.png", 0, 0, 0, tocolor(255, 255, 255))
        dxDrawImage(sx - 190/zoom,sy/2 - 250/zoom,150/zoom,500/zoom,interaction.shader, 0, 0, 0, tocolor(255,255,255,200))

        

        if interaction.list[interaction.current].icon == "roof" then
            text = "Dach"
            local var1, var2 = getVehicleVariant(veh)

            if kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2] == var2 then
                ifKabrio = 1
            elseif kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4] == var2 then
                ifKabrio = 2
            else
                ifKabrio = false
            end

            dxDrawText(checkDach(veh, ifKabrio), 0, sy/2-17/zoom, sx - 270/zoom, sy/2-17/zoom, white, 1, font1, "right", "center")
        else
            text = interaction.list[interaction.current].text(veh)
            dxDrawText(text, 0, sy/2-17/zoom, sx - 270/zoom, sy/2-17/zoom, white, 1, font1, "right", "center")
        end
        
        if regulations[text] then
            local regulationLevel = tonumber(interaction.list[interaction.current].regulation(veh))
            local regulationName = interaction.list[interaction.current].name

            if regulationName == "Napęd:" then
                theText = regulationName.." #5496ff"..napedy[regulationLevel]
            else
                theText = regulationName.." #5496ff"..regulationLevel
            end

            local textWidth = dxGetTextWidth(theText:gsub("#%x%x%x%x%x%x", ""), 1, font2)

            if getElementSpeed(veh, "km/h") > 5 then
                dxDrawText("Aby regulować moduły zatrzymaj pojazd", 0, sy/2+17/zoom, sx - 270/zoom, sy/2+17/zoom, tocolor(225, 55, 55, 255), 1, font2, "right", "center", false, false, false, true)
            else
                if getKeyState("arrow_r") == true then
                    dxDrawImage(sx - 290/zoom, sy/2 + 6/zoom, 22/zoom, 22/zoom, "data/arrow.png", 0, 0, 0, tocolor(225, 225, 225, 200))
                else
                    dxDrawImage(sx - 290/zoom, sy/2 + 6/zoom, 22/zoom, 22/zoom, "data/arrow.png", 0, 0, 0, tocolor(225, 225, 225, 255))
                end

                if getKeyState("arrow_l") == true then
                    dxDrawImage(sx - 332/zoom - textWidth, sy/2 + 6/zoom, 22/zoom, 22/zoom, "data/arrow.png", 180, 0, 0, tocolor(225, 225, 225, 200))
                else
                    dxDrawImage(sx - 332/zoom - textWidth, sy/2 + 6/zoom, 22/zoom, 22/zoom, "data/arrow.png", 180, 0, 0, tocolor(225, 225, 225, 255))
                end

                dxDrawText(theText, 0, sy/2+17/zoom, sx - 300/zoom, sy/2+17/zoom, tocolor(225, 225, 225, 255), 1, font2, "right", "center", false, false, false, true)
            end
        else
            dxDrawText("Aby potwierdzić wybór wciśnij #5496ffspację#ffffff", 0, sy/2+17/zoom, sx - 270/zoom, sy/2+17/zoom, tocolor(225, 225, 225, 255), 1, font2, "right", "center", false, false, false, true)
        end
    end    
end

function addTune(veh)
    if not getElementData(veh, "vehicle:id") then return end
    if not getElementData(veh, "vehicle:upgrades") then return end
    local veh = getPedOccupiedVehicle(localPlayer)

    if getElementData(veh, "vehicle:upgrades")["gz"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Regulacja zawieszenia") end,
            icon = "susp",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:suspension") or 0) end,
            name = "Wysokość zawieszenia:",
            data = "vehicle:suspension",
            limits = {down=-7, up=7},
            trigger = nil,
            event = "suspensionRegulate",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk1"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK1") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk1") or 0) end,
            name = "Prędkość maksymalna:",
            data = "vehicle:mk1",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK1",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk2"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK2") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk2") or 0) end,
            name = "Przyśpieszenie:",
            data = "vehicle:mk2",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK2",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk3"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK3") end,
            icon = "drivetype",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk3") or 0) end,
            name = "Napęd:",
            data = "vehicle:mk3",
            limits = nil,
            trigger = nil,
            event = "regulateMK3",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["abs"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:toggleABS") and "Wyłącz ABS" or "Włącz ABS") end,
            icon = "abs",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleABS",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["lpg"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:togglelpg") and "Przełącz na "..(getElementData(veh, "vehicle:silnik") or "Benzyna") or "Przełącz na LPG") end,
            icon = "lpg",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleLPG",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["nitro"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:toggleNitro") and "Wyłącz nitro" or "Włącz nitro") end,
            icon = "nitro",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleNitro",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["taxi"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(localPlayer, "job:taxi") and "Anuluj zlecenie" or "Włącz apl. transportową") end,
            icon = "taxo",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,

        })
    end

    if kabriolety[getVehicleModelFromName(getVehicleName(veh))] then
        local var1, var2 = getVehicleVariant(veh)

        if kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2] == var2 then
            ifKabrio = 1
        elseif kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4] == var2 then
            ifKabrio = 2
        else
            ifKabrio = false
        end

        if kabriolety[getVehicleModelFromName(getVehicleName(veh))] and ifKabrio ~= false then
            table.insert(interaction.list, {
            
                text = "Dach",
                icon = "roof",
                x = sx/2 - 150/zoom,
                y = sy - 80/zoom,
                trigger = "vehicleSwitchVariant",

            })
        end
    end
end

function refreshList()
    interaction.list = {
        {
            text = function(veh) return (getVehicleEngineState(veh) and "Zgaś silnik" or "Uruchom silnik") end,
            icon = "motor",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleEngine",
        },

        {
            text = function(veh) return (getVehicleOverrideLights(veh) == 2 and "Zgaś światła" or "Włącz światła") end,
            icon = "headlights",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleLights",
        },

        {
            text = function(veh) return (isElementFrozen(veh) == false and "Zaciągnij ręczny" or "Spuść ręczny") end,
            icon = "brake",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleHandbrake",
        },

        {
            text = function(veh) return (isVehicleLocked(veh) and "Otwórz pojazd" or "Zamknij pojazd") end,
            icon = "doors",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleDoors",
        },

        {
            text = function(veh) return ("Wyrzuć pasażerów") end,
            icon = "kick",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "kickPassengers",
        },
    }

    local veh = getPedOccupiedVehicle(localPlayer)
    if getElementModel(veh) == 578 and getElementData(veh, "laweta") then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "zaladowane") and "Rozładuj lawetę" or "Załaduj lawetę") end,
            icon = "tow",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "toggleZaladunek",

        })
    end
end

function switchInteraction(_, c)
    if c and (not getPedOccupiedVehicle(localPlayer) or getPedOccupiedVehicleSeat(localPlayer) ~= 0) then return end
    if c == "down" then
        refreshList()
        addTune(getPedOccupiedVehicle(localPlayer))
        interaction.open = true
        interaction.current = 1
        interaction.pos = false
        interaction.prev = {hud=getElementData(localPlayer, "player:hudof") or false, chat=isChatVisible()}
        showChat(false)
        setElementData(localPlayer, "player:hudof", true)
        bindKey("arrow_d", "down", changeDown)
        bindKey("arrow_u", "down", changeUp)
        bindKey("arrow_l", "down", regulateIT)
        bindKey("arrow_r", "down", regulateIT)
        bindKey("space", "down", selectOption)
        addEventHandler("onClientRender", root, renderInteraction)
    else
        interaction.open = false
        setElementData(localPlayer, "player:hudof", interaction.prev.hud or false)
        showChat(interaction.prev.chat)
        unbindKey("arrow_d", "down", changeDown)
        unbindKey("arrow_u", "down", changeUp)
        unbindKey("arrow_l", "down", regulateIT)
        unbindKey("arrow_r", "down", regulateIT)
        unbindKey("space", "down", selectOption)
        removeEventHandler("onClientRender", root, renderInteraction)
    end
end
bindKey("lshift", "both", switchInteraction)

function changeUp()
    interaction.current = interaction.current - 1

    if interaction.current <= 0 then
        interaction.current = #interaction.list
        interaction.pos = interaction.pos + (#interaction.list)*125
    end
end

function changeDown()
    interaction.current = interaction.current + 1

    if interaction.current > #interaction.list then
        interaction.current = 1
        interaction.pos = interaction.pos - (#interaction.list)*125
    end
end

function regulateIT(k, ks)
    local veh = getPedOccupiedVehicle(localPlayer)

    if getElementSpeed(veh, "km/h") > 5 then return end

    local text = interaction.list[interaction.current].text(veh)

    if veh and regulations[text] then
        local actualRegulateData = interaction.list[interaction.current].data
        local actualRegulateLimits = interaction.list[interaction.current].limits
        local actualRegulateEvent = interaction.list[interaction.current].event

        if actualRegulateLimits == nil then
            if k  == "arrow_r" and ks == "down" then
                triggerServerEvent(actualRegulateEvent, localPlayer, veh, "up")
            elseif k == "arrow_l" and ks == "down" then
                triggerServerEvent(actualRegulateEvent, localPlayer, veh, "down")
            end
        else
            if k  == "arrow_r" and ks == "down" then
                local level = getElementData(veh, actualRegulateData) or 0
                if level >= actualRegulateLimits.up then return end
    
                setElementData(veh, actualRegulateData, level+1)
                triggerServerEvent(actualRegulateEvent, localPlayer, veh, "up")
            elseif k == "arrow_l" and ks == "down" then
                local level = getElementData(veh, actualRegulateData) or 0
                if actualRegulateLimits.down >= level then return end
                setElementData(veh, actualRegulateData, level-1)
                triggerServerEvent(actualRegulateEvent, localPlayer, veh, "down")
            end
        end
    end
end

function selectOption()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh then
        if interaction.list[interaction.current].icon ~= "roof" then
            text = interaction.list[interaction.current].text(veh)
        else
            text = nil
        end

        if text == "Zaciągnij ręczny" then
            if getElementSpeed(veh, "km/h") > 5 then return end
        end

        if interaction.list[interaction.current].icon == "taxo" then
                exports["noobisty-taxi"]:toggleTaxo(true)
                interaction.open = false
                setElementData(localPlayer, "player:hudof", interaction.prev.hud or false)
                showChat(interaction.prev.chat)
                unbindKey("arrow_d", "down", changeDown)
                unbindKey("arrow_u", "down", changeUp)
                unbindKey("arrow_l", "down", regulateIT)
                unbindKey("arrow_r", "down", regulateIT)
                unbindKey("space", "down", selectOption)
                removeEventHandler("onClientRender", root, renderInteraction)
            return
        end

        if not regulations[text] then
            triggerServerEvent(interaction.list[interaction.current].trigger, localPlayer, getPedOccupiedVehicle(localPlayer))
        end
    end
end

function shadowText(text, x, y, w, h, color, ...)
    for _x = -1, 1 do
        for _y = -1, 1 do
            dxDrawText(text, x+_x, y+_y, w+_x, h+_y, tocolor(0, 0, 0, 100), ...)
        end
    end
    return dxDrawText(text, x, y, w, h, color, ...)
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

setWorldSpecialPropertyEnabled( "extraairresistance", false )
addEventHandler("onClientPreRender", root, function(dt) delta = dt end)