replace = {

    [613] = {
        dff = "comet.dff",
        txd = "comet.txd",
        parentId = 480,
    },

    [614] = {
        dff = "blistacrx.dff",
        txd = "blistacrx.txd",
        parentId = 496,
    },

    [615] = {
        dff = "cockroach.dff",
        txd = "cockroach.txd",
        parentId = 519,
    },

    [616] = {
        dff = "gauntlet.dff",
        txd = "gauntlet.txd",
        parentId = 475,
    },

    [617] = {
        dff = "zion.dff",
        txd = "zion.txd",
        parentId = 405,
    },

    [618] = {
        dff = "barracks.dff",
        txd = "barracks.txd",
        parentId = 433,
    },

    [619] = {
        dff = "tron.dff",
        txd = "tron.txd",
        parentId = 522,
    },

    [620] = {
        dff = "kuruma1.dff",
        txd = "kuruma1.txd",
        parentId = 560,
    },
    
    [621] = {
        dff = "kuruma2.dff",
        txd = "kuruma2.txd",
        parentId = 560,
    },

    [622] = {
        dff = "kuruma3.dff",
        txd = "kuruma3.txd",
        parentId = 560,
    },

    [623] = {
        dff = "kuruma4.dff",
        txd = "kuruma4.txd",
        parentId = 560,
    },

    [624] = {
        dff = "bmwm2.dff",
        txd = "bmwm2.txd",
        parentId = 602,
    },

    [625] = {
        dff = "gclass.dff",
        txd = "gclass.txd",
        parentId = 579,
    },
}

local _getVehicleType = getVehicleType

function getVehicleType(model)
    if model >= 400 and model <= 611 then
        return _getVehicleType(model)
    end

    if replace[model] then
        return _getVehicleType(replace[model].parentId)
    end
    return "Automobile"
end