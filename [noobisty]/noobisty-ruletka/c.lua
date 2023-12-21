sx, sy = guiGetScreenSize()

function sizeChanged(size)
    zoom = size*0.9
    font1 = exports["borsuk-gui"]:getFont("Lato-Regular", 9/zoom, false)
    font2 = exports["borsuk-gui"]:getFont("Lato-Regular", 10/zoom, false)
    font3 = exports["borsuk-gui"]:getFont("Lato-Bold", 11/zoom, false)
    font4 = exports["borsuk-gui"]:getFont("Lato-Bold", 12/zoom, false)
    font5 = exports["borsuk-gui"]:getFont("Lato-Regular", 15/zoom, false)
end

sizeChanged(exports["borsuk-gui"]:getZoom())
addEventHandler("onGUISizeChanged", root, sizeChanged)

local windowPos = {x=math.floor(sx/2-1000/zoom/2), y=math.floor(sy/2-600/zoom/2), w=math.floor(1000/zoom), h=math.floor(600/zoom)}
local windowPos1 = {x=math.floor(sx/2-1200/zoom/2), y=math.floor(sy/2-800/zoom/2), w=math.floor(1200/zoom), h=math.floor(800/zoom)}

tabela={}
table_statistics = {}

mozliwybet = true
blokadaColor = false

windows = {
    
    editbox = nil,
    main = false,

}

markery = {
    {1127.92, 3.01, 1000.68},
    {1126.94, 3.01, 1000.68},
    {1125.89, 3.00, 1000.68},
    {1135.06, -3.87, 1000.68},
    {1132.90, -1.80, 1000.68},
    {1134.94, 0.61, 1000.68},
    {1124.84, 3.01, 1000.68},
}

for i=1,6 do
table.insert(tabela,{0,0,181,0,"zielone","x14",math.random(0,14)})
table.insert(tabela,{1,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{2,0,0,0,"czarne","x2",math.random(0,14)})
table.insert(tabela,{3,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{4,0,0,0,"czarne","x2",math.random(0,14)})
table.insert(tabela,{5,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{6,0,0,0,"czarne","x2",math.random(0,14)})
table.insert(tabela,{7,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{8,0,0,0,"czarne","x2",math.random(0,14)})
table.insert(tabela,{9,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{10,0,0,0,"czarne","x2",math.random(0,14)})
table.insert(tabela,{11,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{12,0,0,0,"czarne","x2",math.random(0,14)})
table.insert(tabela,{13,255,0,0,"czerwone","x2",math.random(0,14)})
table.insert(tabela,{14,0,0,0,"czarne","x2",math.random(0,14)})
end

betyr={}
betyb={}
betyg={}


iloscokienek=75
czas = 4000
kolejnelosowanie = 0
kolejnelosowaniestart= 0

function betowaniefroms(kolor,kwota)
    ilosc = 0
    if kolor == "red" then
        for i,v in pairs(betyr) do
            if betyr[i][1] == getPlayerName(source) then
                ilosc = betyr[i][2]
                table.remove (betyr,i)
            end
        end
        table.insert ( betyr,{""..getPlayerName(source).."", tonumber(kwota+ilosc)})
        table.sort(betyr, function(a, b) return a[2]>b[2] end)
    end

    if kolor == "black" then
        for i,v in pairs(betyb) do
            if betyb[i][1] == getPlayerName(source) then
                ilosc = betyb[i][2]
                table.remove (betyb,i)
            end
        end
        table.insert ( betyb,{""..getPlayerName(source).."", tonumber(kwota+ilosc)})
        table.sort(betyb, function(a, b) return a[2]>b[2] end)
    end

    if kolor == "green" then
        for i,v in pairs(betyg) do
            if betyg[i][1] == getPlayerName(source) then
                ilosc = betyg[i][2]
                table.remove (betyg,i)
            end
        end
        table.insert ( betyg,{""..getPlayerName(source).."", tonumber(kwota+ilosc)})
        table.sort(betyg, function(a, b) return a[2]>b[2] end)
    end
end
addEvent("betowanietoc", true )
addEventHandler("betowanietoc", getRootElement(), betowaniefroms)

bankMoney = 0

function getPlayerBankMoney()
    return bankMoney
end

function triggerBankMoney(money)
    bankMoney = money
end
addEvent("triggerMoney", true )
addEventHandler("triggerMoney", getRootElement(), triggerBankMoney)

ruletkapola = dxCreateRenderTarget(1100/zoom, 70/zoom, true)
ruletkabety = dxCreateRenderTarget(1100/zoom, 390/zoom, true)
start = getTickCount()
koniec= getTickCount()
random = 15
winColor = {}

function drawButton(text, x, y, w, h, id, color)
	if isMouseIn(x, y, w, h) then
		dxDrawRoundedRectangle(x, y, w, h, 15, tocolor(color[1], color[2], color[3], 200))
		dxDrawText(text, x, y-1, x+w, y+h, tocolor(255, 255, 255, 155), 1, font4, "center", "center", false, false, false, false, false)
	else
		dxDrawRoundedRectangle(x, y, w, h, 15, tocolor(color[1], color[2], color[3], 255))
		dxDrawText(text, x, y-1, x+w, y+h, tocolor(255, 255, 255, 255), 1, font4, "center", "center", false, false, false, false, false)
	end
end

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

function window()
    if windows.main == true then
        local xTEXT, yTEXT, wTEXT, hTEXT = windowPos.x, windowPos.y, windowPos.w, windowPos.h
        x =94*6.21/zoom
        dxDrawRoundedRectangle(windowPos1.x-math.floor(2/zoom) - 1, windowPos1.y - 1, windowPos1.w+math.floor(3/zoom) + 2, windowPos1.h + 2, 15, tocolor(75, 75, 75, 255)) 
        dxDrawRoundedRectangle(windowPos1.x-math.floor(2/zoom), windowPos1.y, windowPos1.w+math.floor(3/zoom), windowPos1.h, 15, tocolor(35, 35, 35, 255)) 

        aktualnyczas= getTickCount()
        if aktualnyczas > kolejnelosowanie then
            text = "Trwa losowanie..."
        else
            zailelosowanie = (kolejnelosowanie-aktualnyczas)/1000
            zailelosowanie = string.format("%.1f", zailelosowanie ) 
            text = "Losowanie zostanie rozpoczęte za "..math.floor(zailelosowanie).." sek."
        end

        dxDrawRectangle(windowPos1.x+math.floor(10/zoom), windowPos1.y+math.floor(105/zoom), math.floor(1180/zoom), math.floor(10/zoom), tocolor(60, 60, 60, 190), false)

        local postepodliczania = (aktualnyczas-kolejnelosowaniestart)/(kolejnelosowanie-kolejnelosowaniestart)
        odliczaniepasek= interpolateBetween(math.floor(1180/zoom),0,0,math.floor(0/zoom),0,0,postepodliczania ,'OutQuad')

        if odliczaniepasek > 0 then
            dxDrawRectangle(windowPos1.x+math.floor(10/zoom), windowPos1.y+math.floor(105/zoom), odliczaniepasek,  math.floor(10/zoom),tocolor(75, 75, 75, 230), false)
        end

        dxDrawText(""..text.."", xTEXT, yTEXT-math.floor(650/zoom), xTEXT+wTEXT, yTEXT+hTEXT, tocolor(255, 255, 255, 200), 1, font4, "center", "center", true )

        local postep =  (getTickCount()- start)/(koniec- start)
        przesuniecie = interpolateBetween(-15*70,0,0,-random*70,0,0,postep ,'OutQuad')

        dxDrawText('Bank: '..przecinek(getPlayerBankMoney(localPlayer))..' PLN', xTEXT, yTEXT-math.floor(310/zoom), xTEXT+wTEXT, yTEXT+hTEXT, tocolor(255, 255, 255, 200), 1, font5, 'center', 'center', false, false, false, false, false)
        
        drawButton("Czerwony (x2)", windowPos1.x+math.floor(50/zoom), windowPos1.y+math.floor(370/zoom), math.floor(330/zoom), math.floor(35/zoom), 1, {200, 25, 25})
        drawButton("Zielony (x14)", windowPos1.x+math.floor(435/zoom), windowPos1.y+math.floor(370/zoom), math.floor(330/zoom), math.floor(35/zoom), 2, {25, 155, 25})
        drawButton("Czarny (x2)", windowPos1.x+windowPos1.w-math.floor(50/zoom)-math.floor(330/zoom), windowPos1.y+math.floor(370/zoom), math.floor(330/zoom), math.floor(35/zoom), 3, {10, 10, 10})

dxSetRenderTarget(ruletkabety ,true)

        betyx = 5
        suma = 0
        betyy = 38

        for i,v in pairs(betyr) do
            suma=suma+betyr[i][2]
            dxDrawText(betyr[i][1]:gsub("#%x%x%x%x%x%x", ""), betyx/zoom-5/zoom, betyy/zoom, betyx/zoom+320/zoom, betyy/zoom+30/zoom, tocolor(255, 255, 255, 255), 1, font3, "left", "center", false, false, false, false, false)
            if winColor[v[1]] == "red" then
                dxDrawText('+'..przecinek(betyr[i][2]*2)..'', betyx/zoom, betyy/zoom, betyx/zoom+320/zoom, betyy/zoom+30/zoom, tocolor(9, 255, 0, 255), 1, font3, "right", "center", false, false, false, false, false)
            elseif winColor[v[1]] == "black" then
                dxDrawText('-'..przecinek(betyr[i][2])..'', betyx/zoom, betyy/zoom, betyx/zoom+320/zoom, betyy/zoom+30/zoom, tocolor(255, 0, 0, 255), 1, font3, "right", "center", false, false, false, false, false)
            elseif winColor[v[1]] == "green" then
                dxDrawText('-'..przecinek(betyr[i][2])..'', betyx/zoom, betyy/zoom, betyx/zoom+320/zoom, betyy/zoom+30/zoom, tocolor(255, 0, 0, 255), 1, font3, "right", "center", false, false, false, false, false)
            else
                dxDrawText(przecinek(betyr[i][2]), betyx/zoom, betyy/zoom, betyx/zoom+320/zoom, betyy/zoom+30/zoom, tocolor(255, 255, 255, 255), 1, font3, "right", "center", false, false, false, false, false)
            end
            betyy = betyy+32
        end

        dxDrawRectangle(betyx/zoom-5/zoom, 33/zoom, 330/zoom, math.floor(2/zoom), tocolor (75, 75, 75, 255), false)
        dxDrawText(""..przecinek(suma).." PLN", betyx/zoom, 1/zoom, betyx/zoom+320/zoom, 35/zoom, tocolor(55, 175, 55, 255), 1, font3, "right", "center", false, false, false, false, false)

        betyx = 260+260+15
        suma = 0
        betyy = 38
        for i,v in pairs(betyb) do
            suma=suma+betyb[i][2]
            dxDrawText(betyb[i][1]:gsub("#%x%x%x%x%x%x", ""), betyx/zoom+235/zoom, betyy/zoom, betyx/zoom+450/zoom, betyy/zoom+30/zoom, tocolor(255, 255, 255, 255), 1, font3, "left", "center", false, false, false, false, false)
            if winColor[v[1]] == "black" then
                dxDrawText('+'..przecinek(betyb[i][2]*2)..'', betyx/zoom+115/zoom, betyy/zoom, betyx/zoom+560/zoom, betyy/zoom+30/zoom, tocolor(9, 255, 0,255), 1, font3, "right", "center", false, false, false, false, false)
            elseif winColor[v[1]] == "red" then
                dxDrawText('-'..przecinek(betyb[i][2])..'', betyx/zoom+115/zoom, betyy/zoom, betyx/zoom+560/zoom, betyy/zoom+30/zoom, tocolor(255, 0, 0,255), 1, font3, "right", "center", false, false, false, false, false)
            elseif winColor[v[1]] == "green" then
                dxDrawText('-'..przecinek(betyb[i][2])..'', betyx/zoom+115/zoom, betyy/zoom, betyx/zoom+560/zoom, betyy/zoom+30/zoom, tocolor(255, 0, 0,255), 1, font3, "right", "center", false, false, false, false, false)
            else
                dxDrawText(przecinek(betyb[i][2]), betyx/zoom+115/zoom, betyy/zoom, betyx/zoom+560/zoom, betyy/zoom+30/zoom, tocolor(255, 255, 255,255), 1, font3, "right", "center", false, false, false, false, false)
            end
            betyy = betyy+32
        end

        dxDrawRectangle(betyx/zoom+235/zoom, 33/zoom, 330/zoom, math.floor(2/zoom), tocolor (75, 75, 75, 255), false)
        dxDrawText(""..przecinek(suma).." PLN", betyx/zoom, 1/zoom, betyx/zoom+560/zoom, 35/zoom, tocolor(55, 175, 55, 255), 1, font4, "right", "center", false, false, false, false, false)

        betyx = 260+10
        suma = 0
        betyy = 38
        for i,v in pairs(betyg) do
            suma=suma+betyg[i][2]
            dxDrawText(betyg[i][1]:gsub("#%x%x%x%x%x%x", ""), betyx/zoom+115/zoom, betyy/zoom, betyx/zoom+370/zoom, betyy/zoom+30/zoom, tocolor(255, 255, 255, 255), 1, font3, "left", "center", false, false, false, false, false)
            if winColor[v[1]] == "green" then
                dxDrawText('+'..przecinek(betyg[i][2]*14)..'', betyx/zoom, betyy/zoom, betyx/zoom+440/zoom, betyy/zoom+30/zoom, tocolor(9, 255, 0, 255), 1, font3, "right", "center", false, false, false, false, false)
            elseif winColor[v[1]] == "black" then
                dxDrawText('-'..przecinek(betyg[i][2])..'', betyx/zoom, betyy/zoom, betyx/zoom+440/zoom, betyy/zoom+30/zoom, tocolor(255, 0, 0, 255), 1, font3, "right", "center", false, false, false, false, false)
            elseif winColor[v[1]] == "red" then
                dxDrawText('-'..przecinek(betyg[i][2])..'', betyx/zoom, betyy/zoom, betyx/zoom+440/zoom, betyy/zoom+30/zoom, tocolor(255, 0, 0, 255), 1, font3, "right", "center", false, false, false, false, false)
            else
                dxDrawText(przecinek(betyg[i][2]), betyx/zoom, betyy/zoom, betyx/zoom+440/zoom, betyy/zoom+30/zoom, tocolor(255, 255, 255, 255), 1, font3, "right", "center", false, false, false, false, false)
            end
            betyy = betyy+32
        end

        dxDrawRectangle(betyx/zoom+115/zoom, 33/zoom, 330/zoom, math.floor(2/zoom), tocolor (75, 75, 75, 255), false)
        dxDrawText(""..przecinek(suma).." PLN", betyx/zoom, 1/zoom, betyx/zoom+440/zoom, 35/zoom, tocolor(55, 175, 55, 255), 1, font4, "right", "center", false, false, false, false, false)

dxSetRenderTarget()

dxSetRenderTarget(ruletkapola,true)

        for i,v in pairs(tabela) do
            dxDrawImage(x+przesuniecie/zoom, 0, math.floor(70/zoom), math.floor(70/zoom), "img/number.png", 0, 0, 0, tocolor(v[2], v[3], v[4]))
            dxDrawText(v[6], x+przesuniecie/zoom + 35/zoom, 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, font4, "center", "center", false, false, false, false, false)
            x=x+70/zoom
       end

dxSetRenderTarget()

        
        dxDrawImage(windowPos.x-math.floor(100/zoom), windowPos.y+math.floor(45/zoom), windowPos.w+200/zoom, windowPos.h-math.floor(540/zoom), ruletkapola)
        dxDrawImage(windowPos.x-math.floor(50/zoom), windowPos.y+math.floor(310/zoom), windowPos.w+100/zoom, windowPos.h-math.floor(210/zoom), ruletkabety)
        dxDrawImage(windowPos.x-math.floor(100/zoom), windowPos.y+math.floor(35/zoom), windowPos.w+200/zoom, windowPos.h-math.floor(520/zoom), "img/overlay.png", 0, 0, 0, tocolor(255, 255, 255))
    end
end

addEventHandler('onClientClick', root, function(btn, state)
    if btn == 'left' and state == 'down' then
        if isMouseIn(windowPos1.x+math.floor(50/zoom), windowPos1.y+math.floor(370/zoom), math.floor(330/zoom), math.floor(35/zoom)) and windows.main == true then
            local kwota = exports["borsuk-gui"]:getEditboxText(windows.editbox)
            if tonumber(kwota) >= 25000 then exports["noobisty-notyfikacje"]:createNotification("Kasyno", "Maksymalnie możesz postawić 25,000 PLN", {200, 200, 55}, "sight") return end

            if mozliwybet then
                if blokadaColor == true then return end
                if tonumber(kwota) and tonumber(kwota) > 0 and not string.find(kwota, "%D") then
                    triggerServerEvent("betowanietos",localPlayer,'red',kwota)
                    triggerServerEvent("bankTriggerMoney",localPlayer,localPlayer)
                    blokadaColor = true
                end
            end

        elseif isMouseIn(windowPos1.x+math.floor(435/zoom), windowPos1.y+math.floor(370/zoom), math.floor(330/zoom), math.floor(35/zoom)) and windows.main == true then
            local kwota = exports["borsuk-gui"]:getEditboxText(windows.editbox)
            if tonumber(kwota) >= 25000 then exports["noobisty-notyfikacje"]:createNotification("Kasyno", "Maksymalnie możesz postawić 25,000 PLN", {200, 200, 55}, "sight") return end
            if mozliwybet then
                if blokadaColor == true then return end
                if tonumber(kwota) and tonumber(kwota) > 0 and not string.find(kwota, "%D") then
                    triggerServerEvent("betowanietos",localPlayer,'green',kwota)
                    triggerServerEvent("bankTriggerMoney",localPlayer,localPlayer)
                    blokadaColor = true
                end
            end

        elseif isMouseIn(windowPos1.x+windowPos1.w-math.floor(50/zoom)-math.floor(330/zoom), windowPos1.y+math.floor(370/zoom), math.floor(330/zoom), math.floor(35/zoom)) and windows.main == true then
            local kwota = exports["borsuk-gui"]:getEditboxText(windows.editbox)
            if tonumber(kwota) >= 25000 then exports["noobisty-notyfikacje"]:createNotification("Kasyno", "Maksymalnie możesz postawić 25,000 PLN", {200, 200, 55}, "sight") return end
            if mozliwybet then
                if blokadaColor == true then return end
                if tonumber(kwota) and tonumber(kwota) > 0 and not string.find(kwota, "%D") then
                    triggerServerEvent("betowanietos",localPlayer,'black',kwota)
                    triggerServerEvent("bankTriggerMoney",localPlayer,localPlayer)
                    blokadaColor = true
                end
            end
        end
    end
end)

function rollowanie (liczba, wygrywajacyKolor)
random = liczba
  start = getTickCount()
 koniec = getTickCount()+czas
mozliwybet = false


setTimer(function()
    kolejnelosowaniestart= getTickCount()
    kolejnelosowanie = getTickCount()+10000
    mozliwybet = true
    blokadaColor = false
    betyr={}
    betyb={}
    betyg={}
end, czas, 1)


end
addEvent( "losowanieliczb", true )
addEventHandler( "losowanieliczb", getRootElement(), rollowanie )

local function showGUI(el, md)
    if not md or getElementType(el) ~= "player" or el ~= localPlayer then return end
    showCursor(true, false)
    windows.main = true
    addEventHandler("onClientRender", root, window)
    triggerServerEvent("bankTriggerMoney",localPlayer,localPlayer)
    exports["borsuk-gui"]:destroyEditbox(windows.editbox)
    windows.editbox = exports["borsuk-gui"]:createEditbox("Wpisz kwotę", windowPos.x+math.floor(320/zoom), windowPos.y+math.floor(180/zoom), math.floor(350/zoom), math.floor(50/zoom), font1)
end

local function closeGUI(el, md)
    if not md or getElementType(el) ~= "player" or el ~= localPlayer then return end
    showCursor(false)
    windows.main = false
    removeEventHandler("onClientRender", root, window)
    exports["borsuk-gui"]:destroyEditbox(windows.editbox)
end

local function setup()
    for k,v in ipairs(markery) do
        local col = createMarker(v[1], v[2], v[3]-1, "cylinder", 1, 55, 155, 55, 55)
        setElementInterior(col, 12)
        setElementDimension(col, 1)
        setElementData(col, "marker:title", "Kasyno")
        setElementData(col, "marker:desc", "Maszyna")
        addEventHandler("onClientMarkerHit", col, showGUI)
        addEventHandler("onClientMarkerLeave", col, closeGUI)
        triggerServerEvent("bankTriggerMoney",localPlayer,localPlayer)
    end
end
setup()

function przecinek(xd)
    local left,num,right = string.match(xd,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function isMouseIn(x, y, width, height)
    if (not isCursorShowing()) then
        return false
    end
    local sx, sy = guiGetScreenSize ()
    local cx, cy = getCursorPosition ()
    local cx, cy = (cx * sx), (cy * sy)
    if (cx >= x and cx <= x + width ) and (cy >= y and cy <= y + height) then
        return true
    else
        return false
    end
end

if windows.editbox then
    exports["borsuk-gui"]:destroyEditbox(windows.editbox)
end