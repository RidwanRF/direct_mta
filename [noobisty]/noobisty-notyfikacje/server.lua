function createNotification(plr,...)
    local test = {...}
    local type = 'info'
    if (test[4] == 'sighter') then
        type = 'warning'
    elseif (test[4] == 'sight') then
        type = 'success'
    end
    return exports['borsuk-notyfikacje']:addNotification(plr, type, test[1], test[2], 5000)
end