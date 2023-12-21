addCommandHandler("rape", function(plr, cmd, target)
    if getElementData(plr, "player:level") < 3 then return end
    if not target then return end
    local cel = findPlayer(plr, target)
    if not cel then end
    local x, y, z = getPositionFromElementOffset(cel, 0, 1, 0)
    setElementPosition(plr, x, y, z)
    local rx, ry, rz = getElementRotation(cel)
    setElementRotation(plr, rx, ry, rz+180)
    toggleAllControls(cel, false)
    setPedAnimation ( cel, "sex", "sex_1_cum_w", -1, true, false )
    setPedAnimation ( plr, "sex", "sex_1_cum_p", -1, true, false )
end)

addCommandHandler("rapes", function(plr, cmd, target)
    if getElementData(plr, "player:level") < 3 then return end
    if not target then return end
    local cel = findPlayer(plr, target)
    if not cel then end
    toggleAllControls(cel, true)
    setPedAnimation ( cel, false )
    setPedAnimation ( plr, false)
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function findPlayer(plr,cel)
	local target=nil
	if (tonumber(cel) ~= nil) then
		target=getElementByID("p"..cel)
	else -- podano fragment nicku
		for _,thePlayer in ipairs(getElementsByType("player")) do
			if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 0, true) then
				if (target) then
					outputChatBox("* Znaleziono więcej niż jednego gracza o pasującym nicku, podaj więcej liter.", plr)
					return nil
				end
				target=thePlayer
			end
		end
	end
	if target and getElementData(target,"p:inv") then return nil end
	return target
end

function getOrganizationData(oid)
    local q = exports["iq-db"]:query("SELECT * FROM `borsuk-organizacje` WHERE id=?", oid)
    return (q and q[1] or false)
end

function loadPlayerOrg(player)
    if isElement(player) and player then
        if getElementType(player) ~= "player" then return end
        local sid = getElementData(player,"player:sid")
        if not sid then return end
        local q = exports["iq-db"]:query("SELECT * FROM `borsuk-orgs` WHERE sid=?", sid)
        if #q == 0 then
            setElementData(player, "player:organization", false)
            setElementData(player, "player:organization:data", false)
            return
        end

        local data = getOrganizationData(q[1]["org"])
        if data then
            setElementData(player, "player:organization", data["name"])
            setElementData(player, "player:organization:data", data)
        else
            setElementData(player, "player:organization", false)
            setElementData(player, "player:organization:data", false)
        end

        for _, stat in ipairs({ 24, 69, 70, 71, 72, 73, 74, 76, 77, 78, 79 }) do
            setPedStat(player, stat, 1000)
         end
    end
end
addEvent("loadPlayerOrg",true)
addEventHandler("loadPlayerOrg", root, loadPlayerOrg)
addEvent("load:player",true)
addEventHandler("load:player", root, loadPlayerOrg)

local clickTick = {}

for k,v in pairs(getElementsByType("player")) do
    loadPlayerOrg(v)
end

addEvent("createOrg", true)
addEventHandler("createOrg", root, function(name, tag, r, g, b)
    if (clickTick[source] or 0) > getTickCount() then return end

    local color = r .. "," .. g .. "," .. b
    if getPlayerMoney(source) < 100000 then
        return exports["noobisty-notyfikacje"]:createNotification(source, "Tworzenie organizacji", "Nie posiadasz 200,000 PLN", {255, 50, 50}, "sighter")
    end
    local q = exports["iq-db"]:query("SELECT * FROM `borsuk-organizacje` WHERE `tag`=?", tag:upper())
    if #q > 0 then
        exports["noobisty-notyfikacje"]:createNotification(source, "Tworzenie organizacji", "Organizacja z takim TAG'iem już istnieje", {255, 50, 50}, "sighter")
        return
    end
    local q = exports["iq-db"]:query("SELECT * FROM `borsuk-organizacje` WHERE `name`=?", name)
    if #q > 0 then
        exports["noobisty-notyfikacje"]:createNotification(source, "Tworzenie organizacji", "Organizacja z taką nazwą już istnieje", {255, 50, 50}, "sighter")
        return
    end
    local q = exports["iq-db"]:query("SELECT * FROM `borsuk-organizacje` WHERE `color`=?", color)
    if #q > 0 then
        exports["noobisty-notyfikacje"]:createNotification(source, "Tworzenie organizacji", "Organizacja z takim kolorem już istnieje", {255, 50, 50}, "sighter")
        return
    end

    local sid = getElementData(source, "player:sid")
    local q, _, oid = exports["iq-db"]:query("INSERT INTO `borsuk-organizacje`(`name`, `spawn`, `tag`, `color`, `owner`) VALUES (?,?,?,?,?)", name, "false", tag:upper(), color, sid)
    takePlayerMoney(source, 100000)
    exports["noobisty-notyfikacje"]:createNotification(source, "Tworzenie organizacji", "Stworzono organizację " .. name, {50, 255, 50}, "sight")

    exports["iq-db"]:query("INSERT INTO `borsuk-orgs`(`sid`, `org`, `level`) VALUES (?,?,?)", sid, oid, 4)

    clickTick[source] = getTickCount()+3000
end)

local types = {

    ['normal'] = nil,
    ['crime'] = true,

}

function findPlayerBySID(sid)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, "player:sid") == sid then
            return v
        end
    end
end

function addOrganization(plr, cmd, name, tag, type, sid, r, g, b)
    if not name or not tag or not type or not sid or not r or not g or not b then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "/stworz.org <nazwa> <tag> <typ> <sid> <r> <g> <b>", {200, 50, 50}, "sighter")
    end

	if 3 >= name:len() then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Podaj dłuższą nazwę organizacji", {200, 50, 50}, "sighter")
    end

    if 3 >= type:len() then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Podaj typ organizacji (crime/normal)", {200, 50, 50}, "sighter")
    end

    if 2 >= tag:len() then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Podaj tag organizacji", {200, 50, 50}, "sighter")
    end

    if 0 >= sid:len() then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Podaj sid właściciela", {200, 50, 50}, "sighter")
    end

    if 0 >= r:len() or 0 >= b:len() or 0 >= g:len() then
        return exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Podaj kolor organizacji", {200, 50, 50}, "sighter")
    end

    local orgType = types[type]
    local q, _, oid = exports["iq-db"]:query("INSERT INTO `borsuk-organizacje`(`name`, `spawn`, `tag`, `color`, `owner`, `crime`) VALUES (?,?,?,?,?,?)", name, "false", tag:upper(), r..','..g..','..b, sid, orgType)
    exports["iq-db"]:query("INSERT INTO `borsuk-orgs`(`sid`, `org`, `level`) VALUES (?,?,?)", sid, oid, 4)

    local findPlayer = findPlayerBySID(sid)
    if findPlayer and getElementType(findPlayer) == "player" then
        loadPlayerOrg(findPlayer)
        exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Stworzono organizację " .. name .. " dla gracza ".. getPlayerName(findPlayer), {50, 255, 50}, "sight")
    else
        exports["noobisty-notyfikacje"]:createNotification(plr, "Tworzenie organizacji", "Stworzono organizację " .. name .. " dla gracza o SID ".. sid, {50, 255, 50}, "sight")
    end
end
addCommandHandler("stworz.org", addOrganization)

function globalMessage(plr, cmd, ...)
	local organization = getElementData(plr,'player:organization')
	if not organization then
		return
	end

	local msg = table.concat ( { ... }, " " )
	local orgplayers = getElementsByType('player')

	for i,v in pairs(orgplayers) do
	local organization1 = getElementData(v,'player:organization')
		if organization == organization1 then
			outputChatBox("#747474"..organization1.."#FFFFFF > "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#FFFFFF:#FFFFFF "..msg:gsub("#%x%x%x%x%x%x",""), v,_,_,_,true)
		end
	end
	local desc = "[#747474ORGANIZACJA#ffffff] ["..getElementData(plr,"id").."]"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."("..getElementData(plr,"player:organization").."): "..msg:gsub("#%x%x%x%x%x%x","")..""
	triggerEvent("admin:addText", resourceRoot, desc:gsub("#%x%x%x%x%x%x",""))
end
addCommandHandler("Organizacja", globalMessage)

addEventHandler("onPlayerJoin", root, function() 
	bindKey(source, "o", "down", "chatbox", "Organizacja")
end)