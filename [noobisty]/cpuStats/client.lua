local sx,sy = guiGetScreenSize()
local resStat = false
local serverStats = nil
local serverColumns, serverRows = {}, {}

function isAllowed()
	if getElementData(localPlayer, "player:level") == 4 then
		return true
	else
		return false
	end
end

addCommandHandler("stats", function()
	if isAllowed() then
		resStat = not resStat
		if resStat then
			outputChatBox("* Włączono podgląd zużycia CPU", 0, 255, 0, true)
			addEventHandler("onClientRender", root, resStatRender)
			triggerServerEvent("getServerStat", localPlayer)
		else
			outputChatBox("* Wyłączono podgląd zużycia CPU", 255, 0, 0, true)
			removeEventHandler("onClientRender", root, resStatRender)
			serverStats = nil
			serverColumns, serverRows = {}, {}
			triggerServerEvent("destroyServerStat", localPlayer)
		end
	end
end)

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, function(stat1,stat2)
	serverStats = true
	serverColumns, serverRows = stat1,stat2
end)

function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	local columns, rows = getPerformanceStats("Lua timing")
	local height = (13*#rows)
	local y = sy/2-height/2
	for i, row in ipairs(rows) do
		if i > 0 then
		local text = row[1]:sub(0,15)..": "..row[2]..""
		dxDrawText(text,0+sx/4+1,0+1+y,500,500,tocolor(0,0,0,255),1,"default_bold","center")
		dxDrawText(text,0+sx/4,0+y,500,500,tocolor(255,255,255,255),1,"default_bold","center")
		y = y + 15
		end
	end
	
	if #serverRows ~= 0 then
		local x = sx-140
		local height = (15*#serverRows)
		local y = sy/2-height/2
		y = y + 5
		for i, row in ipairs(serverRows) do
			local text = row[1]:sub(0,15)..": "..row[2]
			dxDrawText(text,sx-sx/3+1,y+1,sx-sx/4,15,tocolor(0,0,0,255),1,"default_bold","center")
			dxDrawText(text,sx-sx/3,y,sx-sx/4,15,tocolor(255,255,255,255),1,"default_bold","center")
			y = y + 15
		end
	end
end