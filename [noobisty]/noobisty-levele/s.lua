function setLevel( player, level )
	setElementData( player, "player:lvl", level )
end

function setExp( player, level )
	setElementData( player, "player:exp", level )
end

function getLevel( player )
	return getElementData( player, "player:lvl" )
end

function addExp( player, exp )
	triggerClientEvent ( player, "addExpC", player, exp )
end

function getExp( player )
	return getElementData( player, "player:exp" )
end

function getExpGate( player )
	local gate = math.floor(100 * (getLevel(player) * 0.65))
	local gate = tostring(gate)
	local gate = tonumber(string.sub(gate, 1, string.len(gate)-1).."0")

	if gate > 100 then
		return gate
	else
		return 100
	end
end