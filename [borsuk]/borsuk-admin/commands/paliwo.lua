addCommandHandler('paliwo', function(player, cmd, amount)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not amount or not tonumber(amount) or tonumber(amount) < 0 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Użyj: /paliwo [ilość]') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie jesteś w pojeździe!') end

    setElementData(vehicle, 'vehicle:fuel', tonumber(amount))
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Zmieniono ilość paliwa!')
end)