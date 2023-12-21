main = {
    ['bot'] = false,
    ['handshake'] = false
}



function connecttobot()
    if (main['bot'] ~= false) then
		sockClose(main['bot']);
	end
	
    main['bot'] = sockOpen('51.83.172.113', 6666);
end

connecttobot()

addEventHandler('onSockOpened', root, function(socket)
	if (socket ~= main['bot']) then return end;
	--print('[Api] Connected.');
end)

function sendConnectedInfo(uid, tag)
	local plr = findPlayerBySID(uid)
	if (plr) then
		exports['borsuk-notyfikacje']:addNotification(plr, 'success', 'Discord', 'Pomyslnie polaczono konto mta z discordem (tag: '..tag..')! Za polaczenie konta otrzymujesz 200$', 5000)
		givePlayerMoney(plr,200)
	end
end

function test()
	return 'mta => discord'
end

function normalJSON(arr)
	if not arr then
		return false;
	end
	arr.auth = 'jebanieborsukacwelajebanego';
	local json = toJSON(arr);
	json = json:sub(2, -2);
	return json;
end

function botWrite(...) 
	sockWrite(main['bot'], normalJSON(...)..';;');
end

function getOnlinePlayers()
	local tbl = {}
	for i,v in pairs(getElementsByType('player')) do
		table.insert(tbl,{
			id = getElementData(v,'player:id'),
			name = getPlayerName(v),
			rank = exports['pl-admins']:getRankName((getElementData(v,'player:admin') and getElementData(v,'player:admin').rank or 0)),
			discordid = getElementData(v,'player:discordid'),
			time = getElementData(v,'player:joinTime')
		})
	end
	return tbl
end

function sendPremiumMessage(author,text)
	outputChatBox("#FFD100(Premium) > #ffffff"..author.."#ffffff: "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
end

function sendAdminMessage(author,text)
	-- outputChatBox("#FFD100(Premium) > #ffffff"..author.."#ffffff: "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
	for i,v in pairs(getElementsByType('player')) do
		if (getElementData(v,'player:admin')) then
			outputChatBox("#d62032(AC) > #ffffff"..author.."#ffffff: "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
		end
	end
end

function findPlayerBySID(sid)
	for i,v in pairs(getElementsByType('player')) do
		if getElementData(v,'player:sid') == tonumber(sid) then
			return v
		end
	end
	return false
end

function getPlayerMoneyInSerwer(uid)
	local rows = exports['pl-db']:query('SELECT * FROM `pl-users` WHERE id=?',uid)
	if not findPlayerBySID(uid) then return rows[1].money end
	return getPlayerMoney(findPlayerBySID(uid))
end

addEventHandler('onSockData', root, function(socket, received)
	if (socket ~= main['bot']) then return end;
	local jsons = split(received, ';;;');
	for _, json in pairs(jsons) do
		local data = fromJSON(json);
		if (data) then
			-- iprint(data);
			if (data.handshake) then
				handshake = true;
				-- outputDebugString('Połączono z '..data.handshake, 3, 0, 255, 0);
			end
			if (data.funcname) then
				functions[data.funcname](data);
			end
		end
	end
end)


-- addEventHandler('onPlayerJoin',root,function ()
-- 	local players = getElementsByType('player')
-- 	exports['pl-db']:query("INSERT INTO `pl-players-records` (`date`, `players`) \
-- 	VALUES (NOW(), ?) \
-- 	ON DUPLICATE KEY UPDATE `players` = IF(`players` < ?, ?, `players`);",#players,#players,#players)
-- end)