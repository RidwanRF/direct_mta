local main = {

	shader = dxCreateShader("shader.fx"),
	myRenderTarget = dxCreateRenderTarget(1024, 600),

	statistic = {

		{'Przyśpieszenie', 30, "engineAcceleration"},
		{'Prędkość maksymalna', 350, "maxVelocity"},
		{'Sterowanie', 50, "steeringLock"},
		{'Przyczepność', 1.5, "tractionLoss"},
		{'Masa pojazdu', 5000, "mass"},
		{'Utrata trakcji', 1.5, "tractionLoss"},

	},

	upgrades = {

		{'MK1', 'mk1'},
		{'MK2', 'mk2'},
		{'MK3', 'mk3'},
		{'Turbo', 'turbo'},
		{'Pojemność silnika', false, 'vehicle:engine', ' dm3'},
		{'Pojemność baku', false, 'vehicle:bak', ' L'},

	},

	upgrades2 = {

		{'Instalacja LPG', 'lpg'},
		{'Nitro', 'nitro'},
		{'RH', 'gz'},
		{'Szyby', false, "vehicle:carTint", " %"},
		{'Przebieg', false, "vehicle:mileage", " km"},
		{'Rodzaj paliwa', false, "vehicle:silnik"},

	},

	shape = createColSphere(972.327209, -1241.910156, 16.321466, 5)

}

local fonts = {

	[1] = exports["borsuk-gui"]:getFont("Roboto", 20, false),
	[2] = exports["borsuk-gui"]:getFont("Lato-Regular", 15, false),
	[3] = exports["borsuk-gui"]:getFont("Roboto", 15, false),

}

dxSetShaderValue(main.shader, "tex", main.myRenderTarget)

local positions = {

	{972.776843, -1234.02527, 17.063768, 0, 0, 90},

}

objects = {}

for i,v in ipairs(positions) do
	object = createObject(3354, v[1], v[2], v[3]+1)
	setElementRotation(object, v[4], v[5], v[6])

	table.insert(objects, object)
end

function renderDiagnostic(v)
	if main.myRenderTarget then
		
		dxSetRenderTarget(main.myRenderTarget)

			dxDrawRectangle(0, 0, 1024, 600, tocolor(25, 25, 25, 255))
			dxDrawText("Stacja diagnostyczna", 1024 / 2, 50, nil, nil, tocolor(255, 255, 255, 200), 1, fonts[1], "center", "bottom", false, false, false, false, false)
			dxDrawRectangle(512 - 200, 50, 400, 2, tocolor(75, 75, 75, 255))

			local veh = getElementsWithinColShape(main.shape, "vehicle")
			if #veh == 1 then
				for i, v in ipairs(veh) do
					veh = v
				end
				if not getElementData(veh, "vehicle:id") then return end

				dxDrawText(exports['pystories-vehicles']:getVehicleName(veh).." - "..getElementData(veh, "vehicle:id"), 1024 / 2, 55, nil, nil, tocolor(255, 255, 255, 200), 1, fonts[3], "center", "top", false, false, false, false, false)

				offset = 0
				for i, v in ipairs(main.statistic) do
					dxDrawText(v[1], 0, 215 + offset, 350, nil, tocolor(200, 200, 200, 255), 1, fonts[2], "center", "center", false, false, false, false, false)
        			dxDrawRectangle(25, 235 + offset, 300, 10, tocolor(0, 195, 255, 75))

        			local progress = (300*getVehicleHandlingProperty(veh, v[3])/v[2])
        			local progress = math.min(progress, 300)
        			dxDrawRectangle(25, 235 + offset, progress, 10, tocolor(0, 195, 255, 200))

					offset = offset + 55
				end

				offset = 0
				for i, v in ipairs(main.upgrades) do
					if v[2] ~= false then
						local upgrades = getElementData(veh, "vehicle:upgrades") or {}

						dxDrawRectangle(1024/2 - 156, 215 + offset, 300, 30, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 1024/2 - 150, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						local ifElse = upgrades[v[2]] and tocolor(55, 200, 55, 255) or tocolor(200, 55, 55, 255)
						dxDrawText(upgrades[v[2]] and "Tak" or "Nie", 1024/2, 230 + offset, 645, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)
					else
						local result = getElementData(veh, v[3]) or "Brak danych"
						dxDrawRectangle(1024/2 - 156, 215 + offset, 300, 30, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 1024/2 - 150, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						if v[4] then
							dxDrawText(result..v[4], 1024/2, 230 + offset, 645, nil, tocolor(55, 155, 255, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						else
							dxDrawText(result, 1024/2, 230 + offset, 645, nil, tocolor(55, 155, 255, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						end
					end

					offset = offset + 55
				end

				offset = 0
				for i, v in ipairs(main.upgrades2) do
					if v[2] ~= false then
						local upgrades = getElementData(veh, "vehicle:upgrades") or {}

						dxDrawRectangle(1024/2 - 156 + 325, 215 + offset, 300, 30, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 1024/2 - 150 + 325, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						local ifElse = upgrades[v[2]] and tocolor(55, 200, 55, 255) or tocolor(200, 55, 55, 255)
						dxDrawText(upgrades[v[2]] and "Tak" or "Nie", 1024/2 + 325, 230 + offset, 645 + 325, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)
					else
						if v[3] == "vehicle:mileage" then
							result = math.floor(tonumber(getElementData(veh, v[3]) or 0))
						else
							result = getElementData(veh, v[3]) or "Brak danych"
						end
						dxDrawRectangle(1024/2 - 156 + 325, 215 + offset, 300, 30, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 1024/2 - 150 + 325, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						if v[4] then
							dxDrawText(result..v[4], 1024/2 + 325, 230 + offset, 645 + 325, nil, tocolor(55, 155, 255, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						else
							dxDrawText(result, 1024/2 + 325, 230 + offset, 645 + 325, nil, tocolor(55, 155, 255, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						end
					end

					offset = offset + 55
				end
			elseif #veh >= 1 then
				dxDrawText("Zbyt wiele pojazdów na stanowisku", 1024 / 2, 55, nil, nil, tocolor(255, 75, 75, 200), 1, fonts[3], "center", "top", false, false, false, false, false)
			else
				dxDrawText("Brak pojazdu na stanowisku", 1024 / 2, 55, nil, nil, tocolor(255, 75, 75, 200), 1, fonts[3], "center", "top", false, false, false, false, false)
			end

		dxSetRenderTarget()

		for i, v in ipairs(objects) do
			engineApplyShaderToWorldTexture(main.shader, "ws_garagedoor3_white", objects[i])
		end
	end
end

addEventHandler('onClientRender', root, function()
	local x, y, z = getElementPosition(localPlayer)
	local theObj = getElementsWithinRange(x, y, z, 20, "object")

	for i, v in ipairs(theObj) do
		if getElementModel(v) == 3354 then
			renderDiagnostic(v)
		end
	end
end)

function convertNumber(amount)
    local formatted = amount 
    while true do
      formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1.%2') 
        if k == 0 then 
            break 
        end 
    end 
    return formatted 
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	if isElement(main.myRenderTarget) then destroyElement(main.myRenderTarget) end
end)

function getVehicleHandlingProperty(element, property)
    if isElement(element) and getElementType(element) == "vehicle" and type(property) == "string" then
        local handlingTable = getVehicleHandling(element) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
    return false
end