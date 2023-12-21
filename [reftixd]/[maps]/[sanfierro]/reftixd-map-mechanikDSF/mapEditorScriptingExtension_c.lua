-- FILE: 	mapEditorScriptingExtension_c.lua
-- PURPOSE:	Prevent the map editor feature set being limited by what MTA can load from a map file by adding a script file to maps
-- VERSION:	RemoveWorldObjects (v1) AutoLOD (v1) BreakableObjects (v1)

function requestLODsClient()
	triggerServerEvent("requestLODsClient", resourceRoot)
end
addEventHandler("onClientResourceStart", resourceRoot, requestLODsClient)

function setLODsClient(lodTbl)
	for model in pairs(lodTbl) do
		engineSetModelLODDistance(model, 300)
	end
end
addEvent("setLODsClient", true)
addEventHandler("setLODsClient", resourceRoot, setLODsClient)

function applyBreakableState()
	for k, obj in pairs(getElementsByType("object", resourceRoot)) do
		local breakable = getElementData(obj, "breakable")
		if breakable then
			setObjectBreakable(obj, breakable == "true")
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, applyBreakableState)

engineSetModelLODDistance(11387, 3000)
engineSetModelLODDistance(11340, 3000)
removeWorldModel(11340, 50, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11339, 50, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11387, 150, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11279, 150, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11328, 250, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11326, 250, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11327, 250, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11360, 250, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11416, 250, -2079.9499511719, 159.19999694824, 47.293727874756)
removeWorldModel(11359, 250, -2079.9499511719, 159.19999694824, 47.293727874756)
