local main = {
    shaders = {},
    avatars = {},
    waiting = {},
    ['textures'] = {
        ['mask'] = dxCreateTexture('data/images/mask.png'),
        ['noavatar'] = dxCreateTexture('data/images/avatar.png'),
        ['circleMask'] = dxCreateTexture('data/images/mask2.png')
    }
}

local main2 = {
    shaders = {},
    avatars = {},
    waiting = {},
}

function getPlayerAvatar(c,mask)
    if not mask then mask = 'mask' end
    local uid = tonumber(c)
    if not uid then return end
    local unique = uid..tostring(mask)

    if main.shaders[unique] then
        return main.shaders[unique]
    end

    if not main.waiting[unique] then
        main.waiting[unique] = true
        triggerServerEvent('fetchAvatar',resourceRoot,uid)
    end

    if not main.shaders[unique] then
        main.shaders[unique] = dxCreateShader("data/fx/mask.fx")
        dxSetShaderValue(main.shaders[unique], "sPicTexture", main['textures']['noavatar'])
        dxSetShaderValue(main.shaders[unique], "sMaskTexture", mask)
        dxSetShaderValue(main.shaders[unique], 'gUVScale', 1, 1)
    end

    return main.shaders[unique]
end

function getCircleAvatar(c)

    local uid = tonumber(c)
    if not uid then return end
    if main2.shaders[uid] then
        return main2.shaders[uid]
    end

    if not main2.waiting[uid] then
        main2.waiting[uid] = true
        triggerServerEvent('fetchCircleAvatar',resourceRoot,uid)
    end

    if not main2.shaders[uid] then
        main2.shaders[uid] = dxCreateShader("data/fx/mask.fx")
        dxSetShaderValue(main2.shaders[uid], "sPicTexture", main['textures']['noavatar'])
        dxSetShaderValue(main2.shaders[uid], "sMaskTexture", main['textures']['circleMask'])
        dxSetShaderValue(main2.shaders[uid], 'gUVScale', 1, 1)
    end

    return main2.shaders[uid]
end

addEvent('returnAvatars2',true)
addEventHandler('returnAvatars2',resourceRoot,function (avatar,uid)
    if main2.avatars[uid] and isElement(main2.avatars[uid]) then
        destroyElement(main2.avatars[uid])
    end

    main2.avatars[uid] = dxCreateTexture(avatar)
    dxSetShaderValue(main2.shaders[uid], "sPicTexture", main2.avatars[uid])
end)

addEvent('returnAvatars',true)
addEventHandler('returnAvatars',resourceRoot,function (avatar,uid)
    if main.avatars[uid] and isElement(main.avatars[uid]) then
        destroyElement(main.avatars[uid])
    end

    main.avatars[uid] = dxCreateTexture(avatar)
    dxSetShaderValue(main.shaders[uid], "sPicTexture", main.avatars[uid])
end)

-- local txt = dxCreateTexture('mask.png')

-- addEventHandler('onClientRender',root,function ()
--     dxDrawImage(200,200,200,200,getPlayerAvatar(1,txt))
-- end)

--[[function getPlayerStateAvatar(plr)
    if (test['avatars'][plr] and test['avatars'][plr].avatar and not test['avatars'][plr].shader) then
        test['avatars'][plr].shader = dxCreateShader('data/fx/mask.fx')
        dxSetShaderValue(test['avatars'][plr].shader, "sPicTexture", test['avatars'][plr].avatar)
        dxSetShaderValue(test['avatars'][plr].shader, "sMaskTexture", main['textures']['circleMask'])
        dxSetShaderValue(test['avatars'][plr].shader, 'gUVScale', 1, 1)
    else
        test['avatars'][plr] = {}
        test['avatars'][plr].shader = dxCreateShader("data/fx/mask.fx")
        dxSetShaderValue(test['avatars'][plr].shader, "sPicTexture", main['textures']['noavatar'])
        dxSetShaderValue(test['avatars'][plr].shader, "sMaskTexture", main['textures']['circleMask'])
        dxSetShaderValue(test['avatars'][plr].shader, 'gUVScale', 1, 1)
    end
    return test['avatars'][plr].shader
end

addEvent('returnDownloadedAvatar',true)
addEventHandler('returnDownloadedAvatar',root,function (plr,data)
    test['avatars'][plr] = {}
    test['avatars'][plr].avatar = dxCreateTexture(data)
end)


addEvent('returnAvatars',true)
addEventHandler('returnAvatars',root,function (avatar,uid)
    if main.avatars[uid] and isElement(main.avatars[uid]) then
        destroyElement(main.avatars[uid])
    end

    main.avatars[uid] = dxCreateTexture(avatar)
    dxSetShaderValue(main.shaders[uid], "sPicTexture", main.avatars[uid])
end)
--]]