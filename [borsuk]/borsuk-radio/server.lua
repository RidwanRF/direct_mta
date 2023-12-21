addCommandHandler("audycja", function(plr, cmd)
    fetchRemote("http://23.88.49.58:8010/", function(responseData, errorCode)
        local pos = responseData:find("Current Song:")
        local data = responseData:sub(pos+41, pos+300)
        data = data:sub(1, data:find("</td")-1)
        
        triggerClientEvent(plr, "showRadioStats", resourceRoot, plr, data)
    end)
end)