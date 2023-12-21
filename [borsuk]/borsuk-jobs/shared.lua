local SSIDE = not localPlayer

function getUpgradePoints(...)
    local player, job;
    if SSIDE then
        player, job = ...
    else
        player, job = localPlayer, ...
    end

    local upgradePoints = getElementData(player, 'player:upgrade-points') or {}
    return upgradePoints[job] or 0
end

function addUpgradePoints(...)
    local player, job, points;
    if SSIDE then
        player, job, points = ...
    else
        player, job, points = localPlayer, ...
    end

    local upgradePoints = getElementData(player, 'player:upgrade-points') or {}
    upgradePoints[job] = (upgradePoints[job] or 0) + points
    setElementData(player, 'player:upgrade-points', upgradePoints)
end

if SSIDE then
    function addPlayerJobPoints(job, points)
        local sid = getElementData(localPlayer, 'player:sid')
        if not sid then return end
        exports['pystories-db']:dbGet('INSERT INTO `borsuk-jobs` (`sid`, `job`, `points`) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE `points` = `points` + ?', sid, job, points, points)
    end
end

function giveJobMoney(...)
    if SSIDE then
        local player, money = ...
        givePlayerMoney(player, money)

        local sid = getElementData(player, 'player:sid')
        local job = getElementData(player, 'player:job')
        if not job then return end

        exports['pystories-db']:dbGet('INSERT INTO `borsuk-job-earnings-history` (`sid`, `date`, `money`, `job`) VALUES (?, NOW(), ?, ?) ON DUPLICATE KEY UPDATE `money` = `money` + ?', sid, money, job, money)
    else
        triggerServerEvent('giveJobMoney', resourceRoot, ...)
    end
end

if SSIDE then
    addEvent('giveJobMoney', true)
    addEventHandler('giveJobMoney', resourceRoot, function(money)
        givePlayerMoney(client, money)
    end)
end