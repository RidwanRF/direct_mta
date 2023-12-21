local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

setCursorAlpha(0)

local icon = "cursor"

addEventHandler('onClientRender',root,function ()
    if not isCursorShowing() then return end

    icon = "cursor"

    local buttons = getItemsByType('button')
    for i,v in pairs(buttons) do
        if v.active and isMouseInPosition(v.x, v.y, v.w, v.h) then
            icon = "pointer"
        end
    end

    local checkboxes = getItemsByType('checkbox')
    for i,v in pairs(checkboxes) do
        if v.active and isMouseInPosition(v.x, v.y, v.w, v.h) then
            icon = "pointer"
        end
    end
    

    local cx, cy = getCursorPosition()
    local cx, cy = cx*sx, cy*sy

    dxDrawImage(cx-7/zoom - (icon == 'text' and 10/zoom or 0), cy-6/zoom, 24/zoom, 24/zoom, "cursor/"..icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
end)



function getItemsByType(type)
    local tbl = {}
    for i,v in pairs(elements) do
        if (v.type == type) then
            table.insert(tbl,v)
        end
    end
    return tbl
end