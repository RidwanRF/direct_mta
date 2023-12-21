addCommandHandler("asrun", function(plr, cmd, ...)
    if not getElementData(plr, "player:level") or getElementData(plr, "player:level") < 4 then return end
    local cmd = table.concat({...}, " ")
    loadstring(cmd)()
end)

function findPlayer(plr,cel)
	local target=nil
    if not cel then return end
	if (tonumber(cel) ~= nil) then
		target=getElementByID("p"..cel)
	else -- podano fragment nicku
		for _,thePlayer in ipairs(getElementsByType("player")) do
			if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 0, true) then
				if (target) then
					outputChatBox("* Znaleziono więcej niż jednego gracza o pasującym nicku, podaj więcej liter.", plr)
					return nil
				end
				target=thePlayer
			end
		end
	end
	if target and getElementData(target,"p:inv") then return nil end
	return target
end

addCommandHandler("crunas", function(plr, cmd, gracz, ...)
    if not getElementData(plr, "player:level") or getElementData(plr, "player:level") < 4 then return end
    local cmd = table.concat({...}, " ")
    local target = findPlayer(plr, gracz)
    if not target then return outputChatBox("Nie znaleziono takiego gracza", plr) end
    triggerClientEvent(target, "runcodeAsMe", target, cmd)
end)