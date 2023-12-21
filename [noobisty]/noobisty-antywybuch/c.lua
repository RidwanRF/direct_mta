function jebacrejsa()
	for _,car in ipairs(getElementsByType("vehicle",root,true)) do
		if getElementHealth(car) < 300 then
			if getElementHealth(car) > 20 and getElementModel(car) ~= 432 then
				setElementHealth(car,301) 
			end
		end
		if getVehicleController(car) then
			if getElementData(car, "damage:proof") == true then
				setVehicleDamageProof(car,true)
			else 
				setVehicleDamageProof(car,false)
			end
		else
			setVehicleDamageProof(car,true)
		end
	end
end
jebacrejsa()
setTimer(jebacrejsa,15000,0)


function pali()
	if isPedInVehicle(localPlayer) then
		local car = getPedOccupiedVehicle(localPlayer)
		if car then
			if getElementHealth(car) <= 320 then
				if getElementHealth(car) > 20 and getElementModel(car) ~= 432 then
					setElementHealth(car,320) 
				end
			end
		end
	end
end 
setTimer(pali,1000,0)


addEventHandler("onClientVehicleEnter",root,function(plr,seat)
	if seat == 0 or not getVehicleController(source) then
		if getElementData(source, "damage:proof") == true then setVehicleDamageProof(source,true) return end
		setVehicleDamageProof(source,false)
		jebacrejsa()
	end
end)
addEventHandler("onClientVehicleExit",root,function(plr,seat)
	if seat == 0 or not getVehicleController(source) then
		setVehicleDamageProof(source, true)
	end
end)
addEventHandler("onClientPlayerQuit",root,function()
	local veh = getPedOccupiedVehicle(source)
	if veh then
		if not getVehicleController(veh) or getVehicleController(veh) == source then
			setVehicleDamageProof(source, true)
		end
	end
end)
addEventHandler("onClientPlayerWasted",root,function()
	local veh = getPedOccupiedVehicle(source)
	if veh then
		if not getVehicleController(veh) or getVehicleController(veh) == source then
			setVehicleDamageProof(source, true)
		end
	end
end)

addEventHandler("onClientVehicleCollision",root,function(_,_,loss)
	if getElementData(source, "damage:proof") == true then cancelEvent() return end
end)
boomDim={
	[500]={[15]=true},
}
addEventHandler("onClientVehicleDamage",root,function(_,_,loss)
	if boomDim[getElementDimension(localPlayer)] and boomDim[getElementDimension(localPlayer)][getElementInterior(localPlayer)] then return end
	if getElementData(source, "damage:proof") == true then cancelEvent() return end
	if source and isElement(source) and source == getPedOccupiedVehicle(localPlayer) then
		if not isVehicleBlown(source) then
			if getElementHealth(source) - loss < 301 then
				cancelEvent()
			end
		end
	end
end)