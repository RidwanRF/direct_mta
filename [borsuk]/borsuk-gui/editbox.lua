function createEditbox(text, x, y, w, h, font, icon, passworded, special, z_index)
    local id = findFreeValue(gui.editboxes)
    if not id then
        triggerServerEvent("kickMe", localPlayer, "GUI Error")
    end

    gui.editboxes[id] = {
        text = text,
        x = x,
        y = y,
        w = w,
        h = h,
        font = font,
        icon = icon,
        passworded = (passworded or false),
        special = special,
        hover = 0,
        edit_text = "",
        visible = true,
        active = false,
        z_index = (z_index or 0),
    }

    return id
end

function destroyEditbox(id)
    if not gui.editboxes[id] then return end
    gui.editboxes[id] = nil
end

function setEditboxVisible(id, boolean)
    gui.editboxes[id].visible = boolean
end

function setEditboxPosition(id, x, y)
    gui.editboxes[id].x = x
    gui.editboxes[id].y = y
end

function getEditboxText(id)
    if not gui.editboxes[id] then return end
    return gui.editboxes[id].edit_text
end

function setEditboxText(id, text)
    gui.editboxes[id].edit_text = text
end

bindKey("tab", "down", function()
    local actual = false
    for k,v in pairs(gui.editboxes) do
        if v.active then
            v.active = false
            actual = k
            break
        end
    end

    if actual and gui.editboxes[actual+1] then
        gui.editboxes[actual+1].active = true
    end
end)

addEventHandler("onClientClick", root, function(btn, state)
    if btn ~= "left" or state ~= "down" then return end

    for k,v in pairs(gui.editboxes) do
        v.active = false
        guiSetInputEnabled(false)
    end

    for k,v in pairs(gui.editboxes) do
        if isMouseInPosition(v.x, v.y, v.w, v.h) and v.visible then
            for _,c in pairs(gui.editboxes) do
                c.active = false
                guiSetInputEnabled(false)
            end
            v.active = true
            guiSetInputEnabled(true)
        end
    end
end)

addEventHandler("onClientRender", root, function()
    for k,v in pairs(gui.editboxes) do
        if v.visible then
            if isMouseInPosition(v.x, v.y, v.w, v.h) or v.active then
                dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(25, 25, 25, 225))
            else
                dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(25, 25, 25, 200))
            end

            local text = v.text
            if #v.edit_text > 0 or v.active then
                text = (v.passworded and string.rep("*", #v.edit_text) or v.edit_text)
            end

            if v.active then
                local isLine = ((v.active and getTickCount() % 1000 > 500) and true or false)

                if isLine then
                    local textWidth = dxGetTextWidth(text, 1, v.font)
                    dxDrawRectangle(v.x + textWidth + (v.icon and v.h - 5/zoom or 15/zoom), v.y + v.h/4, 1, v.h/2, tocolor(175, 175, 175, 200))
                end
            end

            if v.icon then
                dxDrawImage(v.x + 8/zoom, v.y + 12/zoom, v.h - 24/zoom, v.h - 24/zoom, v.icon, 0, 0, 0, tocolor(255,255,255,100+(v.hover/255)*50))
            end

            dxDrawText(text, v.x + (v.icon and v.h-5/zoom or 15/zoom) - 2, v.y, v.x + v.w - 20/zoom, v.y + v.h, tocolor(200,200,200,155+(v.hover/255)*100), 1, v.font, "left", "center", true)

            if v.active then
                v.hover = math.min(v.hover + 150/gui.dt, 200)
            else
                v.hover = math.max(v.hover - 120/gui.dt, 0)
            end
        end
    end
end, false, "low-99")

addEventHandler("onClientCharacter", root, function(char)
    for k,v in pairs(gui.editboxes) do
        if v.active and v.visible then
            if v.special == true then
                v.edit_text = v.edit_text .. char
            elseif v.special == 2 then
                if tonumber(char) then
                    v.edit_text = v.edit_text .. char
                end
            else
                if (char:lower():byte() >= 97 and char:lower():byte() <= 122) or (char:byte() >= 45 and char:byte() <= 57) then
                    v.edit_text = v.edit_text .. char
                end
            end
        end
    end
end)

addEventHandler("onClientKey", root, function(key, state)
    if not state then return end
    for k,v in pairs(gui.editboxes) do
        if v.active and v.visible then
            if key == "backspace" then
                v.edit_text = v.edit_text:sub(1, #v.edit_text-1)
            end
        end
    end
end)

--[[
local zoom = exports["borsuk-gui"]:getZoom()
local sx, sy = guiGetScreenSize()
local font1 = exports["borsuk-gui"]:getFont("Roboto", 12/zoom, false)

local btn = createEditbox("Login", sx/2-125/zoom, sy/2-22.5/zoom, 250/zoom, 45/zoom, font1)
--setEditboxClickable(btn, false)--]]