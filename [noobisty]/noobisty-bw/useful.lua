sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Roboto", 20/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)

function secondsToClock(seconds)
	seconds = seconds or 0
	if seconds <= 0 then
		return "0 min. 0 sek."
	else
		hours = string.format("%01.f", math.floor(seconds/3600))
		mins = string.format("%01.f", math.floor(seconds/60 - (hours*60)))
		secs = string.format("%01.f", math.floor(seconds - hours*3600 - mins *60))
		return mins.." min. "..secs.." sek."
	end
end

function calculateTime(minutes)
    return math.floor(minutes*60000)
end