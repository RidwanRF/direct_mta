addCommandHandler('fix', function(player, cmd)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie jesteś w pojeździe!') end

    fixVehicle(vehicle)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Naprawiono pojazd!')
end)