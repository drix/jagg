-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Nov 2016

-------------------------------------------------------------------------
local widget  = require( "widget" )
local soundManager = require( "sounds.manager" )
local fire = require( "effects.fire" )


	
-- Properties
local hud = { 
	view=display.newGroup(),
	title='Fire'
}

-- functions

function hud:create(data)

	local background = display.newRect( 0, 0, _W, _H )
	background:setFillColor( 0,0,0,.6 )
	background.anchorY = 0
	background.anchorX = 0
	self.view:insert(background)

 -- button start
 	local newgameSheet = graphics.newImageSheet("images/newgame.png", {height=46, width=189, numFrames=2, sheetContentWidth=189, sheetContentHeight=92})

	local btstart = widget.newButton( { 
		self=self, width=189, height=46,
		sheet=newgameSheet, defaultFrame=2, overFrame=1,
 		onRelease=function(...) 
 			_G.soundManager:play("pop")
 			self:hide()
 		end
 	})
	btstart.x = (_W/2)
 	btstart.y = (_H * 0.9)
	btstart.fixY = (_H * 0.9)
 	self.view:insert(btstart)


	local shadow = display.newText(self.title, _W/2+4, _H/9+4, "Alba Matter", 30)
	shadow:setFillColor(0,0,0,.8)
	self.view:insert(shadow)
	
	local label = display.newText(self.title, _W/2, _H/9, "Alba Matter", 30)
	label:setFillColor(1,1,1)
	self.view:insert(label)
	
	local f = fire.create(0.7)
	f.x = (_W/2)
	f.y = (_H/2)
	self.view:insert(f)

	self.view.alpha = 0
	return self.view
end

function hud:show()
	transition.to( self.view, { 
		alpha=1, 
		time=1000, 
		onComplete = function( ... )

		end
	} )
end

function hud:hide()
	transition.to( self.view, { 
		alpha=0, 
		time=500, 
		onComplete = function( ... )
 			Runtime:dispatchEvent({name="startgame"})
		end
	} )
end

function hud:destroy( )
	if (self.view) then self.view:removeSelf() end
	self.view = nil
end

return hud