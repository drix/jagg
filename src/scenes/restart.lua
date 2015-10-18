-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 07 Jun 2014

-------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------

function scene:createScene( event )
	self.view = display.newGroup( )
	
 	-- logo 
 	self.logo = display.newImageRect("images/logo.png", 205, 90)
	self.logo.x = (_W/2)
	self.logo.y = (_H/2)
	self.view:insert(self.logo)
end

function scene:enterScene( event )
    storyboard.gotoScene( "scenes.game", "fade", 250 )
end

-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )

return scene