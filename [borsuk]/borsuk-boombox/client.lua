local sounds = {}

function playBoomboxSound(object)
    local sound = playSound3D(getElementData(object, "boombox:music"), 0, 0, 0, true)
    setSoundMinDistance(sound, 10)
    setSoundMaxDistance(sound, 30)
    setSoundVolume(sound, 0.2)
    attachElements(sound, object)

    sounds[object] = sound
end
addEvent("playBoomboxSound", true)
addEventHandler("playBoomboxSound", root, playBoomboxSound)

addEvent("stopBoomboxSound", true)
addEventHandler("stopBoomboxSound", root, function(object)
    if sounds[object] then
        destroyElement(sounds[object])
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k,v in pairs(getElementsByType("objet")) do
        if getElementData(v, "boombox:music") then
            playBoomboxSound(v)
        end
    end
end, true, "low-9999")