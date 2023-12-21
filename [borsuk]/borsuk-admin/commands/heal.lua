addCommandHandler('heal', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś gracza!') end

    local target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono gracza!') end

    setElementHealth(target, 100)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Uleczono gracza!')
    exports['borsuk-notyfikacje']:addNotification(target, 'success', 'Sukces', 'Zostałeś uleczony przez '..getPlayerName(player))
end)