local a = loadstring(exports['iq-gui']:importAnimate())()
local maskShader = dxCreateShader('data/mask.fx')

local function drawLine(x, y, tx, ty, color, width)
    local angle = findRotation(x, y, tx, ty)
    local dist = getDistanceBetweenPoints2D(x, y, tx, ty)
    local w, h = dist, width
    dxDrawImage(x, y-h/2, w, h, 'data/rectangle.png', angle+90, -w/2, 0, color)
end

local function renderLineChart(data,chart)
    local x, y, w, h, radius = data.x, data.y, data.w, data.h, data.radius or 0
    local background, color, text = data.background or defaults.background, data.color or defaults.color, fromColor(data.text or defaults.text)
    local font = data.font or defaults.font
    local marginVertical, marginHorizontal, verticalPosition, horizontalPosition = data.marginVertical or defaults.marginVertical, data.marginHorizontal or defaults.marginHorizontal, data.labels and data.labels.verticalPosition or defaults.verticalPosition, data.labels and data.labels.horizontalPosition or defaults
    local min = data.min or math.min(unpack(data.data))
    local max = data.max or math.max(unpack(data.data))

    if data.blur then
        exports['iq-blur']:dxDrawBlur(x, y, w, h, data.mask, 255, true)
    end

    dxDrawRoundedRectangle(x, y, w, h, radius, background)

    dxSetShaderValue(maskShader, 'sPicTexture', data.rt)
    dxSetShaderValue(maskShader, 'sMaskTexture', data.mask)
    dxDrawImage(x, y, w, h, maskShader, 0, 0, 0, tocolor(255, 255, 255, a[tostring(chart) .. '-alpha']))

    if data.labels and data.labels.horizontal then
        if type(data.labels.horizontal) == 'table' then
            local change = 1/(#data.labels.horizontal-1)
            local yc = (verticalPosition == 'bottom' and h or 0) + (verticalPosition == 'bottom' and marginVertical or -marginVertical)

            for k,v in pairs(data.labels.horizontal) do
                local nx = x + (k-1)*w*change
                local ny = y + yc

                if k == 1 then
                    dxDrawText(v, nx, ny - 10, nx + change*w/1.4, ny + 10, tocolor(text[1], text[2], text[3], text[4] * a[tostring(chart) .. '-alpha']/255), 1, font, 'left', 'center', true)
                elseif k == #data.labels.horizontal then
                    dxDrawText(v, nx - change*w/1.4, ny - 10, nx, ny + 10, tocolor(text[1], text[2], text[3], text[4] * a[tostring(chart) .. '-alpha']/255), 1, font, 'right', 'center', true)
                else
                    dxDrawText(v, nx - change*w/2, ny - 10, nx + change*w/2, ny + 10, tocolor(text[1], text[2], text[3], text[4] * a[tostring(chart) .. '-alpha']/255), 1, font, 'center', 'center', true)
                end
            end
        else
            local y = y + (verticalPosition == 'bottom' and h or 0) + (verticalPosition == 'bottom' and marginVertical or -marginVertical)
            dxDrawText(data.labels.horizontal, x, y - 10, x + w, y + 10, tocolor(text[1], text[2], text[3], text[4] * a[tostring(chart) .. '-alpha']/255), 1, font, 'center', 'center', true)
        end
    end

    if data.labels and data.labels.vertical then
        local xc = (horizontalPosition == 'right' and w or 0) + (horizontalPosition == 'right' and marginHorizontal or -marginHorizontal)
        local labels = {}

        if type(data.labels.vertical) == 'number' then
            for i = max, min, -data.labels.vertical do
                table.insert(labels, i)
            end
        else
            labels = data.labels.vertical
        end

        local change = 1/(#labels-1)
        for k,v in pairs(labels) do
            local nx = x + xc
            local ny = y + (k-1)*h*change
            dxDrawText(v, nx, ny, nil, nil, tocolor(255,255,255,a[tostring(chart) .. '-alpha']), 1, font, horizontalPosition == 'left' and 'right' or 'left', 'center')
        end
    end

    if isMouseInPosition(x, y, w, h) then
        local defaultChartData = roundChartIndexes(data.data or {}, 1, min, max)
        local pointSize = (data.pointSize or defaults.pointSize)*1.5
        local tipMargin = data.tipMargin or defaults.tipMargin
        local r, g, b = unpack(fromColor(data.tipBackgroundColor or defaults.tipBackgroundColor))
        local padding = data.tipBackgroundPadding or defaults.tipBackgroundPadding
        local radius = data.tipBackgroundBorderRadius or defaults.tipBackgroundBorderRadius
        for k,v in pairs(defaultChartData) do
            if isMouseInPosition(x + v.x*w - pointSize/2, y + v.y*h - pointSize/2, pointSize, pointSize) then
                local text = ('%d'):format(min + (max - min)*(1-v.y))
                if data.tipReverse then
                    text = text:reverse()
                end
                if data.tipgsub then
                    text = text:gsub(data.tipgsub[1], data.tipgsub[2])
                end
                if data.tipReverse then
                    text = text:reverse()
                end
                text = (data.tipFormat or '%s'):format(text)
                if data.tipgsub2 then
                    text = text:gsub(data.tipgsub2[1], data.tipgsub2[2])
                end
                local tw = dxGetTextWidth(text, 1, font)
                local fh = dxGetFontHeight(1, font)

                dxDrawRoundedRectangle(x + v.x*w - tw/2 - padding[1], y + v.y*h - fh/2 - tipMargin - padding[2], tw + padding[1] * 2, fh + padding[2] * 2, radius, tocolor(r,g,b,a[tostring(chart) .. '-alpha']))
                dxDrawText(text, x + v.x*w, y + v.y*h - tipMargin, nil, nil, tocolor(255,255,255,a[tostring(chart) .. '-alpha']), 1, font, 'center', 'center', false, false, false, true)
            end
        end
    end
end

local function renderCharts()
    local charts = getElementsByType('chart')
    for k,v in pairs(charts) do
        local data = getElementData(v, 'chart:data')
        if data and data.type == 'line' then
            renderLineChart(data,v)
        end
    end
end

local function updateLineChart(data, min, max)
    local w, h, width, pointSize = data.rtw or data.w, data.rth or data.h, data.width or 2, data.pointSize or defaults.pointSize
    local chartData = data.data or {}
    local color, line, point = data.color or defaults.color, data.line or defaults.line, data.point or defaults.point
    local bottomColor = data.bottomColor or color
    local lineRGBA = fromColor(line)
    local round = data.round or 1
    if #chartData <= 1 then return end
    local roundedChartData = roundChartIndexes(chartData, round, min, max)
    local defaultChartData = roundChartIndexes(chartData, 1, min, max)
    
    dxSetRenderTarget(data.rt, true)
    -- local points = {{w/2, h, color}, {0, h, color}}
    local points = {}
    local pre = false

    for k,v in pairs(roundedChartData) do
        if pre then
            table.insert(points, {w * pre.x, h*pre.y, color})
            table.insert(points, {w * pre.x, h, bottomColor})
            table.insert(points, {w * v.x, h*v.y, color})
            
            table.insert(points, {w * pre.x, h, bottomColor})
            table.insert(points, {w * v.x, h*v.y, color})
            table.insert(points, {w * v.x, h, bottomColor})
        end

        pre = v
    end
    -- table.insert(points, {w, h, color})

    dxDrawPrimitive('trianglelist', false, unpack(points))
    local pre = false
    for k,v in pairs(roundedChartData) do
        if pre then
            drawLine(pre.x*w, pre.y*h, v.x*w, v.y*h, line, width)
        end

        pre = v
    end

    for k,v in pairs(defaultChartData) do
        dxDrawImage(v.x*w - pointSize/2, v.y*h - pointSize/2, pointSize, pointSize, 'data/point.png', 0, 0, 0, point)
    end

    dxSetRenderTarget()
end

function updateChart(data)
    dxSetRenderTarget(data.mask, true)
    dxDrawRoundedRectangle(0, 0, data.rtw or data.w, data.rth or data.h, data.radius or 0, tocolor(255, 255, 255, 255))
    dxSetRenderTarget()
    
    local min = data.min or math.min(unpack(data.data))
    local max = data.max or math.max(unpack(data.data))
    if data.type == 'line' then
        updateLineChart(data, min, max)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    addEventHandler('onClientRender', root, renderCharts, true, 'low-9999')
end)

addEventHandler('onClientRestore', resourceRoot, function(didClearRenderTargets)
    if not didClearRenderTargets then return end

    local charts = getElementsByType('chart')
    for k,v in pairs(charts) do
        local data = getElementData(v, 'chart:data')
        if data then
            updateChart(data)
        end
    end
end)

function createChart(data)
    local chart = createElement('chart')

    data.mask = dxCreateRenderTarget(data.rtw or data.w, data.rth or data.h, true)
    data.rt = dxCreateRenderTarget(data.rtw or data.w, data.rth or data.h, true)
    setElementParent(data.mask, chart)
    setElementParent(data.rt, chart)
    updateChart(data)
    setElementData(chart, 'chart:data', data)
    a[tostring(chart) .. '-alpha'] = {255, 255, 1}

    return chart
end

function interpolateChart(chart, from, to, time, easing)
    local key = tostring(chart) .. '-alpha'
    a[key] = {from or a[key] or 0, to, time, easing}
end

addEventHandler('onClientElementDataChange', resourceRoot, function(key, old, new)
    if key == 'chart:data' and getElementType(source) == 'chart' then
        local data = getElementData(source, 'chart:data')
        updateChart(data)
    end
end)

-- local chart = createChart({
--     x = 250,
--     y = 300,
--     w = 450,
--     h = 250,
--     radius = 10,
--     blur = false,
--     type = 'line',
--     background = tocolor(65, 65, 65, 150),
--     color = 0xAAE8C773,
--     bottomColor = 0x66E8C773,
--     line = 0xFFBCA772,
--     point = 0xFFFFE08F,
--     pointSize = 10,
--     min = 0,
--     max = 120,
--     width = 5,
--     round = 10,
--     marginHorizontal = 10,
--     marginVertical = 10,
--     font = exports['figma']:getFont('Inter-Medium', 8),

--     data = {78, 83, 79, 73, 92, 95, 105},
--     labels = {
--         horizontalPosition = 'left',
--         verticalPosition = 'bottom',
--         horizontal = {
--             '6 dni temu', '5 dni temu', '4 dni temu', '3 dni temu', '2 dni temu', 'wczoraj', 'dzisiaj'
--         },
--         vertical = 30
--     }
-- })

-- addCommandHandler('updatechart', function()
--     local data = getElementData(chart, 'chart:data')
--     data.data = {
--         math.random(10, 90), math.random(10, 90), math.random(10, 90), math.random(10, 90), math.random(10, 90), math.random(10, 90)
--     }
--     data.max = math.random(80, 150)
--     data.labels.vertical = math.random(10, 40)
--     setElementData(chart, 'chart:data', data)
-- end)

-- addCommandHandler('deletechart', function()
--     if chart and isElement(chart) then
--         destroyElement(chart)
--     end
-- end)