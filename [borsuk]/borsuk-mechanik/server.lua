local fixPart = {
	["Silnik"] = {1, fn=function(veh) setElementHealth( veh, 2040 ) end}, 
	["Maska"] = {2, fn=function(veh) setVehicleDoorState( veh, 0, 0 ) end},
	["Bagażnik"] = {3, fn=function(veh) setVehicleDoorState( veh, 1, 0 ) end},
	["Drzwi lewy przód"] = {4, fn=function(veh) setVehicleDoorState( veh, 2, 0 ) end},
	["Drzwi prawy przód"] = {5, fn=function(veh) setVehicleDoorState( veh, 3, 0 ) end},
	["Drzwi lewy tył"] = {6, fn=function(veh) setVehicleDoorState( veh, 4, 0 ) end},
	["Drzwi prawy tył"] = {7, fn=function(veh) setVehicleDoorState( veh, 5, 0 ) end},
	["Szyba przednia"] = {8, fn=function(veh) setVehiclePanelState( veh, 4, 0 ) end},
	["Zderzak przedni"] = {9, fn=function(veh) setVehiclePanelState( veh, 5, 0 ) end},
	["Zderzak tylni"] = {10, fn=function(veh) setVehiclePanelState( veh, 6, 0 ) end},
	["Światło lewe przednie"] = {11, fn=function(veh) setVehicleLightState( veh, 0, 0 ) end},
	["Światła prawe przednie"] = {12, fn=function(veh) setVehicleLightState( veh, 1, 0 ) end},
	["Światła lewe tylnie"] = {13, fn=function(veh) setVehicleLightState( veh, 2, 0 ) end},
	["Światła prawe tylnie"] = {14, fn=function(veh) setVehicleLightState( veh, 3, 0 ) end},
    ["Ładowanie akumulatora"] = {19, fn=function(veh) setElementData( veh, "vehicle:battery", 100 ) end},
}
local fixing = {}
local mechy = {
    {
        col = {-1736.71, -107.59, 3.55, 15, 6, 3},
        brama = {1881, -1738.21, -104.55, 5, 0, 0, 90, 1.00},
        marker = {-1739.80, -100.97, 3.55},
        rt = {-1739, -104.58, 8.6, -1739, -104.59, 7.9, 2.3, -1739.31-100, -104.76, 3.55},
        used = false
    },

    {
        col = {-1736.83, -115.54, 3.55, 15, 6, 3},
        brama = {1881, -1738.21, -112.42, 5, 0, 0, 90, 1.00},
        marker = {-1739.79, -109.12, 3.55},
        rt = {-1739, -112.4, 8.6, -1739, -112.4, 7.9, 2.3, -1739.31-100, -112.4, 3.55},
        used = false
    },
    
    {
        col = {-1736.93, -123.32, 3.55, 15, 6, 3},
        brama = {1881, -1738.21, -120.15, 5, 0, 0, 90, 1.00},
        marker = {-1739.74, -116.41, 3.55},
        rt = {-1739, -120.08, 8.6, -1739, -120.08, 7.9, 2.3, -1739.31-100, -120.08, 3.55},
        used = false
    },

    {
        col = {-1736.44, -130.71, 3.55, 15, 6, 3},
        brama = {1881, -1738.21, -127.99, 5, 0, 0, 90, 1.00},
        marker = {-1739.98, -124.40, 3.55},
        rt = {-1739, -127.94, 8.6, -1739, -127.94, 7.9, 2.3, -1739.31-100, -127.94, 3.55},
        used = false
    },
}

function openGate(id)
    if not mechy[id] then return end
    moveObject(mechy[id].object, 2000, mechy[id].brama[2], mechy[id].brama[3], mechy[id].brama[4]-5)
end

function closeGate(id)
    if not mechy[id] then return end
    moveObject(mechy[id].object, 2000, mechy[id].brama[2], mechy[id].brama[3], mechy[id].brama[4])
end

for k,v in pairs(mechy) do
    local col = createColCuboid(v.col[1], v.col[2], v.col[3]-1, v.col[4], v.col[5], v.col[6]+1)
    local ob = createObject(v.brama[1], v.brama[2], v.brama[3], v.brama[4], v.brama[5], v.brama[6], v.brama[7])
    local marker = createMarker(v.marker[1], v.marker[2], v.marker[3]-1.4, "cylinder", 1, 50, 220, 255)
    if v.brama[8] then
        setObjectScale(ob, v.brama[8])
    end
    setElementData(marker, "marker:title", "Mechanik")
    setElementData(marker, "marker:desc", "Naprawa pojazdu")
    setElementData(marker, "marker:icon", "repair")

    v.object = ob
    v.marker = marker
    v.col = col

    openGate(k)
end

addEvent("getMechs", true)
addEventHandler("getMechs", root, function()
    triggerClientEvent(client, "returnMechs", client, mechy, getTickCount())
end)

local wheelID = {

    [15] = true,
    [16] = true,
    [17] = true,
    [18] = true,

}

local wheelNames = {

    ["Lewe przednie koło"] = 15,
    ["Prawe przednie koło"] = 16,
    ["Lewe tylnie koło"] = 17,
    ["Prawe tylnie koło"] = 18,

}

function endVehicleRepair(selected, veh, id)
    openGate(id)

    mechy[id].used = false
    mechy[id].owner = false
    mechy[id].endTime = false
    fixing[veh] = false

    if wheelID[wheelNames[selected[1]]] then
        local wheelID = wheelNames[selected[1]]
        if wheelID == 15 then
            local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
            setVehicleWheelStates(veh, 0, rearLeft, frontRight, rearRight)
        elseif wheelID == 16 then
            local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
            setVehicleWheelStates(veh, frontLeft, rearLeft, 0, rearRight)
        elseif wheelID == 17 then
            local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
            setVehicleWheelStates(veh, frontLeft, 0, frontRight, rearRight)
        elseif wheelID == 18 then
            local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
            setVehicleWheelStates(veh, frontLeft, rearLeft, frontRight, 0)
        end
    else
        for k,v in pairs(selected) do
            fixPart[v].fn(veh)
        end
    end

    if isElement(veh) then
        setElementData(veh, "vehicle:fixing", false)
        setElementFrozen(veh, false)
        setVehicleLocked(veh, false)
    end

    triggerClientEvent(root, "returnMechs", root, mechy, getTickCount())
end

addEvent("repairVehicle", true)
addEventHandler("repairVehicle", root, function(cost, selected, veh, id)
    if fixing[veh] then return end
    
    takePlayerMoney(source, cost)
    fixing[veh] = true
    closeGate(id)
    setElementFrozen(veh, true)
    setVehicleLocked(veh, true)

    local time = #selected*4000

    mechy[id].used = veh
    mechy[id].owner = getPlayerName(source)
    mechy[id].endTime = getTickCount()+time
    setElementData(veh, "vehicle:fixing", true)

    setTimer(endVehicleRepair, time, 1, selected, veh, id)

    triggerClientEvent(root, "returnMechs", root, mechy, getTickCount())
end)

addEventHandler("onVehicleExit", root, function(plr, seat)
    if seat ~= 0 then return end
    setElementData(source, "vehicle:driver", plr)
end)

--[[addEventHandler("onVehicleStartEnter", root, function()
    if getElementData(source, "vehicle:fixing") then cancelEvent() end
end)]]