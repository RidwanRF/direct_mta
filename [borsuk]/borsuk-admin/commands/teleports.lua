local teleports = {
    {'kurier', {-1829.47, -101.12, 5.65}},
    {'cygan', {-1812.65, 1323.56, 7.19,}},
    {'przecho', {-2443.44, -141.01, 20.99}},
    {'prawko', {-1901.26, 483.81, 35.17}},
    {'magazyn', {-1850.75, -75.79, 15.12}},
    {'zabka', {-1923.50, 578.27, 35.17}},
    {'smieciarki', {2194.005371,-1974.312866,13.559345}},
    {'rybak', {166.859772,-1770.618652,4.413123}},
    {'spawn', {-2652.66, -5.76, 6.13}},
    {'przebieralnia', {-2494.32, -28.20, 25.77}},
    {'derby', {4468.152344,-183.857376,73.400002,650,0}},
    {'kasyno', {-2655.84, 376.28, 4.34}},
    {'szambo', {-1827.12, 73.73, 15.12}},
    {'gielda', {-2008.48, -859.73, 32.17}},
    {'kosiarki', {-2508.94, -709.69, 139.32}},
    {'offroad', {-911.02, -502.12, 25.96}},
}

for i,v in ipairs(teleports) do
    addCommandHandler(v[1], function(player, cmd)
        if not getAdmin(player) then return end
        if isPedInVehicle(player) then removePedFromVehicle(player) end

        setElementPosition(player, v[2][1], v[2][2], v[2][3])
        setElementDimension(player, (v[2][4] or 0))
        setElementInterior(player, (v[2][5] or 0))
        exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Teleport', 'Zostałeś przeniesiony na teleport '..v[1])
    end)
end

addCommandHandler('teleporty', function(player, cmd)
    if not getAdmin(player) then return end

    local c = ''
    for i,v in ipairs(teleports) do
        c = c..'/'..v[1]..'\n'
    end
    c = c:sub(1, #c-1)
    exports['borsuk-notyfikacje']:addNotification(player, 'info', 'Dostępne teleporty', c)
end)