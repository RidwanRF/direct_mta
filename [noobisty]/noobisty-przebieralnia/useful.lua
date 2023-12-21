sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 14/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 11/zoom, false)
    font3 = exports["borsuk-gui"]:getFont("Lato-Bold", 14/zoom, false)
    font4 = exports["borsuk-gui"]:getFont("Lato-Bold", 12/zoom, false)
    font5 = exports["borsuk-gui"]:getFont("Lato-Regular", 10/zoom, false)
    font6 = exports["borsuk-gui"]:getFont("Lato-Bold", 10/zoom, false)
    font7 = exports["borsuk-gui"]:getFont("Lato-Regular", 9/zoom, false)
    font8 = exports["borsuk-gui"]:getFont("Lato-Bold", 9/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)