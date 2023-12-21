local main = {

    tick = getTickCount(),
    tick2 = getTickCount(),
    toggle = 0,

}

function getVehicleSpeed(veh)
    local sx, sy, sz = getElementVelocity(veh)
    local predkosc = math.ceil(((sx^2+sy^2+sz^2)^(0.5)) * 160)
    if predkosc then
        return predkosc
    end
end

addEventHandler("onClientRender", root, function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    if not getElementData(veh, "vehicle:id") then return end

    if veh and getElementData(veh, "vehicle:toggleABS") then
        if getVehicleSpeed(veh) > 10 and getVehicleCurrentGear(veh) ~= 0 then
            if isVehicleOnGround(veh) then
                if getControlState("brake_reverse") == true then
                    if (getTickCount() - main.tick2) >= (50) then
                        main.tick2 = getTickCount()
                        toggleControl("brake_reverse", false)
                        setVehicleLightState(veh, 2,  1)
                        setVehicleLightState(veh, 3,  1)
                        local vx, vy, vz = getElementVelocity(veh)
                        setElementVelocity(veh, vx*0.95, vy*0.95, vz*0.95)
                    end
                else
                    if (getTickCount() - main.tick) >= (25) then
                        main.tick = getTickCount()
                        toggleControl("brake_reverse", true)
                        setVehicleLightState(veh, 2,  0)
                        setVehicleLightState(veh, 3,  0)
                    end
                end
            else
                if getControlState("brake_reverse") == false then
                    toggleControl("brake_reverse", true)
                    main.tick = getTickCount()
                    setVehicleLightState(veh, 2,  0)
                    setVehicleLightState(veh, 3,  0)
                end
            end
        else
            if getControlState("brake_reverse") == false then
                toggleControl("brake_reverse", true)
                main.tick = getTickCount()
                setVehicleLightState(veh, 2,  0)
                setVehicleLightState(veh, 3,  0)
            end
        end
    end
end)