addCommandHandler('ginfo', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Użyj: /ginfo [nick]') end

    local target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end

    local result = exports['iq-db']:query('SELECT * FROM `iq-users` WHERE `uid`=?', getElementData(target, 'player:sid'))
    if not result or #result < 1 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Gracz jest nie zalogowany!') end

    local message = [[Login: %s
Nick: %s
UID: %s
Pieniądze: %s
Pieniądze w banku: %s
Exp: %s
Level: %s
Prawo jazdy: %s
Przegrany czas: %02d:%02d]]

    local licenses = loadstring(result[1].licenses)()
    local licensesTable = {}
    if licenses.pjA then table.insert(licensesTable, 'A') end
    if licenses.pjB then table.insert(licensesTable, 'B') end
    if licenses.pjC then table.insert(licensesTable, 'C') end
    if licenses.pjL then table.insert(licensesTable, 'Licencja lotnicza') end
    licenses = table.concat(licensesTable, ', ')

    local minutes = result[1].playedTime
    local hours = math.floor(minutes / 60)
    minutes = minutes - (hours * 60)

    message = message:format(
        result[1].login,
        result[1].nick,
        result[1].uid,
        getPlayerMoney(target),
        result[1].bankMoney,
        result[1].exp,
        result[1].level,
        #licenses > 0 and licenses or 'Brak',
        hours, minutes
    )

    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacje o graczu', message)
end)