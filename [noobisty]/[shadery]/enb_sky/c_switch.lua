--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchSkyAlt", root, true )
--
--	To switch off:
--			triggerEvent( "switchSkyAlt", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
-- Auto switch on at start
--------------------------------

function toggleShader(state)
	if state == true then startShaderResource() else stopShaderResource() end
end

--------------------------------
-- onClientResourceStop
-- Stop the resource
--------------------------------
addEventHandler( "onClientResourceStop", getResourceRootElement( getThisResource()),stopShaderResource)
