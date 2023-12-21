addCommandHandler('duty', function(player)
    if getElementData(player, 'player:admin') then
        setElementData(player, 'player:admin', false)
        exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Duty', 'Wylogowano z służby administracyjnej!')

        takeWeapon(player, 22)
        toggleControl(player, 'aim_weapon', false)
    else
        local q = exports['iq-db']:query('SELECT * FROM `borsuk-admin` WHERE serial=?', getPlayerSerial(player))
        if not q or #q == 0 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Brak uprawnień!') end

        setElementData(player, 'player:admin', q[1].level)
        local name = getRankName(q[1].level)
        exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Duty', 'Zalogowano na służbę '..name..'!')
        
        giveWeapon(player, 22)
        toggleControl(player, 'aim_weapon', true)
    end
end)