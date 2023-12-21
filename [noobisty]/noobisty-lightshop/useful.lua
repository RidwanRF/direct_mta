sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Roboto", 12/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 10/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)