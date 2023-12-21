local txd = engineLoadTXD('salon.txd')
engineImportTXD(txd, 14836)

local dff = engineLoadDFF('salon.dff', 14836)
engineReplaceModel(dff, 14836)

local col = engineLoadCOL('salon.col')
engineReplaceCOL(col, 14836)

engineSetModelLODDistance(14836, 300)