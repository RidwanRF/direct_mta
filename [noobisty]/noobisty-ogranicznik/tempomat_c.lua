local wybraneOgraniczenie = 1
local ograniczenia = {nil, 160, 120, 80, 60,50, 40, 20}

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then -- if true - element is valid, no need to check again
		local diff = speed/acSpeed
		if diff ~= diff then return end -- if the number is a 'NaN' return end.
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end
	return false
end

function getVehSpeed(veh)
	local speedx,speedy,speedz = getElementVelocity(veh)
	return math.ceil(((speedx^2+speedy^2+speedz^2)^(0.5)) * 185)
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

local ograniczeniaModeli={
}

local ograniczeniaModeliWsteczne={
[532]=20,
[408]=20,
[481]=10,
[509]=10,
[510]=10,
[574]=15,
}



local cuboids={

}

function addCuboid(data)
	table.insert(cuboids, data)
end

for i,v in ipairs(cuboids) do
	setElementData(v[1],"cub:ogr",v[2])
end

function isFactionMoto(veh)
    if getPlayerTeam(localPlayer) == getTeamFromName("SAPD") or getPlayerTeam(localPlayer) == getTeamFromName("SAMD") then 
        if getElementModel(veh) == 523 or getElementModel(veh) == 586 then 
            return true
        end
    end
    return false
end

function tempomat()
	local plr = localPlayer
--	if getElementData(plr,"ACL") ~= "Admin" then return end
	if not isPedInVehicle(plr) then return end
	local veh=getPedOccupiedVehicle(plr)
	if getPedOccupiedVehicleSeat(plr) ~= 0 then return end
	local ograniczenie=ograniczenia[wybraneOgraniczenie]
	--if getElementData(veh, "tune:ogranicznik") ~= 1 then ograniczenie = nil end
	local cub_ogr = false
	local isPlane=false
	--if getVehicleType(veh)=="Plane" and getElementData(veh,"wznoszenie") and not isVehicleOnGround(veh) then isPlane=true ograniczenie=30 else end
	--if getVehicleType(veh)=="Plane" and getElementData(veh,"wznoszenie") and isVehicleOnGround(veh) then isPlane=true ograniczenie=60 else end
	if getVehicleType(veh)=="Plane" then isPlane=true else end
	if getElementModel(veh) ~= 573 then
		if not isPlane and not isVehicleOnGround(veh) then return end
	end
	local vx,vy,vz=getElementVelocity(veh)
	if not getVehicleEngineState(veh) then if getDistanceBetweenPoints2D(0,0,vx,vy)<0.1 then vx,vy = 0,0 setElementVelocity(veh,vx,vy,vz) return end end
	if (getVehicleSirensOn(veh) ~= true) or (getVehicleSirensOn(veh) == true and getElementData(veh,"vehicle:id")) then
		for i,v in ipairs(getElementsByType("colshape",resourceRoot,true)) do
			if getElementData(v,"cub:ogr") then
				if isElementWithinColShape(veh,v) and getElementDimension(veh) == 0 and getElementInterior(veh) == 0 then
					ograniczenie = math.min(tonumber(getElementData(v,"cub:ogr")) or 9999,tonumber(ograniczenie) or 9999)
					cub_ogr = true
				end
			end
		end
	end
	
	if not isPlane and not (getVehicleType(veh)=="Automobile" or getVehicleType(veh)=="Monster Truck" or getVehicleType(veh)=="Quad" or getVehicleType(veh) == "Bike") and not isFactionMoto(veh) and not ograniczeniaModeli[getElementModel(veh)] then return end
	if not isPlane and ograniczeniaModeli[getElementModel(veh)] then ograniczenie=ograniczeniaModeli[getElementModel(veh)] end
	if not isPlane and getElementData(veh,"ograniczenie") then ograniczenie=getElementData(veh,"ograniczenie") end
	if ograniczeniaModeli[getElementModel(veh)] then ograniczenie = math.min(ograniczenie,ograniczeniaModeli[getElementModel(veh)]) end
	if ograniczeniaModeliWsteczne[getElementModel(veh)] and getControlState("brake_reverse") and math.abs(vz)<0.03 then ograniczenie = math.min(ograniczenie or 9999,ograniczeniaModeliWsteczne[getElementModel(veh)] or 9999) end
	
	
	
	local wheels = {getVehicleWheelStates(veh)}
	local l=100
	for i,v in ipairs(wheels) do if v==1 then l = l - 20 end end
	if l~=100 and (ograniczenie or 9999) > l then if (getVehicleType(veh) ~= "Plane") then ograniczenie=l end end
	
	
	if not ograniczenie then return end
	
	local speed = getVehSpeed(veh)
	if ch_gtc ~= nil and (getTickCount()-ch_gtc) > 5500 then ch_gtc = nil end
	
	if speed > ograniczenie then
		if tonumber(getElementData(localPlayer,"cheat"))~=4 then
			local differ = speed-ograniczenie
			if differ > 5 then
				if utrdist or cub_ogr then
					setElementSpeed(veh,1,speed-3)
				else
					if ch_gtc ~= nil then
						local accel = math.max(1,math.min(100,getVehicleHandling(veh)["engineAcceleration"]))
						local val = 1-(accel/100)
						local fin = interpolateBetween(1,0,0,val,0,0,(getTickCount()-ch_gtc)/5000,"Linear")
						local cv,cy,cz = getElementVelocity(veh)
						setElementVelocity(veh,cv*fin,cy*fin,cz*fin)
						if fin == val then
							ch_gtc = nil
						end
					else
						local accel = math.max(1,math.min(100,getVehicleHandling(veh)["engineAcceleration"]))
						local val = 1-(accel/100)
						local cv,cy,cz = getElementVelocity(veh)
						setElementVelocity(veh,cv*val,cy*val,cz*val)
					end
				end
			else
				local cv,cy,cz = getElementVelocity(veh)
				local diff = ograniczenie/speed > 0.3 and ograniczenie/speed or 0.3
				setElementVelocity(veh,cv*diff,cy*diff,cz*diff)
			end
		end
	end

end


addEventHandler("onClientRender",root,tempomat)


local last_change = getTickCount()

local function isInTeamSAPD(player)
	if (getPlayerTeam(player) == getTeamFromName("SAPD")) then 
		return true 
	end
	return false
end

addCommandHandler("Zmniejsz ograniczenie predkosci", function()
	if isCursorShowing() or isPedDoingGangDriveby(localPlayer) then return end
	local v=getPedOccupiedVehicle(localPlayer)
	if not v then return end
	if getVehicleController(v)~=localPlayer then return end
	if getElementModel(v) ~= 573 then
		if not isVehicleOnGround(v) then return end
	end
	--if getElementData(v, "tune:ogranicznik") ~= 1 then return end
	if not (getVehicleType(v)=="Automobile" or getVehicleType(v)=="Monster Truck") and not isFactionMoto(v) then return end
	local team = getPlayerTeam(localPlayer)
	if (last_change + 250 > getTickCount()) and (not isElement(team)) then return end -- bugowanie prędkości przy zepsutej oponie
	if (wybraneOgraniczenie == 3) and not isInTeamSAPD(localPlayer) then wybraneOgraniczenie = 2 end
	wybraneOgraniczenie=wybraneOgraniczenie-1
	if wybraneOgraniczenie<1 then wybraneOgraniczenie=#ograniczenia end
	local speed = getVehSpeed(v)
	ch_gtc = getTickCount()
	last_change = getTickCount()
	if ograniczenia[wybraneOgraniczenie] == nil then ch_gtc = nil end
	setElementData(localPlayer,"Ogranicznik:Set",ograniczenia[wybraneOgraniczenie],false)
	if ograniczenia[wybraneOgraniczenie] then
		outputChatBox("Ⓘ #FFFFFFOgraniczenie prędkości zostało zmienione na #00FF00" ..ograniczenia[wybraneOgraniczenie].. "km/h.", 255,255,0, true)
	else
		outputChatBox("Ⓘ #FFFFFFOgraniczenie prędkości zostało #FF0000wyłączone.", 255,255,0, true)
	end
end)
bindKey("mouse1","down", "Zmniejsz ograniczenie predkosci")

addCommandHandler("Zwieksz ograniczenie predkosci", function()
	if isCursorShowing() or isPedDoingGangDriveby(localPlayer) then return end
	local v=getPedOccupiedVehicle(localPlayer)
	if not v then return end
	if not (getVehicleType(v)=="Automobile" or getVehicleType(v)=="Monster Truck") and not isFactionMoto(v) then return end
	if getVehicleController(v)~=localPlayer then return end
	if getElementModel(v) ~= 573 then
		if not isVehicleOnGround(v) then return end
	end
	--if getElementData(v, "tune:ogranicznik") ~= 1 then return end
	local team = getPlayerTeam(localPlayer)
	if (last_change + 250 > getTickCount()) and (not isElement(team)) then return end -- bugowanie prędkości przy zepsutej oponie
	last_change = getTickCount()
	if (wybraneOgraniczenie == 1) and not isInTeamSAPD(localPlayer) then wybraneOgraniczenie = 2 end  
	wybraneOgraniczenie=wybraneOgraniczenie+1
	if wybraneOgraniczenie>#ograniczenia then wybraneOgraniczenie=1 end
	ch_gtc = getTickCount()
	if ograniczenia[wybraneOgraniczenie] == nil then ch_gtc = nil end
	setElementData(localPlayer,"Ogranicznik:Set",ograniczenia[wybraneOgraniczenie],false)
	if ograniczenia[wybraneOgraniczenie] then
		outputChatBox("Ⓘ #FFFFFFOgraniczenie prędkości zostało zmienione na #00FF00" .. ograniczenia[wybraneOgraniczenie] .. "km/h.", 255,255,0, true)
	else
		outputChatBox("Ⓘ #FFFFFFOgraniczenie prędkości zostało #FF0000wyłączone.", 255,255,0, true)
	end
end)
bindKey("mouse2","down", "Zwieksz ograniczenie predkosci")

addEventHandler("onClientVehicleExit",root,function(plr,s)
	if plr == localPlayer and s == 0 then
		setElementData(localPlayer,"Ogranicznik:Set",nil)
	end
end)

addEventHandler("onClientVehicleEnter",root,function(plr,s)
	if plr == localPlayer and s == 0 then
		--if getElementData(source, "tune:ogranicznik") ~= 1 then return end
		setElementData(localPlayer,"Ogranicznik:Set",ograniczenia[wybraneOgraniczenie])
	end
end)