addCommandHandler('variant', function(player, cmd, id, id2)
    if not getAdmin(player, 4) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not id or not id2 or not tonumber(id) or not tonumber(id2) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Użyj: /variant [id 1] [id 2]') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie jesteś w pojeździe!') end

    setVehicleVariant(vehicle, id, id2)
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Ustawiono wariant pojazdu '.. id ..', '.. id2)
end)