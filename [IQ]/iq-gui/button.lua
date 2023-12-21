function createButton(text, x, y, w, h, color, data)
    local elementID = createElement('button', x, y, w, h, color)
    local element = getElement(elementID)
  
    -- Add button specific properties and functions
    element.text = text
    element.font = data.font or 'default'
    element.alignX = data.alignX or 'center'
    element.alignY = data.alignY or 'center'
    element.paddingX = data.paddingX or data.padding or 0
    element.paddingY = data.paddingY or data.padding or 0
    element.borderRadius = data.borderRadius or 0
    element.image = data.image or nil
    element.textColor = data.textColor or {255, 255, 255, 255}
    element.hoverColor = data.hoverColor or color
    element.hoverImage = data.hoverImage or nil
  
    return elementID
end

function setButtonText(element, text)
    local element = getElement(element)
    if not element then return end
    element.text = text
end

function renderButton(element)
    local x, y, w, h = element.x, element.y, element.w, element.h
    local r, g, b, a = unpack(element.color)
    local tr, tg, tb, ta = unpack(element.textColor)
    local hovered = isMouseInPosition(element.x, element.y, element.w, element.h)
    local hoverColor = element.hoverColor
    r, g, b, a = r or 255, g or 255, b or 255, a or 255
    tr, tg, tb, ta = tr or 255, tg or 255, tb or 255, ta or 255
    
    if hovered and hoverColor then
        r, g, b, a = unpack(hoverColor)
    end
    
    a, ta = (a or 255) * element.alpha, ta * element.alpha
    
    if element.image then
        dxDrawImage(x, y, w, h, (hovered and element.hoverImage) and element.hoverImage or element.image, 0, 0, 0, tocolor(r, g, b, a))
    else
        if element.borderRadius then
            dxDrawRoundedRectangle(x, y, w, h, element.borderRadius, tocolor(r, g, b, a))
        else
            dxDrawRectangle(x, y, w, h, tocolor(r, g, b, a))
        end
    end

    dxDrawText(
        element.text,
        x + element.paddingX,
        y + element.paddingY,
        x + w - element.paddingX,
        y + h - element.paddingY,
        tocolor(tr, tg, tb, ta),
        1,
        element.font,
        element.alignX,
        element.alignY
    )
end