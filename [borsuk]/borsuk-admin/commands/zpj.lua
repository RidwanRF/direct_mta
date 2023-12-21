local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},
}

addCommandHandler('zpj', function(player, cmd, target, time, ...)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    if not time or not time:match('%d+[smhd]') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano czasu!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano powodu!') end

    local time, unit = time:match('(%d+)([smhd])')
    local time = tonumber(time)
    
    exports['iq-db']:query('INSERT INTO `borsuk-punishments` (`serial`, `reason`, `time`, `type`) VALUES (?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', "zpj")', getPlayerSerial(target), reason, time)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Pomyślnie zabrano prawo jazdy graczowi!')
    exports['borsuk-notyfikacje']:addNotification(target, 'warning', 'Informacja', 'Zostało Ci zabrane prawo jazdy przez ' .. getPlayerName(player) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. ' za ' .. reason .. '!')
end)

addCommandHandler('opj', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end

    exports['iq-db']:query('DELETE FROM `borsuk-punishments` WHERE `serial` = ? AND `type` = "zpj"', getPlayerSerial(target))
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Pomyślnie przywrócono prawo jazdy graczowi!')
    exports['borsuk-notyfikacje']:addNotification(target, 'success', 'Informacja', 'Twoje prawo jazdy zostało przywrócone przez ' .. getPlayerName(player) .. '!')
end)