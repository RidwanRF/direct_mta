local cache = {}

addEvent('requestJobData', true)
addEventHandler('requestJobData', resourceRoot, function(name)
    local uid = getElementData(client, 'player:sid')
    local topList, myPosition, history = false, false, {0, 0, 0, 0, 0, 0, 0}

    if cache['topList'] and cache['topList'].tick > getTickCount() then
        topList = cache['topList'].data
    else
        local q = exports['pystories-db']:dbGet('SELECT j.points, j.uid, u.login AS name FROM `borsuk-jobs` AS j JOIN `pystories_users` AS u ON j.uid = u.id WHERE j.job=? ORDER BY j.points DESC LIMIT 3', name)
        cache['topList'] = {
            tick = getTickCount() + 2000,
            data = q
        }
        topList = q
    end

    local q = exports['pystories-db']:dbGet('SELECT `points` FROM `borsuk-jobs` WHERE uid = ?', uid)
    if q and q[1] then
        local q = exports['pystories-db']:dbGet('SELECT COUNT(*) AS position FROM `borsuk-jobs` WHERE points > (SELECT points FROM `borsuk-jobs` WHERE uid = ?) ORDER BY points DESC', uid)
        myPosition = q[1].position + 1
    end

    local q = exports['pystories-db']:dbGet('SELECT `money`, `date`, DATEDIFF(NOW(), `date`) AS diff FROM `borsuk-job-earnings-history` WHERE `sid` = ? AND `job` = ? AND `date` > DATE_SUB(NOW(), INTERVAL 7 DAY) ORDER BY `date` ASC', uid, name)
    if q and #q > 0 then
        for i,v in ipairs(q) do
            local day = v.diff
            history[7 - day] = v.money
        end
    end

    triggerClientEvent(client, 'requestJobData:callback', resourceRoot, topList, myPosition, history)
end)

addCommandHandler('jobmultiplier', function(plr, cmd, job, mult)
    if not exports['pystories-admin']:getAdmin(plr, 4) then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not jobs[job] then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Nie ma takiej pracy, użyj /listjobs') end
    if not tonumber(mult) then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Nieprawidłowa wartość mnożnika!') end
    if tonumber(mult) < 0 then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Mnożnik nie może być mniejszy od 0!') end

    jobs[job].multiplier = tonumber(mult)
    exports['borsuk-notyfikacje']:addNotification(plr, 'success', 'Sukces', 'Zmieniono mnożnik dla pracy '..job..' na x'..mult)

    triggerClientEvent(root, 'job-multiplier:update', resourceRoot, job, mult)
end)

addCommandHandler('listjobs', function(plr)
    if not exports['pystories-admin']:getAdmin(plr, 4) then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    local jobNames = {}
    for job in pairs(jobs) do
        table.insert(jobNames, job)
    end
    local str = table.concat(jobNames, '\n')

    exports['borsuk-notyfikacje']:addNotification(plr, 'info', 'Lista prac', str)
end)