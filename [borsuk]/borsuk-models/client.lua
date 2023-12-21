local replace = {
    [14901] = "test",
    [1209] = "vendmach",
    [3014] = "zabka",
    [1853] = "szyba",
    [4113] = "model",
    [1990] = "box",
    [5819] = "mechanik",
    [5784] = "stairs",
    [493] = "jetmax",
    [1899] = "FishingRod",
    [555] = "monroe",
    [1926] = "FAME",
    [573] = "duneride",
    [444] = "marshall",
    [496] = "student",
    --[480] = "student",
    [1921] = "toolbox",
    [462] = "faggio",
    --[4103] = "exter",
}

for k,v in pairs(replace) do
    if fileExists("data/" .. v .. ".col") then
        local file = engineLoadCOL("data/" .. v .. ".col")
        engineReplaceCOL(file, k)
    end
    if fileExists("data/" .. v .. ".txd") then
        local file = engineLoadTXD("data/" .. v .. ".txd")
        engineImportTXD(file, k)
    end
    if fileExists("data/" .. v .. ".dff") then
        local file = engineLoadDFF("data/" .. v .. ".dff")
        engineReplaceModel(file, k, true)
    end
end

local szyba = createObject(1853, 1335.59776,-1553.006670,14.586250)
setElementAlpha(szyba, 155)
setElementDoubleSided(szyba, true)

local pomnik = createObject(1786, 1093.295166,-1802.993945,13.88641,0,0,-90)