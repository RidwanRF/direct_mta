local ranks = {
    [0] = {
        name = "Gracz",
        hex = 0xFF889DB1,
    },
    [1] = {
        name = 'Support',
        hex = 0xFF80FF00,
    },
    [2] = {
        name = 'Administrator',
        hex = 0xFFFF0000,
    },
    [3] = {
        name = 'RCON',
        hex = 0xFF7E0C0C,
    },
    [4] = {
        name = 'Zarząd',
        hex = 0xFFFF9900,
    },
}

for k,v in pairs(ranks) do
    v.rgb = fromcolor(v.hex)
    v.color = string.format("#%02X%02X%02X", v.rgb[1], v.rgb[2], v.rgb[3])
end

function getRankName(id)
    return ranks[id or 0].name or 'Gracz'
end

function getRankHex(id)
    return ranks[id or 0].color or '#889DB1'
end

function getRankRGB(id)
    return ranks[id or 0].rgb or {136, 157, 177}
    -- return ranks[id].rgb or {136, 157, 177}
end

function getRankColor(id)
    return ranks[id or 0].hex or 0xFF889DB1
end