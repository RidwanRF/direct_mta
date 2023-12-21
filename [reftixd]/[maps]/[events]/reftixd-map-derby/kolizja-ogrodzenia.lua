addEventHandler("onClientResourceStart", resourceRoot,
function()

col = engineLoadCOL ("kolizja-ogrodzenie-derby.col")
engineReplaceCOL(col,13623)
col = engineLoadCOL ("przywraca-kolizje.col")
engineReplaceCOL(col,13607)


setOcclusionsEnabled( false )

end
)