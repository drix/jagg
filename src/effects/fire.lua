-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Nov 2016

-------------------------------------------------------------------------

-- properties
local fire = { }

-- functions
fire.create = function( size )
	-- Table of emitter parameters
	local emitterParams = {
	    startColorAlpha = 1,
	    startParticleSizeVariance = 53.47 * size,
	    startColorGreen = 0.3031555,
	    yCoordFlipped = -1,
	    blendFuncSource = 770,
	    rotatePerSecondVariance = 153.95,
	    particleLifespan = 0.7237 * size,
	    tangentialAcceleration = -144.74,
	    finishColorBlue = 0.3699196,
	    finishColorGreen = 0.5443883,
	    blendFuncDestination = 1,
	    startParticleSize = 50.95 * size,
	    startColorRed = 0.8373094,
	    textureFileName = "particle.png",
	    startColorVarianceAlpha = 1,
	    maxParticles = 256 * size,
	    finishParticleSize = 64 * size,
	    duration = -1,
	    finishColorRed = 1,
	    maxRadiusVariance = 72.63 * size,
	    finishParticleSizeVariance = 64 * size,
	    gravityy = -671.05 * size,
	    speedVariance = 90.79 * size,
	    tangentialAccelVariance = -92.11 * size,
	    angleVariance = -142.62 * size,
	    angle = -244.11 * size
	}

	-- Create the emitter
	local emitter = display.newEmitter( emitterParams )

	-- Center the emitter within the content area
	emitter.x = display.contentCenterX
	emitter.y = display.contentCenterY
 	return emitter
end

return fire