addCommandHandler('reporty', function(player, cmd, sid)
    if not getElementData(player, 'player:sid') then return end
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local sid = tonumber(sid)
    if not sid then return exports['borsuk-notyfikacje']:addNotification(player, 'warning', 'Błąd', 'Użyj: /reporty <sid>') end

    local q = exports['pystories-db']:dbGet('SELECT j.reporty, u.login AS name FROM `borsuk-admin` AS j JOIN `pystories_users` AS u ON j.uid = u.id WHERE j.uid = ?', sid)
    if not q[1] then return exports['borsuk-notyfikacje']:addNotification(player, 'warning', 'Błąd', 'Nie znaleziono takiego gracza!') end

    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Reporty', 'Gracz ' .. q[1].name .. ' posiada ' .. q[1].reporty .. ' wykonanych reportów.')
end)