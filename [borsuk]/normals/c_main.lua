local shader = dxCreateShader("shaders/pedNormal.fx", 0, 0, false, "all")
local texture = dxCreateTexture("normal.png")
engineApplyShaderToWorldTexture(shader, "sandnew_law")
dxSetShaderValue(shader, "sBumpTexture", texture)

local shader = dxCreateShader("shaders/pedNormal.fx", 0, 0, false, "all")
local texture = dxCreateTexture("normal2.png")
--engineApplyShaderToWorldTexture(shader, "*")
dxSetShaderValue(shader, "sBumpTexture", texture)

addEventHandler("onClientRender", root, function()
	local cx, cy, cz, lx, ly, lz = getCameraMatrix()

	dxSetShaderValue(shader, "sLightDir", {lx-cx, ly-cy, lz-cz-0.5})
end)