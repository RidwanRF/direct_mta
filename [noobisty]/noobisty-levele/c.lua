level = {}
level.alpha = 0
level.hide = 1

addEventHandler( "onClientRender", root, function()
	if not level.newLevel then
		level.newLevel = getElementData( localPlayer, "player:lvl" )
	end
	if not level.newExp then
		level.newExp = getElementData( localPlayer, "player:exp" )
	end
	local expGate = getExpGate()
	--if not level.newExp then level.newExp = 0 end
	if getElementData( localPlayer, "player:exp" ) ~= level.newExp then
		if getElementData( localPlayer, "player:exp" ) < level.newExp then
			if level.alpha < 200 then
				level.alpha = level.alpha + 5
			else
				setElementData( localPlayer, "player:exp", getElementData( localPlayer, "player:exp" ) + 1 )
				if getElementData( localPlayer, "player:exp" ) >= expGate then
					setElementData( localPlayer, "player:exp", 0 )
					setElementData( localPlayer, "player:lvl", getElementData( localPlayer, "player:lvl" ) + 1 )
					level.newExp = level.newExp - expGate
				end
			end
		else
			if level.alpha < 200 then
				level.alpha = level.alpha + 5
			else
				setElementData( localPlayer, "player:exp", getElementData( localPlayer, "player:exp" ) - 1 )
				if getElementData( localPlayer, "player:exp" ) < 0 then
					setElementData( localPlayer, "player:exp", expGate )
					setElementData( localPlayer, "player:lvl", getElementData( localPlayer, "player:lvl" ) - 1 )
					level.newExp = level.newExp + getExpGate
				end
			end
		end
	else
		if level.hide == 1 then
			setTimer( function()
				level.hide = 2
			end, 1000, 1 )
		end
		if level.hide == 2 then
			if level.alpha > 0 then
				level.alpha = level.alpha - 5
			end
		end
	end
end)

function setLevel( level )
	setElementData( localPlayer, "player:lvl", level )
end

function setExp( level )
	setElementData( localPlayer, "player:exp", level )
	level.newExp = 0
end

function getLevel(  )
	return getElementData( localPlayer, "player:lvl" )
end

function addExp( exp )
	level.newExp = level.newExp + exp
end

function getExp(  )
	return getElementData( localPlayer, "player:exp" )
end

addEvent( "addExpC", true )
addEventHandler( "addExpC", localPlayer, function( exp )
	level.newExp = level.newExp + exp
end )

function getExpGate(plr)
	if not plr then plr = localPlayer end

	local gate = math.floor(100 * ((getElementData(plr, "player:lvl" ) or 0) * 0.65))
	local gate = tostring(gate)
	local gate = tonumber(string.sub(gate, 1, string.len(gate)-1).."0")

	if gate > 100 then
		return gate
	else
		return 100
	end
end