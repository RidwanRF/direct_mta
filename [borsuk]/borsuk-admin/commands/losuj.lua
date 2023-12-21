addCommandHandler('losuj', function(player, cmd, ...)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    local reward = table.concat({...}, ' ')
    reward = #reward > 0 and reward or false
    local hex = getRankHex(getElementData(player, 'player:admin'))
    local message;
    if reward then
        message = ('Administrator %s%s #ffffffrozpoczyna losowanie nagrody #F6984B%s'):format(hex, getPlayerName(player), reward)
    else
        message = ('Administrator %s%s #ffffffrozpoczyna losowanie'):format(hex, getPlayerName(player))
    end

    outputChatBox(message, root, 255, 255, 255, true)

    setTimer(function()
        local players = getElementsByType('player')
        local winner = players[math.random(#players)]
        local message;
        if reward then
            message = ('Gracz #cccccc%s #ffffffwygrał nagrodę #F6984B%s'):format(getPlayerName(winner), reward)
        else
            message = ('Gracz #cccccc%s #ffffffwygrał losowanie'):format(getPlayerName(winner))
        end
        outputChatBox(message, root, 255, 255, 255, true)

        exports['borsuk-notyfikacje']:addNotification(winner, 'info', 'Wygrana', 'Wygrałeś losowanie! Gratulacje!')
    end, 10000, 1)
end)