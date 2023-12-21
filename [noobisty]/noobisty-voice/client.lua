-- variables
local voicePlayers = {}

zoom = 1
sW, sH = guiGetScreenSize()
if sW < 1920 then
    zoom = math.min(2, 1920 / sW)
end

-- draw (voice reosource)
local g_screenX,g_screenY = guiGetScreenSize()
local BONE_ID = 8
local WORLD_OFFSET = 0.8
local ICON_PATH = "images/voice.png"
local ICON_WIDTH = 0.15*g_screenX
local VOICE_MODE = {}
--
local iconHalfWidth = ICON_WIDTH/2

local ICON_DIMENSIONS = 12
local ICON_LINE = 20
local ICON_TEXT_SHADOW = tocolor ( 0, 0, 0, 255 )
range = 15

sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 12/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)

--Draw the voice image
addEventHandler ( "onClientRender", root,
function()
		local sX, sY, sZ = getElementPosition(localPlayer)

		x = 0
		for player in pairs(voicePlayers) do
			x = x + 1
			offsetY = (25/zoom)*(x-1)
			local rX, rY, rZ = getElementPosition(player)
			local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 

			setSoundVolume( player, 30-distance )

			dxDrawText(getPlayerName(player), 1, 1, sx - 4/zoom, sy - 64/zoom - offsetY, tocolor(0, 0, 0), 1, font1, "right", "bottom", false, false, false, true)
			dxDrawText(getPlayerName(player), 0, 0, sx - 5/zoom, sy - 65/zoom - offsetY, tocolor(0, 195, 255), 1, font1, "right", "bottom", false, false, false, true)
		end
	end
)

-- events
addEventHandler("onClientPlayerVoiceStart", getRootElement(), function()
	if not getElementData (source, "player:spawn" ) then
			cancelEvent()
		return
	end

	if getElementData (source, "mute:player" ) then
			cancelEvent()
		return
	end
	
	local localDimension = getElementDimension( localPlayer )
	local localInterior = getElementInterior( localPlayer )
	if source == localPlayer then
		if not getElementData(source, "player:premiumplus") and 2 > tonumber(exports["noobisty-levele"]:getLevel()) then
			exports["noobisty-notyfikacje"]:createNotification("VoiceChat", "Aby rozmawiać na voice-chacie musisz posiadać minimum 2 level bądź Premium+", {200, 50, 50}, "sighter")
			cancelEvent()
		return 
	end
		setElementData(source, "voice:mowi", true)
		voicePlayers[source] = true
		local posX, posY, posZ = getElementPosition(source)
        local nearbyPlayers = getElementsWithinRange(posX, posY, posZ, 30, "player")
	else
		local sourceDimension = getElementDimension( source )
		local sourceInterior = getElementInterior( source )
		if tonumber(localDimension) ~= tonumber(sourceDimension) or tonumber(localInterior) ~= tonumber(sourceInterior) then
				cancelEvent()
			return
		end
		local sX, sY, sZ = getElementPosition(localPlayer) 
		local rX, rY, rZ = getElementPosition(source)
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 
		if distance <= range then
			voicePlayers[source] = true
		else 
			cancelEvent()
		end
	end 
end)

addEventHandler("onClientPlayerVoiceStop",getRootElement(),function()
	if source == localPlayer then
		setElementData(source, "voice:mowi", false)
	end
	voicePlayers[source] = nil
end)

addEventHandler("onClientPlayerQuit",getRootElement(),function()
	voicePlayers[source] = nil
end)