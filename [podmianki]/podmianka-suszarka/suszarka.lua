local resourceRoot = getResourceRootElement(getThisResource())
     
addEventHandler("onClientResourceStart",resourceRoot,
function ()
    
    txd = engineLoadTXD ( "22.txd" )
    engineImportTXD ( txd, 346 )

    dff = engineLoadDFF ( "22.dff", 346 )
    engineReplaceModel ( dff, 346 )

    txd2 = engineLoadTXD ( "22.txd" )
    engineImportTXD ( txd2, 350 )

    dff2 = engineLoadDFF ( "22.dff", 350 )
    engineReplaceModel ( dff2, 350 )

end)