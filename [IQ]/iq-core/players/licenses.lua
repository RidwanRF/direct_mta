function addPlayerLicense(player, license)
    local licenses = getElementData(player, 'player:licenses') or {}
    licenses[license] = true
    setElementData(player, 'player:licenses', licenses)
end

function isPlayerHaveLicense(player, license)
    local licenses = getElementData(player, 'player:licenses') or {}
    return licenses[license]
end