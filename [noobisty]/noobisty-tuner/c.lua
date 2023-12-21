function zoomCamera(key)
    if key == "mouse_wheel_up" then
        if isCursorShowing() then
            cameraSettings["zoom"] = math.max(cameraSettings["zoom"] - 5, 30)
            cameraSettings["zoomTick"] = getTickCount()
        end
    elseif key == "mouse_wheel_down" then
        if isCursorShowing() then
            cameraSettings["zoom"] = math.min(cameraSettings["zoom"] + 5, 60)
            cameraSettings["zoomTick"] = getTickCount()
        end
    end
end

function setCamera()
    _, _, vehicleRotation = getElementRotation(data.vehicle[localPlayer])
    cameraRotation = vehicleRotation + 60
    cameraSettings = {

	    ["distance"] = 9,
	    ["movingSpeed"] = 2,
        ["currentX"] = math.rad(cameraRotation),
		["defaultX"] = math.rad(cameraRotation),
		["currentY"] = math.rad(cameraRotation),
		["currentZ"] = math.rad(15),
		["maximumZ"] = math.rad(35),
		["minimumZ"] = math.rad(0),
	    ["freeModeActive"] = false,
	    ["zoomTick"] = 0,
	    ["zoom"] = 60,
        ["moveState"] = "freeMode",
        ["viewingElement"] = data.vehicle[localPlayer],

    }
end

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix(element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x,y,z
end

local originalTune = {}

function getOriginalTune()
	return originalTune
end

function restoreDefaultTuning()
	local veh = getPedOccupiedVehicle(localPlayer)
	for i = 0, 16 do
		removeVehicleUpgrade(veh, getVehicleUpgradeOnSlot(veh, i))
		if originalTune[i] then
			addVehicleUpgrade(veh, originalTune[i])
		end
	end
	setElementData(veh, "visualTuning", originalTune.data)
	setElementData(veh, "vehicle:carTint", originalTune.tint)
	setElementData(veh, "vehicle:engine", originalTune.pojemnoscsilnika)
	setElementData(veh, "vehicle:bak", originalTune.pojemnoscbaku)
end

function buyTuning()
	local cost = calculateCost()
	if getPlayerMoney() < cost then
		restoreDefaultTuning()
		return exports["noobisty-notyfikacje"]:createNotification("Tuning", "Nie posiadasz tyle gotówki", {255, 0, 0}, "sighter")
	end
	local veh = getPedOccupiedVehicle(localPlayer)
	local t = {}
	for i = 0, 16 do
		t[i] = getVehicleUpgradeOnSlot(veh, i)
	end
	local visual = getElementData(veh, "visualTuning")
	local tint = getElementData(veh, "vehicle:carTint")
	local engine = getElementData(veh, "vehicle:engine")
	local bak = getElementData(veh, "vehicle:bak")
	triggerServerEvent("buyTuningAndPay", veh, t, visual, tint, engine, bak, cost)
end

function createTuningVehicle(veh)
	for i = 0, 16 do
		local up = getVehicleUpgradeOnSlot(veh, i)
		originalTune[i] = up
	end

	originalTune.data = (getElementData(veh, "visualTuning") or {
		innerSize = 1,
		wheelResize = 1,
		wheelTilt = 0,
	})
	originalTune.tint = (getElementData(veh, "vehicle:carTint") or 0)
	originalTune.pojemnoscsilnika = tonumber(getElementData(veh, "vehicle:engine") or 1.2)
	originalTune.pojemnoscbaku = tonumber(getElementData(veh, "vehicle:bak") or 25)

    local vehicleData = {

        model = (getElementData(veh, "vehicle:model") or getElementModel(veh)),
        wheels = (getElementData(veh, "visualTuning") or {}),
        windows = (getElementData(veh, "vehicle:tincarTintt") or 0),
        color = {getVehicleColor(veh)},
        plate = getVehiclePlateText(veh),

    }

    data.vehicle[localPlayer] = veh
	setElementPosition(data.vehicle[localPlayer], 610.28, -1.36, 1000.92)
	setElementRotation(data.vehicle[localPlayer], 0, 0, -90)
    setElementInterior(data.vehicle[localPlayer], 1)
    setElementInterior(localPlayer, 1)

    setCamera()
    setCameraShakeLevel(0)
    showCursor(true)
	toggleAllControls(false)
end

function openGUI(el)
    if el == localPlayer then
		originalTune = {}

        local veh = getPedOccupiedVehicle(localPlayer)

        if veh and localPlayer == getVehicleController(veh) then
            createTuningVehicle(veh)
        end
    end
end

function runScript()
    for i,v in ipairs(data.markerPos) do
        local marker = createMarker(v[1], v[2], v[3]-1, 'cylinder', 3, 255, 255, 0, 55)
        setElementData(marker, "marker:title", "Tuning")
        setElementData(marker, "marker:desc", "Ulepsz swój pojazd!")

        addEventHandler('onClientMarkerHit', marker, openGUI)
    end
end
--runScript()

local mouseTable = {

	["speed"] = {0, 0},
	["last"] = {0, 0},
	["move"] = {0, 0}

}

addEventHandler("onClientPreRender", root, function(timeSlice)
	if isCursorShowing() then
		local cursorX, cursorY = getCursorPosition()
		
		mouseTable["speed"][1] = math.sqrt(math.pow((mouseTable["last"][1] - cursorX) / timeSlice, 2))
		mouseTable["speed"][2] = math.sqrt(math.pow((mouseTable["last"][2] - cursorY) / timeSlice, 2))
		
		mouseTable["last"][1] = cursorX
		mouseTable["last"][2] = cursorY
	end
	
	if data.toggleGUI then
		local _, _, _, _, _, _, roll, fov = getCameraMatrix()
		local cameraZoomProgress = (getTickCount() - cameraSettings["zoomTick"]) / 500
		local cameraZoomAnimation = interpolateBetween(fov, 0, 0, cameraSettings["zoom"], 0, 0, cameraZoomProgress, "Linear")
		
		local cameraX, cameraY, cameraZ, elementX, elementY, elementZ = _getCameraPosition("both")
			
		setCameraMatrix(cameraX, cameraY, cameraZ, elementX, elementY, elementZ, roll, cameraZoomAnimation)
			
		if getKeyState("mouse1") and isCursorShowing() and not isMTAWindowActive() then
			cameraSettings["freeModeActive"] = true
		else
			cameraSettings["freeModeActive"] = false
		end
	end
end)

addEventHandler("onClientCursorMove", root, function(cursorX, cursorY, absoluteX, absoluteY)
	if data.toggleGUI then
		if cameraSettings["freeModeActive"] then
			lastCursorX = mouseTable["move"][1]
			lastCursorY = mouseTable["move"][2]
			
			mouseTable["move"][1] = cursorX
			mouseTable["move"][2] = cursorY
			
			if cursorX > lastCursorX then
				cameraSettings["currentX"] = cameraSettings["currentX"] - (mouseTable["speed"][1] * 100)
			elseif cursorX < lastCursorX then
				cameraSettings["currentX"] = cameraSettings["currentX"] + (mouseTable["speed"][1] * 100)
			end
			
			if cursorY > lastCursorY then
				cameraSettings["currentZ"] = cameraSettings["currentZ"] + (mouseTable["speed"][2] * 50)
			elseif cursorY < lastCursorY then
				cameraSettings["currentZ"] = cameraSettings["currentZ"] - (mouseTable["speed"][2] * 50)
			end
			
			cameraSettings["currentY"] = cameraSettings["currentX"]
			cameraSettings["currentZ"] = math.max(cameraSettings["minimumZ"], math.min(cameraSettings["maximumZ"], cameraSettings["currentZ"]))
		end
	end
end)

function _getCameraPosition(element)
	if element == "component" then
		local componentX, componentY, componentZ = getVehicleComponentPosition(data.vehicle[localPlayer], cameraSettings["viewingElement"])
		local elementX, elementY, elementZ = getPositionFromElementOffset(data.vehicle[localPlayer], componentX, componentY, componentZ)
		local elementZ = elementZ + 0.2
		
		local cameraX = elementX + math.cos(cameraSettings["currentX"]) * cameraSettings["distance"]
		local cameraY = elementY + math.sin(cameraSettings["currentY"]) * cameraSettings["distance"]
		local cameraZ = elementZ + math.sin(cameraSettings["currentZ"]) * cameraSettings["distance"]
		
		return cameraX, cameraY, cameraZ, elementX, elementY, elementZ
	elseif element == "vehicle" then
		local elementX, elementY, elementZ = getElementPosition(data.vehicle[localPlayer])
		local elementZ = elementZ + 0.2
		
		local cameraX = elementX + math.cos(cameraSettings["currentX"]) * cameraSettings["distance"]
		local cameraY = elementY + math.sin(cameraSettings["currentY"]) * cameraSettings["distance"]
		local cameraZ = elementZ + math.sin(cameraSettings["currentZ"]) * cameraSettings["distance"]
		
		return cameraX, cameraY, cameraZ, elementX, elementY, elementZ
	elseif element == "both" then
		if type(cameraSettings["viewingElement"]) == "string" then
			local componentX, componentY, componentZ = getVehicleComponentPosition(data.vehicle[localPlayer], cameraSettings["viewingElement"])
			
			elementX, elementY, elementZ = getPositionFromElementOffset(data.vehicle[localPlayer], componentX, componentY, componentZ)
		else
			elementX, elementY, elementZ = getElementPosition(data.vehicle[localPlayer])
		end
		
		local elementZ = elementZ + 0.2
		
		local cameraX = elementX + math.cos(cameraSettings["currentX"]) * cameraSettings["distance"]
		local cameraY = elementY + math.sin(cameraSettings["currentY"]) * cameraSettings["distance"]
		local cameraZ = elementZ + math.sin(cameraSettings["currentZ"]) * cameraSettings["distance"]
		
		return cameraX, cameraY, cameraZ, elementX, elementY, elementZ
	end
end