local names = {

    ['shadow'] = 'enb_shadows',
    ['blur'] = 'enb_depth',
    ['motionblur'] = true,
    ['colors'] = 'enb_palette',
    ['render'] = true,
    ['detail'] = 'enb_detail',
    ['car'] = 'enb_car',
    ['sky'] = 'enb_sky',
    ['smoke'] = 'pystories-vehicles',
    ['water'] = 'enb_water',
    ['snow'] = 'enb_snow',
    ['hudof'] = true,

}

function toggleShader(name, state)
    if names[name] then
        if names[name] == true then
            if name == 'render' then
                if state == true then setFarClipDistance(5000) else resetFarClipDistance() end
            end

            if name == 'motionblur' then
                triggerServerEvent('setPlayerBlur', localPlayer, localPlayer, state)
            end

            if name == 'hudof' then
                setElementData(localPlayer, 'player:hudof', state)
            end
        else
            exports[names[name]]:toggleShader(state)
        end
    end
end

function switchShader(shaderName)
    local shaders = getElementData(localPlayer, "player:shaders") or {}
	toggleShader(shaderName, shaders[shaderName])
end

addEvent("switchShaders", true)
addEventHandler("switchShaders", root, function(shaders)
    for i, v in pairs(shaders) do
        toggleShader(i, v)
    end
end)