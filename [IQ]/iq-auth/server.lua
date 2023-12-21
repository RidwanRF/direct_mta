addEvent('iq-login:tryLogin',true)
addEventHandler('iq-login:tryLogin',root,function (plr,login,password)
    local rows = exports['iq-db']:query('SELECT * FROM `iq-users` WHERE login=?', login)

    if (#rows > 0) then
        if (rows[1].password == md5(password)) then
            local function findPlayer(sid)
                for i,v in pairs(getElementsByType('player')) do
                    if (getElementData(v,'player:sid') == sid) then
                        return true
                    end
                end

                return false
            end

            if findPlayer(rows[1].uid) then
                exports['borsuk-notyfikacje']:addNotification(plr,'error', 'Błąd', 'Ktos jest juz zalogowany na te konto', 5000)
            else
                -- check ban
                local q = exports['iq-db']:query('SELECT *, NOW() > time AS timePassed FROM `borsuk-ban` WHERE `sid` = ?', rows[1].uid)

                if q and #q > 0 then
                    if tonumber(q[1].type) == 1 and tonumber(q[1].timePassed) ~= 1 then
                        exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Konto jest zbanowane\nAdministrator: '..q[1]['admin-name']..'\nPowód: '..q[1].reason..'\nCzas: '..q[1].time..' (/time)', 5000)
                        return
                    elseif tonumber(q[1].type) == 2 then
                        exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Konto jest permanentnie zbanowane\nAdministrator: '..q[1]['admin-name']..'\nPowód: '..q[1].reason, 5000)
                        return
                    end
                end

                exports['borsuk-notyfikacje']:addNotification(plr,'success', 'Logowanie', 'Pomyslnie zalogowano sie na konto: '..rows[1].login..'', 5000)
                setPlayerName(plr, rows[1].login)
                setElementData(plr, 'player:sid', rows[1].uid)
                triggerClientEvent(plr, 'createSpawnPanel', plr)
            end
        else
            exports['borsuk-notyfikacje']:addNotification(plr,'error', 'Błąd', 'Podano zle haslo', 5000)
        end
    else
        exports['borsuk-notyfikacje']:addNotification(plr,'error', 'Błąd', 'Nie ma takiego konta', 5000)
    end
end)

function generateKey(key)
    return tonumber(key)..""..math.random(1,20)..""..math.random(20,40)
end

addEvent('iq-login:tryRegister',true)
addEventHandler('iq-login:tryRegister',root,function (plr,login,password)
    player = plr
    local result = exports["iq-db"]:query("SELECT * FROM `iq-users` WHERE serial=?", getPlayerSerial(plr))
	if result and #result >= 3 then
        exports['borsuk-notyfikacje']:addNotification(plr,'error', 'Błąd', 'Osiągnąłeś limit kont', 5000)
	    return
    end

	local result=exports["iq-db"]:query("SELECT * FROM `iq-users` WHERE login=?", login)
	if result and #result > 0 then
        exports['borsuk-notyfikacje']:addNotification(plr,'error', 'Błąd', 'Konto o tej nazwie już istnieje', 5000)
	else
        local rows4 = exports['iq-db']:query('SELECT * FROM `iq-users`')
        local discordData = {
            code = generateKey(#rows4 + 1),
            connected = false,
            discordID = false
        }
		local code = string.char(math.random(65, 90)) .. string.char(math.random(65, 90)) .. string.char(math.random(65, 90)) .. "-" .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9)
		local query = exports['iq-db']:query('INSERT INTO `iq-users` (`login`, `nick`, `password`, `serial`, `ip`) VALUES (?, ?, ?, ?, ?)',
        login, login, md5(password), getPlayerSerial(plr), getPlayerIP(client))
		if query then
            exports['borsuk-notyfikacje']:addNotification(plr,'success', 'Sukces', 'Pomyślnie się zarejestrowałeś', 5000)
		end
	end
end)