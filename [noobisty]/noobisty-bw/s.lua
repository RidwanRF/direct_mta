addEventHandler("onPlayerWasted", root, function()
    if isPedInVehicle(source) then removePedFromVehicle(source) end

	triggerClientEvent(source, "toggleBW", source, true)
end)

addEvent("respawnPlayerBW", true)
addEventHandler("respawnPlayerBW", root, function(plr)
	local x, y, z = getElementPosition(plr)
	spawnPlayer(plr, x, y, z)

	setCameraTarget(plr, plr)
	setElementModel(plr, getElementData(plr, "player:skin"))
end)

addCommandHandler('usunbw', function(plr, cmd, targetPlayer)
    if exports['borsuk-admin']:getAdmin(plr, 3) or exports['borsuk-admin']:getAdmin(plr, 4) then
        local target = exports['iq-core']:findPlayer(plr, targetPlayer)
        if target then
            local x, y, z = getElementPosition(target)
	        spawnPlayer(target, x, y, z)

	        setCameraTarget(target, target)
	        setElementModel(target, getElementData(target, "player:skin"))
            triggerClientEvent(target, "toggleBW", target, false)
        end
    end
end)

addCommandHandler('nadajbw', function(plr, cmd, targetPlayer)
    if exports['borsuk-admin']:getAdmin(plr, 3) or exports['borsuk-admin']:getAdmin(plr, 4) then
        local target = exports['iq-core']:findPlayer(plr, targetPlayer)
        if target then
            setElementHealth(target, 0)
        end
    end
end)