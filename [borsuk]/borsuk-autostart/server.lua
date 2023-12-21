for _, res in ipairs(getResources()) do
    if getResourceName(res) == "borsuk-gui" or getResourceName(res) == "object_preview" then
        startResource(res)
    end
end

setTimer(function()
    local run = {
        "shader_",
        "enb_",
        "DB",
        "DB2",
        "pystories-db",
        "pystories-",
        "community-",
        "borsuk-",
        "noobisty-",
        "naked-",
        "berlin-",
        "ST_",
        "rpg_",
        "map_",
        "urzad",
        "podmianka",
        "dmta",
        "reftixd",
    }

    for k,v in pairs(run) do
        for _, res in ipairs(getResources()) do
            if getResourceName(res):find(v) then
                startResource(res)
            end
        end
    end
end, 1000, 1)