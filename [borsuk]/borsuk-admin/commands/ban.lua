local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},
}

addCommandHandler('b', function(player, cmd, target, time, ...)
    if not getAdmin(player, 2) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    if not time or not time:match('%d+[smhd]') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano czasu!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano powodu!') end

    local time, unit = time:match('(%d+)([smhd])')
    local time = tonumber(time)
    
    exports['iq-db']:query('INSERT INTO `borsuk-ban` (`sid`, `serial`, `reason`, `time`, `type`, `admin`, `admin-name`, `admin-serial`) VALUES (?, ?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', 1, ?, ?, ?)', getElementData(target, 'player:sid'), getPlayerSerial(target), reason, time, getElementData(player, 'player:sid'), getPlayerName(player), getPlayerSerial(player))
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Zbanowano gracza ' .. getPlayerName(target) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. '!')
    outputConsole('\n\n------------------------\nZostałeś zbanowany!\nAdministator: ' .. getPlayerName(player) .. '\nPowód: ' .. reason .. '\nCzas: ' .. time .. ' ' .. intervals[unit][2], target)
    kickPlayer(target, 'Zostałeś zbanowany!\nSprawdź powód w konsoli!')
end)

addCommandHandler('pb', function(player, cmd, target, ...)
    if not getAdmin(player, 2) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano powodu!') end

    exports['iq-db']:query('INSERT INTO `borsuk-ban` (`sid`, `serial`, `reason`, `time`, `type`, `admin`, `admin-name`, `admin-serial`) VALUES (?, ?, ?, NOW(), 2, ?, ?, ?)', getElementData(target, 'player:sid'),getPlayerSerial(target), reason, getElementData(player, 'player:sid'), getPlayerName(player), getPlayerSerial(player))
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Permanentnie zbanowano gracza ' .. getPlayerName(target) .. ' na zawsze!')
    outputConsole('\n\n------------------------\nZostałeś permanentnie zbanowany!\nAdministator: ' .. getPlayerName(player) .. '\nPowód: ' .. reason .. '\nCzas: zawsze', target)
    kickPlayer(target, 'Zostałeś permanentnie zbanowany!\nSprawdź powód w konsoli!')
end)

addCommandHandler('ub', function(player, cmd, serial)
    if not getAdmin(player, 2) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not serial then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano serialu!') end

    exports['iq-db']:query('DELETE FROM `borsuk-ban` WHERE `serial` = ?', serial)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Odbanowano gracza o serialu ' .. serial .. '!')
end)