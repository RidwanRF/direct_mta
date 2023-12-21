local warianty = {

    [477] = {

        [0] = {"Mały spoiler", 20000},
        [1] = {"Duży spoiler", 25000},
        [2] = {"Poszerzane boki", 125000},
        [3] = {"Bez spoilera", 25000},

    },

    [405] = {

        [0] = {"Combi", 35000},
        [1] = {"Sedan", 50000},

    },

    [426] = {

        [0] = {"Sedan", 40000},
        [1] = {"Spoiler", 45000},
        [2] = {"Combi", 55000},

    },

    [426] = {

        [0] = {"Sedan", 40000},
        [1] = {"Spoiler", 45000},
        [2] = {"Combi", 55000},

    },

    [451] = {

        [0] = {"Bez spoilera", 40000},
        [1] = {"Lotka", 50000},
        [2] = {"Duże skrzydło", 75000},
        [3] = {"Spoiler", 60000},

    },

    [429] = {

        [0] = {"Bez dachu", 25000},
        [1] = {"Kabriolet", 50000},
        [3] = {"Dach", 60000},

    },

    [410] = {

        [0] = {"Dach", 25000},
        [1] = {"Kabriolet", 30000},

    },

    [560] = {

        [0] = {"Sedan", 35000},
        [1] = {"Combi", 45000},

    },

    [560] = {

        [0] = {"Sedan", 35000},
        [1] = {"Combi", 45000},

    },

    [613] = {

        [0] = {"Kabriolet", 35000},
        [1] = {"Dach", 45000},
        [2] = {"Kabriolet z bokami", 35000},
        [3] = {"Składany dach", 25000},
        [4] = {"Dach + Retro lampy", 65000},

    },

}

local save = {

    wariant  = {arg1 = nil, arg2 = nil}

}

local e1 = false

local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 13/zoom)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 11/zoom)
local font3 = exports["borsuk-gui"]:getFont("Lato-Bold", 13/zoom)

local marker = createMarker(-2052.61, 171.57, 27.70-1, "cylinder", 3, 0, 170, 255)
setElementData(marker, "marker:title", "Tuning")
setElementData(marker, "marker:desc", "Zmiana wariantu")

function dxDrawShadowText(text, x, y, w, h, color, ...)
    dxDrawText(text, x + 2, y + 2, w + 2, h + 2, tocolor(0, 0, 0, 155), ...)
    dxDrawText(text, x, y, w, h, color, ...)
end

local _getElementModel = getElementModel
function getElementModel(veh)
    return (getElementData(veh, "vehicle:model") or _getElementModel(veh))
end

function renderVariantGUI()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local model = getElementModel(veh)
    local var1, var2 = getVehicleVariant(veh)

    dxDrawRoundedRectangle(sx/2 - 190/zoom, sy - 194/zoom, 380/zoom, 120/zoom, 15/zoom, tocolor(25,25,25))

    if not warianty[model] then
        dxDrawText("Brak wariantów dla tego pojazdu", sx/2, sy - 170/zoom, sx/2, sy - 100/zoom, white, 1, font1, "center", "center")
    else
        local c1 = (warianty[model].current1 or 0)
        dxDrawText("< Pierwszy wariant: " .. warianty[model][c1][1].." >", sx/2, sy - 175/zoom, sx/2, sy - 130/zoom, white, 1, font1, "center", "top")
        dxDrawText("Cena zmiany wariantu: " ..warianty[model][c1][2].." PLN", sx/2, sy - 200/zoom, sx/2, sy - 110/zoom, tocolor(55, 200, 55), 1, font2, "center", "bottom")
        dxDrawText("Aby zakupić wariant kliknij #0091ffK", sx/2, sy - 110/zoom, sx/2, sy - 90/zoom, tocolor(200, 200, 200), 1, font2, "center", "top", false, false, false, true)
    end
end

function updateVariant()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    local model = getElementModel(veh)
    local c1 = (warianty[model].current1 or 0)
    setElementData(veh, "vehicle:var", {c1, c2}, false)
    setVehicleVariant(veh, c1, c1)
end

function leftKey()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local model = getElementModel(veh)

    if (warianty[model].current0 or 1) == 1 then
        warianty[model].current1 = math.max((warianty[model].current1 or 0) - 1, 0)
    else
        warianty[model].current2 = math.max((warianty[model].current2 or 0) - 1, 0)
    end

    updateVariant()
end

function rightKey()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local model = getElementModel(veh)

    if (warianty[model].current0 or 1) == 1 then
        warianty[model].current1 = math.min((warianty[model].current1 or 0) + 1, #warianty[model])
    else
        warianty[model].current2 = math.min((warianty[model].current2 or 0) + 1, #warianty[model])
    end

    updateVariant()
end

function buyVariant()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local model = getElementModel(veh)
    local var1, var2 = getVehicleVariant(veh)
    local c1 = (warianty[model].current1 or 0)

    if getPlayerMoney(localPlayer) >= warianty[model][c1][2] then
        save.wariant = {arg1 = c1, arg2 = c1}
        triggerServerEvent("changeVariant", localPlayer, localPlayer, veh, c1, warianty[model][c1][1], warianty[model][c1][2])
    else
        exports["noobisty-notyfikacje"]:createNotification("Zmiana wariantu", "Nie posiadasz tyle pieniędzy", {200, 50, 50}, "sighter")
    end
end

function showVariantGUI()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    if getElementData(localPlayer, "player:sid") ~= getElementData(veh, "vehicle:ownedPlayer") then return end
    setElementVelocity(veh, 0, 0, 0)
    addEventHandler("onClientRender", root, renderVariantGUI)
    local model = getElementModel(veh)

    local var1, var2 = getVehicleVariant(veh)
    save.wariant = {arg1 = var1, arg2 = var2}

    if warianty[model] then
        bindKey("arrow_l", "down", leftKey)
        bindKey("arrow_r", "down", rightKey)
        bindKey("k", "down", buyVariant)
    end
end

function hideVariantGUI()
    local veh = getPedOccupiedVehicle(localPlayer)
    removeEventHandler("onClientRender", root, renderVariantGUI)

    unbindKey("arrow_l", "down", leftKey)
    unbindKey("arrow_r", "down", rightKey)
    unbindKey("k", "down", buyVariant)
    if not veh then return end

    if save.wariant.arg1 ~= nil then
        local model = getElementModel(veh)
        setElementData(veh, "vehicle:var", {save.wariant.arg1, save.wariant.arg2}, false)
        setVehicleVariant(veh, save.wariant.arg1, save.wariant.arg2)
    end
end

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end

    showVariantGUI()
end)

addEventHandler("onClientMarkerLeave", marker, function(plr)
    if plr ~= localPlayer then return end

    hideVariantGUI()
end)

function onQuitGame()
    if source == localPlayer then
        setElementData(getPedOccupiedVehicle(localPlayer), "vehicle:var", {save.wariant.arg1, save.wariant.arg2}, false)
        setVehicleVariant(getPedOccupiedVehicle(localPlayer), save.wariant.arg1, save.wariant.arg2)
    end
end
addEventHandler( "onClientPlayerQuit", root, onQuitGame)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end