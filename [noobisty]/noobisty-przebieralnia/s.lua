function buySkin(plr, skinid)
    local data = getElementData(plr, "player:skinShop") or {}
    data[skinid] = true
    setElementData(plr, "player:skinShop", data)
end

addEvent("przebieralniaKupSkina", true)
addEventHandler("przebieralniaKupSkina", root, function(money, skin)
    takePlayerMoney(source, money)
    buySkin(source, skin)
    setElementData(source, "buywait", false)
end)

addEvent("przebieralniaZmienSkina", true)
addEventHandler("przebieralniaZmienSkina", root, function(skin)
    setElementModel(source, skin)
    setElementData(source, "player:skin", skin)
end)