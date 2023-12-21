addCommandHandler('tppos', function(player, cmd, ...)
    if not getElementData(player, 'player:sid') then return end
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local pos = table.concat({...}, ','):gsub(' ', ''):gsub(',,', ',')
    if not pos then
        return exports['borsuk-notyfikacje']:addNotification(player, 'warning', 'Błąd', 'Użyj: /tppos x, y, z')
    end

    local x, y, z = unpack(split(pos, ','))
    if not x or not y or not z then
        return exports['borsuk-notyfikacje']:addNotification(player, 'warning', 'Błąd', 'Użyj: /tppos x, y, z')
    end

    setElementPosition(player, x, y, z)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Zostałeś przeniesiony na pozycję: ' .. x .. ', ' .. y .. ', ' .. z)
end)