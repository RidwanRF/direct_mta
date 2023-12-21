addCommandHandler('warn', function(player, cmd, target, ...)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano powodu!') end

    exports['iq-db']:query('INSERT INTO `borsuk-punishments` (`serial`, `reason`, `time`, `type`) VALUES (?, ?, NOW(), "warn")', getPlayerSerial(target), reason)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Pomyślnie ostrzeżono gracza!')
    
    triggerClientEvent(target, 'onClientShowWarn', resourceRoot, getPlayerName(player), reason)
end)