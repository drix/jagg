-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-------------------------------------------------------------------------

local physics = require( "physics" )
local widget  = require( "widget" )

local soundManager = require( "sounds.manager" )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- properties
scene.shouldAcumulateGems = true
scene.gemsLimit = 80
scene.gemsGroup = nil
scene.reload = 10
scene.gems   = 0
scene.music  = nil

-- GUI
scene.background = nil
scene.btNewgame = nil

scene.gear = nil
scene.logo = nil

scene.floor = nil
scene.wallleft = nil
scene.wallright = nil
scene.roof = nil


local newgameSheet = graphics.newImageSheet("images/newgame.png", {height=46, width=189, numFrames=2, sheetContentWidth=189, sheetContentHeight=92})
	
------- Event Listeners ---------------

local listenerOnEnterFrame = nil

local function enterFrame( self, event )
	-- animate gear
	self.gear.rotation = scene.gear.rotation + 2
	-- animate buttons
	self.btNewgame.y = self.btNewgame.fixY + math.sin( system.getTimer() * .2 ) * 1.2 
	-- create new gems
	self.reload = self.reload - 1
	if (self.reload < 1) then
		self.reload = 10
		self:createGem()
	end
end

local listenerOnCollision = nil

local function onCollision( self, event )
	if ( event.phase == "ended" ) then
    	if (event.object1 == self.floor) then
    		timer.performWithDelay(1,function ( ... )
    			-- if the scene has been destroyed already (only edge cases but...)
    			if not (self.floor) then return  end
    			-- remove gem with in the next cicle
    			if (event.object2 and event.object2.isGem) then
    				event.object2:removeSelf( )
    				self.gems = self.gems - 1 
    			end
    		end)
    	end
    end
end

local function listenerOnAccelerate( event )
	physics.setGravity( 10 * event.xGravity, -10 * event.yGravity )
end


-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------

function scene:createScene( event )
    local group = self.view

    -- background
	self.background = display.newImageRect("images/background-intro.png", display.contentWidth,display.contentHeight)
	self.background.anchorX = 0
	self.background.anchorY = 0
	self.background.x = 0
	self.background.y = 0
	group:insert(self.background)
	
 	-- gear 
 	self.gear = display.newImageRect("images/gear.png", 80, 80)
	self.gear.x = (display.contentWidth/2)
 	self.gear.y = (display.contentHeight * 0.2)
 	group:insert(self.gear)

 	-- falling gems
	self.gemsGroup = display.newGroup( )
	
	self.floor = display.newRect(0,_H + 50,_W,30)
	self.floor:setFillColor( 0,0,0,1 )
	self.floor.anchorX = 0
	self.gemsGroup:insert( self.floor )

	self.wallleft = display.newRect(-30,0,30,_H + 50)
	self.wallleft:setFillColor( 0,0,0,1 )
	self.wallleft.anchorY = 0
	self.gemsGroup:insert( self.wallleft )

	self.wallright = display.newRect(0,0,30,_H+ 50)
	self.wallright:setFillColor( 0,0,0,1 )
	self.wallright.anchorY = 0
	self.wallright.x = _W + 30

	self.roof = display.newRect(0,-40,_W,30)
	self.roof:setFillColor( 0,0,0,1 )
	self.roof.anchorX = 0
	self.gemsGroup:insert( self.roof )

    group:insert(self.gemsGroup)

 	-- logo 
 	self.logo = display.newImageRect("images/logo.png", 205, 90)
	self.logo.x = (display.contentWidth/2) - 1
	self.logo.y = (display.contentHeight * 0.2 + 20)
	group:insert(self.logo)

    -- button start
	self.btNewgame = widget.newButton( { 
		self=self,width=189, height=46,
		sheet=newgameSheet, defaultFrame=2, overFrame=1,
 		onRelease=function(...) self.startNewgame(self,...) end
 	})
	self.btNewgame.x = (display.contentWidth/2)
 	self.btNewgame.y = (display.contentHeight * 0.8)
	self.btNewgame.fixY = (display.contentHeight * 0.8)
 	group:insert(self.btNewgame)
end


function scene:enterScene( event )
    local group = self.view
    physics.start()
	physics.setGravity( 0, 9.81 )
  	--physics.setDrawMode("hybrid")

    physics.addBody( self.logo, "dynamic", {density=1.0, friction=0.5, bounce=0.1} )
    physics.addBody( self.gear, "static",  {density=1.0, friction=0.5, bounce=0.1} )
	self.logo.isSleepingAllowed = false
	self.logo.isSensor = true
	self.gear.isSensor = true
	local pivot = physics.newJoint( "pivot", self.gear, self.logo,self.gear.x+1, self.gear.y-20 )
	
	physics.addBody( self.btNewgame, "static", {shape={ 0,5, 95,0, 190,35, 190,5, 0,35},density=1.0, friction=0.5, bounce=0.1} )
    physics.addBody( self.floor, 	 "static", {density=1.0, friction=0.5, bounce=0.1} )
    physics.addBody( self.wallleft,  "static", {density=1.0, friction=0.5, bounce=0.1} )
    physics.addBody( self.wallright, "static", {density=1.0, friction=0.5, bounce=0.1} )
    physics.addBody( self.roof, 	 "static", {density=1.0, friction=0.5, bounce=0.1} )
    self.floor.isSensor = (true ~= self.shouldAcumulateGems)

    -- listeners
    listenerOnEnterFrame =  function ( ... ) enterFrame(self, ...) end
    listenerOnCollision  =  function ( ... ) onCollision(self, ...) end
	-- function disabled because I didn't have a device to test it =(
	--Runtime:addEventListener( "accelerometer", listenerOnAccelerate )
	Runtime:addEventListener( "enterFrame",    listenerOnEnterFrame ) 
	if not (self.shouldAcumulateGems) then
		Runtime:addEventListener( "collision",  listenerOnCollision  )
	end

	-- music
	self.music = _G.soundManager:play("intro",{ loops=-1,volume=.1,channel=1 })
	audio.setVolume( .3, {channel=1} )
end


function scene:destroyScene( event )
	physics.setGravity( 0, 9.81 )
    physics.stop()
end

function scene:exitScene( event )
	-- remove listeners
	Runtime:removeEventListener( "enterFrame", 	  listenerOnEnterFrame  )
	Runtime:removeEventListener( "collision", 	  listenerOnCollision   )
	--Runtime:removeEventListener( "accelerometer", listenerOnAccelerate  )
	listenerOnEnterFrame = nil
	listenerOnCollision  = nil

	-- remove floor to stop collision detection
	self.floor:removeSelf( )

	-- animations on exit
	physics.addBody( self.btNewgame, "dynamic", {density=1.0, friction=0.5, bounce=0.1} )
  	physics.addBody( self.logo, "dynamic", {density=1.0, friction=0.5, bounce=0.1} )
	physics.addBody( self.gear, "dynamic",  {density=1.0, friction=0.5, bounce=0.1} )
end

function scene:move( event )
    local body  = event.target
    local phase = event.phase
    local stage = display.getCurrentStage()
    if "began" == phase then
        stage:setFocus( body, event.id )
        body.isFocus = true
        body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
    elseif body.isFocus then
        if "moved" == phase then        
            -- Update the joint to track the touch
            body.tempJoint:setTarget( event.x, event.y )
        elseif "ended" == phase or "cancelled" == phase then
            stage:setFocus( body, nil )
            body.isFocus = false            
            -- Remove the joint when the touch ends         
            body.tempJoint:removeSelf()            
        end
    end
    -- Stop further propagation of touch event
    return true
end


function scene:createGem( )
	if (self.gems < self.gemsLimit) then
		local gem = display.newImageRect(_G.gemsSheet, math.random(1,5), 30, 30)
		gem.x = self.gear.x
		gem.y = self.gear.y
		self.gems = self.gems + 1
		self.gemsGroup:insert( gem )
		physics.addBody( gem, "dynamic", {radius=15,density=1.0, friction=0.5, bounce=0.1} )
		gem:applyForce( -40 + 80 * math.random(), -30 + 60 * math.random(), gem.x, gem.y )
		gem:addEventListener( "touch", function(...) self:move(...) end )
	end
		
end

function scene:startNewgame( event )
	audio.fadeOut({ channel=self.music, time=3000 })
	_G.soundManager:play("pop")
    storyboard.gotoScene( "scenes.game", "fade", 250 )
end

-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene