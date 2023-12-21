local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f, t, easing, duration, onChange, onEnd)
	assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
	assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
	assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
	table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims, a)
	end
end

addEventHandler("onClientRender", root, function( )
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims, k)
		end
	end
end)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function wordWrap(text, maxwidth, scale, font, colorcoded)
    local lines = {}
    local words = split(text, " ") -- this unfortunately will collapse 2+ spaces in a row into a single space
    local line = 1 -- begin with 1st line
    local word = 1 -- begin on 1st word
    local endlinecolor
    while (words[word]) do -- while there are still words to read
        repeat
            if colorcoded and (not lines[line]) and endlinecolor and (not string.find(words[word], "^#%x%x%x%x%x%x")) then -- if on a new line, and endline color is set and the upcoming word isn't beginning with a colorcode
                lines[line] = endlinecolor -- define this line as beginning with the color code
            end
            lines[line] = lines[line] or "" -- define the line if it doesnt exist

            if colorcoded then
                local rw = string.reverse(words[word]) -- reverse the string
                local x, y = string.find(rw, "%x%x%x%x%x%x#") -- and search for the first (last) occurance of a color code
                if x and y then
                    endlinecolor = string.reverse(string.sub(rw, x, y)) -- stores it for the beginning of the next line
                end
            end
      
            lines[line] = lines[line]..words[word] -- append a new word to the this line
            lines[line] = lines[line] .. " " -- append space to the line

            word = word + 1 -- moves onto the next word (in preparation for checking whether to start a new line (that is, if next word won't fit)
        until ((not words[word]) or dxGetTextWidth(lines[line].." "..words[word], scale, font, colorcoded) > maxwidth) -- jumps back to 'repeat' as soon as the code is out of words, or with a new word, it would overflow the maxwidth
    
        lines[line] = string.sub(lines[line], 1, -2) -- removes the final space from this line
        if colorcoded then
            lines[line] = string.gsub(lines[line], "#%x%x%x%x%x%x$", "") -- removes trailing colorcodes
        end
        line = line + 1 -- moves onto the next line
    end -- jumps back to 'while' the a next word exists
    return lines
end

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local targetCamera = false

local function camRender()
	if not targetCamera then return end
	local cx, cy, cz, lx, ly, lz = getCameraMatrix()
	cx, cy, cz = interpolateBetween(cx, cy, cz, targetCamera[1], targetCamera[2], targetCamera[3], 0.01, 'Linear')
	lx, ly, lz = interpolateBetween(lx, ly, lz, targetCamera[4], targetCamera[5], targetCamera[6], 0.02, 'Linear')

	setCameraMatrix(cx, cy, cz, lx, ly, lz)
end

addEventHandler("onClientPreRender",root,camRender)

function smoothMoveCamera(cx, cy, cz, lx, ly, lz, time)
	targetCamera = {cx, cy, cz, lx, ly, lz, time}
end

function stopSmoothMoveCamera()
	targetCamera = false
end

setCameraTarget(localPlayer)

local txt = dxCreateTexture('data/images/spawn_line.png')
local txt2 = dxCreateTexture('data/images/icon_spawn.png')
sx,sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local font1 = exports['iq-fonts']:getFont('bold',12/zoom)
local font2 = exports['iq-fonts']:getFont('medium',11/zoom)

function drawMarker(x, y, z, text, cz2, sx2,sy2,w,h, description)
    local cx, cy, cz = getCameraMatrix()
    local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz2 or cz)
    dxDrawMaterialLine3D(x, y, z, x, y, cz2 or cz, txt, dist/80)

    local x, y = getScreenFromWorldPosition(x, y, cz2 or cz)
    if x and y then
		x = sx2 + x/sx * w
        y = sy2 + y/sy * h

        -- dxDrawCircle(x, y - 14, 14, 0, 360, 0xFFFFFFFF, 0xFFFFFFFF)
		dxDrawImage(x - 25,y + 23, 23, 23, txt2)
		dxDrawText(text, x + 7, y + 30, nil, nil, tocolor(230,230,230),1,font1,'left','center')
		dxDrawText(description:sub(1,30), x + 7, y + 30 + dxGetFontHeight(1,font1) - 3, nil, nil, tocolor(230,230,230,200),1,font2,'left','center')
        -- dxDrawText(text, x + 14, y + 14, nil, nil, white, 1)
        -- dxDrawText(text, x - 14, y + 14, nil, nil, white, 1, 'top', 'right')
    end
end
