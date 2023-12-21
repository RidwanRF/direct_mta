local sx, sy = guiGetScreenSize()
local zoom = 1 
if sx < 2048 then
	zoom = math.min(2.2, 2048/sx)
end 
local fonts = {}

function getFont(name, size, bold)
    local index = name .. size .. tostring(bold)

    if fonts[index] then
        return fonts[index]
    end

    fonts[index] = dxCreateFont("data/" .. name .. ".ttf", size, bold)

    return fonts[index]
end

function getZoom()
    return zoom
end

function setZoom(z)
    zoom = z
    for k,v in pairs(fonts) do
        destroyElement(v)
        fonts[k] = nil
    end
    triggerEvent("onGUISizeChanged", root, tonumber(z))
end

addEvent("onGUISizeChanged", true)

addCommandHandler("guisize", function(_, size)
    if not size or not tonumber(size) then
        outputChatBox("Aktualna wielkość interfejsu: " .. zoom, 190, 255, 130)
    else
        exports["noobisty-notyfikacje"]:createNotification("Wielkość interfejsu", "Zmieniono wielkość interfejsu z " .. zoom .. " na " .. size, {255, 140, 0}, "sight")
        for k,v in pairs(fonts) do
            destroyElement(v)
            fonts[k] = nil
        end
        triggerEvent("onGUISizeChanged", root, tonumber(size))
        zoom = tonumber(size)
    end
end)