local time = getTickCount()
local isBike={[509]=true,[481]=true,[510]=true}

local function naliczaj(veh)
	if getTickCount()-time>50 then
		time = getTickCount()
		local fuelData = getElementData(veh,'vehicle:fuel')
		local data = getElementData(veh,"vehicle:data")
		if not getElementData(veh, "vehicle:id") then return end
		local vx,vy,vz = getElementVelocity(veh)
		local spd=((vx^2 + vy^2 + vz^2)^(0.5)/2)

		if spd > 0 then
			fuelData.count = math.min(math.max(fuelData.count-(spd)/(60), 0), 100)

			setElementData(veh, "vehicle:fuel", fuelData)
			data.mileage = data.mileage+(spd)/10
			setElementData(veh, "vehicle:data", data)
		end
	end
end


setTimer(function()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then return end
    if not getElementData(vehicle, "vehicle:id") then return end
	if isBike[getElementModel(vehicle)] then return end
	if not getVehicleEngineState(vehicle) then return end

    if getElementData(vehicle,"vehicle:id") then
        naliczaj(vehicle)
        local fuel = getElementData(vehicle,'vehicle:fuel').count
        if fuel<1 then
            setVehicleEngineState(vehicle, false)
        end
    end
end, 1000, 0)