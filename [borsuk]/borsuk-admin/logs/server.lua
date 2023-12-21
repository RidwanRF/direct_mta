local reportTimeout = {}
local syncer = createElement('admin:logs', 'admin:logs')
setElementData(syncer, 'logs', {})

local commandBlackList = {
    ['Zwieksz'] = true,
    ['Zmniejsz'] = true,
}

function addLog(data)
    local logs = getElementData(syncer, 'logs')
    table.insert(logs, data)

    if #logs > 40 then
        table.remove(logs, 1)
    end

    setElementData(syncer, 'logs', logs)
end

function addChatLog(player, message)
    local rank = getElementData(player, 'player:admin')
    addLog({
        type = 'chat',
        player = getElementData(player, 'player:sid'),
        textNoHex = getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): ' .. message,
        text = {
            {getRankColor(rank), getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ')'},
            {0xFFFFFFFF, ': ' .. message},
        },
        sendTime = getRealTime().timestamp
    })
end

function addCommandLog(player, command)
    local rank = getElementData(player, 'player:admin')
    addLog({
        type = 'command',
        player = getElementData(player, 'player:sid'),
        textNoHex = getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): /' .. command,
        text = {
            {getRankColor(rank), getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ')'},
            {0xFFFFFFFF, ': /' .. command},
        },
        sendTime = getRealTime().timestamp
    })
end

addEvent('admin:logConsole', true)
addEventHandler('admin:logConsole', resourceRoot, function(command)
    local cmd = split(command, ' ')[1]
    if commandBlackList[cmd] then return end
    
    addCommandLog(client, command)
end)