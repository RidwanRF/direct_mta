tabela={}
 
-- tworzenie listy
for i=1,6 do
table.insert(tabela,{0,0,200,0,"zielone","x12"})
table.insert(tabela,{1,255,0,0,"czerwone","x2"})
table.insert(tabela,{2,0,0,0,"czarne","x2"})
table.insert(tabela,{3,255,0,0,"czerwone","x2"})
table.insert(tabela,{4,0,0,0,"czarne","x2"})
table.insert(tabela,{5,255,0,0,"czerwone","x2"})
table.insert(tabela,{6,0,0,0,"czarne","x2"})
table.insert(tabela,{7,255,0,0,"czerwone","x2"})
table.insert(tabela,{8,0,0,0,"czarne","x2"})
table.insert(tabela,{9,255,0,0,"czerwone","x2"})
table.insert(tabela,{10,0,0,0,"czarne","x2"})
table.insert(tabela,{11,255,0,0,"czerwone","x2"})
table.insert(tabela,{12,0,0,0,"czarne","x2"})
table.insert(tabela,{13,255,0,0,"czerwone","x2"})
table.insert(tabela,{14,0,0,0,"czarne","x2"})
end -- do listy

betyr={}
betyb={}
betyg={}

----outputChatBox("wylosowales = "..tabela[random][1].." "..tabela[random][5].."$ ( "..random.." okienko )")

function infowygrana (osoba,kolor,ilosc)
exports["noobisty-notyfikacje"]:createNotification(osoba, "Kasyno", "Wygrywasz "..przecinek(ilosc).." PLN", {55, 200, 55}, "sight")
local sr = exports["DB2"]:pobierzWyniki("SELECT `bank_money` FROM `pystories_users` WHERE id="..tonumber(getElementData(osoba, "player:sid")).." LIMIT 1")
triggerClientEvent(osoba, "triggerMoney", osoba, sr.bank_money)
end

function rollowanie ()
losowaliczba = math.random(45,75)

if tabela[losowaliczba][5] == "czerwone" then
	triggerClientEvent("losowanieliczb", root, losowaliczba, "red")
elseif tabela[losowaliczba][5] == "czarne" then
	triggerClientEvent("losowanieliczb", root, losowaliczba, "black")
elseif tabela[losowaliczba][5] == "zielone" then
	triggerClientEvent("losowanieliczb", root, losowaliczba, "green")
end

setTimer(function()

if tabela[losowaliczba][5] == "czerwone" then
for i,v in pairs(betyr) do
  
wygrana = betyr[i][2]*2
local gracz = getPlayerFromName (betyr[i][1])
if gracz then
givePlayerBankMoney(gracz, wygrana)
infowygrana (gracz,"#FF0000czerwone", wygrana)
end
end
betyr={}
betyb={}
betyg={}
end -- do koloru wygranego

if tabela[losowaliczba][5] == "czarne" then
for i,v in pairs(betyb) do
  
wygrana = betyb[i][2]*2
local gracz = getPlayerFromName (betyb[i][1])
if gracz then
givePlayerBankMoney(gracz, wygrana)
infowygrana (gracz,"#111111czarne", wygrana)
end
end
betyr={}
betyb={}
betyg={}
end -- do koloru wygranego

if tabela[losowaliczba][5] == "zielone" then
for i,v in pairs(betyg) do
  
wygrana = betyg[i][2]*14
local gracz = getPlayerFromName (betyg[i][1])
if gracz then
givePlayerBankMoney(gracz, wygrana)
infowygrana (gracz,"#18FF00zielone", wygrana)
--outputChatBox(""..betyg[i][1].." wygrywa "..wygrana.."")
end
end
betyr={}
betyb={}
betyg={}
end -- do koloru wygranego


end, 4000,1 )

--outputChatBox("wylosowales = "..tabela[losowaliczba][1].." "..tabela[losowaliczba][5].."$ ( "..losowaliczba.." okienko )")

end
setTimer (rollowanie, 14000,0 )


function betowanie (kolor, kwota)

if takePlayerBankMoney(source, kwota) then
ilosc = 0

if kolor == "red" then
for i,v in pairs(betyr) do
  
if betyr[i][1] == getPlayerName(source) then
ilosc = betyr[i][2]
table.remove (betyr,i)
end
end
table.insert ( betyr,{""..getPlayerName(source).."", tonumber(kwota+ilosc)})
triggerClientEvent ( "betowanietoc",source,kolor,kwota)
end





if kolor == "black" then
for i,v in pairs(betyb) do
  
if betyb[i][1] == getPlayerName(source) then
ilosc = betyb[i][2]
table.remove (betyb,i)
end
end
table.insert ( betyb,{""..getPlayerName(source).."", tonumber(kwota+ilosc)})
triggerClientEvent ( "betowanietoc",source,kolor,kwota)
end
if kolor == "green" then

for i,v in pairs(betyg) do
  
if betyg[i][1] == getPlayerName(source) then
ilosc = betyg[i][2]
table.remove (betyg,i)
end
end
table.insert ( betyg,{""..getPlayerName(source).."", tonumber(kwota+ilosc)})
triggerClientEvent ( "betowanietoc",source,kolor,kwota)
end

end
end
addEvent( "betowanietos", true )
addEventHandler( "betowanietos", getRootElement(), betowanie )


function bankTriggerMoney(plr)
	if getElementData(plr, "player:sid") then
		local sr = exports["DB2"]:pobierzWyniki("SELECT `bank_money` FROM `pystories_users` WHERE id="..tonumber(getElementData(plr, "player:sid")).." LIMIT 1")
		triggerClientEvent(plr, "triggerMoney", plr, sr.bank_money)
	end
end
addEvent("bankTriggerMoney", true )
addEventHandler("bankTriggerMoney", getRootElement(), bankTriggerMoney)


function takePlayerBankMoney(plr, money)
	local sr = exports["DB2"]:pobierzWyniki("SELECT `bank_money` FROM `pystories_users` WHERE id="..tonumber(getElementData(plr, "player:sid")).." LIMIT 1")
	if not sr or not sr.bank_money then return end
	sr.bank_money = tonumber(sr.bank_money)

	if (sr.bank_money > math.abs(money-1)) then
		exports["DB2"]:zapytanie("UPDATE pystories_users SET bank_money=bank_money-"..math.abs(tonumber(money)).." WHERE id="..tonumber(getElementData(plr, "player:sid")).." LIMIT 1")
		return true
	else
		exports["noobisty-notyfikacje"]:createNotification(plr, "Kasyno", "Nie posiadasz tyle pieniędzy", {200, 50, 50}, "sighter")
		return false
	end
end

function givePlayerBankMoney(plr, money)
	local sid = getElementData(plr, "player:sid")
	if sid then
		exports["DB2"]:zapytanie("UPDATE pystories_users SET bank_money=bank_money+"..(tonumber(money) or 0).." WHERE id="..tonumber(sid).." LIMIT 1")
	end
end

function przecinek(xd)
    local left,num,right = string.match(xd,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end