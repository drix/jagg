-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 07 Jun 2014

-------------------------------------------------------------------------

-- animations
local greemSequence = {
	{name="start", start=1, count=35, time=1000, loopCount=3}
}
local greemSheet = graphics.newImageSheet("images/animation_intro_green.png", {width=180, height=180, numFrames=35, sheetContentWidth=900, sheetContentHeight=1260 })

-- Properties
local hudintro = { 
	label=nil, 
	shadow=nil, 
	animation=nil,
	view=nil, 
	background=nil 
}

-- listeners
local function tick( self, ... )
    if not (self.label) then return end
	self.time = self.time - 1
	if (self.time == 0) then
		transition.to( self.label, { y=_H, time=200})
		transition.to( self.shadow, { y=_H, time=200})
		
		transition.to( self.view, { alpha=0, time=200,
			onComplete=function( ... )
				timer.performWithDelay( 10, function ( ... ) 
					self:destroy() 
					Runtime:dispatchEvent( {name="startGame"} )
				end )
			end} )
	else
		self.label.text  = self.time
		self.shadow.text = self.time
		_G.soundManager:play("count")
		timer.performWithDelay( 1000, function ( ... ) tick(self, ...) end )
	end
end

-- functions

function hudintro:draw( )
    if (self.view) then return end
	self.view = display.newGroup( )

	self.background = display.newRect( 0, 0, _W, _H )
	self.background:setFillColor( 0,0,0,.6 )
	self.background.anchorY = 0
	self.background.anchorX = 0
	self.view:insert(self.background)

	self.animation = display.newSprite( greemSheet, greemSequence )
	self.animation.y = _H/2
	self.animation.x = _W/2
	self.animation.alpha  = 0
	self.view:insert( self.animation )

	self.time = 3

	self.shadow = display.newText(self.time, _W/2+4, _H/2+4, "Alba Matter", 100)
	self.shadow:setFillColor(0,0,0,.8)
	self.shadow.xScale = 1.2
	self.shadow.yScale = 1.2
	self.shadow.alpha  = 0
	self.view:insert( self.shadow)
	
	self.label  = display.newText(self.time, _W/2, _H/2, "Alba Matter", 100)
	self.label:setFillColor(1,1,1)
	self.label.xScale = 0.1
	self.label.yScale = 0.1
	self.label.alpha  = 0
	self.view:insert( self.label)
			
	return self.view
end

function hudintro:play( time )
	self.time = time or 3
	-- play the green animation
	transition.to( self.animation, { 
		alpha=1, 
		time=100, 
		onComplete = function( ... )
			if(self.animation) then
				self.animation:play()
			end
		end
	} )
	-- play the text and start the count down

	timer.performWithDelay( 300, function () _G.soundManager:play("count") end )

	transition.to( self.shadow, { xScale=1, yScale=1, alpha=1, time=400, delay=200, transition=easing.outBounce}) 
	transition.to( self.label, { xScale=1, yScale=1, alpha=1, time=400, delay=200, transition=easing.outBounce,
		onComplete=function( ... )
			timer.performWithDelay( 800, function ( ... ) tick(self, ...) end )
		end} )
end

function hudintro:destroy( )
	if (self.background) then self.background:removeSelf() end
	if (self.animation ) then self.animation:removeSelf()  end
	if (self.label  ) then self.label:removeSelf()  end
	if (self.shadow ) then self.shadow:removeSelf() end
	if (self.view   ) then self.view:removeSelf()   end
	self.background = nil
	self.animation  = nil
	self.label  = nil
	self.shadow = nil
	self.view   = nil
end

return hudintro