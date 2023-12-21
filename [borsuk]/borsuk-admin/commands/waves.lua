addCommandHandler('waves', function(player, cmd, height)
    if not getAdmin(player, 2) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not height then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś wysokości fal!') end

    local height = tonumber(height)
    if not height then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Podana wysokość fal jest nieprawidłowa!') end

    setWaveHeight(height)
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Ustawiono wysokość fal na '..height)
end)