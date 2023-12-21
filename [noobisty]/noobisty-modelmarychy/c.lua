local txd = engineLoadTXD("files/marysia.txd")
engineImportTXD(txd, 325)
local dff = engineLoadDFF("files/marysia.dff", 325)
engineReplaceModel(dff, 325)
