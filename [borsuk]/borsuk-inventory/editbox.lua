local editbox = {
    selected = false,
}

function drawEditbox(id, placeholder, x, y, w, h)
    if not editbox[id] then
        editbox[id] = ''
    end

    dxDrawImage(x, y, w, h, 'data/editbox.png')
    local active = editbox.selected == id
    dxDrawText((active or #editbox[id] > 0) and (editbox[id] .. ((getTickCount() % 600 > 300 and active) and '|' or '')) or placeholder, x + 15/zoom, y, x + w - 30/zoom, y + h, tocolor(255, 255, 255, active and 200 or (#editbox[id] > 0 and 160 or 100)), 1, regular3, 'left', 'center')

    if isMouseInPosition(x, y, w, h) and getKeyState('mouse1') then
        editbox.selected = id
    elseif getKeyState('mouse1') and editbox.selected == id then
        editbox.selected = false
    end
end

function getEditboxText(id)
    return editbox[id]
end

addEventHandler('onClientKey', root, function(key, state)
    if not state or not editbox.selected then return end

    if tonumber(key) then
        if #editbox[editbox.selected] < 4 then
            editbox[editbox.selected] = editbox[editbox.selected] .. key
        end
    elseif key == 'backspace' then
        editbox[editbox.selected] = editbox[editbox.selected]:sub(1, -2)
    elseif key == 'enter' then
        editbox.selected = false
    end
end)

function isEditboxActive()
    return editbox.selected
end