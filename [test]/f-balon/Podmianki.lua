txd = engineLoadTXD ( "crate.txd", 1221)
engineImportTXD ( txd, 1221)
dff = engineLoadDFF ( "crate.dff" )
engineReplaceModel ( dff, 1221)
col = engineLoadCOL ( "crate.col" )
engineReplaceCOL ( col, 1221)