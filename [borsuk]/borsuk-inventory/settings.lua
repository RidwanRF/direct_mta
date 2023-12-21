local SERVER_SIDE = not localPlayer

function showNotification(plr, msg)
    if SERVER_SIDE then
        outputChatBox(msg, plr)
    else
        outputChatBox(plr)
    end
end