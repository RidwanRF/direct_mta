addCommandHandler('a', function(player, cmd, ...)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    local message = table.concat({...}, ' ')
    if not message or #message < 1 then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś treści wiadomości!') end

    local rgb = getRankRGB(getElementData(player, 'player:admin'))
    local hex = getRankHex(getElementData(player, 'player:admin'))
    outputChatBox('>> #ffffff' .. message .. ' - ' .. hex .. getPlayerName(player), root, rgb[1], rgb[2], rgb[3], true)
end)