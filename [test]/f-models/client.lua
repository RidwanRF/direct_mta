local models = {
	{5409,"ventos_ventos-stacja.bin",2433,41752,860584,5056,300,false},
	--{17547,"ventos_salon4.bin",1679,192410,5148968,26008,300,false},
	--{1676,"ventos_ventos-dystrybutor.bin",1294,1656299,307852,540,300,false},
	--{5521,"ventos_salon3.bin",2839,114698,1125628,13756,300,false},
	{4033,"ventos_salon2.bin",1091,244999,1623124,28568,300,false},
	{4018,"ventos_ventos-model-przecho.bin",1856,205575,468392,24992,300,false},
	--{4570,"ventos_salon1.bin",4099,514975,3134436,24304,300,false},
	{17862,"ventos_ventos-gielda1.bin",3541,45296,246952,3376,300,false},
	{14674,"ventos_ventos-model-mechanik.bin",3949,2049668,690216,178592,300,false},
};


local loadFromRAM = false

local function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end

function loadModel(model, fileName, headerLength, dffLength, txdLength, colLength, lod_dist, alpha)
	local file = fileOpen(fileName)
	if not file then
		return
	end

    file.pos = headerLength
	local dffData = file:read(dffLength)
	local txdData = file:read(txdLength)

	if(colLength)then
		colData = file:read(colLength)
	end


    local txd
	if loadFromRAM then
		txd = engineLoadTXD(txdData, alpha)
	else
		saveFile("tmp", txdData)
		txd = engineLoadTXD("tmp", alpha)
		saveFile('out/' .. fileName:gsub(".bin", ".txd"), txdData)
	end
	if txd then		
		engineImportTXD(txd, model)
	end

	-- DFF
	local dff
	if loadFromRAM then
		dff = engineLoadDFF(dffData)
	else
		saveFile("tmp", dffData)
		dff = engineLoadDFF("tmp")
		saveFile('out/' .. fileName:gsub(".bin", ".dff"), dffData)
	end
	if dff then
		engineReplaceModel(dff, model, alpha)
	end

	if fileExists("tmp") then
		fileDelete("tmp")
	end

	-- COL
	if(colLength)then
		local col
		if loadFromRAM then
			col = engineLoadCOL(colData)
		else
			saveFile("tmp", colData)
			col = engineLoadCOL("tmp")
			saveFile('out/' .. fileName:gsub(".bin", ".col"), colData)
		end
		if col then
			engineReplaceCOL(col, model)
		end

		if fileExists("tmp") then
			fileDelete("tmp")
		end
	end

	--

	file:close()

	if(lod_dist and tonumber(lod_dist))then
		engineSetModelLODDistance(model, tonumber(lod_dist))
	end
end

addEventHandler('onClientResourceStart',resourceRoot,function ()

    engineSetAsynchronousLoading(false, false) 
    for i,v in pairs(models) do
        loadModel(unpack(v))
    end
end)