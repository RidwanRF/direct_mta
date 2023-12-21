sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 14/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Bold", 14/zoom, false)
    font3 = exports['figma']:getFont('Inter-Medium', 14/zoom)
    font4 = exports['figma']:getFont('Inter-Medium', 12/zoom)
    font5 = exports['figma']:getFont('Inter-Medium', 11/zoom)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)