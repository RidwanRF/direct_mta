addEvent("onDryerAction", true)
addEventHandler("onDryerAction", root, function(typ, selected, el)
    if not el or not selected then return end
    if typ == "player" then
	
        if selected == 1 then
            setElementHealth(el, 100)
	        outputChatBox("#33CC00✓ #ffffffGracz uleczony", el, 255, 255, 255, true)
        end

        if selected == 2 then
            if getElementData(el, "player:admin") then return end
            setElementHealth(el, 0)
	        outputChatBox("#33CC00✓ #ffffffZabito gracza", el, 255, 255, 255, true)
        end

        if selected == 3 then
            local x, y, z = getElementPosition(source)
            setElementPosition(el, x, y, z)
	        outputChatBox("#33CC00✓ #ffffffGracz został przeniesiony", el, 255, 255, 255, true)
        end

        if selected == 4 then
            local x, y, z = getElementPosition(el)
            setElementPosition(source, x, y, z)
	    outputChatBox("#33CC00✓ #ffffffPrzeniesiono do gracza", el, 255, 255, 255, true)
        end
    end


    if typ == "vehicle" then
	
        if selected == 1 then
            local x, y, z = getElementRotation(el)
            setElementRotation(el, 0, 0, z)
	        outputChatBox("#33CC00✓ #ffffffObrócono pojazd", source, 255, 255, 255, true)
        end

        if selected == 2 then 
            fixVehicle(el)
	        outputChatBox("#33CC00✓ #ffffffNaprawiono pojazd", source, 255, 255, 255, true)
        end


        if selected == 3 then 
            local x, y, z = getElementPosition(source)
            setElementPosition(el, x, y, z)
            setElementPosition(source, x, y, z+0.2)
	        outputChatBox("#33CC00✓ #ffffffPojazd przeniesiony", source, 255, 255, 255, true)
        end
		
        if selected == 4 then 
            if getElementData(el, "vehicle:id") then
                if isElement(el) then
                exports["pystories-vehicles"]:onSaveVehicle(el,source)
                local query = exports["pystories-db"]:dbSet("UPDATE pystories_vehicles SET tp_to_parking=? WHERE id=?", getPlayerName(source), getElementData(el, "vehicle:id"))
                exports["pystories-vehicles"]:onParkVehicle(el)
	    	    outputChatBox("#33CC00✓ #ffffffSchowałeś/aś pojazd do przechowalni", source, 255, 255, 255, true)
                end
            end
        end

        if selected == 5 then 
            if getElementData(el, "vehicle:id") then
                if isElement(el) then
		        exports["pystories-vehicles"]:onSaveVehicle(el,source)
                exports['pystories-db']:dbSet("INSERT INTO pystories_vehicles_parking (idpojazdu, funkcjonariusz,rejestracja,data,powod,cena) VALUES (?,?,?,NOW(),?,?)", getElementData(el, "vehicle:id"), ""..getPlayerName(source).." - Suszarka", "SA "..getElementData(el, "vehicle:id").."", "Brak powodu - Suszarka administracji", 1000)
                exports['pystories-db']:dbSet("Update pystories_vehicles set police=1 where id=?", getElementData(el, "vehicle:id"))
                destroyElement(el)
	    	    outputChatBox("#33CC00✓ #ffffffOddano pojazd na parking policyjny", source, 255, 255, 255, true)
                end
            end
        end

        if selected == 6 then
            if not getElementData(el,"vehicle:spawn") then
				if getElementData(el,"spawnowany") then
					destroyElement(el)
	    			outputChatBox("#33CC00✓ #ffffffPomyślnie usunięto pojazd", source, 255, 255, 255, true)
				else
					respawnVehicle(el)
	    			outputChatBox("#33CC00✓ #ffffffPomyślnie zrespawnowano pojazd", source, 255, 255, 255, true)
				end
			else
                exports["pystories-vehicles"]:onSaveVehicle(el)
                local query = exports["pystories-db"]:dbSet("UPDATE pystories_vehicles SET tp_to_parking=? WHERE id=?", getPlayerName(source), getElementData(el, "vehicle:id"))
                exports["pystories-vehicles"]:onParkVehicle(el)
	    		outputChatBox("#33CC00✓ #ffffffPomyślnie oddano pojazd na parking", source, 255, 255, 255, true)
	    		outputChatBox("#FF0000✘ #ffffffTen pojazd jest prywatny, użyto opcji SCHOWAJ DO PRZECHOWALNI", source, 255, 255, 255, true)
            end
        end

        if selected == 7 then
            setElementData(el,"vehicle:fuel", (getElementData(el, "vehicle:bak") or 25))
            setElementData(el,"vehicle:fuelpgl", 100)
		    outputChatBox("#33CC00✓ #ffffffPomyślnie zatankowano pojazd", source, 255, 255, 255, true)
		end

        if selected == 8 then
            setVehicleLocked (el,false)
	        outputChatBox("#33CC00✓ #ffffffOtwarto pojazd", source, 255, 255, 255, true)
		end
	end
end)