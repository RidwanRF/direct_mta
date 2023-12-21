local renders = {}
local sx, sy = guiGetScreenSize()
local a = loadstring(exports['iq-gui']:importAnimate())()

addEvent("onTargetClick", true)

addEventHandler("onClientRender", root, function()
    for k,v in pairs(renders) do
        if v then
            v.cscroll = math.max(math.min(v.cscroll + (v.scroll - v.cscroll) * 0.1, v.max_scroll), 0)
            dxDrawImageSection(v.x, v.y, v.w, v.h, 0, v.cscroll, v.rw, v.rh, v.rt, 0, 0, 0, tocolor(255,255,255,a[v.id .. '-alpha']))

            local scrollSize = v.h/(v.h+v.max_scroll)
            local scrollPos = (v.cscroll/v.max_scroll)
            scrollPos = (v.h-(v.scrollData.h*scrollSize))*scrollPos
            if v.scrollData.visible then
                local isIn = isMouseInPosition(v.scrollData.x, v.scrollData.y + scrollPos, v.scrollData.w, v.scrollData.h*scrollSize)
                dxDrawRectangle(v.scrollData.x, v.scrollData.y, v.scrollData.w, v.scrollData.h, tocolor(v.scrollData.color[1], v.scrollData.color[2], v.scrollData.color[3], 250*(a[v.id .. '-alpha']/255)))
                dxDrawRectangle(v.scrollData.x, v.scrollData.y + scrollPos, v.scrollData.w, v.scrollData.h*scrollSize, tocolor(v.scrollData.thumb[1],v.scrollData.thumb[2],v.scrollData.thumb[3], (v.scrollData.hold and (175*(a[v.id .. '-alpha']/255)) or (isIn and 200 or 255)*(a[v.id .. '-alpha']/255))))
            end

            if getKeyState("mouse1") and isCursorShowing() then
                local cx, cy = getCursorPosition()
                cx, cy = cx*sx, cy*sy
                if not v.scrollData.hold and isMouseInPosition(v.scrollData.x, v.scrollData.y + scrollPos, v.scrollData.w, v.scrollData.h*scrollSize) then
                    local cy = cy - v.scrollData.y - (v.cscroll/(v.h+v.max_scroll))*v.h
                    v.scrollData.hold = cy/v.scrollData.h
                    v.scrollData.holdType = 1
                elseif v.scrollData.holdType == 1 then
                    local c = 1-((v.scrollData.h*scrollSize)/v.h)
                    local cy = (cy - v.scrollData.y)/v.scrollData.h - v.scrollData.hold
                    v.cscroll = cy*v.max_scroll/c, v.max_scroll
                elseif not v.scrollData.hold and isMouseInPosition(v.x, v.y, v.w, v.h) and not v.noDrag then
                    local cy = cy - v.y
                    v.scrollData.hold = {start=v.cscroll, catch=cy}
                    v.scrollData.holdType = 2
                elseif v.scrollData.holdType == 2 then
                    local cy = cy - v.y
                    local c = cy - v.scrollData.hold.catch
                    v.cscroll = v.scrollData.hold.start - c
                end
            elseif v.scrollData.hold then
                v.scrollData.hold = false
                v.scroll = v.cscroll
                v.scrollData.holdType = false
            end
        end
    end
end, true, 'low-1000')

addEventHandler("onClientClick", root, function(btn, state, x, y)
    for k,v in pairs(renders) do
        if v then
            if isMouseInPosition(v.x, v.y, v.w, v.h) then
                local x, y = x - v.x, y - v.y + v.cscroll
                triggerEvent("onTargetClick", root, k, btn, state, x, y)
            end
        end
    end
end)

function findFreeID()
    local id = 1
    while (renders[id]) do
        id = id + 1
    end
    return id
end

function getScrollPosition(id)
    return renders[id] and math.max(math.min(renders[id].cscroll, renders[id].max_scroll), 0) or 0
end

function setScrollPosition(id, pos)
    if renders[id] then
        renders[id].cscroll = pos
    end
end

function setMaxScrollLimit(id, limit)
    if renders[id] then
        renders[id].max_scroll = limit
    end
end

function interpolateTarget(id, from, to, time, easing)
    local key = id .. '-alpha'
    a[key] = {from or a[key] or 0, to, time, easing}
end

function createTarget(data)
    local id = findFreeID()

    local x, y, w, h = data.x or 0, data.y or 0, data.w or 1, data.h or 1
    local rw, rh = data.rtw or w, data.rth or h
    a[id .. '-alpha'] = {255, 255, 1}

    local info = {
        x = x,
        y = y,
        w = w,
        h = h,
        rw = rw,
        rh = rh,
        cscroll = data.cscroll or 0,
        scroll = 0,
        noDrag = data.noDrag or false,
        max_scroll = data.max_scroll or 1,
        rt = dxCreateRenderTarget(rw, rh + (data.max_scroll or 1), data.alpha),
        scrollSpeed = data.scrollSpeed or 15,
        id = id,

        scrollData = {
            x = (data.scrollData and data.scrollData.x) or (x + w + 5),
            y = (data.scrollData and data.scrollData.y) or y,
            w = (data.scrollData and data.scrollData.w) or 5,
            h = (data.scrollData and data.scrollData.h) or h,
            visible = (data.scrollData and data.scrollData.visible),
            color = (data.scrollData and data.scrollData.color) or {175, 175, 175},
            thumb = (data.scrollData and data.scrollData.thumb) or {175, 175, 175},
        }
    }

    renders[id] = info

    return id, info
end

function destroyTarget(id)
    if not renders[id] then return end
    destroyElement(renders[id].rt)
    renders[id] = nil
    collectgarbage()
end

addEventHandler("onClientKey", root, function(btn, state)
    if not state then return end
    if btn == "mouse_wheel_down" then
        for k,v in pairs(renders) do
            if isMouseInPosition(v.x, v.y, v.w, v.h) then
                v.scroll = math.min(v.scroll + v.scrollSpeed, v.max_scroll)
            end
        end
    elseif btn == "mouse_wheel_up" then
        for k,v in pairs(renders) do
            if isMouseInPosition(v.x, v.y, v.w, v.h) then
                v.scroll = math.max(v.scroll - v.scrollSpeed, 0)
            end
        end
    end
end)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end