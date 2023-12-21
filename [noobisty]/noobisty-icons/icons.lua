local icons = {

    -- Jobs
    ['start'] = dxCreateTexture("buttons/start.png", "argb", true, "clamp"),
    ['upgrade'] = dxCreateTexture("buttons/upgrade.png", "argb", true, "clamp"),
    ['cancel'] = dxCreateTexture("buttons/cancel.png", "argb", true, "clamp"),
    ['buy'] = dxCreateTexture("buttons/buy.png", "argb", true, "clamp"),

}

function getIcon(icon)
    if icons[icon] then
        return icons[icon]
    end
end