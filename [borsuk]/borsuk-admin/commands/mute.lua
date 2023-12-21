local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},
}

addCommandHandler('mute', function(player, cmd, target, time, ...)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    if not time or not time:match('%d+[smhd]') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano czasu!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano powodu!') end

    local time, unit = time:match('(%d+)([smhd])')
    local time = tonumber(time)
    
    exports['iq-db']:query('INSERT INTO `borsuk-punishments` (`serial`, `reason`, `time`, `type`) VALUES (?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', "mute")', getPlayerSerial(target), reason, time)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Pomyślnie wyciszono gracza!')
    exports['borsuk-notyfikacje']:addNotification(target, 'warning', 'Informacja', 'Zostałeś wyciszony przez ' .. getPlayerName(player) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. ' za ' .. reason .. '!')
end)

addCommandHandler('unmute', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end

    exports['iq-db']:query('DELETE FROM `borsuk-punishments` WHERE `serial` = ? AND `type` = "mute"', getPlayerSerial(target))
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Pomyślnie odciszono gracza!')
    exports['borsuk-notyfikacje']:addNotification(target, 'success', 'Informacja', 'Zostałeś odciszony przez ' .. getPlayerName(player) .. '!')
end)