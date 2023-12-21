local replace = {
    [1899] = 'barn',
    [1900] = 'hoe',
    [1901] = 'ground',
    [1902] = 'can',
    [1903] = 'beetroot',
    [1904] = 'carrot',
    [1905] = 'patatoes',
    [1906] = 'house',
    [1907] = 'onions',
    [1908] = 'tomato',
    [1909] = 'redflower',
    [1910] = 'greenflower',
    [1911] = 'blueflower',
    [1912] = 'coca',
    [1913] = 'wheat',
}

for k,v in pairs(replace) do
    if fileExists('data/' .. v .. '.txd') then
        engineImportTXD(engineLoadTXD('data/' .. v .. '.txd'), k)
    end
    if fileExists('data/' .. v .. '.col') then
        engineReplaceCOL(engineLoadCOL('data/' .. v .. '.col'), k)
    end
    if fileExists('data/' .. v .. '.dff') then
        engineReplaceModel(engineLoadDFF('data/' .. v .. '.dff'), k, true)
    end
end