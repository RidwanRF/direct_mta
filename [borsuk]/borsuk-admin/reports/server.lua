local reportTimeout = {}
local syncer = createElement('admin:reports', 'admin:reports')
setElementData(syncer, 'reports', {})

function addReport(sender, target, ...)
    if reportTimeout[sender] and reportTimeout[sender] > getTickCount() then
        exports['borsuk-notyfikacje']:addNotification(sender, 'error', 'Błąd', 'Możesz wysłać kolejne zgłoszenie za {timer:' .. math.ceil((reportTimeout[sender] - getTickCount()) / 1000) .. '} sekund.', 10000, 'report-timeout')
        return
    end

    if not getElementData(sender, 'player:sid') then return end
    
    local target = exports['iq-core']:findPlayer(sender, target or '!@#!@#')
    if not target then return exports['borsuk-notyfikacje']:addNotification(sender, 'error', 'Błąd', 'Nie znaleziono podanego gracza.') end
    if not getElementData(target, 'player:sid') then return exports['borsuk-notyfikacje']:addNotification(sender, 'error', 'Błąd', 'Gracz nie jest zalogowany.') end

    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['borsuk-notyfikacje']:addNotification(sender, 'error', 'Błąd', 'Powód musi mieć minimum 3 znaki.') end

    local report = {
        sender = getElementData(sender, 'player:sid'),
        target = getElementData(target, 'player:sid'),
        reason = {
            {0xFF00FF57, getPlayerName(sender) .. ' (' .. getElementData(sender, 'id') .. ')'},
            {0xFFFFFFFF, ' > '},
            {0xFF00FF57, getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. ')'},
            {0xFFFFFFFF, ': ' .. reason},
        },
        reasonNoHex = getPlayerName(sender) .. ' (' .. getElementData(sender, 'id') .. ') > ' .. getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. '): ' .. reason,
        date = getTickCount(),
        status = 'Oczekuje',
    }

    local reports = getElementData(syncer, 'reports')
    table.insert(reports, report)
    setElementData(syncer, 'reports', reports)

    exports['borsuk-notyfikacje']:addNotification(sender, 'info', 'Informacja', 'Zgłoszenie zostało wysłane.')
    reportTimeout[sender] = getTickCount() + 60000
end

addEvent('admin:acceptReport', true)
addEventHandler('admin:acceptReport', resourceRoot, function(report)
    local reports = getElementData(syncer, 'reports')
    for i, v in ipairs(reports) do
        if i == report then
            v.status = 'W trakcie'
            v.admin = getPlayerName(client)
            setElementData(syncer, 'reports', reports)
            exports['borsuk-notyfikacje']:addNotification(getPlayerBySid(v.sender), 'info', 'Informacja', 'Twoje zgłoszenie zostało przyjęte przez ' .. getPlayerName(client))
            break
        end
    end
end)

addEvent('admin:rejectReport', true)
addEventHandler('admin:rejectReport', resourceRoot, function(report)
    local reports = getElementData(syncer, 'reports')
    for i, v in ipairs(reports) do
        if i == report then
            table.remove(reports, i)
            setElementData(syncer, 'reports', reports)
            exports['borsuk-notyfikacje']:addNotification(getPlayerBySid(v.sender), 'info', 'Informacja', 'Twoje zgłoszenie zostało odrzucone przez ' .. getPlayerName(client))
            break
        end
    end
end)

addEvent('admin:finishReport', true)
addEventHandler('admin:finishReport', resourceRoot, function(report)
    local reports = getElementData(syncer, 'reports')
    for i, v in ipairs(reports) do
        if i == report then
            table.remove(reports, i)
            setElementData(syncer, 'reports', reports)
            exports['borsuk-notyfikacje']:addNotification(getPlayerBySid(v.sender), 'info', 'Informacja', 'Twoje zgłoszenie zostało zakończone przez ' .. getPlayerName(client))

            -- insert if there is row, update 
            if #exports['iq-db']:query('SELECT * FROM `borsuk-admin` WHERE `serial` = ?', getPlayerSerial(client)) > 0 then
                exports['iq-db']:query('UPDATE `borsuk-admin` SET `reporty` = `reporty` + 1 WHERE `serial` = ?', getPlayerSerial(client))
            else
                exports['iq-db']:query('INSERT INTO `borsuk-admin` (`serial`, `date`, `level`, `actived`, `added`, `uid`, `reporty`) VALUES (?, ?, ?, 0, NOW(), ?, 1)', getPlayerSerial(client), getPlayerName(client), getElementData(client, 'player:admin'), getElementData(v.sender, 'player:uid'))
            end
            break
        end
    end
end)

function addReportCommand(plr, cmd, target, ...)
    addReport(plr, target, ...)
end

addCommandHandler('zglos', addReportCommand)
addCommandHandler('report', addReportCommand)
addCommandHandler('raport', addReportCommand)

addEventHandler('onPlayerQuit', root, function()
    local reports = getElementData(syncer, 'reports')
    for i, v in ipairs(reports) do
        if v.sender == source then
            table.remove(reports, i)
            setElementData(syncer, 'reports', reports)
            break
        end
    end
end)