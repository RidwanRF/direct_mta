local vehiclesWithPaintjob = {}

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "vehicle:id") then
			local paintJob = tonumber(getElementData(source, "vehicle:upgrades")['paintjob'])
		
			if paintJob then
				addVehiclePaintjob(source, paintJob)
			end
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "vehicle:id") then
			if getElementData(source, "vehicle:upgrades")["paintjob"] then
				removeVehiclePaintjob(source)
			end
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "vehicle:id") then
			local isVehicleHavePaintjob = tonumber(getElementData(source, "vehicle:upgrades")['paintjob'])
		
			if isVehicleHavePaintjob then
				removeVehiclePaintjob(source)
			end
		end
	end
end)

paintJobs = {}

function loadPaintJobs()
	for i = 1, 12 do
		paintJobs[i] = dxCreateTexture("files/"..i..".png")
	end
end
loadPaintJobs()

function addVehiclePaintjob(vehicle, paintjobID)
	if vehicle and paintjobID then
		if getElementData(vehicle, "vehicle:id") then
			removeVehiclePaintjob(vehicle)
			
			vehiclesWithPaintjob[vehicle] = {}
			vehiclesWithPaintjob[vehicle][1] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "vehicle")
			
			if vehiclesWithPaintjob[vehicle][1] then
				if paintJobs[paintjobID] then
					dxSetShaderValue(vehiclesWithPaintjob[vehicle][1], "TEXTURE", paintJobs[paintjobID])
				end
				engineApplyShaderToWorldTexture(vehiclesWithPaintjob[vehicle][1], "*vehiclegrunge256*", vehicle)
				engineApplyShaderToWorldTexture ( vehiclesWithPaintjob[vehicle][1], "?emap*", vehicle)
			end
		end
	end
end

function removeVehiclePaintjob(vehicle)
	if vehicle then
		if vehiclesWithPaintjob[vehicle] then
			local paintjobID = getElementData(vehicle, "vehicle:upgrades")['paintjob']
			if not paintjobID then return end
			destroyElement(vehiclesWithPaintjob[vehicle][1])
			vehiclesWithPaintjob[vehicle] = nil
		end
	end
end