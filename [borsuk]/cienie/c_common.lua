addEventHandler( "onClientResourceStart", resourceRoot, function()
	collectgarbage( "setpause", 100 )
end
)

extraBuffer = {instance = 0,  RTColor = nil, RTNormal = nil, RTdepth = nil, RTdepthDet = nil}
				
addEventHandler( "onClientPreRender", root,
    function()
		if extraBuffer.instance == 0 then return end
		extraBuffer.RTColor:setAsTarget( true )
		dxSetRenderTarget()
		extraBuffer.RTNormal:setAsTarget( true )
		dxSetRenderTarget()
    end
, true, "high" )

function Matrix:getRotationZXY()
	local nz1, nz2, nz3
	local matRt = self.right
	local matFw = self.forward
	local matUp = self.up
	nz3 = math.sqrt(matFw.x * matFw.x + matFw.y * matFw.y)
	nz1 = -matFw.x * matFw.z / nz3
	nz2 = -matFw.y * matFw.z / nz3
	local vx = nz1 * matRt.x + nz2 * matRt.y + nz3 * matRt.z
	local vz = nz1 * matUp.x + nz2 * matUp.y + nz3 * matUp.z
	return Vector3(math.deg(math.asin(matFw.z) ), -math.deg(math.atan2(vx, vz) ), -math.deg(math.atan2(matFw.x, matFw.y)))
end
		
function Matrix:setRotationZXY( rotDeg )
	local rot = Vector3(math.rad(rotDeg.x), math.rad(rotDeg.y), math.rad(rotDeg.z))
	self.right = Vector3(math.cos(rot.z) * math.cos(rot.y) - math.sin(rot.z) * math.sin(rot.x) * math.sin(rot.y), 
                math.cos(rot.y) * math.sin(rot.z) + math.cos(rot.z) * math.sin(rot.x) * math.sin(rot.y), -math.cos(rot.x) * math.sin(rot.y))
	self.forward =Vector3(-math.cos(rot.x) * math.sin(rot.z), math.cos(rot.z) * math.cos(rot.x), math.sin(rot.x))
	self.up = Vector3(math.cos(rot.z) * math.sin(rot.y) + math.cos(rot.y) * math.sin(rot.z) * math.sin(rot.x), math.sin(rot.z) * math.sin(rot.y) - 
                math.cos(rot.z) * math.cos(rot.y) * math.sin(rot.x), math.cos(rot.x) * math.cos(rot.y))
	return true
end

function Matrix:transformRotationZXY( rotDeg, offset )
	local rot = Vector3(math.rad(rotDeg.x), math.rad(rotDeg.y), math.rad(rotDeg.z))
	local mat1 = {}
	mat1[1] = {math.cos(rot.z) * math.cos(rot.y) - math.sin(rot.z) * math.sin(rot.x) * math.sin(rot.y), 
                math.cos(rot.y) * math.sin(rot.z) + math.cos(rot.z) * math.sin(rot.x) * math.sin(rot.y), -math.cos(rot.x) * math.sin(rot.y)}
	mat1[2] = {-math.cos(rot.x) * math.sin(rot.z), math.cos(rot.z) * math.cos(rot.x), math.sin(rot.x)}
	mat1[3] = {math.cos(rot.z) * math.sin(rot.y) + math.cos(rot.y) * math.sin(rot.z) * math.sin(rot.x), math.sin(rot.z) * math.sin(rot.y) - 
                math.cos(rot.z) * math.cos(rot.y) * math.sin(rot.x), math.cos(rot.x) * math.cos(rot.y)}

	local mat2 = {}
	mat2[1] = {self.right.x, self.right.y, self.right.z}
	mat2[2] = {self.forward.x, self.forward.y, self.forward.z}
	mat2[3] = {self.up.x, self.up.y, self.up.z}
	
	local matOut = {}
	for i = 1,#mat1 do
		matOut[i] = {}
		for j = 1,#mat2[1] do
			local num = mat1[i][1] * mat2[1][j]
			for n = 2,#mat1[1] do
				num = num + mat1[i][n] * mat2[n][j]
			end
			matOut[i][j] = num
		end
	end

	local nz1, nz2, nz3
	nz3 = math.sqrt(matOut[2][1] * matOut[2][1] + matOut[2][2] * matOut[2][2])
	nz1 = -matOut[2][1] * matOut[2][3] / nz3
	nz2 = -matOut[2][2] * matOut[2][3] / nz3
	local vx = nz1 * matOut[1][1] + nz2 * matOut[1][2] + nz3 * matOut[1][3]
	local vz = nz1 * matOut[3][1] + nz2 * matOut[3][2] + nz3 * matOut[3][3]	
	
	local rotationOut = Vector3(math.deg(math.asin(matOut[2][3]) ), -math.deg(math.atan2(vx, vz) ), 
			-math.deg(math.atan2(matOut[2][1], matOut[2][2])))
	
	local positionOut = Vector3(offset:dot(Vector3(matOut[1][1], matOut[2][1], matOut[3][1])),
			offset:dot(Vector3(matOut[1][2], matOut[2][2], matOut[3][2])),
			offset:dot(Vector3(matOut[1][3], matOut[2][3], matOut[3][3]))) + self.position
	
	return rotationOut, positionOut
end

function getForwardFromRotationZXY( rotDeg )
	local rot = Vector3(math.rad(rotDeg.x), math.rad(rotDeg.y), math.rad(rotDeg.z))
	return Vector3(-math.cos(rot.x) * math.sin(rot.z), math.cos(rot.z) * math.cos(rot.x), math.sin(rot.x))
end

function getRotationZXFromForward( fwVec )
	return Vector3(math.deg(math.asin(fwVec.z / fwVec:getLength())), 0, -math.deg(math.atan2(fwVec.x, fwVec.y)))
end
