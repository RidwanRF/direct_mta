function createCheckbox(text, x, y, w, h, color, data)
    local elementID = createElement('checkbox', x, y, w, h, color)
    local element = getElement(elementID)
  
    -- Add button specific properties and functions
    element.text = text
    element.font = data.font or 'default'
    element.image = data.image or nil
    element.textColor = data.textColor or {255, 255, 255, 255}
    element.textHoverColor = data.textHoverColor or element.textColor
    element.textActiveColor = data.textActiveColor or element.textColor
    element.hoverColor = data.hoverColor or color
    element.activeColor = data.activeColor or color
    element.hoverImage = data.hoverImage or nil
    element.activeImage = data.activeImage or nil
    element.gap = data.gap or 3
    element.w = data.w
  
    return elementID
end

function setCheckboxText(element, text)
    local element = getElement(element)
    if not element then return end
    element.text = text
end

function isCheckboxChecked(element)
    local element = getElement(element)
    if not element then return end
    return element.checked
end

function renderCheckbox(element)
    local x, y, w, h = element.x, element.y, element.w, element.h
    local textWidth = dxGetTextWidth(element.text, 1, element.font)
    w = h + element.gap + textWidth
    local r, g, b, a = unpack(element.color)
    local tr, tg, tb, ta = unpack(element.textColor)
    local hovered = isMouseInPosition(x, y, w, h)

    if hovered and element.hoverColor then
        r, g, b, a = unpack(element.hoverColor)
    elseif element.checked and element.activeColor then
        r, g, b, a = unpack(element.activeColor)
    end

    if hovered and element.textHoverColor then
        tr, tg, tb, ta = unpack(element.textHoverColor)
    elseif element.checked and element.textActiveColor then
        tr, tg, tb, ta = unpack(element.textActiveColor)
    end

    a = (a or 255) * element.alpha
    ta = (ta or 255) * element.alpha

    w = (element.w or h)
    if element.image then
        local image = element.image
        if element.checked and element.activeImage then
            image = element.activeImage
        elseif hovered and element.hoverImage then
            image = element.activeImage
        end

        dxDrawImage(x, y, w, h, image, 0, 0, 0, tocolor(r, g, b, a))
    else
        dxDrawRectangle(x, y, w, h, tocolor(r, g, b, a))
    end

    dxDrawText(element.text, x + h + element.gap, y + h/2, nil, nil, tocolor(tr, tg, tb, ta), 1, element.font, 'left', 'center', false, false, false, true)
end