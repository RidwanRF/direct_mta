local shader = dxCreateShader('shader.fx', 0, 0, false, 'object')
engineApplyShaderToWorldTexture(shader, 'lasdockbar')

local visibility = {
    [0] = .15,
    [1] = .15,
    [2] = .15,
    [3] = .15,
    [4] = .15,
    [5] = .15,
    [6] = .2,
    [7] = .3,
    [19] = .3,
    [20] = .3,
    [21] = .15,
    [22] = .15,
    [23] = .15,
    [24] = .15,
    [25] = .15,
}

local function updateShader()
    local hour, minute = getTime()
    local c = visibility[hour] or .4
    local n = visibility[hour + 1] or .4
    local visibility = c + (n - c) * (minute/60)

    dxSetShaderValue(shader, 'visibility', visibility)
end

setTimer(updateShader, 10000, 0)
updateShader()