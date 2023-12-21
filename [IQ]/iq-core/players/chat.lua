addEventHandler('onPlayerChat',root,function (message)
    local player = source
    cancelEvent()
    if not getElementData(player,'player:spawn') then return end

    local x,y,z = getElementPosition(player)
    local players = getElementsWithinRange(x, y, z, 30, 'player')
    local id = getElementData(player, 'id') or 0
    exports['borsuk-admin']:addChatLog(player, message)
    for i,v in pairs(players) do
        if (getElementData(player,'player:admin')) then
            outputChatBox('('..(getElementData(player,'player:admin') and exports['borsuk-admin']:getRankHex(getElementData(player, 'player:admin')))..''..id..'#ffffff) '..(getElementData(player,'player:admin') and exports['borsuk-admin']:getRankHex(getElementData(player, 'player:admin')))..''..getPlayerName(player)..': #e6e6e6'..message, v, 255, 255, 255, true)
        else
            outputChatBox('(#bebebe'..id..'#ffffff) '..getPlayerName(player)..': #e6e6e6'..message, v, 255, 255, 255, true)
        end
        -- outputChatBox('('..(getElementData(player,'player:admin') and exports['borsuk-admin']:getRankHex(getElementData(player, 'player:admin')))..''..id..'#ffffff) ['..(getElementData(player,'player:admin') and exports['borsuk-admin']:getRankName(getElementData(player, 'player:admin')))..''..(exports['borsuk-admin']:getRankHex(getElementData(player, 'player:admin')))..'#ffffff] '..getPlayerName(player)..': #e6e6e6'..message, v, 255, 255, 255, true)
    end
end)