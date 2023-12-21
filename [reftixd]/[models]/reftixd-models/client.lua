local models = {
    ['store'] = 17519,
    ['barber'] = 17944,
    ['groundbarber'] = 17677,
    ['dft30'] = 578,
    ['ambulan'] = 416,
    ['mechanik_garaz'] = 6104,
    ['pumpkin'] = 8981,
    ['kruton9000'] = 2014,
    ['ramp'] = 2015,
    ['welder'] = 2016,
    ['dev_tool'] = 2018,
    ['dev_tool2'] = 2019,
    ['dev_tool3'] = 2020,
    ['tire'] = 2021,
    ['tire2'] = 2022,
    ['tools'] = 1630,
    ['bench1'] = 14401,
    ['slupek'] = 1337,
    ['slupek'] = 1237,
    ['slupek'] = 1335,
    ['prawkoext'] = 6159,
    ['dockbar'] = 3578,
}

for i,v in pairs(models) do
    if fileExists("data/models/"..i..".txd") then
        local txd = engineLoadTXD("data/models/"..i..".txd")
        engineImportTXD(txd, v)
    end
    if fileExists("data/models/"..i..".dffc") then
        local data = decode("data/models/"..i..".dffc", getElementData(getRootElement(), "kodowanieModeli"))
        local dff = engineLoadDFF(data)
        engineReplaceModel(dff, v, true)
    end
    if fileExists("data/models/"..i..".colc") then
        local data = decode("data/models/"..i..".colc", getElementData(getRootElement(), "kodowanieModeli"))
        local col = engineLoadCOL(data)
        engineReplaceCOL(col, v)
    end
end
