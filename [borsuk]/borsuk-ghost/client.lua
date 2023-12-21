addEventHandler("onClientRender", root, function()
    local x, y, z = getElementPosition(localPlayer)
    for k,v in pairs(getElementsWithinRange(x, y, z, 50, "vehicle")) do
        if getElementData(v, "element:ghost") then
            for d,c in pairs(getElementsWithinRange(x, y, z, 50, "vehicle")) do
                setElementCollidableWith(v, c, false)
                setElementCollidableWith(c, v, false)
            end
        end
    end

    for k,v in pairs(getElementsWithinRange(x, y, z, 50, "player")) do
        if getElementData(v, "element:ghost") then
            for d,c in pairs(getElementsWithinRange(x, y, z, 50, "player")) do
                setElementCollidableWith(v, c, false)
                setElementCollidableWith(c, v, false)
            end
        end
    end
end)