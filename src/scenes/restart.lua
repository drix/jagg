-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 07 Jun 2014

-------------------------------------------------------------------------

local composer = require( "composer" )
local scene    = composer.newScene()

-----------------------------------------------
-- *** COMPOSER SCENE EVENT FUNCTIONS ***
------------------------------------------------

function scene:create( event )
	self.view = display.newGroup( )
	
 	-- logo 
 	self.logo = display.newImageRect("images/logo.png", 205, 90)
	self.logo.x = (_W/2)
	self.logo.y = (_H/2)
	self.view:insert(self.logo)
end

function scene:show( event )
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
    	--composer.gotoScene( "scenes.game", "fade", 250 )
        print('restart scene')
    end
end

-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene