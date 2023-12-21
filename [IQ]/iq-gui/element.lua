addEvent('onButtonClick', true)
addEvent('onCheckboxInfoClick', true)

elements = {}
local elementCounter = 0

function createElement(type, x, y, w, h, color)
    elementCounter = elementCounter + 1
    local element = {
        id = elementCounter,
        type = type,
        x = x,
        y = y,
        w = w,
        h = h,
        color = color,
        alpha = 1,
        targetAlpha = 1,
        active = true,
    }
    elements[elementCounter] = element
    return elementCounter
end

function getElement(id)
    return elements[id]
end

function destroyUIElement(elementID)
    elements[elementID] = nil
end

function setElementActive(elementID, active)
    local element = elements[elementID]
    if not element then return end

    element.active = active
    if element.type == 'editbox' then
        element.focused = false
    end
end

function fadeElement(elementID, targetAlpha, easingTime, easing)
    local element = elements[elementID]
    if not element then return end
  
    element.startAlpha = element.alpha
    element.targetAlpha = targetAlpha
    element.fadeStartTime = getTickCount()
    element.fadeEndTime = getTickCount() + easingTime
    element.easingType = easing or 'Linear'
end

function interpolateToPosition(elementID, targetX, targetY, easingTime, easing)
    local element = elements[elementID]
    if not element then return end
  
    element.startX = element.x
    element.startY = element.y
    element.targetX = targetX
    element.targetY = targetY
    element.interpolateStartTime = getTickCount()
    element.interpolateEndTime = getTickCount() + easingTime
    element.interpolateEasingType = easing or 'Linear'
end
  
function setElementAlpha(elementID, alpha)
    local element = elements[elementID]
    if not element then return end
  
    element.alpha = alpha
    element.startAlpha = alpha
    element.targetAlpha = alpha
end

addEventHandler('onClientRender', root, function()
    for _, element in pairs(elements) do
        if element.fadeStartTime and element.fadeEndTime then
            local time = getTickCount()
            if time >= element.fadeEndTime then
                element.alpha = element.targetAlpha
                element.fadeStartTime = nil
                element.fadeEndTime = nil
                element.easingType = nil
            else
                local progress = (time - element.fadeStartTime) / (element.fadeEndTime - element.fadeStartTime)
                element.alpha = interpolateBetween(element.startAlpha, 0, 0, element.targetAlpha, 0, 0, progress, element.easingType)
            end
        end
        
        if element.interpolateStartTime and element.interpolateEndTime then
            local time = getTickCount()
            if time >= element.interpolateEndTime then
                element.x = element.targetX
                element.y = element.targetY
                element.interpolateStartTime = nil
                element.interpolateEndTime = nil
                element.interpolateEasingType = nil
            else
                local progress = (time - element.interpolateStartTime) / (element.interpolateEndTime - element.interpolateStartTime)
                element.x = interpolateBetween(element.startX, 0, 0, element.targetX, 0, 0, progress, element.interpolateEasingType)
                element.y = interpolateBetween(element.startY, 0, 0, element.targetY, 0, 0, progress, element.interpolateEasingType)
            end
        end
    end
end)

addEventHandler('onClientRender', root, function()
    for _, element in pairs(elements) do
        if element.type == 'button' then
            renderButton(element)
        elseif element.type == 'editbox' then
            renderEditbox(element)
        elseif element.type == 'checkbox' then
            renderCheckbox(element)
        end
    end
end, true, 'low-999')

addEventHandler('onClientRender', root, function()
    for _, element in pairs(elements) do
        if element.type == 'editbox' and isCursorShowing() and getKeyState('mouse1') and element.focused then
            local cx, cy = getCursorPosition()
            cx, cy = cx * sx, cy * sy
            
            local text = element.text
            if element.passworded then
                text = string.rep('•', #text)
            end
            local font = element.font
            local width = 0
            local caretIndex = 0
            local totalWidth = dxGetTextWidth(text, 1, font)
            for i = 1, utf8.len(text) do
                local charWidth = dxGetTextWidth(utf8.sub(text, 1, i), 1, font)
                if 
                    (element.alignX == 'left' and charWidth > cx - (element.x + element.paddingX)) or
                    (element.alignX == 'center' and charWidth > cx - (element.x + element.w/2 - totalWidth/2)) or
                    (element.alignX == 'right' and charWidth > cx - (element.x + element.w - totalWidth - element.paddingX))
                then
                    break
                end
                caretIndex = i
                width = charWidth
            end

            element.caretFinish = caretIndex
        end
    end
end, true, 'low-999')

addEventHandler('onClientClick', root, function(button, state, x, y)
    for _, element in pairs(elements) do
        if element.type == 'button' and x >= element.x and x <= element.x + element.w and y >= element.y and y <= element.y + element.h and element.active then
            triggerEvent('onButtonClick', root, element.id, button, state)
        elseif element.type == 'editbox' and state == 'down' and element.active then
            if x >= element.x and x <= element.x + element.w and y >= element.y and y <= element.y + element.h then
                -- if element.focused then
                    local text = element.text
                    if element.passworded then
                        text = string.rep('•', #text)
                    end
                    local font = element.font
                    local width = 0
                    local caretIndex = 0
                    local totalWidth = dxGetTextWidth(text, 1, font)
                    for i = 1, utf8.len(text) do
                        local charWidth = dxGetTextWidth(utf8.sub(text, 1, i), 1, font)
                        if 
                            (element.alignX == 'left' and charWidth > x - (element.x + element.paddingX)) or
                            (element.alignX == 'center' and charWidth > x - (element.x + element.w/2 - totalWidth/2)) or
                            (element.alignX == 'right' and charWidth > x - (element.x + element.w - totalWidth - element.paddingX))
                        then
                            break
                        end
                        caretIndex = i
                        width = charWidth
                    end

                    if not getKeyState('lshift') then
                        element.caretIndex = caretIndex
                    end
                    element.caretFinish = caretIndex
                -- else
                    element.focused = true
                    -- element.caretIndex = utf8.len(element.text)
                    -- element.caretFinish = utf8.len(element.text)
                -- end
            else
                element.focused = false
            end
        elseif element.type == 'checkbox' and x >= element.x and x <= element.x + element.h and y >= element.y and y <= element.y + element.h and element.active and state == 'down' then
            element.checked = not element.checked
        elseif element.type == 'checkbox' and state == 'down' then
            local textWidth = dxGetTextWidth(element.text, 1, element.font)
            local w = element.h + element.gap + textWidth

            if element.type == 'checkbox' and x >= element.x and x <= element.x + w and y >= element.y and y <= element.y + element.h and element.active then
                triggerEvent('onCheckboxInfoClick', root, element.id)
            end
        end
    end
end)

addEventHandler('onClientKey', root, function(key, state)
    for _, element in pairs(elements) do
        if element.type == 'editbox' and element.focused then
            if key == 'c' and getKeyState('lctrl') then
                local start = math.min(element.caretIndex, element.caretFinish)
                local finish = math.max(element.caretIndex, element.caretFinish)
                local selectedText = utf8.sub(element.text, start+1, finish)
                setClipboard(selectedText)
            elseif key == 'a' and getKeyState('lctrl') then
                element.caretIndex = 0
                element.caretFinish = #element.text
            elseif key == 'backspace' and state then
                if element.caretIndex == element.caretFinish then
                    if element.caretIndex > 0 then
                        element.text = utf8.sub(element.text, 1, element.caretIndex - 1) .. utf8.sub(element.text, element.caretIndex + 1)
                        element.caretIndex = element.caretIndex - 1
                        element.caretFinish = element.caretIndex
                    end
                else
                    local start = math.min(element.caretIndex, element.caretFinish)
                    local finish = math.max(element.caretIndex, element.caretFinish)
                    element.text = utf8.sub(element.text, 0, start) .. utf8.sub(element.text, finish+1)
                    element.caretIndex = #utf8.sub(element.text, 0, start)
                    element.caretFinish = element.caretIndex
                end
            elseif key == 'arrow_l' and state then
                if not getKeyState('lshift') then
                    local pos = math.min(element.caretIndex, element.caretFinish)
                    element.caretIndex = math.max(pos - 1, 0)
                    element.caretFinish = element.caretIndex
                else
                    element.caretFinish = math.max(element.caretFinish - 1, 0)
                end
            elseif key == 'arrow_r' and state then
                    if not getKeyState('lshift') then
                        local pos = math.max(element.caretIndex, element.caretFinish)
                        element.caretIndex = math.min(pos + 1, utf8.len(element.text))
                        element.caretFinish = element.caretIndex
                    else
                        element.caretFinish = math.min(element.caretFinish + 1, utf8.len(element.text))
                    end
            elseif key == 'delete' and state then
                if element.caretIndex < utf8.len(element.text) then
                    if element.caretIndex == element.caretFinish then
                        element.text = utf8.sub(element.text, 1, element.caretIndex) .. utf8.sub(element.text, element.caretIndex + 2)
                    else
                        local start = math.min(element.caretIndex, element.caretFinish)
                        local finish = math.max(element.caretIndex, element.caretFinish)
                        element.text = utf8.sub(element.text, 0, start) .. utf8.sub(element.text, finish+1)
                        element.caretIndex = #utf8.sub(element.text, 0, start)
                        element.caretFinish = element.caretIndex
                    end
                end
            end
        end
    end
end)

function charInput(char)
    for _, element in pairs(elements) do
        if element.type == 'editbox' and element.focused then
            local function insertChar()
                if element.caretIndex == element.caretFinish then
                    element.text = utf8.sub(element.text, 1, element.caretIndex) .. char .. utf8.sub(element.text, element.caretIndex + 1)
                    element.caretIndex = element.caretIndex + 1
                    element.caretFinish = element.caretIndex
                else
                    local start = math.min(element.caretIndex, element.caretFinish)
                    local finish = math.max(element.caretIndex, element.caretFinish)
                    element.text = utf8.sub(element.text, 0, start) .. char .. utf8.sub(element.text, finish+1)
                    element.caretIndex = #utf8.sub(element.text, 0, -start)+1
                    element.caretFinish = element.caretIndex
                end
            end

            if char == ' ' and element.space then
                if utf8.len(element.text) < element.maxChars then
                    insertChar()
                end
            elseif utf8.len(element.text) < element.maxChars and (not string.match(char, '.*[@!#$%^&*()?<>].*') or (element.specialCharacters and string.match(char, element.specialCharacters))) and char ~= ' ' then
                insertChar()
            end
        end
    end
end
addEventHandler('onClientCharacter', root, charInput)

addEventHandler('onClientPaste', root, function(paste)
    for i = 1, utf8.len(paste) do
        local char = utf8.sub(paste, i, i)
        charInput(char)
    end
end)

bindKey('tab', 'down', function()
    local active = false
    local iterator = getKeyState('lshift') and reversePairs or pairs

    for _,element in iterator(elements) do
        if element.type == 'editbox' then
            if active then
                active.focused = false
                element.focused = true
                element.caretIndex = utf8.len(element.text)
                break
            elseif element.focused then
                active = element
            end
        end
    end
end)

function get_timestamp(year, month, day, hour, minute, second)
    local t = os.time({
        year = year,
        month = month,
        day = day,
        hour = hour,
        min = minute,
        sec = second
    })
    return t
end