

addEvent('fetchAvatar',true)
addEventHandler('fetchAvatar',root,function (uid)
    local rows = exports['iq-db']:query('SELECT * FROM `iq-discord` WHERE uid=?',uid)
    if (#rows > 0) then
        fetchRemote('http://51.83.172.113:8080/avatars?id='..rows[1].discord_id..'', 'default', 1, 4000, function (responseData, error, player, uid)
            triggerClientEvent(player,'returnAvatars',resourceRoot,responseData,uid)
        end, "", false, client, uid)
    end
end)


addEvent('fetchCircleAvatar',true)
addEventHandler('fetchCircleAvatar',root,function (uid)
    local rows = exports['iq-db']:query('SELECT * FROM `iq-discord` WHERE uid=?',uid)
    if (#rows > 0) then
        fetchRemote('http://51.83.172.113:8080/avatars?id='..rows[1].discord_id..'', 'default', 1, 4000, function (responseData, error, player, uid)
            triggerClientEvent(player,'returnAvatars2',resourceRoot,responseData,uid)
        end, "", false, client, uid)
    end
end)