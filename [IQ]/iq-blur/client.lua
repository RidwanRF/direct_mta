local sx, sy = guiGetScreenSize()
local blurH = dxCreateShader('data/fxBlurH.fx')
local blurV = dxCreateShader('data/fxBlurV.fx')
local blurH2 = dxCreateShader('data/fxBlurH.fx')
local rt = dxCreateRenderTarget(sx, sy)
local rt2 = dxCreateRenderTarget(sx, sy)
local screen = dxCreateScreenSource(sx, sy)
local defaultMask = dxCreateTexture('mask.png')
dxSetShaderValue(blurV, "sTex0", screen)
dxSetShaderValue(blurH2, "sTex0", screen)
dxSetShaderValue(blurH, "sTex0", rt)
dxSetShaderValue(blurH2, "sTex0", rt2)
dxSetShaderValue(blurV, "TexSize", sx, sy)
dxSetShaderValue(blurH2, "TexSize", sx, sy)
dxSetShaderValue(blurH, "TexSize", sx, sy)
dxSetShaderValue(blurH, "gBlurFac", 2)
dxSetShaderValue(blurV, "gBlurFac", 2)
dxSetShaderValue(blurH2, "gBlurFac", 2)
dxSetShaderValue(blurH, "sMaskTexture", defaultMask)

addEventHandler("onClientPedsProcessed", root, function()
	dxUpdateScreenSource(screen)
	dxSetRenderTarget(rt, false)
	dxDrawImage(0, 0, sx, sy, blurV)
	dxSetRenderTarget()

	dxSetRenderTarget(rt2, false)
	dxDrawImage(0, 0, sx, sy, blurH)
	dxSetRenderTarget()
end)

function dxDrawBlur(x, y, w, h, mask, alpha, useMaskColors)
    dxSetShaderValue(blurH2, "sMaskTexture", mask or defaultMask)
    dxSetShaderValue(blurH2, "useMaskColors", not useMaskColors)
    dxSetShaderValue(blurH2, "position", x/sx, y/sy, w/sx, h/sy)
    dxDrawImage(x, y, w, h, blurH2, 0, 0, 0, tocolor(255, 255, 255, alpha or 255))
end

-- addEventHandler('onClientRender', root, function()
--     dxDrawBlur(350, 350, 350, 350, mask)
-- end)