local _fileExists = fileExists
local _engineLoadDFF = engineLoadDFF
local _engineLoadTXD = engineLoadTXD
local _engineLoadCOL = engineLoadCOL
local encryption = 'jebachuciarzapierdolonegosmiecia321eluwina'

function fileExists(path)
    return _fileExists(path .. '.enc')
end

function engineLoadDFF(path, ...)
    local file = fileOpen(path .. '.enc')
    local data = fileRead(file, fileGetSize(file))
    local encryption = encryption .. fileGetSize(file)
    fileClose(file)

    local decrypted = teaDecode(data, encryption)
    return _engineLoadDFF(decrypted, ...)
end

function engineLoadTXD(path, ...)
    local file = fileOpen(path .. '.enc')
    local data = fileRead(file, fileGetSize(file))
    local encryption = encryption .. fileGetSize(file)
    fileClose(file)

    local decrypted = teaDecode(data, encryption)
    return _engineLoadTXD(decrypted, ...)
end

function engineLoadCOL(path, ...)
    local file = fileOpen(path .. '.enc')
    local data = fileRead(file, fileGetSize(file))
    local encryption = encryption .. fileGetSize(file)
    fileClose(file)

    local decrypted = teaDecode(data, encryption)
    return _engineLoadCOL(decrypted, ...)
end

local replace = {
    [14674] = 'mechanik',
    [4018] = 'przechowalnia',
    [5409] = 'stacja',
}

for k, v in pairs(replace) do
    if fileExists('data/' .. v .. '.txd') then
        engineImportTXD(engineLoadTXD('data/' .. v .. '.txd'), k)
    end
    if fileExists('data/' .. v .. '.dff') then
        engineReplaceModel(engineLoadDFF('data/' .. v .. '.dff'), k, true)
    end
    if fileExists('data/' .. v .. '.col') then
        engineReplaceCOL(engineLoadCOL('data/' .. v .. '.col'), k)
    end
end