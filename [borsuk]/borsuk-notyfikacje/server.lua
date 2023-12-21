function addNotification(player, type, title, text, duration, unique)
    if not player then return end
    triggerClientEvent(player, "addNotification", resourceRoot, type, title, text, duration, unique)
end