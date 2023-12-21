local modelSettings = {}
    modelSettings.modelID = 1933
    modelSettings.requiredFiles = {"txd", "dffc", "colc"}

function startupModel()
    for i, v in ipairs(modelSettings.requiredFiles) do
        local decodedFile = exports["al_modelcode"]:decodeModel("model."..v)
        if v == "txd" then
            local txd = engineLoadTXD("model.txd")
            engineImportTXD(txd, modelSettings.modelID)
        elseif v == "dffc" then
            local dff = engineLoadDFF(decodedFile)
            engineReplaceModel(dff, modelSettings.modelID, true)
        elseif v == "colc" then
            local col = engineLoadCOL(decodedFile)
            engineReplaceCOL(col, modelSettings.modelID)
        end
    end
    outputConsole("[model]Loaded model ID "..modelSettings.modelID.."["..table.concat(modelSettings.requiredFiles, ", ").."]")
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startupModel)