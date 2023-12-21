local saveData = {
    { elementData = 'player:skin', key = 'skin', callback = function(player, value)
        setElementModel(player, value)
    end },
   -- { elementData = 'player:test', key = 'test', json = true},
    { key = 'money', callback = function (player, value)
        setPlayerMoney(player, value)
    end },
    { elementData = 'player:level', key = 'level' },
    { elementData = 'player:exp', key = 'exp' },
    { elementData = 'player:hours', key = 'playedTime' },
    { elementData = 'player:inventory', key = 'inventory', json = true },
    { elementData = 'player:licenses', key = 'licenses', json = true }
}

function loadPlayerData(player)
    local uid = getElementData(player, 'player:sid')
    if not uid then return end

    local data = exports['iq-db']:query('SELECT * FROM `iq-users` WHERE uid=?', uid)

    if (#data == 0) then return end

    local rows = exports['iq-db']:query('SELECT * FROM `iq-users` WHERE premium>NOW() AND uid=?', uid)
    if (#rows > 0) then
        setElementData(player, 'player:premium', data[1].premium)
        outputChatBox("✓ #ffffffPosiadasz zakupioną usługę #ffa600Premium#ffffff #bfbfbf(Ważne do "..data[1].premium..")#ffffff", plr, 0, 255, 0, true)
    end
    
    for i,v in pairs(saveData) do
        if (v.elementData) then
            if (v.json) then
                setElementData(player, v.elementData, loadstring((data[1][v.key] and #data[1][v.key] > 3) and data[1][v.key] or "return {}")())
            else
                setElementData(player, v.elementData, data[1][v.key])
            end
            -- setElementData(player, v.elementData, (v.json and loadstring((data[1][v.key] and #data[1][v.key] > 3) and data[1][v.key] or "return {}")() or data[1][v.key]))
        end
        
        if v.callback then
            v.callback(player, (v.json and fromJSON(data[1][v.key]) or data[1][v.key]))
        end
    end

    return true
end

function savePlayerData(player)
    local uid = getElementData(player, 'player:sid')
    if not uid then return end

    local data = {}
    data.money = getPlayerMoney(player)
    data.skin = getElementModel(player)
    data.exp = getElementData(player, 'player:exp') or 0
    data.level = getElementData(player, 'player:level') or 0
    data.wanted = getElementData(player, 'player:wanted') or 0
    data.inventory = getElementData(player,'player:inventory') or {}
    data.hours = getElementData(player,'player:hours') or 0
    data.licenses = getElementData(player,'player:licenses') or {}

    exports['iq-db']:query('UPDATE `iq-users` SET `money` = ?, `skin` = ?, `level` = ?, `exp` = ?, `inventory` = ?, `playedTime` = ?, `licenses` = ?  WHERE uid=? ', data.money, data.skin, data.level, data.exp, serpent.dump(data.inventory), data.hours, serpent.dump(data.licenses), uid)
end

addEventHandler('onPlayerQuit',root,function ()
    savePlayerData(source)
end)