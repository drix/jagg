-- Set the Composer variable "money" to 100
composer.setVariable( "money", 100 )

-- In another scene...
local currentMoney = composer.getVariable( "money" )

------------------------------------------------------------------------------
-- In "scene1.lua" (parent scene)
------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

-- Custom function for resuming the game (from pause state)
function scene:resumeGame()
    --code to resume game
end

-- Options table for the overlay scene "pause.lua"
local options = {
    isModal = true,
    effect = "fade",
    time = 400,
    params = {
        sampleVar = "my sample variable"
    }
}

-- By some method (a pause button, for example), show the overlay
composer.showOverlay( "pause", options )

return scene

------------------------------------------------------------------------------
-- In "pause.lua"
------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        parent:resumeGame()
    end
end

-- By some method (a "resume" button, for example), hide the overlay
composer.hideOverlay( "fade", 400 )

scene:addEventListener( "hide", scene )
return scene