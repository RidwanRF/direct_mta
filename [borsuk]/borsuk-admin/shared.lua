function getAdmin(player, level)
	return (getElementData(player, 'player:admin') or 0) >= (level or 1)
end

function getPlayerBySid(sid)
	for i, v in ipairs(getElementsByType('player')) do
		if getElementData(v, 'player:sid') == sid then
			return v
		end
	end
end