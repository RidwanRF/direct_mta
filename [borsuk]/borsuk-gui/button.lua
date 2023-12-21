function createButton(text, x, y, w, h, font, z_index, color, icon)
    buttonClearRipples()
    local id = findFreeValue(gui.buttons)
    if not id then
        triggerServerEvent("kickMe", localPlayer, "GUI Error")
    end

    gui.buttons[id] = {
        text = text,
        x = x,
        y = y,
        w = w,
        h = h,
        font = font,
        hover = 0,
        clickable = true,
        visible = true,
        z_index = (z_index or 0),
        color = (color or {0, 195, 255}),
        icon = (icon or false),
        clicked = false,
    }

    return id
end

local zoom = exports["borsuk-gui"]:getZoom()
local font = exports["borsuk-gui"]:getFont("Roboto", 12/zoom, false)
local sx, sy = guiGetScreenSize()

function destroyButton(id)
    if not gui.buttons[id] then return end
    gui.buttons[id] = nil
    buttonClearRipples()
end

function setButtonClickable(id, boolean)
    gui.buttons[id].clickable = boolean
end

function setButtonVisible(id, boolean)
    gui.buttons[id].visible = boolean
    buttonClearRipples()
end

function setButtonPosition(id, x, y)
    gui.buttons[id].x = x
    gui.buttons[id].y = y
    buttonClearRipples()
end

addEvent("onButtonClick", true)

addEventHandler("onClientClick", root, function(btn, state)
    for k,v in pairs(gui.buttons) do
        if isMouseInPosition(v.x, v.y, v.w, v.h) and v.clickable and v.visible then
            triggerEvent("onButtonClick", root, k, btn, state)

                if btn == 'left' and state == 'down' then
                    buttonRippleAdd(v.x, v.y, v.w, v.h, 750)
                    playSound('data/click.mp3')
                    v.clicked = true
                elseif btn == 'left' and state == 'up' then
                    v.clicked = false
                end
            break
        end
    end
end)

local isHovered = false

addEventHandler("onClientRender", root, function()
    for k,v in pairs(gui.buttons) do
        if v.visible then
            local r, g, b = interpolateBetween(math.max(v.color[1]-25, 0), math.max(v.color[2]-25, 0), math.max(v.color[3]-25, 0), math.max(v.color[1], 0), math.max(v.color[2], 0), math.max(v.color[3], 0), v.hover/255, "Linear")
            dxDrawImage(v.x-50/zoom, v.y-50/zoom, v.w+100/zoom, v.h+100/zoom, "data/button_hover.png", 0, 0, 0, tocolor(r, g, b, v.hover))
            dxDrawImage(v.x, v.y, v.w, v.h, "data/button.png", 0, 0, 0, tocolor(r, g, b, 255))
            dxDrawImage(v.x, v.y, v.w, v.h, "data/button.png", 0, 0, 0, tocolor(r, g, b, 255))
            dxDrawImage(v.x+2/zoom, v.y+2/zoom, v.w-4/zoom, v.h-4/zoom, "data/button.png", 0, 0, 0, tocolor(0, 0, 0, 85))

            if v.icon ~= false then
                local r, g, b = interpolateBetween(200, 200, 200, 255, 255, 255, v.hover/255, "Linear")
                local textWidth = dxGetTextWidth(v.text, 1, font)
                local center = ((v.x + v.w / 2) - textWidth / 2) + 7/zoom
                dxDrawRectangle(center, v.y + v.h/3, 1, v.h/3, tocolor(r, g, b))
                dxDrawImage(center - v.h/3 - 8/zoom, v.y + v.h/3, v.h/3, v.h/3, v.icon, 0, 0, 0, tocolor(r, g, b, 255))
                dxDrawText(v.text, center + 8/zoom, v.y + 1, v.x + v.w, v.y + v.h, tocolor(r, g, b, 225), 1, font, "left", "center")
            else
                local r, g, b = interpolateBetween(200, 200, 200, 255, 255, 255, v.hover/255, "Linear")
                dxDrawText(v.text, v.x, v.y, v.x + v.w, v.y + v.h, tocolor(r, g, b, 225), 1, font, "center", "center")
            end

            if isMouseInPosition(v.x, v.y, v.w, v.h) and v.clickable then
                v.hover = math.min(v.hover + 100/gui.dt, 200)
            else
                v.hover = math.max(v.hover - 100/gui.dt, 55)
            end
        end
    end
end, false, "low-99")

--[[
local font1 = exports["borsuk-gui"]:getFont("Roboto", 12/zoom, false)
local theico = dxCreateTexture("data/bar_1.png")

local btn = createButton("Dodaj znajomego", sx/2-125/zoom, sy/2+ 32.5/zoom, 250/zoom, 50/zoom, font1, 0, {55, 155, 55}, theico)
--]]