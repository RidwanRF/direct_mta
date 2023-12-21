addCommandHandler("gp",function() 
    if not getElementData(localPlayer, "player:sid") == 9 then return end
    local x,y,z = getElementPosition(localPlayer)
    p = string.format("%.2f, %.2f, %.2f", x,y,z)
    outputChatBox("ⓘ#FFFFFF Interior: " .. getElementInterior(localPlayer) .. " Dimension: " .. getElementDimension(localPlayer), 255, 255, 0, true)
    outputChatBox("ⓘ#FFFFFF Pozycja gracza: #00c3ff{"..p.."},#FFFFFF", 255, 255, 0, true)
    setClipboard("{"..p.."},")
    
    local pojazd = getPedOccupiedVehicle(localPlayer)
    if pojazd then
        local x,y,z = getElementPosition(pojazd)
        local rx,ry,rz = getElementRotation(pojazd)
        p = string.format("%.2f, %.2f, %.2f, %.1f, %.1f, %.1f", x, y, z, rx, ry, rz)
        outputChatBox("ⓘ#FFFFFF Pozycja pojazdu: #00c3ff{"..p.."},#FFFFFF", 255, 255, 0, true)
        setClipboard("{"..p.."},")
    end
end)