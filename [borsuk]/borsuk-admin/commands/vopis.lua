addCommandHandler('vopis', function(player, cmd, ...)
    if not getAdmin(player, 4) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znajdujesz się w pojeździe!') end

    local desc = table.concat({...}, ' ')
    if not desc then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś opisu!') end

    desc = desc:gsub('\\n', '\n')
    setElementData(vehicle, 'vehicle:desc', desc)
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Zmieniłeś opis pojazdu na '..desc)
end)