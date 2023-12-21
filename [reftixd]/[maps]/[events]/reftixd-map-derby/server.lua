local gate = createObject( 13623, 4470, -184.10, 72.30, 0, 0, 0 )
setElementDimension( gate, 650 ) 
setElementInterior( gate, 0 )

addCommandHandler("open", function(plr, cmd)
	if plr and isElement(plr) and getElementType(plr) == "player" then
		if getElementData(plr, "player:sid") then
			if getElementData(plr, "player:admin") then
				moveObject(gate, 2000, 4469.7, -184.1, 65.0)
			end
		end
	end
end)

addCommandHandler("close", function(plr, cmd)
	if plr and isElement(plr) and getElementType(plr) == "player" then
		if getElementData(plr, "player:sid") then
			if getElementData(plr, "player:admin") then
				moveObject(gate, 2000, 4470, -184.10, 72.30)
			end
		end
	end
end)

local cuboid = createColSphere(4468.137695,-183.611359,59.860939, 50)

function exitDerby(thePlayer)
	if isElement(thePlayer) and getElementType(thePlayer) == "player" then
		local veh = getPedOccupiedVehicle(thePlayer)

		if veh then
			if not getElementData(veh, "vehicle:id") then
				destroyElement(veh)
			end
		end

		setTimer( function()
			if isElement(thePlayer) then
				setElementDimension(thePlayer, 0)
				setElementInterior(thePlayer, 0)
				setElementPosition(thePlayer, -1945.555786,487.098114,35.171837)
			end
		end, 100, 1)
	end
end
addEventHandler("onColShapeLeave", cuboid, exitDerby)