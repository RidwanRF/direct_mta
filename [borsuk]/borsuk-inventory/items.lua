local serverSide = not localPlayer

local items = {
    -- ['money-pack'] = {
    --     icon = 'money',
    --     name = 'Torba z pieniedzmi',
    --     description = 'Torba z pieniedzmi',
    --     weight = 2,
    --     -- cantTrade = true,
    --     useClient = function()
    --         -- ALWAYS REMOVE ITEM ON CLIENT SIDE!!!!
    --         addPlayerItem('money-pack', -1)
    --     end,
    --     useServer = function(player)

    --     end,
    --     class = 'gray'
    -- },
    -- ['milka-snack'] = {
    --     icon = 'milka-snack',
    --     name = 'Baton2',
    --     weight = 1,
    --     useClient = function()
    --         -- ALWAYS REMOVE ITEM ON CLIENT SIDE!!!!
    --         addPlayerItem('milka-snack', -1)
    --     end,
    --     useServer = function(player)

    --     end,
    --     class = 'normal'
    -- },
    -- ['psc'] = {
    --     icon = 'milka-snack',
    --     name = 'Baton3',
    --     weight = 1,
    --     useClient = function()
    --         -- ALWAYS REMOVE ITEM ON CLIENT SIDE!!!!
    --         addPlayerItem('psc', -1)
    --     end,
    --     useServer = function(player)

    --     end,
    --     class = 'rare',
    --     progress = true
    -- },
    -- ['psc2'] = {
    --     icon = 'milka-snack',
    --     name = 'PSC za 50zl',
    --     weight = 1,
    --     useClient = function()
    --         -- ALWAYS REMOVE ITEM ON CLIENT SIDE!!!!
    --         addPlayerItem('psc2', -1)
    --     end,
    --     useServer = function(player)

    --     end,
    --     class = 'legendary',
    --     progress = true
    -- },
    -- ['psc3'] = {
    --     icon = 'milka-snack',
    --     name = 'PSC za 100zl',
    --     isTemp = true,
    --     weight = 1,
    --     useClient = function()
    --         -- ALWAYS REMOVE ITEM ON CLIENT SIDE!!!!
    --         addPlayerItem('psc3', -1)
    --     end,
    --     useServer = function(player)

    --     end,
    --     class = 'epic',
    --     progress = true
    -- },
    -- ['psc4'] = {
    --     icon = 'milka-snack',
    --     name = 'Baton 234 ',
    --     weight = 1,
    --     useClient = function()
    --         -- ALWAYS REMOVE ITEM ON CLIENT SIDE!!!!
    --         addPlayerItem('psc4', -1)
    --     end,
    --     useServer = function(player)

    --     end,
    --     class = 'unique',
    --     progress = true
    -- },
    ['fishing-rod-legendary'] = {
        icon = 'fishing-rod',
        name = 'Wędka',
        weight = 1,
        useClient = function(token)
            removeItemByToken(token)
        end,
        useServer = function(player, token)

        end,
        class = 'legendary',
        progress = true
    },
}

function getItemInfo(item)
    return items[item]
end

function generateToken()
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local token = ''
    for i = 1, 4 do
        for c = 1, 4 do
            local r = math.random(1, #chars)
            token = token .. chars:sub(r, r)
        end
        if i ~= 4 then
            token = token .. '-'
        end
    end
    return token
end

function useItem(...)
    local args = {...}
    local player, item;
    if serverSide then
        player, item = args[1], args[2]
    else
        player, item = localPlayer, args[1]
    end

    local itemInfo = getItemInfo(item.name)
    if not itemInfo then return end

    if itemInfo.useClient then
        itemInfo.useClient(item.token)
        triggerServerEvent('useItem', resourceRoot, item.name, item.token)
    end
end