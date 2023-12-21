local scx,scy = guiGetScreenSize ()
    
CMat2Dshadowmap = { }
CMat2Dshadowmap.__index = CMat2Dshadowmap
     
function CMat2Dshadowmap: create(sRTDepth, sRTDepthDet, col)
	local scX, scY = guiGetScreenSize()
	local cShader = {
		shader = DxShader( "fx/material2D_shadowMapOut.fx" ),
		resolution = Vector2(scX, scY),
		color = tocolor( col.x, col.y, col.z, col.w )
	}
	
	if extraBuffer.instance == 0 then
		extraBuffer.RTColor = DxRenderTarget( scX, scY, false )
	end
	
	if cShader.shader then
		cShader.shader:setValue( "fViewportSize",  scX, scY )
		cShader.shader:setValue( "sPixelSize", 1 / scX, 1 / scY )	
		cShader.shader:setValue( "sAspectRatio", scX / scY )
		cShader.shader:setValue( "sClip", 0.3, 600 )

		extraBuffer.instance = extraBuffer.instance + 1
			
		cShader.shader:setValue( "sRTColor", extraBuffer.RTColor )
		cShader.shader:setValue( "sRTNormal", extraBuffer.RTNormal )
		
		cShader.shader:setValue( "sRTDepth", sRTDepth )
		cShader.shader:setValue( "sRTDepthDet", sRTDepthDet )

		self.__index = self
		setmetatable( cShader, self )
		return cShader
	else
		return false
	end
end

function CMat2Dshadowmap: setInMatrix( cameraPos, fwVec, upVec, hitLen, lenMul, lenMulDet )
	if self.shader then
	self.shader:setValue("sCameraPosition", cameraPos.x, cameraPos.y, cameraPos.z)
	self.shader:setValue("sCameraForward", fwVec.x, fwVec.y, fwVec.z) 
	self.shader:setValue("sCameraUp", upVec.x, upVec.y, upVec.z)
	self.shader:setValue("sScrRes", hitLen * lenMul, hitLen * lenMul)
	self.shader:setValue("sScrRes_det", hitLen * lenMulDet, hitLen * lenMulDet)	
	end
end

function CMat2Dshadowmap: setColor( col )
	if self.shader then
		self.color = tocolor( col.x, col.y, col.z, col.w )
	end
end

function CMat2Dshadowmap: draw()
	if self.shader then
		local elePos = getCamera().matrix.position

		self.shader:setValue( "sElementPosition", elePos.x, elePos.y, elePos.z )
		dxDrawMaterialLine3D( elePos.x + 0.5, elePos.y, elePos.z, elePos.x + 0.5, elePos.y + 1, elePos.z,
			self.shader, 1, self.color, elePos.x + 0.5,elePos.y + 0.5, elePos.z + 1 )	
	end
end
        
function CMat2Dshadowmap: destroy()
	if self.shader then
		self.shader:destroy()
	end
	self = nil
end
