addEventHandler('onPlayerConnect', root, function(name, ip, username, serial)
    local q = exports['iq-db']:query('SELECT *, NOW() > time AS timePassed FROM `borsuk-ban` WHERE `serial` = ?', serial)

    if q and #q > 0 then
        if tonumber(q[1].type) == 1 and tonumber(q[1].timePassed) ~= 1 then
            outputConsole('\n\n------------------------\nZostałeś zbanowany na tym serwerze.\nAdministrator: ' .. q[1]['admin-name'] .. '\nPowód: '..q[1].reason..'\nCzas: '..q[1].time..' (/time)\n\nJeśli uważasz, że to błąd, skontaktuj się z administracją.\nDiscord: discord.gg/directmta', getPlayerFromName(name))
            cancelEvent(true, 'Jesteś zbanowany!\nSprawdź konsolę (F8)')
        elseif tonumber(q[1].type) == 2 then
            outputConsole('\n\n------------------------\nZostałeś permanentnie zbanowany na tym serwerze.\nAdministrator: ' .. q[1]['admin-name'] .. '\nPowód: '..q[1].reason..'\n\nJeśli uważasz, że to błąd, skontaktuj się z administracją.\nDiscord: discord.gg/directmta', getPlayerFromName(name))
            cancelEvent(true, 'Jesteś permanentnie zbanowany!\nSprawdź konsolę (F8)')
        end
    end
end)