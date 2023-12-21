addCommandHandler('kolor', function(player, cmd, target, r, g, b)
    if not getAdmin(player, 3) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    if target and type(target) == 'string' and target:gsub(' ', ''):match('%d+,%d+,%d+') then
        r, g, b = target:gsub(' ', ''):match('(%d+),(%d+),(%d+)')
        target = player
    else
        local ctemp = (target .. (r and (','..r:gsub(',', '')) or '') .. (g and (','..g:gsub(',', '')) or '') .. (b and (','..b:gsub(',', '')) or '')):gsub(',,', ',')
        if ctemp:gsub(' ', ''):match('%d+,%d+,%d+') then
            r, g, b = ctemp:gsub(' ', ''):match('(%d+),(%d+),(%d+)')
            target = player
        elseif tonumber(target) and tonumber(r) and tonumber(g) then
            r, g, b = target, r, g
            target = player
        elseif tonumber(r) and tonumber(g) and tonumber(b) then
            r, g, b = r, g, b
            target = exports['iq-core']:findPlayer(player, target)
        end
    end

    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono podanego gracza!') end
    if not r or not g or not b then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podano koloru!') end

    local vehicle = getPedOccupiedVehicle(target)
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', target == player and 'Nie jesteś w pojeździe!' or 'Gracz nie jest w pojeździe!') end

    local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
    setVehicleColor(vehicle, r, g, b, r2, g2, b2)

    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Zmieniono kolor pojazdu!')
end)