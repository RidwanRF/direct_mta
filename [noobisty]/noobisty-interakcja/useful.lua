sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 18/zoom, false)
    font1 = exports["borsuk-gui"]:getFont("Lato-Bold", 25/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)