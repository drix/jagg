-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 07 Jun 2014

-------------------------------------------------------------------------
local widget  = require( "widget" )

-- properties
local hudgameover = { 
	btRestart=nil,
	star1=nil, 
	star2=nil,  
	star3=nil,
	plin1=nil, 
	plin2=nil,
	plin3=nil,
	view=nil,
	music=nil
}

-- animations

local starData = {
	{name="spin", start=1, count=23, time=800, loopCount=0},
	{name="off", frames={24}, time=1000, loopCount=1}
}
local starSheet = graphics.newImageSheet("images/stars.png", {height=50, width=52, numFrames=24, sheetContentWidth=315, sheetContentHeight=200})

local plinData = {
	{name="plin", start=1, count=25, time=800, loopCount=1}
}
local plinSheet = graphics.newImageSheet("images/plin.png", {height=100, width=100, numFrames=25, sheetContentWidth=500, sheetContentHeight=500})

local restartSheet = graphics.newImageSheet("images/playagain.png", {height=55, width=200, numFrames=2, sheetContentWidth=200, sheetContentHeight=110})
	

-- functions

function hudgameover:draw( )
	if (self.view) then return end
	self.view = display.newGroup( )
 	self.view.alpha = 0
 	self.view.y = 120

 	-- stars
	self.star1 = display.newSprite( starSheet, starData )
	self.star1.x = _W/2 - 70
	self.star1:setSequence( "off" )
	self.view:insert( self.star1 )

	self.star2 = display.newSprite( starSheet, starData )
	self.star2.x = _W/2
	self.star2:setSequence( "off" )
	self.view:insert( self.star2 )

	self.star3 = display.newSprite( starSheet, starData )
	self.star3.x = _W/2 + 70
	self.star3:setSequence( "off" )
	self.view:insert( self.star3 )

	-- plins animations
	self.plin1   = display.newSprite( plinSheet, plinData )
	self.plin1.x = _W/2 - 70
	self.plin1:addEventListener( "sprite", function( event )
		if (event.phase == "ended") then
			self.star1:setSequence( "spin" )
			self.star1:play( )
		end
	end)
	self.view:insert( self.plin1 )

	self.plin2   = display.newSprite( plinSheet, plinData )
	self.plin2.x = _W/2
	self.plin2:addEventListener( "sprite", function( event )
		if (event.phase == "ended") then
			self.star2:setSequence( "spin" )
			self.star2:play( )
		end
	end)
	self.view:insert( self.plin2 )

	self.plin3   = display.newSprite( plinSheet, plinData )
	self.plin3.x = _W/2 + 70
	self.plin3:addEventListener( "sprite", function( event )
		if (event.phase == "ended") then
			self.star3:setSequence( "spin" )
			self.star3:play( )
		end
	end)
	self.view:insert( self.plin3 )

    -- button start
	self.btRestart = widget.newButton( { 
		width=189, height=46, --onRelease=self.restart, -- release action added laters to avoid itermitent bug, it may be related to the widget and transition.to
		x=(_W/2+8), y=(_H-self.view.y),
		sheet=restartSheet, defaultFrame=2, overFrame=1
 	})
	self.btRestart.fixY  = (_H/2) - self.view.y
 	self.btRestart.alpha = 0
 	self.view:insert(self.btRestart)

 	return self.view
end

function hudgameover:play( delay, score )
	transition.to( self.view, { alpha=1, time=100, delay=delay, onComplete=function( ... )
		if (score > 5000) then 
			timer.performWithDelay(200, function ( )
				_G.soundManager:play("star")
				self.plin1:play() 
			end)
		end
		if (score > 10000) then 
			timer.performWithDelay(500, function ( )
				_G.soundManager:play("star")
				self.plin2:play() 
			end)
		end
		if (score > 20000) then 
			timer.performWithDelay(800, function ( )
				_G.soundManager:play("star")
				self.plin3:play() 
			end)
		end

 		transition.to( self.btRestart, { alpha=1, y=self.btRestart.fixY, time=400, delay=300,
			onComplete=function( ... )
				self.music = _G.soundManager:play("end",{ loops=-1, channel=5 })
				Runtime:addEventListener( "enterFrame", self.enterFrame ) 
				self.btRestart:addEventListener( "tap", self.restart )
		end})	
	end})

end

function hudgameover:destroy( )
	Runtime:removeEventListener( "enterFrame", self.enterFrame ) 
	if (self.btRestart) then self.btRestart:removeSelf() end
	if (self.star1) then self.star1:removeSelf() end
	if (self.star2) then self.star2:removeSelf() end
	if (self.star3) then self.star3:removeSelf() end
	if (self.plin1) then self.plin1:removeSelf() end
	if (self.plin2) then self.plin2:removeSelf() end
	if (self.plin3) then self.plin3:removeSelf() end
	if (self.view ) then self.plin3:removeSelf() end
	if (self.music) then audio.stop(self.music ) end
	self.btRestart=nil
	self.star1=nil
	self.star2=nil  
	self.star3=nil
	self.plin1=nil 
	self.plin2=nil  
	self.plin3=nil  
	self.view=nil
	self.music=nil
end

--- listeners
function hudgameover.restart( event )
	_G.soundManager:play("pop")
 	Runtime:dispatchEvent( {name="restart"} )
end

function hudgameover.enterFrame( event )
	self = hudgameover
	self.btRestart.y = self.btRestart.fixY + math.sin( system.getTimer() * .2 ) * 1.2 
end

return hudgameover