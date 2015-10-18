-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 04 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

local gemboard 	 = require("core.gemboard")

local super    	 = require("core.boardgame")
local gemgame    = setmetatable( {}, {__index = super } )
local gemgame_mt = { __index = gemgame }	-- metatable

-- animations
local dieSequence = {{name="die", start=1, count=20, time=280, loopCount=1}}
local dieSheet = graphics.newImageSheet("images/animation_die.png", {width=60, height=60, numFrames=20, sheetContentWidth=300, sheetContentHeight=240 })

-------------------------------------------------
-- PROPERTIES
-------------------------------------------------
local properties = {
	view  = nil,
	focusDisplay = nil,
	mustBeMatchToSwap = true
}

local updateTimerId = nil

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function checkIfGemsAreTooFar( self, index1, index2 )
	local pos1 = self.board:getPosition(index1)
    local pos2 = self.board:getPosition(index2)
    return (1 == (math.abs( pos1.col - pos2.col ) + math.abs( pos1.row - pos2.row )))            
end

local function move( self, event )
	if not(event or self.isStarted) then return false end
    local body  = event.target
    local phase = event.phase
    local stage = display.getCurrentStage()
    local x = event.x - (self.view.x + self.board.x)
    local y = event.y - (self.view.y + self.board.y)
    local index = self.board:getIndexByXY(x,y)

    if "began" == phase then
        stage:setFocus( body, event.id )
        body.isFocus = true

        -- user just touch a gem
        if not (self.itemOnFocus) then
        	self:setItemOnFocus(index)
        
        -- user touch the same gem, just stop the action
        elseif (index == self.itemOnFocus) then
        	self:setItemOnFocus(nil)
        	body.isFocus = false
        
        -- user touch another gem
        elseif (index) then
            -- check if the gem is too far or not
            if (checkIfGemsAreTooFar(self,index,self.itemOnFocus)) then
            	-- stop dragging befor move it
            	stage:setFocus( body, nil )
            	body.isFocus = false
            	-- move gems
        		self:tryToSwapToIndex(index)

        	-- if itemis too far, it became the new focus
        	else
        		self:setItemOnFocus(index)
        	end
        end
    elseif body.isFocus then
        if "moved" == phase then
        	if (body.isFocus and index and index ~= self.itemOnFocus) then
            	if (checkIfGemsAreTooFar(self,index,self.itemOnFocus)) then
            		-- stop dragging
            		stage:setFocus( body, nil )
            		body.isFocus = false
            		-- move gems
        			self:tryToSwapToIndex(index)
        		end
        		
        	end

        elseif "ended" == phase or "cancelled" == phase then
            stage:setFocus( body, nil )
            body.isFocus = false
        end
    end
    -- Stop further propagation of touch event
    return true
end
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function gemgame.new(object) -- constructor
	local self = super.new(copy(properties))
	if (object) then 
		fill(self, object)
	end
	return setmetatable( self, gemgame_mt )
end

function gemgame:tryToSwapToIndex(index)
	local tempindex = self.itemOnFocus
    self:setItemOnFocus(nil)

    local g1 = self.board:getItemAtIndex(index)
    local g2 = self.board:getItemAtIndex(tempindex)

    -- user are clicking too fast
    if not (g1.sprite and g2.sprite) then return false end

    self.board:swapFromIndexToIndex(index,tempindex)
    if (self.mustBeMatchToSwap) then
    	local hasmatchs, disposal = self.board:testForMatchs()
    	if not (hasmatchs) then
    		-- get target location
    		local p1 = self.board:getPosition(index)
    		p1.y = (p1.row - 1) * self.board.tileHeight
    		p1.x = (p1.col - 1) * self.board.tileWidth
    		
    		local p2 = self.board:getPosition(tempindex)
    		p2.y = (p2.row - 1) * self.board.tileHeight
    		p2.x = (p2.col - 1) * self.board.tileWidth

    		-- animate it
    		transition.to(g1.sprite,{ time=200, x=p2.x, y=p2.y, onComplete=function()
    			transition.to(g1.sprite,{ time=150, x=p1.x, y=p1.y})
    		end })
    		transition.to(g2.sprite,{ time=200, x=p1.x, y=p1.y,	onComplete=function()
				transition.to(g2.sprite,{ time=150, x=p2.x, y=p2.y})
    		end })
				
   			self.board:swapFromIndexToIndex(index,tempindex)
   		else
    		self:swapGems()
    	end
    else
    	self:swapGems()
    end
end

function gemgame:createBoard(options)
	if not (options.view) then
		self.view = display.newGroup( )
	else 
		self.view = options.view
	end
	self.board = gemboard.new(options)	
	self.board:draw(self.view)
	self.board:fill(nil,true)
	self:draw()
end

function gemgame:start( )
	super.start(self)
	-- make sure don't duplicate listeners
	self.board.view._functionListeners = nil
  	self.board.view._tableListeners = nil
  	-- add listener
	self.board.view:addEventListener( "touch", function(...) move(self, ...) end )
end

function gemgame:restart( )
	super.restart(self)
	self.board:fill(nil,true)
	self:draw()
end

function gemgame:stop( )
  	self:setItemOnFocus(nil)
	super.stop(self)
	if(self.board and self.board.view) then
		self.board.view._functionListeners = nil
  		self.board.view._tableListeners = nil
  	end
end

function gemgame:pause( )
	super.pause(self)
	self.board.view._functionListeners = nil
  	self.board.view._tableListeners = nil
end

function gemgame:setItemOnFocus(index)
	if (self.focusDisplay) then
		self.focusDisplay:removeSelf( )
		self.focusDisplay = nil
	end
	if (index) then
		local gem = self.board:getItemAtIndex(index)
		if (gem.sprite) then
			self.focusDisplay = display.newRoundedRect( gem.x + self.view.x + self.board.x, gem.y + self.view.y + self.board.y, gem.width, gem.height, gem.height * 0.15 )		
			self.focusDisplay.anchorX = 0
			self.focusDisplay.anchorY = 0
			self.focusDisplay.strokeWidth = 2
			self.focusDisplay:setFillColor(0, 0, 0,.1)
			self.focusDisplay:setStrokeColor(1, .2, .2)
		end
	end
	self.itemOnFocus = index
end

function gemgame:draw()
	if not (self.board) then return end
	-- draw items
	for i,v in ipairs(self.board.matrix) do
		if (v and v.draw and v.needsDisplay) then
			v:draw(self.board.view,v.x,v.y)
			v.needsDisplay = false
		end
	end
end

function gemgame:timer( event )
    if (self.isStarted and not self.isPaused) then
   		self:update()
    end
end

function gemgame:swapGems()
	self:animate(false)
	timer.performWithDelay(200,function ( )
		self:update()
	end)
end

function gemgame:update()
	if not (self.isStarted) then return end

	while self.board:settleGems() do end

	local hasmatchs, disposal = self.board:testForMatchs()
	if (hasmatchs) then
		_G.soundManager:play("pop")

		self:countpoints(disposal)
   		self:animateDie(disposal)
   		self.board:disposeItems(disposal, false)

   		-- make sure it don't update faster than it should or the animations look bugged
   		if (updateTimerId) then timer.cancel( updateTimerId ) end
   		updateTimerId = timer.performWithDelay(200,function (...) self:timer(...) end)
	else
		-- verifie if has moviments yet
		local hasposiblemoviments, disposal = self.board:testForMatchs((self.board.minmatchs-1), true)
		if not (hasposiblemoviments ) then
			Runtime:dispatchEvent({name="noMoreMoviments"})
			return false
		end
	end
	self:animate(true)
end

function gemgame:countpoints( disposal )
	local score = 0
	for gtype, indexes in ipairs(disposal) do
			if (#indexes > 0) then 
				local  multiplier = 100
				if (#indexes > 5) then
					multiplier = 200
				elseif (#indexes == 5) then
					multiplier = 500
				elseif (#indexes == 4) then
					multiplier = 300
				end
				score = score + (#indexes * multiplier)
			end
	end
	Runtime:dispatchEvent( {name="score",value=score} )
end

function gemgame:animateDie(disposal)
	for gtype, indexes in ipairs(disposal) do
		for i,index in ipairs(indexes) do
			local pos = self.board:getPosition(index)
			local dying  = display.newSprite( dieSheet, dieSequence )
			self.board.view:insert( dying )
			dying.x = pos.col * self.board.tileWidth - self.board.tileWidth *.5
			dying.y = pos.row * self.board.tileHeight - self.board.tileHeight *.5
			dying:play()
			local function didDie( event )
				if ( event.phase == "ended" ) then
			 		dying:removeEventListener( "sprite", didDie )
			 		dying:removeSelf( )
				end
			end
			dying:addEventListener( "sprite", didDie )
		end
	end
end

function gemgame:animate(bounce)
	-- draw items
	if not (self.board) then return end

	for i,v in ipairs(self.board.matrix) do
		if (v and v.sprite) then
			local p = self.board:getPosition(i)
			local ixy = self.board:getIndexByXY(v.sprite.x+1,v.sprite.y+1)
			-- move only the gems at the wrong place
			if not(i == ixy) then
				-- if the final row isn't the firs row
				-- reposition the item before animate
				-- it looks much better the animation
				if (v.sprite.y < 0) then
					v.sprite.y = self.board.tileHeight * -(self.board.row - p.row) + self.board.view.y
				end
				
				local x = ((p.col-1) * self.board.tileWidth )
       			local y = ((p.row-1) * self.board.tileHeight)

				-- if item is too far, the bouce function doesn't look nice, 
				-- it is better do in 2 attempts
				transition.to(v.sprite,{ time=200, x=x, y=y})
				if (bounce == true and y ~= v.sprite.y) then
					transition.to(v.sprite,{ time=60, delay=200, y=y-(self.board.tileHeight*.1), transition=easing.outCubic})
       				transition.to(v.sprite,{ time=80, delay=260, y=y, transition=easing.inCubic })
				end
       			
			end
		end
	end
end

return gemgame