local replace = [[
texture Tex0; 
  
technique simple 
{ 
    pass P0 
    { 
        Texture[0] = Tex0; 
    } 
} 
]]
local shaders = {}
local textures = {}

function updateCustomTxt(element)
    local data = getElementData(element, "element:customtxt")
    if shaders[element] then
        destroyElement(shaders[element])
        shaders[element] = nil
    end
    if not data then return end

    if not shaders[element] then
        shaders[element] = dxCreateShader(replace, 0, 0, false, "all")
    end
    if not textures[data.replace] then
        textures[data.replace] = dxCreateTexture("data/" .. data.replace .. ".png")
    end
    for k,v in pairs(data.textures) do
        engineApplyShaderToWorldTexture(shaders[element], v, element)
    end
    dxSetShaderValue(shaders[element], "Tex0", textures[data.replace])
end

addEventHandler("onClientElementDataChange", root, function(key, old, new)
    if key == "element:customtxt" then
        updateCustomTxt(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k,v in pairs(getElementsByType("player")) do
        updateCustomTxt(v)
    end
    for k,v in pairs(getElementsByType("ped")) do
        updateCustomTxt(v)
    end
    for k,v in pairs(getElementsByType("vehicle")) do
        updateCustomTxt(v)
    end
end)