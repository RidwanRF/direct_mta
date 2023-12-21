-- Variables
main = {}

-- Flip function
main.flip = function(plr)
	local veh = getPedOccupiedVehicle(plr)

	if veh then
		outputChatBox('✘#FFFFFF Aby obrócić pojazd wysiądź z niego', plr, 255, 0, 0, true)
	else
		local x, y, z = getElementPosition(plr)
		local vehicles = getElementsWithinRange(x, y, z, 3, "vehicle")

		if #vehicles == 0 then
			outputChatBox('✘#FFFFFF Brak pojazdu w pobliżu', plr, 255, 0, 0, true)
		elseif #vehicles == 1 then
			for i,v in ipairs(vehicles) do
				local rX, rY, rZ = getElementRotation(v)
				setElementRotation(v, 0, 0, rZ)
				outputChatBox("ⓘ#FFFFFF Pojazd został obrócony", plr, 255, 255, 0, true)
			end
		else
			outputChatBox('✘#FFFFFF Zbyt dużo pojazdów wokół ciebie', plr, 255, 0, 0, true)
		end
	end
end


-- Handlers
addCommandHandler("op", main.flip)

