local vehicleNames = {}
for i = 400, 611 do
    vehicleNames[i] = getVehicleNameFromModel(i)
end

function getModelFromPartialName(name)
    if tonumber(name) then
        return tonumber(name)
    end

    local name = name:lower()
    for i, v in pairs(vehicleNames) do
        if v:lower():find(name, 1, true) then
            return i
        end
    end
end

addCommandHandler('cv', function(player, cmd, ...)
	if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    local name = table.concat({...}, ' ')
    if not name or #name < 3 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Wpisz poprawną nazwę pojazdu!') end

    local model = getModelFromPartialName(name)
    if not model then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono takiego pojazdu!') end

    if (model == 447 or model == 432 or model == 425 or model == 520) and not getAdmin(player, 4) then
        return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tego pojazdu!')
    end

    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    local vehicle;
    if getPedOccupiedVehicle(player) then
        vehicle = getPedOccupiedVehicle(player)

        if getElementData(vehicle, 'vehicle:id') then
            exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie możesz podmienić prywatnego pojazdu!')
            return
        end
            
        setElementModel(vehicle, model)
        exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Sukces', 'Pojazd został podmieniony!')
    else
        vehicle = createVehicle(model, x, y, z, rx, ry, rz)
        setElementInterior(vehicle, getElementInterior(player))
        setElementDimension(vehicle, getElementDimension(player))
        setElementData(vehicle, 'vehicle:fuel', {count=100})
        warpPedIntoVehicle(player, vehicle)
        setVehiclePlateText(vehicle, getPlayerName(player))
        exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Sukces', 'Pomyślnie stworzono pojazd!')
    end
end)

addCommandHandler('dv', function(player)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not getPedOccupiedVehicle(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie jesteś w pojeździe!') end

    local vehicle = getPedOccupiedVehicle(player)
    if getElementData(vehicle, 'vehicle:id') then
        exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie możesz usunąć prywatnego pojazdu!')
        return
    end

    destroyElement(vehicle)
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Sukces', 'Pojazd został usunięty!')
end)