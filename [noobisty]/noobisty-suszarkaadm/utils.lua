function isPedAiming(plr)
    if isElement(plr) then
        if getElementType(plr) == "player" or getElementType(plr) == "vehicle" then
            if getPedTask(plr, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
                return true
            end
        end
    end
    return false
end

sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 12/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Bold", 14/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)