-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 05 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

local scene = scene

-- animations
local bombSequence = {
	{name="normal", frames={1}, time=1000, loopCount=0},
	{name="shake", start=1, count=2, time=1000, loopCount=0},
	{name="boom", frames={2}, time=1000, loopCount=0}
}
local bombSheet = graphics.newImageSheet("images/bomb.png", {height=113, width=112, numFrames=2, sheetContentWidth=225, sheetContentHeight=113})
	
---------------------------------------------
---- PROPERTIES
---------------------------------------------
local hudtimer = { 
	label=nil, 
	shadow=nil, 
	tleft=0,
	tlimit=0,
	id=nil, 
	bomb=nil,
	boom=nil,
	bar=nil,
	barbox=nil,
	heart=nil
}

----- Event Listeners ---------

local function tick(self, event)
	self.tleft = self.tleft-1
   	self.label.text  = self.tleft
   	self.shadow.text = self.tleft

   	local scale = ( (self.tleft-1) / self.tlimit )
   	if (scale > 0) then
   		transition.to( self.bar, { time=990,xScale=scale} )
   	else
   		self.bar.alpha = 0
   	end
	
	if(self.tleft==0)then
    	self.label.text  = ""
    	self.shadow.text = ""
 		audio.stop( self.heart )

    	-- boom 
 		self.boom = display.newImageRect("images/boom.png", 250, 256)
		self.boom.x = (_W * 0.5)
 		self.boom.y = (_H * 0.5)
		self.boom.yScale = .5
		self.boom.xScale = .5
		self.boom.alpha  = .1
		transition.to( self.boom, { time=600,xScale=1,yScale=1,alpha=1,transition=easing.outElastic, 
			onComplete=function( ... )
				transition.to( self.boom, { delay=2000, time=300,xScale=.1,yScale=.1, y=_H +20} )
			end} )

 		_G.soundManager:play("boom",{channel=4})
   
		-- bomb
 		self.bomb:setSequence("boom")
 		self.bomb:play()

 		-- destroy
		transition.to( self.view, { time=800, delay=2000, y=_H/2, 
			onComplete=function( ... )
				timer.performWithDelay( 300, function ( ... )
					self:destroy()
				end )
			end} )
		Runtime:dispatchEvent({ name = "timeout" } )
    
    elseif(self.tleft==5)then
 		self.bomb:setSequence("shake")
 		self.bomb:play()

 		audio.setVolume( 1, {channel=3} )
	 end
 end

function hudtimer:draw( limit )
	self.view   = display.newGroup( )
	self.tleft  = limit
	self.tlimit = limit
	
	-- bar box
	self.barbox = display.newRoundedRect( 60, _H - 35, _W - 80, 15, 5 )
	self.barbox.anchorX = 0
	self.barbox.anchorY = 0
	self.barbox.strokeWidth = 2
	self.barbox:setFillColor( 0,0,0,.8 )
	self.barbox:setStrokeColor( .8,0,0,1 )
	self.view:insert( self.barbox )

	-- bar
	self.bar = display.newRoundedRect( 60, _H - 35, _W - 80, 15, 5 )
	self.bar.anchorX = 0
	self.bar.anchorY = 0
	self.bar:setFillColor( 1,0,0, 1 )
	self.view:insert( self.bar )

	-- bomb
	self.bomb = display.newSprite( bombSheet, bombSequence )
	self.bomb.y = display.contentHeight - 64
	self.bomb.x = 45
	self.bomb:setSequence( "normal" )
	self.bomb:play( ) -- just in case we add an animation 
	self.view:insert( self.bomb )

	-- timer
	self.shadow = display.newText(limit, _W - 28, _H - 38, "Pokemon Solid", 35)
	self.shadow.anchorX = 30
	self.shadow:setFillColor(0,0,0)
	self.view:insert( self.shadow )
	
	self.label = display.newText(limit, _W - 30, _H - 40, "Pokemon Solid", 35)
	self.label.anchorX = 30
	self.label:setFillColor(1,1,1)
	self.view:insert( self.label )

	return self.view
end

function hudtimer:startCountdown( tleft )
	self.tlimit = tleft
	-- clean up
	if (self.id) then
		timer.cancel( self.id )
	end
	-- update
	if (tleft) then
		self.tleft = tleft
	end
	tick(self)
	-- dispatch
	self.id = timer.performWithDelay(1000,function(...) tick(self,...) end, self.tleft)

	-- sound
    self.heart = _G.soundManager:play("heart",{ loops=-1,channel=3 })
    audio.setVolume( .5, {channel=3} )
end

function hudtimer:destroy( )
	if (self.id   ) then timer.cancel( self.id ) end
	if (self.label) then self.label:removeSelf() end
	if (self.boom)  then self.boom:removeSelf() end
	if (self.bomb)  then self.bomb:removeSelf() end
	if (self.barbox)  then self.barbox:removeSelf() end
	if (self.bar)  then self.bar:removeSelf() end
	if (self.shadow)  then self.shadow:removeSelf() end
	self.tleft  = nil
	self.tlimit = nil
	self.label  = nil
	self.boom   = nil
	self.bomb   = nil
	self.bar    = nil
	self.shadow = nil
	self.barbox = nil
end

return hudtimer