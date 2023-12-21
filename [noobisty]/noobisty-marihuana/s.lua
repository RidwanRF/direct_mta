timers = {}

addEvent('toggleAnimation', true)
addEventHandler('toggleAnimation', root, function(plr, animData, time)
    local animName, animDesc = animData[1], animData[2]

    setElementFrozen(plr, true)
    setPedAnimation(plr, animName, animDesc, -1, true, false)
    

    timers[plr] = setTimer(function()
        setElementFrozen(plr, false)
        setPedAnimation(plr, false)

        if isTimer(timers[plr]) then killTimer(timers[plr]) end
    end, time, 1)
end)

local main = {

    positions = {

        {-119.090820, -90.469681, 3.118082, 120},
        {-119.090820, -90.469681, 3.118082, 120},

    },

    dealerPed = nil,
    dealerSphere = nil,

    costs = {

        ['weed'] = 0,
        ['tops'] = 0,

    }

}

function randomCost()
    main.costs = {

        ['weed'] = math.random(500, 950),
        ['tops'] = math.random(700, 1200),

    }
end
randomCost()
setTimer(randomCost, 60000*60, 0)

function randomMessage()
    local randomMessages = {

        {"No co tam ziomuś?"},
        {"Znów przyszedłeś zawracać mi dupsko?"},
        {"Uwielbiam kolor zielony"},
        {"Mordeczko czegoś potrzeba?"},

    }

    local randomize = math.random(1, #randomMessages)
    return randomMessages[randomize][1]
end

function hitDealer(plr, dim)
    if getElementType(plr) == "player" then
        if getElementData(plr, "player:organization") then
            local randomMessage = randomMessage()
            outputChatBox("Diler [#63c963420#ffffff]: "..randomMessage, plr, 255, 255, 255, true)
            triggerClientEvent(plr, 'toggleGUI', resourceRoot, true, main.costs)
        else
            outputChatBox("Diler [#63c963420#ffffff]: Sorka ziomuś nie znamy sie", plr, 255, 255, 255, true)
            exports["noobisty-notyfikacje"]:createNotification(plr, "Diler", "Nie posiadasz organizacji", {255, 50, 50}, "sighter")
        end
    end
end

function leaveDealer(plr, dim)
    if getElementType(plr) == "player" then
        triggerClientEvent(plr, 'toggleGUI', resourceRoot, false)
    end
end

function createDealer()
    local randomTable = math.random(1, #main.positions)
    main.dealerPed = createPed(29, main.positions[randomTable][1], main.positions[randomTable][2], main.positions[randomTable][3], main.positions[randomTable][4], true)
    main.dealerSphere = createColSphere(main.positions[randomTable][1], main.positions[randomTable][2], main.positions[randomTable][3], 1.5)

    addEventHandler("onColShapeHit", main.dealerSphere, hitDealer)
    addEventHandler("onColShapeLeave", main.dealerSphere, leaveDealer)
end
createDealer()

createRadarArea(-1273.93, -1113.32, -300, 220, 200, 165, 55, 100)