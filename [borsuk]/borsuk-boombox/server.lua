local boomboxes = {}
local texts = {}

addCommandHandler("boombox", function(plr, cmd, url)
    if not url or not url:find("http://foow.org/") then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Boombox", "Wspieramy tylko muzykę z http://foow.org", {255, 50, 50}, "sighter")
    end
    setElementData(plr, "player:boomboxmusic", url)
    exports["noobisty-notyfikacje"]:createNotification(plr, "Boombox", "Postaw boombox ponownie aby załadować muzykę", {50, 255, 50}, "sight")
end)

addEvent("equipBoombox", true)
addEventHandler("equipBoombox", root, function(equipped)
    if boomboxes[source] and isElement(boomboxes[source]) then
        triggerClientEvent(root, "stopBoomboxSound", root, boomboxes[source])
        destroyElement(boomboxes[source])
    end
    if texts[source] and isElement(texts[source]) then
        destroyElement(texts[source])
    end

    setElementData(source, "player:boombox", false)

    if equipped then
        exports["noobisty-notyfikacje"]:createNotification(source, "Boombox", "Wyjęto boombox, wpisz /boombox [url] aby ustawić muzykę", {50, 255, 50}, "sight")
        boomboxes[source] = createObject(2226, 0, 0, 0)
        setElementData(boomboxes[source], "boombox:music", (getElementData(source, "player:boomboxmusic") or "http://23.88.49.58:8010/radio.mp3"))
        exports["borsuk-pattach"]:attach(boomboxes[source], source, 24, 0, 0, 0.36, -90)
        triggerClientEvent(root, "playBoomboxSound", root, boomboxes[source])
        setElementData(source, "player:boombox", boomboxes[source])
    end
end)

addCommandHandler("poloz", function(plr)
    local boombox = getElementData(plr, "player:boombox")
    if not boombox or not isElement(boombox) then return end

    exports["borsuk-pattach"]:detach(boombox, plr)
    local x, y, z = getElementPosition(plr)
    local rx, ry, rz = getElementRotation(plr)
    setElementPosition(boombox, x, y, z - 1)
    setElementRotation(boombox, 0, 0, rz+180)

    texts[plr] = createElement("text")
    setElementPosition(texts[plr], x, y, z - 0.5)
    setElementData(texts[plr], "name", "Właściciel: " .. getPlayerName(plr) .. "\n/podnies")
end)

addCommandHandler("podnies", function(plr)
    local boombox = getElementData(plr, "player:boombox")
    if not boombox or not isElement(boombox) then return end

    exports["borsuk-pattach"]:attach(boombox, plr, 24, 0, 0, 0.36, -90)

    if texts[plr] and isElement(texts[plr]) then
        destroyElement(texts[plr])
    end
end)