function decode(path, key)
    local f = fileOpen(path)
    local rawdatac = fileRead(f, fileGetSize(f))
    fileClose(f)
    local rawdata = decodeString("tea", rawdatac, {key = key})
    return rawdata
end