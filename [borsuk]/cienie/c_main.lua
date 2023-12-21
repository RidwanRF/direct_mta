local viewRadius = 150
local viewDirection = Vector3(0.47753345966339, -0.3432052731514, -0.80880898237228)
local visibility = 0

shaderTable = {inFx = nil, inFxDet = nil, outFx = nil, watMask = nil, world = nil}
local scx, scy = guiGetScreenSize()
local prev = {}

textureRemoveList = {
						"",	                                                       -- unnamed
						"basketball2","skybox_tex*","flashlight_*",                -- other
						"font*","radar*","sitem16","snipercrosshair",              -- hud
						"siterocket","cameracrosshair",                            -- hud
						"*shad*",                                                  -- shadows
						"coronastar","coronamoon","coronaringa",
						"coronaheadlightline",                                     -- coronas
						"lunar",                                                   -- moon
						"tx*",                                                     -- grass effect
						"lod*",                                                    -- lod 
						"cj_w_grad",                                               -- checkpoint
						"*cloud*",                                                 -- clouds
						"*smoke*",                                                 -- smoke
						"sphere_cj",                                               -- nitro
						"water*","newaterfal1_256",
						"boatwake*","splash_up","carsplash_*",
						"fist","*icon","headlight*",
						"unnamed","sphere","plaintarmac*"
					}

textureZEnableFal = {
						"plaintarmac*"
					}		
			
textureApplyList = {
						"ws_tunnelwall2smoked", "shadover_law",
						"greenshade_64", "greenshade2_64", "venshade*", 
						"blueshade2_64","blueshade4_64","greenshade4_64",
						"metpat64shadow","bloodpool_*", "water*"
					}
		
function enableShader()
	if (tonumber(dxGetStatus().VideoCardNumRenderTargets)  > 1 and tonumber(dxGetStatus().VideoCardPSVersion) > 2 
			and tostring(dxGetStatus().DepthBufferFormat) ~= "unknown") then	
		extraBuffer.RTDepth = DxRenderTarget(scx, scy, false)
		extraBuffer.RTDepthDet = DxRenderTarget(scx, scy, false)
		extraBuffer.RTNormal = DxRenderTarget(scx, scy, false)
		
		shaderTable.world = DxShader("fx/sm_world.fx", 0, 50, false, "ped,vehicle")
		shaderTable.inFxDet = DxShader("fx/sm_in.fx", 0, 70, true, "world,ped,vehicle,object")
		shaderTable.inFx = DxShader("fx/sm_in.fx", 0, 20, true, "world,ped,vehicle,object")
		shaderTable.watMask = DxShader("fx/sm_wat.fx", 0, 20, true, "world")
		
		shaderTable.outFx = CMat2Dshadowmap: create(extraBuffer.RTDepth, extraBuffer.RTDepthDet, Vector4(255,255,255,150))
	else
		return
	end
	
	bAllValid = shaderTable.outFx and shaderTable.inFx and shaderTable.inFxDet and extraBuffer.RTDepth and
				extraBuffer.RTDepthDet and shaderTable.watMask and shaderTable.world

	if not bAllValid then
		prev = {false, false}
	else
		shaderTable.inFx:setValue("sClip", 0.3, 600)
		shaderTable.inFxDet:setValue("sClip", 0.3, 600)
		
		shaderTable.inFx:setValue("depthRT", extraBuffer.RTDepth)
		shaderTable.inFxDet:setValue("depthRT", extraBuffer.RTDepthDet)
		shaderTable.world:setValue("sRTNormal", extraBuffer.RTNormal)

		shaderTable.watMask:applyToWorldTexture("water*")

		applyShaderToList(shaderTable.inFx)
		applyShaderToList(shaderTable.inFxDet)
		applyShaderToList(shaderTable.world)
		
		startShineTimer()
		prev = {true, true}
		bAllValid = false
	end
end

function disableShader()
	prev = {wsEffectEnabled, bAllValid}
	wsEffectEnabled = false
	bAllValid = false
end

function switchShader()
	if prev and not wsEffectEnabled then
		wsEffectEnabled = prev[1]
		bAllValid = prev[2]
	elseif wsEffectEnabled and bAllValid then
		disableShader()
	end
end


function isShadowsOn()
	return (wsEffectEnabled and bAllValid)
end

addEventHandler("onClientResourceStart", resourceRoot, enableShader)

function applyShaderToList(myShader)
	myShader:applyToWorldTexture("*")
	for _,removeMatch in ipairs(textureRemoveList) do
		myShader:removeFromWorldTexture(removeMatch)	
	end	
	for _,applyMatch in ipairs(textureApplyList) do
		myShader:applyToWorldTexture(applyMatch)	
	end
end

addEventHandler("onClientPreRender", root, function()
		if not bAllValid then return end
        shaderTable.outFx: draw()
end
, true, "high")

addEventHandler("onClientRender", root, function()
		if not bAllValid then return end
end
, true, "low")

addEventHandler("onClientPreRender", root,
    function()
	if not shaderTable.inFx then return end
		extraBuffer.RTDepthDet:setAsTarget(false)
		dxDrawRectangle(0, 0, scx, scy)
		extraBuffer.RTDepth:setAsTarget(false)
		dxDrawRectangle(0, 0, scx, scy)
		extraBuffer.RTNormal:setAsTarget(false)
		dxDrawRectangle(0, 0, scx, scy, tocolor(0,0,0,255))
		dxSetRenderTarget()	
    end
, true, "high+1")

addEventHandler("onClientPreRender", root, function()
	if not bAllValid then return end

	local fwVec = viewDirection:getNormalized()
	local camMat = getCamera().matrix
	local centerPos = camMat.position
	local camFw = camMat:getForward()
	local cameraPos = centerPos - fwVec * viewRadius

	local bottomPos = Vector3(centerPos.x, centerPos.y, centerPos.z - viewRadius)
	local rtVec = ((centerPos - cameraPos):cross(bottomPos - cameraPos)):getNormalized()
	local upVec =  -(rtVec:cross(fwVec)):getNormalized()

	if not isLineOfSightClear(centerPos.x, centerPos.y, centerPos.z, centerPos.x, centerPos.y, -100, true, false, false) then
		isHit, hitPosX, hitPosY, hitPosZ = processLineOfSight(centerPos.x, centerPos.y, centerPos.z, centerPos.x, centerPos.y, -100, true, false, false)
	end
	if not hitPosZ then hitPosZ = centerPos.z end
	local hitLen = math.max(math.min(math.abs(hitPosZ - centerPos.z) * 0.5, 15), 1)

	cameraPos = Vector3(hitPosX, hitPosY, hitPosZ) - fwVec * viewRadius 
	
	shaderTable.inFx:setValue("sCameraPosition", cameraPos.x, cameraPos.y, cameraPos.z)
	shaderTable.inFx:setValue("sCameraForward", fwVec.x, fwVec.y, fwVec.z) 
	shaderTable.inFx:setValue("sCameraUp", upVec.x, upVec.y, upVec.z)
	shaderTable.inFx:setValue("sScrRes", hitLen * 200, hitLen * 200)
	
	shaderTable.inFxDet:setValue("sCameraPosition", cameraPos.x, cameraPos.y, cameraPos.z)
	shaderTable.inFxDet:setValue("sCameraForward", fwVec.x, fwVec.y, fwVec.z) 
	shaderTable.inFxDet:setValue("sCameraUp", upVec.x, upVec.y, upVec.z)
	shaderTable.inFxDet:setValue("sScrRes", hitLen * 25, hitLen * 25)	
	
	shaderTable.outFx: setInMatrix(cameraPos, fwVec, upVec, hitLen, 200, 25)
end
, true, "high+2")

shineDirectionList = {
			{  0,  0,	-0.019183,	0.994869,	-0.099336,	4,			0.0,		1 },			-- Moon fade in start
			{  0, 30,	-0.019183,	0.994869,	-0.099336,	4,			0.25,		1 },			-- Moon fade in end
			{  3, 00,	-0.019183,	0.994869,	-0.099336,	4,			0.5,		1 },			-- Moon bright
			{  6, 30,	-0.019183,	0.994869,	-0.099336,	4,			0.5,		1 },			-- Moon fade out start
			{  6, 39,	-0.019183,	0.994869,	-0.099336,	4,			0.0,		0 },			-- Moon fade out end

			{  6, 40,	-0.914400,	0.377530,	-0.146093,	16,			0.0,		0 },			-- Sun fade in start
			{  6, 50,	-0.914400,	0.377530,	-0.146093,	16,			1.0,		0 },			-- Sun fade in end
			{  7,  0,	-0.891344,	0.377265,	-0.251386,	16,			1.0,		0 },			-- Sun
			{ 10,  0,	-0.678627,	0.405156,	-0.612628,	16,			0.5,		0 },			-- Sun
			{ 13,  0,	-0.303948,	0.490790,	-0.816542,	16,			0.5,		0 },			-- Sun
			{ 16,  0,	 0.169642,	0.707262,	-0.686296,	16,			0.5,		0 },			-- Sun
			{ 18,  0,	 0.380167,	0.893543,	-0.238859,	16,			0.5,		0 },			-- Sun
			{ 18, 30,	 0.398043,	0.911378,	-0.238859,	4,			1.0,		0 },			-- Sun
			{ 18, 53,	 0.360288,	0.932817,	-0.238859,	1,			1.5,		0 },			-- Sun fade out start
			{ 19, 00,	 0.360288,	0.932817,	-0.238859,	1,			0.0,		0 },			-- Sun fade out end

			{ 19, 01,	 0.360288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade in start
			{ 19, 30,	 0.360288,	0.932817,	-0.612628,	4,			0.5,		0 },			-- General fade in end
			{ 21, 00,	 0.360288,	0.932817,	-0.612628,	4,			0.5,		0 },			-- General fade out start
			{ 22, 09,	 0.360288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade out end

			{ 22, 10,	-0.744331,	0.663288,	-0.077591,	32,			0.0,		1 },			-- Star fade in start
			{ 22, 30,	-0.744331,	0.663288,	-0.077591,	32,			0.5,		1 },			-- Star fade in end
			{ 23, 50,	-0.744331,	0.663288,	-0.077591,	32,			0.5,		1 },			-- Star fade out start
			{ 23, 59,	-0.744331,	0.663288,	-0.077591,	32,			0.0,		1 },			-- Star fade out end
			}

function updateShineDirection ()
	if not wsEffectEnabled or isDynamicSkyEnabled then return end
	local h, m, s = getTimeHMS ()
	local fhoursNow = h + m / 60 + s / 3600

	for idx,v in ipairs( shineDirectionList ) do
		local fhoursTo = v[1] + v[2] / 60
		if fhoursNow <= fhoursTo then
			local vFrom = shineDirectionList[ math.max( idx-1, 1 ) ]
			local fhoursFrom = vFrom[1] + vFrom[2] / 60

			local f = math.unlerp( fhoursFrom, fhoursNow, fhoursTo )
			local x = math.lerp( vFrom[3], f, v[3] )
			local y = math.lerp( vFrom[4], f, v[4] )
			local z = math.lerp( vFrom[5], f, v[5] )
			local sharpness  = math.lerp( vFrom[6], f, v[6] )
			local brightness = math.lerp( vFrom[7], f, v[7] )
			local nightness = math.lerp( vFrom[8], f, v[8] )
			sharpness, brightness = applyWeatherInfluence ( sharpness, brightness, nightness )

			lightDirection = Vector3( x, y, z )
			viewDirection = Vector3(x, y, z):getNormalized()
			visibility = math.clamp(0,brightness * 1.5, 1)

			break
		end
	end
end

function startShineTimer()
	shineTimer = setTimer( updateShineDirection, 100, 0 )
end

function killShineTimer()
	killTimer( shineTimer )
end
weatherInfluenceList = {
			-- id   sun:size   :translucency  :bright      night:bright 
			{  0,       1,			0,			1,			1 },		-- Hot, Sunny, Clear
			{  1,       0.8,		0,			1,			1 },		-- Sunny, Low Clouds
			{  2,       0.8,		0,			1,			1 },		-- Sunny, Clear
			{  3,       0.8,		0,			0.8,		1 },		-- Sunny, Cloudy
			{  4,       1,			0,			0.2,		0 },		-- Dark Clouds
			{  5,      1.5,			0,			0.5,		1 },		-- Sunny, More Low Clouds
			{  6,      1.5,			1,			0.5,		1 },		-- Sunny, Even More Low Clouds
			{  7,       1,			0,			0.01,		0 },		-- Cloudy Skies
			{  8,       1,			0,			0,			0 },		-- Thunderstorm
			{  9,       1,			0,			0,			0 },		-- Foggy
			{  10,      1,			0,			1,			1 },		-- Sunny, Cloudy (2)
			{  11,     1.5,			0,			1,			1 },		-- Hot, Sunny, Clear (2)
			{  12,     1.5,			1,			0.5,		0 },		-- White, Cloudy
			{  13,      1,			0,			0.8,		1 },		-- Sunny, Clear (2)
			{  14,      1,			0,			0.7,		1 },		-- Sunny, Low Clouds (2)
			{  15,      1,			0,			0.1,		0 },		-- Dark Clouds (2)
			{  16,      1,			0,			0,			0 },		-- Thunderstorm (2)
			{  17,     1.5,			1,			0.8,		1 }, 		-- Hot, Cloudy
			{  18,     1.5,			1,			0.8,		1 },		-- Hot, Cloudy (2)
			{  19,      1,			0,			0,			0 },		-- Sandstorm
		}

function applyWeatherInfluence ( sharpness, brightness, nightness )
	local id = getWeather()
	id = math.min ( id, #weatherInfluenceList - 1 )
	local item = weatherInfluenceList[ id + 1 ]
	local sunSize  = item[2]
	local sunTranslucency = item[3]
	local sunBright = item[4]
	local nightBright = item[5]

	if bHasCloudsBug and not getCloudsEnabled() then
		nightBright = 0
	end

	local useSize		  = math.lerp( sunSize, nightness, 1 )
	local useTranslucency = math.lerp( sunTranslucency, nightness, 0 )
	local useBright		  = math.lerp( sunBright, nightness, nightBright )

	brightness = brightness * useBright
	sharpness = sharpness / useSize

	return sharpness, brightness
end

local timeHMS = {0,0,0}
local minuteStartTickCount
local minuteEndTickCount

function getTimeHMS()
	return unpack(timeHMS)
end

addEventHandler( "onClientRender", root,
	function ()
		if not wsEffectEnabled then return end
		local h, m = getTime ()
		local s = 0
		if m ~= timeHMS[2] then
			minuteStartTickCount = getTickCount ()
			local gameSpeed = math.clamp( 0.01, getGameSpeed(), 10 )
			minuteEndTickCount = minuteStartTickCount + 1000 / gameSpeed
		end
		if minuteStartTickCount then
			local minFraction = math.unlerpclamped( minuteStartTickCount, getTickCount(), minuteEndTickCount )
			s = math.min ( 59, math.floor ( minFraction * 60 ) )
		end
		timeHMS = {h, m, s}
	end
)

function math.lerp(from,alpha,to)
    return from + (to-from) * alpha
end

function math.unlerp(from,pos,to)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end


function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.unlerpclamped(from,pos,to)
	return math.clamp(0,math.unlerp(from,pos,to),1)
end
