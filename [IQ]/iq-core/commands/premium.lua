

addCommandHandler('v',function (plr,cmd,...)
    if not getElementData(plr,'player:sid') then return end

    local text = table.concat({...}, ' ')
    
    exports['iq-discord']:botWrite({
        funcname = 'sendPremiumChatMessage',
        args = {
            mtaUID = getElementData(plr,'player:sid'),
            nick = getPlayerName(plr),
            text = text
        }
    });

    for i,v in pairs(getElementsByType('player')) do
        if (getElementData(plr,'player:admin')) then
            outputChatBox("#FFD100(Premium) > #ffffff["..exports['borsuk-admin']:getRankHex(getElementData(plr, 'player:admin'))..""..getElementData(plr,"id").."#ffffff] "..getPlayerName(plr):gsub('#%x%x%x%x%x%x', '').."#ffffff: "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
        else
            outputChatBox("#FFD100(Premium) > #ffffff[#bebebe"..getElementData(plr,"id").."#ffffff] "..getPlayerName(plr):gsub('#%x%x%x%x%x%x', '').."#ffffff: "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
        end
    end
end)