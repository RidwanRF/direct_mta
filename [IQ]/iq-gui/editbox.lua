function createEditbox(placeholderText, x, y, w, h, color, data)
    local elementID = createElement('editbox', x, y, w, h, color)
    local element = getElement(elementID)
  
    -- Add editbox specific properties and functions
    element.text = ''
    element.placeholderText = placeholderText
    element.passworded = data.passworded or false
    element.maxChars = data.maxChars or 16
    element.font = data.font or 'default'
    element.alignX = data.alignX or 'center'
    element.alignY = data.alignY or 'center'
    element.paddingX = data.paddingX or data.padding or 0
    element.paddingY = data.paddingY or data.padding or 0
    element.borderRadius = data.borderRadius or 0
    element.image = data.image or nil
    element.textColor = data.textColor or {255, 255, 255, 255}
    element.placeholderColor = data.placeholderColor or {255, 255, 255, 255}
    element.caretColor = data.caretColor or {255, 255, 255, 255}
    element.caretWidth = data.caretWidth or 1
    element.caretHeight = data.caretHeight or nil
    element.caretIndex = 0
    element.caretFinish = 0
    element.hoverColor = data.hoverColor or color
    element.focusColor = data.focusColor or color
    element.hoverImage = data.hoverImage or nil
    element.focusImage = data.focusImage or nil
    element.icon = data.icon or nil
    element.iconPadding = data.iconPadding or 0
    element.specialCharacters = data.specialCharacters or false

    return elementID
end

function setEditboxText(element, text)
    local element = getElement(element)
    if not element then return end
    element.text = text
end

function getEditboxText(element)
    local element = getElement(element)
    if not element then return end
    return element.text
end

function renderEditbox(element)
    local x, y, w, h = element.x, element.y, element.w, element.h
    local r, g, b, a = unpack(element.color)
    local hovered = isMouseInPosition(element.x, element.y, element.w, element.h)
    local hoverColor = element.hoverColor
    local focusColor = element.focusColor

    if element.focused and focusColor then
        r, g, b, a = unpack(focusColor)
    elseif hovered and hoverColor then
        r, g, b, a = unpack(hoverColor)
    end

    a = (a or 255) * element.alpha

    -- Draw the rectangle background
    if element.image then
        local image = element.image
        if element.focused and element.focusImage then
            image = element.focusImage
        elseif hovered and element.hoverImage then
            image = element.hoverImage
        end

        dxDrawImage(x, y, w, h, image, 0, 0, 0, tocolor(r, g, b, a))
    else
        if element.borderRadius then
            dxDrawRoundedRectangle(x, y, w, h, element.borderRadius, tocolor(r, g, b, a))
        else
            dxDrawRectangle(x, y, w, h, tocolor(r, g, b, a))
        end
    end

    if element.icon then
        local h = element.h - element.iconPadding*2
        dxDrawImage(element.x + element.iconPadding, element.y + element.iconPadding, h, h, element.icon, 0, 0, 0, tocolor(255,255,255,255*element.alpha))
    end

    local text = element.text
    if element.passworded then
        text = string.rep('•', #text)
    end

    -- Draw the caret if the editbox is focused
    if element.focused and element.caretIndex ~= element.caretFinish then
        local caretR, caretG, caretB, caretA = unpack(element.caretColor)
        caretA = (caretA or 255)
        defaultCaretA = caretA
        caretA = element.alpha
        local blinkAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, getTickCount()%700/700, 'CosineCurve')
        caretA = caretA * blinkAlpha

        local caretWidth = element.caretWidth or 1
        local caretHeight = element.caretHeight or (h * (2/3))

        local caretX = x + element.paddingX + dxGetTextWidth(utf8.sub(text, 1, element.caretIndex), 1, element.font)
        if element.alignX == 'center' then
            caretX = x + element.w / 2 - dxGetTextWidth(text, 1, element.font)/2 + dxGetTextWidth(utf8.sub(text, 1, element.caretIndex), 1, element.font)
        elseif element.alignX == 'right' then
            caretX = x + element.w - element.paddingX - dxGetTextWidth(text, 1, element.font) + dxGetTextWidth(utf8.sub(text, 1, element.caretIndex), 1, element.font)
        end
        caretX = math.min(caretX, element.x + element.w - element.paddingX)
    
        local caretTX = x + element.paddingX + dxGetTextWidth(utf8.sub(text, 1, element.caretFinish), 1, element.font)
        if element.alignX == 'center' then
            caretTX = x + element.w / 2 - dxGetTextWidth(text, 1, element.font)/2 + dxGetTextWidth(utf8.sub(text, 1, element.caretFinish), 1, element.font)
        elseif element.alignX == 'right' then
            caretTX = x + element.w - element.paddingX - dxGetTextWidth(text, 1, element.font) + dxGetTextWidth(utf8.sub(text, 1, element.caretFinish), 1, element.font)
        end
        caretTX = math.min(caretTX, element.x + element.w - element.paddingX)
        local tx, ty, tw, th = x + element.paddingX, y + element.paddingY, x + w - element.paddingX, y + h - element.paddingY
        local caretWidth = caretTX - caretX
        if caretWidth < 0 then
            caretX = caretX + caretWidth
            caretWidth = -caretWidth
        end

        if caretX < tx then
            local diff = tx-caretX
            caretX = caretX + diff
            caretWidth = caretWidth - diff
        end

        dxDrawRectangle(caretX, y + h / 2 - caretHeight / 2, caretWidth, caretHeight, tocolor(caretR, caretG, caretB, defaultCaretA/2))
    end

    -- Draw the placeholder text if there's no actual text
    if #element.text == 0 and element.placeholderText and not element.focused then
        local placeholderR, placeholderG, placeholderB, placeholderA = unpack(element.placeholderColor)
        placeholderA = placeholderA or 255
        placeholderA = placeholderA * element.alpha
        dxDrawText(element.placeholderText, x + element.paddingX, y + element.paddingY, x + w - element.paddingX, y + h - element.paddingY, tocolor(placeholderR, placeholderG, placeholderB, placeholderA), 1, element.font, element.alignX, element.alignY)
    end

    -- Draw the actual text
    local textR, textG, textB, textA = unpack(element.textColor)
    textA = (textA or 255) * element.alpha

    dxDrawText(text, x + element.paddingX, y + element.paddingY, x + w - element.paddingX, y + h - element.paddingY, tocolor(textR, textG, textB, textA), 1, element.font, element.alignX, element.alignY, true)

    -- Draw the caret if the editbox is focused
    if element.focused and element.caretIndex == element.caretFinish then
        local caretR, caretG, caretB, caretA = unpack(element.caretColor)
        caretA = (caretA or 255)
        defaultCaretA = caretA
        caretA = caretA * element.alpha
        local blinkAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, getTickCount()%700/700, 'CosineCurve')
        caretA = caretA * blinkAlpha

        local caretWidth = element.caretWidth or 1
        local caretHeight = element.caretHeight or (h * (2/3))

        local caretX = x + element.paddingX + dxGetTextWidth(utf8.sub(text, 1, element.caretIndex), 1, element.font)
        if element.alignX == 'center' then
            caretX = x + element.w / 2 - dxGetTextWidth(text, 1, element.font)/2 + dxGetTextWidth(utf8.sub(text, 1, element.caretIndex), 1, element.font)
        elseif element.alignX == 'right' then
            caretX = x + element.w - element.paddingX - dxGetTextWidth(text, 1, element.font) + dxGetTextWidth(utf8.sub(text, 1, element.caretIndex), 1, element.font)
        end
        caretX = math.min(caretX, element.x + element.w - element.paddingX)

        dxDrawRectangle(caretX, y + h / 2 - caretHeight / 2, caretWidth, caretHeight, tocolor(caretR, caretG, caretB, caretA))
    end
end

-- if getPlayerName(localPlayer) ~= 'borsuczyna' then return end
-- local edit = createEditbox('test', 450, 450, 250, 45, {25, 25, 25}, {
--     borderRadius = 10,
--     alignX = 'center',
--     paddingX = 10,
--     caretWidth = 2,
--     caretHeight = 20,
--     caretColor = {255, 0, 0},
--     font = 'default-bold',
--     maxChars = 200
-- })
-- showCursor(true)
-- setElementAlpha(edit, 0)
-- fadeElement(edit, 1, 1000, 'InQuad')

-- local btn = createButton('test', 250, 300, 250, 45, {25, 25, 25}, {
--     borderRadius = 10,
--     hoverColor = {255, 0, 0},
-- })
-- setElementAlpha(btn, 0)
-- fadeElement(btn, 1, 1000, 'InQuad')

-- addEventHandler('onButtonClick', root, function(element, button, state)
--     if element == btn and button == 'left' and state == 'down' then
--         interpolateToPosition(btn, 250, 350, 1000, 'OutQuad')

--         setElementActive(btn)
--         -- setElementActive(edit)
--         -- fadeElement(btn, 0, 1000, 'InQuad')
--         -- fadeElement(edit, 0, 1000, 'InQuad')
--         -- setTimer(function()
--         --     destroyElement(btn)
--         --     destroyElement(edit)
--         -- end, 1000, 1)
--     end
-- end)