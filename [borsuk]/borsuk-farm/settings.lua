HOE_POSITION = {-2.7, -7, 251, 0, -90, 0}
CAN_POSITION = {2, -6.5, 250.7, 0, 0, 200}

PLANTS = {
    Carrots = {
        seeds = 'carrotSeed',
        finalItem = 'carrot',
        finalItemCount = 2, -- you will get 2 carrots when harvested
        growTime = 60 * 5,
        object = 1904,
    },
    Beetroots = {
        seeds = 'beetrootSeed',
        finalItem = 'beetroot',
        finalItemCount = 1,
        growTime = 60 * 6,
        object = 1903,
    },
    Patatoes = {
        seeds = 'patatoesSeed',
        finalItem = 'patato',
        finalItemCount = 1,
        growTime = 60 * 6,
        object = 1905,
    },
    Onions = {
        seeds = 'onionSeeds',
        finalItem = 'onion',
        finalItemCount = 1,
        growTime = 60 * 5,
        object = 1907,
    },
    Tomatoes = {
        seeds = 'tomatoSeeds',
        finalItem = 'tomato',
        finalItemCount = 1,
        growTime = 60 * 4,
        object = 1908,
    },
    ['Red flower'] = {
        seeds = 'redflowerSeeds',
        finalItem = 'redflower',
        finalItemCount = 1,
        growTime = 60 * 4,
        object = 1909,
    },
    ['Green flower'] = {
        seeds = 'greenflowerSeeds',
        finalItem = 'greenflower',
        finalItemCount = 1,
        growTime = 60 * 4,
        object = 1910,
    },
    ['Blue flower'] = {
        seeds = 'blueflowerSeeds',
        finalItem = 'blueflower',
        finalItemCount = 1,
        growTime = 60 * 4,
        object = 1911,
    },
    Coca = {
        seeds = 'cocaSeeds',
        finalItem = 'coca',
        finalItemCount = 1,
        growTime = 60 * 4,
        object = 1912,
    },
    Wheat = {
        seeds = 'wheatSeeds',
        finalItem = 'wheat',
        finalItemCount = 1,
        growTime = 60 * 4,
        object = 1913,
    },
}

local SERVER_SIDE = not localPlayer

-- DELETE THIS, ONLY FOR TESTING PURPOSES
if not SERVER_SIDE then
    -- setElementData(localPlayer, 'player:inventory', {
    --     carrotSeed = 16,
    --     beetrootSeed = 15,
    --     patatoesSeed = 13,
    --     onionSeeds = 10,
    --     tomatoSeeds = 10,
    --     redflowerSeeds = 10,
    --     greenflowerSeeds = 10,
    --     blueflowerSeeds = 10,
    --     cocaSeeds = 10,
    --     wheatSeeds = 10,
    -- })
end

function showNotification(plr, msg)
    if SERVER_SIDE then
        outputChatBox(msg, plr)
    else
        outputChatBox(plr)
    end
end

function getItemsCount(plr, name)
    -- local name = SERVER_SIDE and name or plr
    -- local plr = SERVER_SIDE and plr or localPlayer
    -- local inventory = getElementData(plr, 'player:inventory') or {}
    -- return inventory[name] or 0
end

function giveItem(plr, name, amount)
    -- local amount = SERVER_SIDE and amount or name
    -- local name = SERVER_SIDE and name or plr
    -- local plr = SERVER_SIDE and plr or localPlayer
    
    -- local inventory = getElementData(plr, 'player:inventory') or {}
    -- inventory[name] = (inventory[name] or 0) + amount
    -- setElementData(plr, 'player:inventory', inventory)
end