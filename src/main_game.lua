-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------


--Initial Settings
display.setStatusBar(display.HiddenStatusBar) --Hide status bar from the beginning
_H = display.contentHeight
_W = display.contentWidth

-- Global gemsSheet, made global to save us loading and removing it each gem!
if not (_G.gemsSheet) then
	_G.gemsSheet = graphics.newImageSheet("images/gems.png", {height = 36, width = 36, numFrames = 5, sheetContentWidth = 180, sheetContentHeight = 36})
end

--Global score vars
_G.soundManager = require( "sounds.manager" )

--Import storyboard etc
local composer = require( "composer" )
composer.recycleOnSceneChange = true --So it automatically purges for us.

--Now change scene to go to the menu.
composer.gotoScene( "scenes.start", "fade", 400 )