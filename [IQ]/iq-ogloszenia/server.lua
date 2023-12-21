local ogloszenie = false

addCommandHandler('ogloszenie',function (plr,cmd,...)
    if not getElementData(plr,'player:sid') then return end

    if (ogloszenie) then
        return exports['borsuk-notyfikacje']:addNotification(plr, 'warning', 'Zwolnij', 'Obecnie jest juz jakies ogloszenie!', 5000)
    end

    ogloszenie = true
    local text = table.concat({...},' ')
    triggerClientEvent(root,'createAd',root,getPlayerName(plr),text,getElementData(plr,'player:sid'),getElementData(plr,'id'))

    setTimer(function ()
        ogloszenie = false
    end,10015,1)
end)