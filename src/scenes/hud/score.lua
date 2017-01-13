-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 07 Jun 2014

-------------------------------------------------------------------------

-- animations
local greemSequence = {
	{name="start", start=1, count=20, time=1500, loopCount=1}
}
local greemSheet = graphics.newImageSheet("images/animation_score_green.png", {width=120, height=120, numFrames=20, sheetContentWidth=600, sheetContentHeight=480 })

-- properties
local hudscore = { 
	score=0, 
	label=nil, 
	shadow=nil, 
	animation=nil, 
	view=nil,
	healthFull=nil
}


-- functions

function hudscore:draw( score )
	self.score  = score or 0

	if (self.view) then return end
	self.view = display.newGroup( )
	
	self.animation = display.newSprite( greemSheet, greemSequence )
	self.animation.y = 27
	self.animation.x = _W/2
	self.animation:setSequence( "start" )
	self.view:insert(self.animation)

	self.shadow = display.newText(self.score, _W/2+2, 52, "Alba Matter", 30)
	self.shadow:setFillColor(0,0,0,.8)
	self.view:insert(self.shadow)
	self.label  = display.newText(self.score, _W/2, 50, "Alba Matter", 31)
	self.label:setFillColor(1,1,1)
	self.view:insert(self.label)


	-- Overlay the "outline" object over the "filled" object
	local healthEmpty = display.newImageRect( "images/health-empty.png", 25, 300 )
	healthEmpty.x = 15
	healthEmpty.y = 150
	self.view:insert(healthEmpty)

	-- Place the "filled" object on the screen
	self.healthFull = display.newImageRect( "images/health-full.png", 25, 300 )
	self.healthFull.x = 15
	self.healthFull.y = 150
	self.view:insert(self.healthFull)
	 
	-- Create the mask object
	local healthMask = graphics.newMask( "images/health-mask.png" )
	-- Apply the mask to the bottom image ('filledUI')
	self.healthFull:setMask( healthMask )
	self.healthFull.maskY = 10
	 
	Runtime:addEventListener( "score", self.eventScore )
	Runtime:addEventListener( "health", self.eventHealth )
end


function hudscore:destroy( )
	if (self.label ) then self.label:removeSelf()  end
	if (self.shadow) then self.shadow:removeSelf() end
	if (self.view  ) then self.view:removeSelf()   end
	if (self.animation) then self.animation:removeSelf() end
	self.animation = nil
	self.label  = nil
	self.shadow = nil
	self.view   = nil
	self.score  = 0
	Runtime:removeEventListener( "score", self.eventScore )
	Runtime:removeEventListener( "health", self.eventHealth )
end

-- listeners
function hudscore.eventScore(event)
	local value = event.value or 0
	self = hudscore
	-- don't let the score be negative
	self.score  = math.max( 0, self.score + value )
	self.shadow.text = self.score
	self.label.text  = self.score

	if (value > 500) then
		self.animation:play()
		local channel = _G.soundManager:play("warp", {delay=100})
		audio.setVolume( .2, {channel=channel} )
	end
end

function hudscore.eventHealth( event )
	local value = event.value or 0
	local min = 10
	local max = 250
	transition.to(hudscore.healthFull, {maskY = max - ((max - min) * value), time = 1000})
end

return hudscore