local option={}
local vehicle={}
local player={}
value = nil
element = nil
option.selected = 0
option.actived = false


option["vehicle"] = {

    "OBRÓĆ",
    "NAPRAW",
    "PRZENIEŚ DO SIEBIE",
    "SCHOWAJ DO PRZECHOWALNI",
    "ODDAJ NA PARKING POLICYJNY",
    "RESPAWNUJ POJAZD (USUŃ)",
    "ZATANKUJ",
    "OTWORZ AUTO",

}

option["player"] = {

    "ULECZ",
    "ZABIJ",
    "PRZENIEŚ DO SIEBIE",
    "PRZENIEŚ DO NIEGO",

}

function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function isRendering()
    if isPedAiming(localPlayer) and getPedWeapon(localPlayer) == 22 and getElementData(localPlayer, "player:admin") == true then
    if option.actived == true then
    	if not isElement(element) then return end
        if value == "vehicle" then

            local ID = (tonumber(getElementData(element, "vehicle:id")) or 0)
            local vehicleName = getVehicleName(element)
            local vehicleEngine = (getElementData(element, "vehicle:engine") or "1.2")
            local vehicleFuel = (getElementData(element, "vehicle:fuel") or 100)
            local vehicleMileage = (getElementData(element, "vehicle:mileage") or 0)

            stringInfo = "ID: "..ID.."\nPojazd: "..vehicleName.."\nPojemność silnika: "..vehicleEngine.." dm3\nStan paliwa: "..math.floor(vehicleFuel).." L\nPrzebieg: "..math.floor(vehicleMileage).." km\nStan pojazdu: "..(getElementHealth(element)/10).." %"

            dxDrawText(option[value][option.selected] or "WYBIERZ OPCJE", sx/2+2/zoom, 47/zoom, nil, nil, tocolor(0, 0, 0, 255), 1, font2, "center", "bottom", false, false, false, false, false)
            dxDrawText(stringInfo, sx/2+2/zoom, 47/zoom, nil, nil, tocolor(0, 0, 0, 255), 1, font1, "center", "top", false, false, false, false, false)
            dxDrawText(option[value][option.selected] or "WYBIERZ OPCJE", sx/2, 45/zoom, nil, nil, tocolor(25, 195, 255, 255), 1, font2, "center", "bottom", false, false, false, false, false)
            dxDrawText(stringInfo, sx/2, 45/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, font1, "center", "top", false, false, false, false, false)


        elseif value == "player" then

            local p_uid = getElementData(element, "player:sid") or 0
            local p_id = getElementData(element, "id") or 0
            local p_money = getPlayerMoney(element)
            local p_skin = getElementData(element, "player:skin") or 0
            local p_organization = getElementData(element, "player:organization") or "Brak"
            local p_faction = getElementData(element, "player:faction") or "Brak"
            local p_time = getElementData(element, "player:hours") or 0
            local p_pp = getElementData(element, "player:pp") or 0

            stringInfo = "SID: "..p_uid.."\nID: "..p_id.."\nGotówka: "..p_money.." PLN\nSkin: "..p_skin.."\nOrganizacja: "..p_organization.."\nFrakcja: "..p_faction..""

            dxDrawText(option[value][option.selected] or "WYBIERZ OPCJE", sx/2+2/zoom, 47/zoom, nil, nil, tocolor(0, 0, 0, 255), 1, font2, "center", "bottom", false, false, false, false, false)
            dxDrawText(stringInfo, sx/2+2/zoom, 47/zoom, nil, nil, tocolor(0, 0, 0, 255), 1, font1, "center", "top", false, false, false, false, false)
            dxDrawText(option[value][option.selected] or "WYBIERZ OPCJE", sx/2, 45/zoom, nil, nil, tocolor(25, 195, 255, 255), 1, font2, "center", "bottom", false, false, false, false, false)
            dxDrawText(stringInfo, sx/2, 45/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, font1, "center", "top", false, false, false, false, false)

 		end
	end
end
end

addEventHandler("onClientPlayerTarget",root, function(el)
    if isPedAiming(localPlayer) and el and getPedWeapon(localPlayer) == 22 and getElementData(localPlayer, "player:admin") == true then
        if not option.actived  then
			if getElementData(el,"p:inv") then return end
            if getElementType(el) == "vehicle" then
                value="vehicle"
                element=el
                option.actived=true
            elseif getElementType(el) == "player" then
                value="player"
                element=el
                option.actived=true
            else return end
            bindKey("mouse1", "down", onElementClicked)
            bindKey("mouse_wheel_down", "down", onElementMoveDown)
            bindKey("mouse_wheel_up", "down", onElementMoveUp)
            bindKey("q", "down", onElementMoveDown)
            bindKey("e", "down", onElementMoveUp)
            addEventHandler("onClientHUDRender", root, isRendering)
        end
    else
        if option.actived then
            vehicle.el=nil
            option.actived=false
            unbindKey("mouse1", "down", onElementClicked)
            unbindKey("mouse_wheel_down", "down", onElementMoveDown)
            unbindKey("mouse_wheel_up", "down", onElementMoveUp)
            unbindKey("q", "down", onElementMoveDown)
            unbindKey("e", "down", onElementMoveUp)
            removeEventHandler("onClientHUDRender", root, isRendering)
        end
    end
end)

function onElementMoveUp() if option.selected > 9 then option.selected=1 else option.selected=option.selected+1 end end
function onElementMoveDown() if option.selected < 1 then option.selected=9 else option.selected=option.selected-1 end end
function onElementClicked() if option.selected > 0 then triggerServerEvent("onDryerAction", localPlayer, value, option.selected, element) end end

function blokada ( prevSlot, newSlot )
	if getPedWeapon(getLocalPlayer(), newSlot) == 22 then 
		toggleControl( "fire", false )
        toggleControl( "action", false )
	end
end
addEventHandler ( "onClientPlayerWeaponSwitch", localPlayer, blokada)