--[[moc = 1

bindKey("m", "down", function() -- Zmiana mocy
if localPlayer then -- Jeżeli gracz wtedy
if moc == 1 then
setElementData(localPlayer, "moc:mowy", "Szept")
moc = 2
elseif moc == 2 then
setElementData(localPlayer, "moc:mowy", "Mowa")
moc = 1
end
end
end)


local sx,sy=guiGetScreenSize()
local w, h = (sx/1680),(sy/1050)
local czcionka = dxCreateFont(":pd_gui/fonts/normal.ttf", 12)

addEventHandler("onClientRender", root, function()
		local moc_mowy = getElementData(localPlayer, "moc:mowy") or "Mowa"
		if getElementData(localPlayer, "voice:mowi") then
		dxDrawText("[M] Moc mowy: "..moc_mowy.."", 83*w + 1, 983*h + 1, 364*w + 1, 1032*h + 1, tocolor(0,0,0, 255), 1.0, czcionka, "center", "center", false, false, false, true, false)
        dxDrawText("[M] Moc mowy: #0096FF"..moc_mowy.."#ffffff", 83*w, 983*h, 364*w, 1032*h, tocolor(255, 255, 255, 255), 1.0, czcionka, "center", "center", false, false, false, true, false)
    	else
		dxDrawText("[M] Moc mowy: "..moc_mowy.."", 83*w + 1, 983*h + 1, 364*w + 1, 1032*h + 1, tocolor(0,0,0, 255), 1.0, czcionka, "center", "center", false, false, false, true, false)
        dxDrawText("[M] Moc mowy: #747474"..moc_mowy.."#ffffff", 83*w, 983*h, 364*w, 1032*h, tocolor(255, 255, 255, 255), 1.0, czcionka, "center", "center", false, false, false, true, false)
    end
    end)--]]