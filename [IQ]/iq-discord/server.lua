local plrs = {}

function randomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    math.randomseed(os.time())

    local result = ""
    for i = 1, length do

        local randomIndex = math.random(1, #chars)

        result = result .. string.sub(chars, randomIndex, randomIndex)
    end

    return result
end

function showCodeInfo(plr, code)
    exports['borsuk-notyfikacje']:addNotification(plr, 'warning', 'Discord', 'Kod do polaczenia konta discord-mta zostal skopiowany do schowka. Aby polaczyc konto udaj sie na kanal 🤖・bot oraz wpisz komende /polacz <kod>', 5000)
    triggerClientEvent(plr,'setClipboard',plr, code)
end

addCommandHandler('discord',function (plr)
    if not getElementData(plr,'player:sid') then return end

    if (plrs[plr] and getTickCount() - plrs[plr] < 5000) then
        return exports['borsuk-notyfikacje']:addNotification(plr, 'warning', 'Zwolnij', 'Tej komendy mozesz uzyc tylko raz na 5 sekund!', 5000)
    end

    plrs[plr] = getTickCount()

    local rows = exports['iq-db']:query('SELECT * FROM `iq-discord` WHERE uid=?',getElementData(plr,'player:sid'))
    if (#rows > 0) then
        if (rows[1].discord_id == "" or rows[1].discord_id == " ") then
            showCodeInfo(plr, rows[1].code)
        else
            exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Discord', 'Posiadasz juz polaczone konto z discordem!', 5000)
        end
    else
        local code = randomString(23)
        exports['iq-db']:query('INSERT INTO `iq-discord` (`code`,`uid`) VALUES (?,?)',code, getElementData(plr,'player:sid'))
        showCodeInfo(plr, code)
    end
end)