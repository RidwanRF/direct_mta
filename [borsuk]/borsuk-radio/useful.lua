sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Lato-Bold", 11/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 10/zoom, false)
    font3 = exports["borsuk-gui"]:getFont("Lato-Bold", 15/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)