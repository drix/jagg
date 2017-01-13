-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 07 Jun 2014

-------------------------------------------------------------------------
local prism = require("prism")

-- properties
local hudparticles = { 
	view=nil,
	fire=nil

}

-- functions

function hudparticles:draw( )
	if (self.view) then return end
	self.view = display.newGroup()

	self.fire = prism.newEmitter({
		-- Particle building and emission options
		particles = {
			type = "image",
			image = "particle.png",
			width = 25,
			height = 25,
			color = {{1, 0.1, 0}, {1, 0.5, 0}},
			blendMode = "add",
			particlesPerEmission = 15,
			delayBetweenEmissions = 120,
			inTime = 100,
			lifeTime = 700,
			outTime = 700,
			startProperties = {xScale = 1, yScale = 1},
			endProperties = {xScale = 0.3, yScale = 0.3, alpha = 0}
		},
		-- Particle positioning options
		position = {
			type = "point"
		},
		-- Particle movement options
		movement = {
			type = "angular",
			angle = "0-90",
			velocityRetain = .97,
			speed = 0.8,
			yGravity = -0.05
		}
	})
	self.fire.x, self.fire.y = 55, 390
	self.fire:startEmitTimer()
	self.view:insert(self.fire)
	Runtime:addEventListener( "emitGem", self.gem )
 	return self.view
end

function hudparticles.gem( event )
	local to = {}
    if event.type == 1 then  -- 1 gem blue
    	to.color =  {{0, .1, 1}, {.2, .8, 1}}
    	to.x = 50
    	to.y = 500
    end
    if event.type == 2 then  -- 2 gem pink
    	to.color =  {{1, .1, 1}, {1, .8, 1}}
    	to.x = 120
    	to.y = 500
    end
    if event.type == 3 then  -- 3 gem red
    	to.color =  {{1, .1, 0}, {1, .8, 0}}
    	to.x = 10
    	to.y = 270
    end
    if event.type == 4 then  -- 4 gem yellow
    	to.color =  {{0, 1, 1}, {.2, .8, .5}}
    	to.x = 190
    	to.y = 500
    end
    if event.type == 5 then  -- 5 gem greem
    	to.color =  {{1, 1, 1}, {.2, 0, 1}}
    	to.x = 260
    	to.y = 500
    end
   	

	local emitter = prism.newEmitter({
		-- Particle building and emission options
		particles = {
			type = "image",
			image = "particle.png",
			width = 20,
			height = 20,
			color = to.color,
			blendMode = "add",
			particlesPerEmission = 3,
			delayBetweenEmissions = 10,
			inTime = 100,
			lifeTime = 100,
			outTime = 100,
			startProperties = {xScale = 1, yScale = 1},
			endProperties = {xScale = 0.3, yScale = 0.3}
		},
		-- Particle positioning options
		position = {
			type = "point"
		},
		-- Particle movement options
		movement = {
			type = "angular",
			angle = "0-359",
			velocityRetain = .97,
			speed = 1
		}
	})
	emitter.x, emitter.y = event.from.x, event.from.y
	self.view:insert(emitter)
	emitter:startEmitTimer()

	transition.to(emitter, {y = to.y, time = 500, transition = easing.inBack})
	transition.to(emitter, {x = to.x, time = 500, transition = easing.inOut, onComplete=function ( )
		emitter.stopEmitTimer()
	end})

end

function hudparticles:destroy( )
	self.fire.stopEmitTimer()
	Runtime:removeEventListener( "emitGem", self.gem )
end

return hudparticles