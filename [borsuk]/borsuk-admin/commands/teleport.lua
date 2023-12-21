addCommandHandler('tt', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś gracza!') end

    local target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono gracza!') end

    local element = getPedOccupiedVehicle(player) or player
    local vehicle = getPedOccupiedVehicle(target)

    if vehicle then
        local freeSeat = false
        for i = 0, getVehicleMaxPassengers(vehicle) do
            if not getVehicleOccupant(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            if getPedOccupiedVehicle(player) then
                removePedFromVehicle(player)
            end

            setElementInterior(player, getElementInterior(target))
            setElementDimension(player, getElementDimension(target))
            warpPedIntoVehicle(player, vehicle, freeSeat)
            exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano do pojazdu gracza!')
            return
        end
    end

    local x, y, z = getElementPosition(target)
    setElementPosition(element, x, y + 1, z)
    setElementInterior(element, getElementInterior(target))
    setElementDimension(element, getElementDimension(target))

    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano do gracza!')
end)

addCommandHandler('th', function(player, cmd, target)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś gracza!') end

    local target = exports['iq-core']:findPlayer(player, target)
    if not target then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono gracza!') end

    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        local freeSeat = false
        for i = 0, getVehicleMaxPassengers(vehicle) do
            if not getVehicleOccupant(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            if getPedOccupiedVehicle(target) then
                removePedFromVehicle(target)
            end

            setElementInterior(target, getElementInterior(player))
            setElementDimension(target, getElementDimension(player))
            warpPedIntoVehicle(target, vehicle, freeSeat)
            exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano gracza do pojazdu!')
            return
        end
    end

    if getPedOccupiedVehicle(target) then
        removePedFromVehicle(target)
    end

    local x, y, z = getElementPosition(player)
    setElementPosition(target, x, y + 1, z)
    setElementInterior(target, getElementInterior(player))
    setElementDimension(target, getElementDimension(player))

    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano gracza do siebie!')
end)

addCommandHandler('vtt', function(player, cmd, id)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not id or not tonumber(id) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś ID pojazdu!') end

    local vehicle = false
    for _, v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == tonumber(id) then
            vehicle = v
            break
        end
    end
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono pojazdu!') end

    local freeSeat = false
    for i = 0, getVehicleMaxPassengers(vehicle) do
        if not getVehicleOccupant(vehicle, i) then
            freeSeat = i
            break
        end
    end

    if freeSeat then
        if getPedOccupiedVehicle(player) then
            removePedFromVehicle(player)
        end

        setElementInterior(player, getElementInterior(vehicle))
        setElementDimension(player, getElementDimension(vehicle))
        warpPedIntoVehicle(player, vehicle, freeSeat)
        exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano do pojazdu!')
        return
    end

    local x, y, z = getElementPosition(vehicle)
    setElementPosition(player, x, y, z + 1)
    setElementInterior(player, getElementInterior(vehicle))
    setElementDimension(player, getElementDimension(vehicle))
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano do pojazdu!')
end)

addCommandHandler('vth', function(player, cmd, id)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end
    if not id or not tonumber(id) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie podałeś ID pojazdu!') end

    local vehicle = false
    for _, v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == tonumber(id) then
            vehicle = v
            break
        end
    end
    if not vehicle then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie znaleziono pojazdu!') end

    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    setElementPosition(vehicle, x, y, z)
    setElementRotation(vehicle, rx, ry, rz)
    setElementInterior(vehicle, getElementInterior(player))
    setElementDimension(vehicle, getElementDimension(player))
    warpPedIntoVehicle(player, vehicle, 0)
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Teleportowano do pojazdu!')
end)