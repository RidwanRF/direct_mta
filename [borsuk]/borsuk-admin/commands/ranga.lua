addCommandHandler('ranga', function(player, cmd, target, rank)
    if not getAdmin(player, 4) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    if target == player then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie możesz zmienić sobie rangi!') end
    if not getElementData(target, 'player:sid') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Gracz nie jest zalogowany!') end
    if not rank or not tonumber(rank) or tonumber(rank) < 0 or tonumber(rank) > 4 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano poprawnej rangi!') end
    rank = tonumber(rank)

    local q = exports['iq-db']:query('SELECT * FROM `borsuk-admin` WHERE `serial` = ?', getPlayerSerial(target))
    local previousRank = (q and q[1]) and q[1].level or false

    local rankName = rank ~= 0 and getRankName(rank) or 'Gracz'
    if previousRank then
        if previousRank > rank then
            exports['borsuk-notyfikacje']:addNotification(target, 'info', 'Ranga', 'Zostałeś degradowany do rangi '..rankName..'!')
        else
            exports['borsuk-notyfikacje']:addNotification(target, 'info', 'Ranga', 'Zostałeś awansowany do rangi '..rankName..'!')
        end
    else
        exports['borsuk-notyfikacje']:addNotification(target, 'info', 'Ranga', 'Została ci nadana ranga '..rankName..'!')
    end

    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Ranga', 'Nadano rangę '..rankName..' graczowi '..getPlayerName(target)..'!')
    
    if previousRank then
        if rank ~= 0 then
            exports['iq-db']:query('UPDATE `borsuk-admin` SET `level` = ? WHERE `serial` = ?', rank, getPlayerSerial(target))
        else
            exports['iq-db']:query('DELETE FROM `borsuk-admin` WHERE `serial` = ?', getPlayerSerial(target))
        end
    else
        exports['iq-db']:query('INSERT INTO `borsuk-admin` (`serial`, `date`, `level`, `actived`, `added`, `uid`, `reporty`) VALUES (?, ?, ?, NOW(), NOW(), ?, 0)', getPlayerSerial(target), rank, getElementData(player, 'player:sid'))
    end

    if getElementData(target, 'player:admin') then
        if rank == 0 then
            setElementData(target, 'player:admin', false)
        else
            setElementData(target, 'player:admin', rank)
        end
    end
end)