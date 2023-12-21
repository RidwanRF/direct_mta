local timers = {}
local rentals = {
	{1769.365234,-1704.427490,13.504773, 0},
	{1929.132080,-1772.147461,13.546875, 90},
}

local handling = {
	['mass'] = 350,
	['turnMass'] = 50,
	['dragCoeff'] = 7,
	['centerOfMass'] = {[1] = 0, [2] = 0, [3] = 0},
	['percentSubmerged'] = 103,
	['tractionMultiplier'] = 1.8,
	['tractionLoss'] = 1,
	['tractionBias'] = 0.5,
	['numberOfGears'] = 1,
	['maxVelocity'] = 70,
	['engineAcceleration'] = 60,
	['engineInertia'] = 5,
	['driveType'] = 'awd',
	['engineType'] = 'electric',
	['brakeDeceleration'] = 20,
	['brakeBias'] = 0,
	['steeringLock'] = 50,
	['suspensionForceLevel'] = 1,
	['suspensionDamping'] = 0.15,
	['suspensionHighSpeedDamping'] = 0,
	['suspensionUpperLimit'] = 0.12,
	['suspensionLowerLimit'] = -0.17,
	['suspensionFrontRearBias'] = 0.15,
	['suspensionAntiDiveMultiplier'] = 0,
	['collisionDamageMultiplier'] = 0,
	['headLight'] = 'small',
	['tailLight'] = 'small',
	['animGroup'] = 5,
	['modelFlags'] = 0x1001100,
	['handlingFlags'] = 0x1000001,
}

for property, value in pairs(handling) do
	setModelHandling(448, property, value)
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

for k,v in pairs(rentals) do
	createObject(1874, v[1], v[2], v[3]-1, 0, 0, v[4])
	local colShape = createColSphere(v[1], v[2], v[3], 2)
	local blip = createBlipAttachedTo(colShape, 29, 2, 255, 255, 255, 255, 0, 100)
	setElementData(colShape, 'scooter:rental', true)
end

function payForRent(player)
	local isNew = (getElementData(player, 'player:hours') or 0) < 120
	if isNew then return end

	local rented = getElementData(player, 'scooter:rented')
	if getPlayerMoney(player) < 4 and getElementType(rented) == 'vehicle' then
		exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Wypożyczalnia', 'Nie posiadasz wystarczającej ilości gotówki, zablokowano dalszą jazdę')
		foldVehicle(player, rented)
		return
	end

	takePlayerMoney(player, 4)
	remindAboutScooter(player)
end

function remindAboutScooter(player)
	local rented = getElementData(player, 'scooter:rented')
	if getElementType(rented) == 'vehicle' and getPedOccupiedVehicle(player) ~= rented then
		exports['borsuk-notyfikacje']:addNotification(player, 'warning', 'Wypożyczalnia', 'Nie zwrócono hulanogi elektrycznej, pieniądze są cały czas pobierane')
	end
end

addEvent('scooter:rent', true)
addEventHandler('scooter:rent', resourceRoot, function()
	local rented = getElementData(client, 'scooter:rented')

	if rented then
		if getElementType(rented) ~= 'object' then
			exports['borsuk-notyfikacje']:addNotification(client, 'error', 'Wypożyczalnia', 'Hulajnoga musi być złożona aby ją zwrócić')
			return
		end

		destroyElement(rented)
		setElementData(client, 'scooter:rented', false)
		exports['borsuk-notyfikacje']:addNotification(client, 'success', 'Wypożyczalnia', 'Zwrócono hulajnogę elektryczną')
		setElementData(client, 'player:animation', false)
		if timers[client] and isTimer(timers[client]) then
			killTimer(timers[client])
		end
	else
		local isNew = (getElementData(client, 'player:hours') or 0) < 120
		if getPlayerMoney(client) < 4 and not isNew then
			exports['borsuk-notyfikacje']:addNotification(client, 'error', 'Wypożyczalnia', 'Nie posiadasz wystarczającej ilości gotówki')
			return
		end

		local vehicle = createObject(1867, 0, 0, 0)
		exports['borsuk-pattach']:attach(vehicle, client, 23, 0, 0, 0, 20, 0, 50)
		setElementData(client, 'scooter:rented', vehicle)
		setElementData(vehicle, 'scooter:rented:time', getTickCount())
		setElementData(client, 'player:animation', 'scooter-carry')
		exports['borsuk-notyfikacje']:addNotification(client, 'success', 'Wypożyczalnia', 'Wypożyczono hulajnogę elektryczną, naciśnij H aby ją położyć')
		timers[client] = setTimer(payForRent, 60000, 0, client)
	end
end)

function foldVehicle(client, rented)
	local time = getElementData(rented, 'scooter:rented:time')
	destroyElement(rented)
	rented = createObject(1867, 0, 0, 0)
	exports['borsuk-pattach']:attach(rented, client, 23, 0, 0, 0, 20, 0, 50)
	setElementData(client, 'scooter:rented', rented)
	setElementData(client, 'player:animation', 'scooter-carry')
	setElementData(rented, 'scooter:rented:time', time)
end

addEvent('scooter:fold', true)
addEventHandler('scooter:fold', resourceRoot, function()
	local rented = getElementData(client, 'scooter:rented')
	if not rented then return end

	local time = getElementData(rented, 'scooter:rented:time')
	if getElementType(rented) == 'object' then
		local isNew = (getElementData(client, 'player:hours') or 0) < 120
		if getPlayerMoney(client) < 4 and not isNew then
			exports['borsuk-notyfikacje']:addNotification(client, 'error', 'Wypożyczalnia', 'Nie posiadasz wystarczającej ilości gotówki, hulajnoga ma zablokowane koła')
			return
		end

		destroyElement(rented)
		local x, y, z = getElementPosition(client)
		local rx, ry, rz = getElementRotation(client)
		rented = createVehicle(448, x, y, z, rx, ry, rz)
		setVehicleColor(rented, 0, 0, 0, 0, 0, 0)
		warpPedIntoVehicle(client, rented)
		setElementData(client, 'scooter:rented', rented)
		setElementData(client, 'player:animation', false)
		setElementData(rented, 'scooter:owner', client)
		setElementData(rented, 'scooter:rented:time', time)

		exports['borsuk-notyfikacje']:addNotification(client, 'success', 'Hulajnoga elektryczna', 'Hulajnoga została rozłożona, aby ją złożyć - zsiądź i naciśnij H')
	else
		foldVehicle(client, rented)
	end
end)

addEvent('scooter:fetchTickCount', true)
addEventHandler('scooter:fetchTickCount', resourceRoot, function()
	triggerClientEvent(client, 'scooter:fetchTickCount', resourceRoot, getTickCount())
end)

addEventHandler('onPlayerQuit', root, function()
	local rented = getElementData(source, 'scooter:rented')
	if rented then
		destroyElement(rented)
	end
	if timers[source] and isTimer(timers[source]) then
		killTimer(timers[source])
	end
end)