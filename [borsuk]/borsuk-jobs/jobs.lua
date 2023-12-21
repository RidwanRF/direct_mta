jobs = {
    ['grzybiarz'] = {
        name = 'Grzybiarz',
        description = 'Praca grzybiarza  polega na zbieraniu odpowienich grzybów do koszyka. W zależności od typu zebranego grzyba dostaniesz większą lub mniejszą premie do zarobku. Pamiętaj aby zbierać grzyby jadalne, dodatkowo za zebranie trującego grzyba otrzymujesz mniejszą wypłate.',
        upgrades = {
            {'Sprinter', 'Umożliwia sprint', 20},
            {'Sprinter', 'Umożliwia sprint', 40},
            {'Sprinter', 'Umożliwia sprint', 30},
        },
        multiplier = 1
    },
    ['kurier'] = {
        name = 'Grzybiarz',
        description = 'Praca grzybiarza  polega na zbieraniu odpowienich grzybów do koszyka. W zależności od typu zebranego grzyba dostaniesz większą lub mniejszą premie do zarobku. Pamiętaj aby zbierać grzyby jadalne, dodatkowo za zebranie trującego grzyba otrzymujesz mniejszą wypłate.',
        upgrades = {
            {'Sprinter', 'Umożliwia sprint', 20},
            {'Sprinter', 'Umożliwia sprint', 40},
            {'Sprinter', 'Umożliwia sprint', 30},
        },
        multiplier = 1
    },
    ['xd'] = {
        name = 'Grzybiarz',
        description = 'Praca grzybiarza  polega na zbieraniu odpowienich grzybów do koszyka. W zależności od typu zebranego grzyba dostaniesz większą lub mniejszą premie do zarobku. Pamiętaj aby zbierać grzyby jadalne, dodatkowo za zebranie trującego grzyba otrzymujesz mniejszą wypłate.',
        upgrades = {
            {'Sprinter', 'Umożliwia sprint', 20},
            {'Sprinter', 'Umożliwia sprint', 40},
            {'Sprinter', 'Umożliwia sprint', 30},
        },
        multiplier = 1
    },
}

addEvent('job-multiplier:update', true)
addEventHandler('job-multiplier:update', resourceRoot, function(job, multiplier)
    if not jobs[job] then return end
    jobs[job].multiplier = multiplier
end)

if localPlayer then -- if it's cside then
    triggerServerEvent('job-multiplier:fetch', resourceRoot)

    addEvent('job-multiplier:update-all', true)
    addEventHandler('job-multiplier:update-all', resourceRoot, function(multipliers)
        for job, multiplier in pairs(multipliers) do
            if not jobs[job] then return end
            jobs[job].multiplier = multiplier
        end
    end)
else
    addEvent('job-multiplier:fetch', true)
    addEventHandler('job-multiplier:fetch', resourceRoot, function()
        local multipliers = {}
        for job, data in pairs(jobs) do
            multipliers[job] = data.multiplier
        end

        triggerClientEvent(client, 'job-multiplier:update-all', resourceRoot, multipliers)
    end)
end