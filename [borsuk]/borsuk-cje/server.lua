local randomClothesData = {
	[0] = 67,
	[1] = 32,
	[2] = 44,
	[3] = 37,
	[4] = 2,
	[5] = 3,
	[6] = 3,
	[7] = 3,
	[8] = 6,
	[9] = 5,
	[10] = 6,
	[11] = 6,
	[12] = 5,
	[13] = 11,
	[14] = 11,
	[15] = 16,
	[16] = 56,
}

function setPedClothes(thePed, clothingSlot, clothingID)
	if not isElement(thePed) or type(clothingSlot) ~= "number" then return end
	if not clothingID then
		return removePedClothes(thePed, clothingSlot)
	end
	local hasClothes = getPedClothes(thePed, clothingSlot) 
	if hasClothes then
		removePedClothes(thePed, clothingSlot)
	end
	local texture, model = getClothesByTypeIndex(clothingSlot, clothingID)
	return addPedClothes(thePed, texture, model, clothingSlot)
end

function randomPedClothes(ped)
	if getElementModel(ped) == 0 then
        for e,d in pairs(randomClothesData) do
			setPedClothes(ped, e, math.random(0, d))
		end
    end
end