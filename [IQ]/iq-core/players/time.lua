function addPlayerTime(plr, time)
    return setElementData(plr,'player:hours',(getElementData(plr,'player:hours') or 0) + time)
end

setTimer(function ()
    for i,v in pairs(getElementsByType('player')) do
        addPlayerTime(v,1)
    end
end,1000*60,0)