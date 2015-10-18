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
	view=nil 
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

	self.shadow = display.newText(self.score, _W/2+2, 52, "Alba Matter", 30)
	self.shadow:setFillColor(0,0,0,.8)
	self.label  = display.newText(self.score, _W/2, 50, "Alba Matter", 31)
	self.label:setFillColor(1,1,1)
	Runtime:addEventListener( "score", self.addscore )
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
	Runtime:removeEventListener( "score", self.addscore )
end

-- listeners

function hudscore.addscore(event)
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

return hudscore