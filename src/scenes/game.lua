-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 06 Jun 2014

-------------------------------------------------------------------------

local physics = require( "physics" )
local widget  = require( "widget" )

local composer = require( "composer" )
local scene    = composer.newScene()

local soundManager = require( "sounds.manager" )

local gem 	   = require( "core.gem" )
local gemgame  = require( "core.gemgame" )

-- properties
scene.background = nil
scene.game = nil
scene.timeLimit = 5

-- GUI
scene.btPause  = nil
scene.btReset  = nil
scene.txtScore = nil

scene.hudtimer = nil
scene.hudscore = nil
scene.hudintro = nil
scene.hudparticles = nil
scene.hudgameover = nil

scene.message = nil

-- sounds
scene.music = nil

-----------------------------------------------
-- *** COMPOSER SCENE EVENT FUNCTIONS ***
------------------------------------------------

function scene:create( event )
	print('scene:create game')
	self.background = display.newImageRect("images/background.jpg", _W+100,_H)
	self.background.anchorX = 0
	self.background.anchorY = 0
	self.background.x = -110
	self.background.y = 0
	self.view:insert(self.background)
	
	-- HUDs
	self.hudtimer 	 = require( "scenes.hud.timer")
    self.hudscore 	 = require( "scenes.hud.score")
	self.hudparticles= require( "scenes.hud.particles" )
	self.hudintro 	 = require( "scenes.hud.levelinstructions")
	self.hudgameover = require( "scenes.hud.gameover" )


    -- Create game
    local gemtypes = {
		gem.new({type=1}), -- gem blue
		gem.new({type=2}), -- gem pink
		gem.new({type=3}), -- gem red
		gem.new({type=4}), -- gem yellow
		gem.new({type=5})  -- gem greem 
	}
	self.game = gemgame.new()
	self.game:createBoard({row=9,col=7, x=60,y=85,types=gemtypes})
	self.view:insert( self.game.view )
	
	-- draw HUDs
	self.hudtimer:draw(self.timeLimit)
    self.hudscore:draw(0)
    self.hudparticles:draw()
    self.hudintro:create()
	self.view:insert( self.hudtimer.view )
	self.view:insert( self.hudscore.view )
	self.view:insert( self.hudparticles.view )
	self.view:insert( self.hudintro.view )

end

function scene:show( event )
	print('scene:show game')

	local phase = event.phase

    if ( phase == "will" ) then
	    -- add listeners
	    Runtime:addEventListener( "timeout",   self.endGame     )
		Runtime:addEventListener( "startGame", self.startGame   )
		Runtime:addEventListener( "restart",   self.restartGame )
		Runtime:addEventListener( "noMoreMoviments", self.refreshGame )
		
		-- start music and intro (countdown)
		self.music = _G.soundManager:play("bass-loop",{ loops=-1,channel=2})
    elseif ( phase == "did" ) then
		self.hudintro:show()
		
    end
end

function scene:hide( event )
	print('scene:hide game')
	local phase = event.phase
    if ( phase == "will" ) then
	    Runtime:removeEventListener( "timeout",   self.endGame     )
		Runtime:removeEventListener( "startGame", self.startGame   )
		Runtime:removeEventListener( "restart",   self.restartGame )
		Runtime:removeEventListener( "noMoreMoviments", self.refreshGame )
		self.isActive = false
    elseif ( phase == "did" ) then
		-- clear huds
		self.hudintro:destroy()
		self.hudscore:destroy()
		self.hudtimer:destroy()
		self.hudgameover:destroy()
		self.hudparticles:destroy()
		-- destroy game
		self.game:destroy()

	end
	--audio.stop(self.music)
end

function scene:destroy( event )
	print('scene:destroy game')

	self.background = nil
	self.hudtimer   = nil
	self.hudscore   = nil
	self.hudintro   = nil
	self.hudgameover= nil
end

-----------------------------------------------
-- Game function
-----------------------------------------------

function scene:startGame( event )
	self = scene
	self.game:start()
    self.hudtimer:startCountdown(self.timeLimit)
end

function scene:restartGame( event )
    composer.gotoScene( "scenes.restart", "fade", 250 )
end

-- No more moviments will never be called on a 7x9 board, but in another levels it may be
function scene:refreshGame( event )
	self = scene 
	local message = display.newText("No more moviments", _W/2, _H/2, "Alba Matter", 30)
	local shadow = display.newText("No more moviments", _W/2+2, _H/2+2, "Alba Matter", 30)
	shadow:setFillColor( 0,0,0,1 )
	self.view:insert( shadow )
	self.view:insert( message )
	timer.performWithDelay( 2000, function () 
		message:removeSelf( ) 
		shadow:removeSelf( ) 
	end)
	self.game:pause( )
	transition.to( self.game.view, {alpha=0, time=300, onComplete=function()
		self.game:restart()
		transition.to( self.game.view, {alpha=1, time=300})
	end})
end

function scene:endGame( )
	self = scene
	self.game:stop()
	audio.fadeOut({ channel=self.music, time=5000 })

	-- explode animation of the board
	physics.start()
	for i,g in ipairs(self.game.board.matrix) do
		if (g.sprite) then
			physics.addBody( g.sprite, "dynamic", { density=1.0, friction=0.5, bounce=0.3})
			local forceMag = math.random()
			g.sprite:applyLinearImpulse(forceMag, forceMag, _W*math.random(), _H*math.random())
		end
	end

	-- show the stars and reset button, the first argument is the delay it will apear
	self.hudgameover:draw()
	self.view:insert( self.hudgameover.view )
	self.hudgameover:play(1000,self.hudscore.score)
end

-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene