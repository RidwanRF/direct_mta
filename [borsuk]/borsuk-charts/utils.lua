defaults = {
    background = tocolor(255, 255, 255, 100),
    color = tocolor(255, 255, 255, 100),
    line = tocolor(255, 255, 255, 100),
    point = tocolor(255, 255, 255, 200),
    text = tocolor(255, 255, 255, 200),
    marginHorizontal = 5,
    marginVertical = 5,
    tipMargin = 10,
    pointSize = 5,
    font = 'default',
    verticalPosition = 'bottom',
    horizontalPosition = 'left',
    tipBackgroundColor = tocolor(35, 35, 35, 200),
    tipBackgroundPadding = {5, 3},
    tipBackgroundBorderRadius = 3,
}

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function quadraticBezierCurve(aX, aY, bX, bY, segments)
    local points = {}

    for t = 0, 1, 1/segments do
        local x = (1 - t) * aX + t * bX
        local y = (1 - t) * aY + t * bY
        table.insert(points, {x=x, y=y})
    end

    return points
end

function quadraticCurve(ax, ay, bx, by, cx, cy, segments)
    local positions = {}
    for i = 0, segments do
        local t = i / segments
        local x = (1 - t) * (1 - t) * ax + 2 * (1 - t) * t * cx + t * t * bx
        local y = (1 - t) * (1 - t) * ay + 2 * (1 - t) * t * cy + t * t * by
        table.insert(positions, {x = x, y = y})
    end
    return positions
end

function easyQuadraticCurve(x, y, tx, ty, segments)
    return quadraticCurve(x, y, tx, ty, x + (tx - y)/2, y, segments)
end

function easyDoubleQuadraticCurve(x, y, tx, ty, segments, t)
    local t = t or 0
    local points1 = quadraticCurve(x, y, l(x, tx, 0.5), l(y, ty, 0.5), l(x, tx, 0.25), l(y, ty, t/4), segments)
    local points2 = quadraticCurve(l(x, tx, 0.5), l(y, ty, 0.5), tx, ty, l(x, tx, 0.75), l(y, ty, 1 - t/4), segments)
    -- local points2 = {}
    return table.join(points1, points2)
end

-- function roundChartIndexes(input, numIntervals, min, max)
--     local output = {}
--     local pre = false
--     local change = 1/#input
--     for k,v in pairs(input) do
--         local prg = (k-2)/(#input-1)
--         if pre then
--             local points = quadraticBezierCurve(0, pre, 1, v, numIntervals)
--             for k,v in pairs(points) do
--                 local y = 1-(v.y-min)/(max-min)
--                 if k ~= #points then table.insert(output, {x=prg+v.x*change, y=y}) end
--             end
--             -- table.insert(output, points[#points].y)
--         end

--         pre = v
--     end
--     table.insert(output, {x=1, y=1-(input[#input]-min)/(max-min)})
--     return output
-- end

function roundChartIndexes(input, numIntervals, min, max)
    local output = {}
    local pre = false
    local change = 1/(#input-1)

    local function add(x, y)
        table.insert(output, {
            x = x,
            y = y
        })
    end

    for k,v in pairs(input) do
        -- local prg = (k-1)/(#input-1)
        local prg = (k-2)/(#input-1)
        if pre then
            if numIntervals > 1 then
                local points = easyDoubleQuadraticCurve(0, pre, 1, v, numIntervals, 0)
                -- add(prg, 1-(v-min)/(max-min))
                for k,v in pairs(points) do
                    local y = 1-(v.y-min)/(max-min)
                    if k ~= #points then add(prg+v.x*change, y) end
                end
            else
                local y = 1-(pre-min)/(max-min)
                add(prg, y)
            end
        end

        pre = v
    end
    add(1, 1-(input[#input]-min)/(max-min))
    return output
end

function fromColor(color)
	if color then
		local blue = bitExtract(color, 0, 8)
		local green = bitExtract(color, 8, 8)
		local red = bitExtract(color, 16, 8)
		local alpha = bitExtract(color, 24, 8)
		
		return { red, green, blue, alpha }
	end
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function table.join(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

function l(a, b, t)
    return a + (b-a)*t
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end