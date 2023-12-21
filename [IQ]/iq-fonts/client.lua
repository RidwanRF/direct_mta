local fonts = {}

function getFont(font,size)
    if not font or not size then return end
    if not fonts[font] then
        fonts[font] = {}
    end

    fonts[font][size] = dxCreateFont('data/fonts/'..font..'.ttf',size)
    return fonts[font][size]
end