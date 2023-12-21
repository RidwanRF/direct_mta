addEvent('kickPlayerAFK', true)
addEventHandler('kickPlayerAFK', root, function(plr)
    kickPlayer(plr, "AntyAFK")
end)