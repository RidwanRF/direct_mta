addCommandHandler('flip', function(player, cmd)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie jesteś w pojeździe!') end

    local rx, ry, rz = getElementRotation(vehicle)
    setElementRotation(vehicle, 0, 0, rz)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Obrócono pojazd!')
end)