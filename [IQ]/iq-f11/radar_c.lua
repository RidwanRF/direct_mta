-- z neta headera nie ma xd
BLIP_TEXTURES = {}
local blipData = {
  { "arrow", "blips/arrow.png" },
  { "player", "blips/player.png" }, -- ikonka gracza
  { "radar_airYard", "blips/radar_airYard.png" },
  { "radar_ammugun", "blips/radar_ammugun.png" },
  { "radar_barbers", "blips/radar_barbers.png" },
  { "radar_boatyard", "blips/radar_boatyard.png" },
  { "radar_bulldozer", "blips/radar_bulldozer.png" },
  { "radar_burgerShot", "blips/radar_burgerShot.png" },
  { "radar_cash", "blips/radar_cash.png" },
  { "radar_CATALINAPINK", "blips/radar_CATALINAPINK.png"},
  { "radar_centre", "blips/radar_centre.png" },
  { "radar_CESARVIAPANDO", "blips/radar_CESARVIAPANDO.png" },
  { "radar_chicken", "blips/radar_chicken.png" },
  { "radar_CJ", "blips/radar_CJ.png" },
  { "radar_CRASH1", "blips/radar_CRASH1.png" },
  { "radar_dateDisco", "blips/radar_dateDisco.png" },
  { "radar_dateDrink", "blips/radar_dateDrink.png" },
  { "radar_dateFood", "blips/radar_dateFood.png" },
  { "radar_diner", "blips/radar_diner.png" },
  { "radar_emmetGun", "blips/radar_emmetGun.png" },
  { "radar_enemyAttack", "blips/radar_enemyAttack.png" },
  { "radar_fire", "blips/radar_fire.png" },
  { "radar_Flag", "blips/radar_Flag.png" },
  { "radar_gangB", "blips/radar_gangB.png" },
  { "radar_gangG", "blips/radar_gangG.png" },
  { "radar_gangN", "blips/radar_gangN.png" },
  { "radar_gangP", "blips/radar_gangP.png" },
  { "radar_gangY", "blips/radar_gangY.png" },
  { "radar_girlfriend", "blips/radar_girlfriend.png" },
  { "radar_gym", "blips/radar_gym.png" },
  { "radar_hostpital", "blips/radar_hostpital.png" },
  { "radar_impound", "blips/radar_impound.png" },
  { "radar_light", "blips/radar_light.png" },
  { "radar_LocoSyndicate", "blips/radar_LocoSyndicate.png" },
  { "radar_MADDOG", "blips/radar_MADDOG.png" },
  { "radar_mafiaCasino", "blips/radar_mafiaCasino.png" },
  { "radar_MCSTRAP", "blips/radar_MCSTRAP.png" },
  { "radar_modGarage", "blips/radar_modGarage.png" },
  { "radar_north", "blips/radar_north.png" },
  { "radar_OGLOC", "blips/radar_OGLOC.png" },
  { "radar_pizza", "blips/radar_pizza.png" },
  { "radar_police", "blips/radar_police.png" },
  { "radar_propertyG", "blips/radar_propertyG.png" },
  { "radar_propertyR", "blips/radar_propertyR.png" },
  { "radar_qmark", "blips/radar_qmark.png" },
  { "radar_race", "blips/radar_race.png" },
  { "radar_runway", "blips/radar_runway.png" },
  { "radar_RYDER", "blips/radar_RYDER.png" },
  { "radar_saveGame", "blips/radar_saveGame.png" },
  { "radar_school", "blips/radar_school.png" },
  { "radar_spray", "blips/radar_spray.png" },
  { "radar_SWEET", "blips/radar_SWEET.png" },
  { "radar_tattoo", "blips/radar_tattoo.png" },
  { "radar_THETRUTH", "blips/radar_THETRUTH.png" },
  { "radar_TORENO", "blips/radar_TORENO.png" },
  { "radar_TorenoRanch", "blips/radar_TorenoRanch.png" },
  { "radar_triads", "blips/radar_triads.png" },
  { "radar_triadsCasino", "blips/radar_triadsCasino.png" },
  { "radar_truck", "blips/radar_truck.png" },
  { "radar_tshirt", "blips/radar_tshirt.png" },
  { "radar_waypoint", "blips/radar_waypoint.png" },
  { "radar_WOOZIE", "blips/radar_WOOZIE.png" },
  { "radar_ZERO", "blips/radar_ZERO.png" },
  { "radar_Runway_light", "blips/radar_light.png" },
  { "scooter", "blips/scooter.png" },
}

local tiles = { }
local timer
local enabled = true
local ROW_COUNT = 12

function toggleRadar( )
	disabled = not enabled
	handleTileLoading ( )
	timer = setTimer ( handleTileLoading, 250, 0 )
	
	-- podmianka dysku radaru
	for i = 2, #blipData do
		BLIP_TEXTURES[blipData[i][1]] = dxCreateTexture("images/radar/"..blipData[i][2])
     end
	 
end
addEventHandler ( "onClientResourceStart", resourceRoot, toggleRadar)

function handleTileLoading ( )
	local visibleTileNames = table.merge ( engineGetVisibleTextureNames ( "radar??" ), engineGetVisibleTextureNames ( "radar???" ) )
	    for name, data in pairs ( tiles ) do
		    if not table.find ( visibleTileNames, name ) then
			    unloadTile ( name )
		    end
	    end
	for index, name in ipairs ( visibleTileNames ) do
		loadTile ( name )
	end
end

function table.merge ( ... )
	local ret = { }
	    for index, tbl in ipairs ( {...} ) do
		    for index, val in ipairs ( tbl ) do
			    table.insert ( ret, val )
		    end
	    end
	return ret
end

function table.find ( tbl, val )
	for index, value in ipairs ( tbl ) do
		if ( value == val ) then
			return index
		end
	end
	
	return false
end

function loadTile ( name )
	if type ( name ) ~= "string" then
		return false
	end
	
	if ( tiles[name] ) then
		return true
	end
	
	local id = tonumber ( name:match ( "%d+" ) )
	
	if not ( id ) then
		return false
	end
	
	local row = math.floor ( id / ROW_COUNT )
	local col = id - ( row * ROW_COUNT )
	
	local posX = -3000 + 500 * col
	local posY =  3000 - 500 * row
	
	local index = col * row
	local file = "images/radar/"..name..".png"
	local texture = dxCreateTexture ( file )
	if not ( texture ) then
		return false
	end
	
	local shader = dxCreateShader ( "fx/texreplace.fx" )
	if not ( shader ) then
		destroyElement ( texture )
		return false
	end
	
	dxSetShaderValue ( shader, "gTexture", texture )
	engineApplyShaderToWorldTexture ( shader, name )
	tiles[name] = { shader = shader, texture = texture }
	return true
end

function unloadTile ( name )
	local tile = tiles[name]
	    if not ( tile ) then
		    return false
	    end
	if isElement ( tile.shader )  then destroyElement ( tile.shader )  end
	if isElement ( tile.texture ) then destroyElement ( tile.texture ) end
	
	tiles[name] = nil
	return true
end
