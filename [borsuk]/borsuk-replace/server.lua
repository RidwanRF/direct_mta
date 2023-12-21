local encryption = 'jebachuciarzapierdolonegosmiecia321eluwina'

function encodeFile(name)
    if not name or not fileExists('data/'..name) then return false end

    local file = fileOpen('data/'..name, true)
    local data = fileRead(file, fileGetSize(file))
    local encryption = encryption .. fileGetSize(file)
    fileClose(file)

    local fileEncrypted = fileCreate('data/'..name..'.enc')
    fileWrite(fileEncrypted, teaEncode(data, encryption))
    fileClose(fileEncrypted)

    local metaFile = fileOpen('meta.xml', false)
    local meta = fileRead(metaFile, fileGetSize(metaFile))
    meta = meta:sub(1, #meta-7)..'\t<file src="data/'..name..'.enc"/>\n</meta>'
    fileClose(metaFile)

    fileDelete('meta.xml')
    local metaFile = fileCreate('meta.xml')
    fileWrite(metaFile, meta)
    fileClose(metaFile)

    return true
end

addCommandHandler('borsukkoduj', function(plr, cmd, name)
    local account = getPlayerAccount(plr)
    if not account or not isObjectInACLGroup('user.'..getAccountName(account), aclGetGroup('Admin')) then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Kodowanie', 'Nie masz uprawnień!') end
    
    local successAny = false
    for k,v in pairs({'dff', 'txd', 'col'}) do
        local success = encodeFile(name..'.'..v)
        if success then successAny = true end
    end

    if not successAny then
        local success = encodeFile(name)
        if not success then return exports['borsuk-notyfikacje']:addNotification(plr, 'error', 'Kodowanie', 'Podany plik nie istnieje!') end
    end

    exports['borsuk-notyfikacje']:addNotification(plr, 'success', 'Kodowanie', 'Plik '..name..' został zakodowany!')
end)