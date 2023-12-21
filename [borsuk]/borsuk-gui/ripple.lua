local clicks = {}
local screenW, screenH = guiGetScreenSize()

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
		 local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		 if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			  for i, v in ipairs( aAttachedFunctions ) do
				   if v == func then
					return true
			   end
		  end
	 end
	end
	return false
end

function buttonClearRipples()
	for i,v in ipairs(clicks) do 
		table.remove(clicks, i)
	end 
	removeEventHandler('onClientRender',root,render)
end

function buttonRippleAdd(x,y,w,h,time)

	buttonClearRipples()

	if not isEventHandlerAdded('onClientRender', root, render) then
		addEventHandler('onClientRender',root,render)
	end 

	local cx,cy = getCursorPosition()
	cx,cy = cx*screenW,cy*screenH

	table.insert(clicks, {
			clickid = #clicks,
			posx=x,
			posy=y,
			posw=w,
			posh=h,
			clickx = cx,
			clicky = cy,
			target = dxCreateRenderTarget(w,h,true),
			tick = getTickCount(),
			time = time or 1000,
			kierunek = 'up',
            alpha = 0,
            totalRadius = 0,
		}
	)

	return #clicks
end

function buttonRippleRemove(id)
	for i,v in ipairs(clicks) do
		if v.clickid == id then
			table.remove(clickid, i)
		end
	end
end

local tick


render = function()

    for i,v in ipairs(clicks) do

		if getTickCount() - v.tick >= v.time and v.kierunek == 'down' and not getKeyState('mouse1') then
			table.remove(clicks, i)
			if #clicks < 1 then 
				removeEventHandler('onClientRender',root,render)
			end 
        elseif getTickCount() - v.tick >= v.time and v.kierunek == 'up' and not getKeyState('mouse1') then
			v.kierunek = 'down'
			v.tick = getTickCount()
		end
		
		local x,y,w,h = v.posx, v.posy, v.posw, v.posh
		
		if v.kierunek == 'up' then 
		    v.alpha = interpolateBetween ( v.alpha,0,0,25,0,0, (getTickCount()-v.tick)/v.time, "Linear")
		else 
		    v.alpha = interpolateBetween ( v.alpha,0,0,0,0,0, (getTickCount()-v.tick)/v.time, "Linear")
		end

		if v.kierunek == 'up' then 
		    v.totalRadius = interpolateBetween ( 0,0,0,w,0,0, (getTickCount()-v.tick)/v.time, "InOutQuad")
		else 
		    v.totalRadius = interpolateBetween ( w,0,0,w,0,0, (getTickCount()-v.tick)/v.time, "InOutQuad")
		end 
		
		clickX = v.clickx
		clickY = v.clicky
		
		dxSetRenderTarget(v.target)
		
		clickX = clickX - x
		clickY = clickY - y
		
		dxDrawCircle(clickX,clickY,v.totalRadius,0,360,tocolor(0,0,0,255),tocolor(0,0,0,255),256,1,false)
		
		dxSetRenderTarget()
		
		dxDrawImage ( x, y, w, h, v.target, 0, 0, 0, tocolor(255, 255, 255, v.alpha),true)
		
		
		
	end

end