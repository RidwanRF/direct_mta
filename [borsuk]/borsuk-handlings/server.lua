local hand = getModelHandling(541)
for k,v in pairs(hand) do
    setModelHandling(555, k, v)
end


function loadHandlings()
	setModelHandling(558, "maxVelocity", 300)

    setModelHandling(573, "driveType", "rwd")
    setModelHandling(573, "maxVelocity", 150)
    setModelHandling(573, "engineAcceleration", 4)
end
addEventHandler("onResourceStart", resourceRoot, loadHandlings)