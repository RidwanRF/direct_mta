function useJetpack(player, cmd)
    if not getAdmin(player, 2) then return end

    if not doesPedHaveJetPack(player) then
        givePedJetPack(player)
        exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Dodano jetpack')
    else
        removePedJetPack(player)
        exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Informacja', 'Usunięto jetpack')
    end
end

addEventHandler('onPlayerJoin', root, function()
    bindKey(source, 'j', 'down', useJetpack)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i, v in ipairs(getElementsByType('player')) do
        bindKey(v, 'j', 'down', useJetpack)
    end
end)