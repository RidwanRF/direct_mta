local sx, sy = guiGetScreenSize()
local zoom = exports["borsuk-gui"]:getZoom()
local font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom)
local font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 18/zoom)
local font3 = exports["borsuk-gui"]:getFont("Lato-Regular", 13/zoom)

local marker = createMarker(2848.49, -1124.80, 113.33-1, "cylinder", 1, 50, 170, 255)
setElementDimension(marker, 1)
setElementData(marker, "marker:title", "Organizacja")
setElementData(marker, "marker:desc", "Tworzenie organizacji")

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    showOrgCreate()
end)

function renderOrgCreate()
    dxDrawRectangle(sx/2 - 228/zoom, sy/2 - 230/zoom, 456/zoom, 500/zoom, tocolor(55,55,55))
    dxDrawRectangle(sx/2 - 225/zoom, sy/2 - 230/zoom, 450/zoom, 500/zoom, tocolor(20,20,20))
    dxDrawRectangle(sx/2 - 225/zoom, sy/2 - 170/zoom, 450/zoom, 1, tocolor(35,35,35))

    dxDrawText("Tworzenie organizacji", sx/2, sy/2 - 400/zoom, sx/2, sy/2, tocolor(255,255,255,80), 1, font2, "center", "center")
    dxDrawText("• Nazwy nie można zmienić\n• Maksymalnie 15 osób z możliwością ulepszenia\n• Wymagany 10 poziom\n• Koszt założenia wynosi 100,000 PLN\n• Organizacje przestępcze wymagają podania", sx/2, sy/2 - 150/zoom, sx/2, sy/2, tocolor(255,255,255,150), 1, font3, "center", "top")

    dxDrawRectangle(sx/2+107/zoom - 1, sy/2+95/zoom - 1, 40/zoom + 2, 40/zoom + 2, tocolor(55, 55, 55))
    local kolor = exports["borsuk-gui"]:getEditboxText(hex)
    if #kolor == 6 or #kolor == 7 then
        local r, g, b = hex2rgb(kolor)
        if r and g and b then
            dxDrawRectangle(sx/2+107/zoom, sy/2+95/zoom, 40/zoom, 40/zoom, tocolor(r, g, b))
        end
    end
end

function showOrgCreate()
    hideOrgCreate()
    addEventHandler("onClientRender", root, renderOrgCreate)

    nazwa = exports["borsuk-gui"]:createEditbox("Ogólna nazwa", sx/2-150/zoom, sy/2-30/zoom, 300/zoom, 50/zoom, font1, nil, false, true)
    tag = exports["borsuk-gui"]:createEditbox("TAG", sx/2-150/zoom, sy/2+30/zoom, 300/zoom, 50/zoom, font1, nil, false, true)
    hex = exports["borsuk-gui"]:createEditbox("Kolor HEX", sx/2-150/zoom, sy/2+90/zoom, 250/zoom, 50/zoom, font1, nil, false, true)
    stworz = exports["borsuk-gui"]:createButton("Stwórz", sx/2-75/zoom, sy/2 + 150/zoom, 150/zoom, 45/zoom, font3)
    anuluj = exports["borsuk-gui"]:createButton("Anuluj", sx/2-75/zoom, sy/2 + 205/zoom, 150/zoom, 45/zoom, font3)

    showCursor(true)

    toggleAllControls(true)
end

function hideOrgCreate()
    removeEventHandler("onClientRender", root, renderOrgCreate)

    nazwa = exports["borsuk-gui"]:destroyEditbox(nazwa)
    tag = exports["borsuk-gui"]:destroyEditbox(tag)
    hex = exports["borsuk-gui"]:destroyEditbox(hex)
    stworz = exports["borsuk-gui"]:destroyButton(stworz)
    anuluj = exports["borsuk-gui"]:destroyButton(anuluj)
    toggleAllControls(true)

    showCursor(false)
end

addEvent("onButtonClick", true)
addEventHandler("onButtonClick", root, function(button, c, s)
	if c ~= "left" or s ~= "down" then 
		return 
	end
	if button == anuluj then
        hideOrgCreate()
    elseif button == stworz then
        local name = exports["borsuk-gui"]:getEditboxText(nazwa)
        local tag_ = exports["borsuk-gui"]:getEditboxText(tag)
        local hex_ = exports["borsuk-gui"]:getEditboxText(hex)
        if name:len() < 3 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nazwa organizacji musi być dłuższa", {255, 50, 50}, "sighter")
        elseif getElementData(localPlayer, "player:organization") then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Już posiadasz organizację", {255, 50, 50}, "sighter")
        elseif name:len() > 16 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nazwa organizacji musi być krótsza", {255, 50, 50}, "sighter")
        elseif hex_:gsub("#", ""):len() ~= 6 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "HEX jest nie prawidłowy", {255, 50, 50}, "sighter")
        elseif tag_:len() ~= 4 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "TAG jest nie prawidłowy (4 znaki)", {255, 50, 50}, "sighter")
        elseif name:len() > 16 then 
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nazwa organizacji musi być krótsza", {255, 50, 50}, "sighter")
        elseif 10 >= tonumber(getElementData(localPlayer, "player:lvl")) then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nie posiadasz 15 poziomu", {255, 50, 50}, "sighter")
        elseif getPlayerMoney(localPlayer) < 100000 then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "Nie posiadasz 200,000 PLN", {255, 50, 50}, "sighter")
        end

        local r, g, b = hex2rgb(hex_)
        if not r or not g or not b then
            return exports["noobisty-notyfikacje"]:createNotification("Tworzenie organizacji", "HEX jest nie prawidłowy", {255, 50, 50}, "sighter")
        end

        triggerServerEvent("createOrg", localPlayer, name, tag_, r, g, b)
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    hideOrgCreate()
end)

function hex2rgb(hex) 
    hex = hex:gsub("#","") 
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
end