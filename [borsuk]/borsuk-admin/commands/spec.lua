addCommandHandler('spec', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś gracza!') end

    local target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono gracza!') end

    local x, y, z = getElementPosition(player)
    setElementData(player, 'spec:pos', {x, y, z})
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Rozpoczęto specowanie gracza ' .. getPlayerName(target):gsub('#%x%x%x%x%x%x', '') .. '\nUżyj /specoff aby przestać')
    removePedFromVehicle(player)
    setElementInterior(player, getElementInterior(target))
    setElementDimension(player, getElementDimension(target))

    setTimer(function()
        setCameraTarget(player, target)
    end, 100, 1)
end)

addCommandHandler('specoff', function(player, cmd)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    local pos = getElementData(player, 'spec:pos')
    if not pos then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie specujesz nikogo!') end

    setCameraTarget(player, player)
    setElementPosition(player, pos[1], pos[2], pos[3])
    setElementData(player, 'spec:pos', nil)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Zakończono specowanie!')
end)