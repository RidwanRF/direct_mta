local owners = {
    ['349A4C9C334DEB38BB52E6B07D6C27A2'] = true, -- IQ
    ['CBF0C81FCC29BDA534DBDA421889F442'] = true -- ReftiXD
}

setElementData(getRootElement(), "kodowanieModeli", code)

addCommandHandler("koduj", function(localPlayer, cmd, name)
    if not owners[getPlayerSerial(localPlayer)] then return end
    local col = checkFile("data/models/"..name..".col")
    local dff = checkFile("data/models/"..name..".dff")
    local txd = checkFile("data/models/"..name..".txd")
    outputChatBox("dff: "..tostring(dff), localPlayer)
    outputChatBox("col: "..tostring(col), localPlayer)
    outputChatBox("txd: "..tostring(txd), localPlayer)
    if col then
        codeFile("data/models/"..name..".col", localPlayer)
    end
    if dff then
        codeFile("data/models/"..name..".dff", localPlayer)
    end
    if txd then
        local xml = xmlLoadFile("meta.xml", false)
        local files = xmlNodeGetChildren(xml)
        for i, v in ipairs(files) do
            if xmlNodeGetAttribute(v, "src") == "data/models/"..name..".txd" then return end
        end
        local child = xmlCreateChild(xml, "file")
        xmlNodeSetAttribute(child, "src", "data/models/"..name..".txd")
        xmlSaveFile(xml)
    end
end)

function codeFile(path, player)
    if not fileExists(path) then
        outputChatBox("* Nie udało się zakodować pliku: "..path..", gdyż nie udało się go otworzyć", player)
        return
    end
    local f = fileOpen(path)
    if not f then
        outputChatBox("* Nie udało się zakodować pliku: "..path..", gdyż nie udało się go otworzyć", player)
        return
    end
    local uncoded = fileRead(f, fileGetSize(f))
    if not uncoded then
        outputChatBox("* Nie udało się odczytać niezakodowanego pliku: "..path, player)
        return
    end
    local coded = encodeString("tea", uncoded, {key = getElementData(getRootElement(), "kodowanieModeli")})
    fileClose(f)
    if not coded then
        return
        outputChatBox("* Nie udało się zakodować danych pliku: "..path, player)
    end
    local npath = path.."c"
    local nf = fileCreate(npath)
    if not nf then
        outputChatBox("* Nie udało się utworzyć zakodowanej wersji pliku: "..path, player)
        return
    end
    fileWrite(nf, coded)
    fileClose(nf)
    outputChatBox("* Pomyślnie zakodowano plik: "..path, player)
    local xml = xmlLoadFile("meta.xml", false)
    local files = xmlNodeGetChildren(xml)
    for i, v in ipairs(files) do
        if xmlNodeGetAttribute(v, "src") == npath then return end
    end
    local child = xmlCreateChild(xml, "file")
    xmlNodeSetAttribute(child, "src", npath)
    xmlSaveFile(xml)
end

function checkFile(path)
    if not fileExists(path) then
        if fileExists(path.."c") then
            return false
        else
            return false
        end
    else
        return true
    end
end