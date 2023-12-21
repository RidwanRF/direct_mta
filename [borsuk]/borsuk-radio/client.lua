local radio = {

    theSound = {},
    radioVolume = {},
    radioData = {
        
        actualSong = nil,
        infoPos = 0,

    },

    positions = {

        {"http://23.88.49.58:8010/radio.mp3", -1835.835938,-67.782150,11.370897, 30, 60, 1},

    }

}

for i,v in pairs(radio.positions) do
    radio.theSound[i] = playSound3D(v[1], v[2], v[3], v[4])
    if v.dimension then
        setElementDimension(radio.theSound[i], v.dimension)
    end
    if v.interior then
        setElementInterior(radio.theSound[i], v.interior)
    end
    setSoundMinDistance(radio.theSound[i], v[5])
    setSoundMaxDistance(radio.theSound[i], v[6])
    if not radio.radioVolume[i] then radio.radioVolume[i] = 5 end
    setSoundVolume(radio.theSound[i], radio.radioVolume[i]/100)
end

function setRadioVolume(volume)
    for i,v in ipairs(radio.positions) do
        setSoundVolume(radio.theSound[i], volume/100)
        radio.radioVolume[i] = volume
    end

end

function getRadioVolume()
    return radio.radioVolume[1]
end

function renderStats()
    if radio.radioData.actualSong then
        dxDrawRectangle(sx / 2, 10/zoom, radio.radioData.infoPos/zoom, 100/zoom, tocolor(30, 30, 30, 255))
        dxDrawRectangle(sx / 2, 10/zoom, -radio.radioData.infoPos/zoom, 100/zoom, tocolor(30, 30, 30, 255))
        dxDrawRectangle(sx / 2, 109/zoom, -radio.radioData.infoPos/zoom, 1/zoom, tocolor(100, 225, 255, 200))
        dxDrawRectangle(sx / 2, 109/zoom, radio.radioData.infoPos/zoom, 1/zoom, tocolor(100, 225, 255, 200))

        if radio.radioData.infoPos == 250 then
            dxDrawText('♪ Radio DirectFM ♪', sx/2, 40/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, font3, "center", "bottom", false, false, false, true, false)
            dxDrawText('Aktualnie odtwarzamy', sx/2, 80/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, font1, "center", "bottom", false, false, false, true, false)
            dxDrawText(radio.radioData.actualSong, sx/2, 80/zoom, nil, nil, tocolor(100, 225, 255, 225), 1, font2, "center", "top", false, false, false, true, false)
        end
    end
end

addEvent("showRadioStats", true)
addEventHandler("showRadioStats", resourceRoot, function(plr, data)
    if radio.radioData.actualSong then return end

    if data then
        radio.radioData.actualSong = data
        addEventHandler("onClientRender", root, renderStats)
        createAnimation(0, 250, 'Linear', 500, function(value) radio.radioData.infoPos = value end)

        setTimer( function()
            createAnimation(250, 0, 'Linear', 500, function(value) radio.radioData.infoPos = value end)

            setTimer( function()
                removeEventHandler("onClientRender", root, renderStats)
                radio.radioData.actualSong = nil
            end, 550, 1)
        end, 4000, 1)
    end
end)