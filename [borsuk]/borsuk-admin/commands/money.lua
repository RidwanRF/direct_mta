addCommandHandler('money', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś gracza!') end

    local target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end

    local money = getPlayerMoney(target)
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Gracz '..getPlayerName(target)..' posiada $'..money)
end)