addEvent("addCustomPaintjob", true)
addEventHandler("addCustomPaintjob", root, function(veh, pjID)
    if isElement(veh) then
        if getElementData(veh, "vehicle:id") then
            exports["pystories-db"]:dbSet("UPDATE pystories_vehicles SET custompj=? WHERE id=?", pjID, getElementData(veh, "vehicle:id"))
        end
    end
end)