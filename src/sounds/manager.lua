-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-------------------------------------------------------------------------

local soundManager = {}

-- no time for optimisations, sory, just load it all

--Loads default sounds.
soundManager.sounds = {}

-- preload audio effects
soundManager.sounds["pop"] 	  = audio.loadSound("sounds/pop.mp3")
soundManager.sounds["star"]   = audio.loadSound("sounds/star.mp3")
soundManager.sounds["warp"]   = audio.loadSound("sounds/warp.mp3")
soundManager.sounds["count"]  = audio.loadSound("sounds/beep4.mp3")

-- channel 1
soundManager.sounds["intro"] = audio.loadStream("sounds/kickstarter.mp3")
-- channel 2
soundManager.sounds["bass-loop"] = audio.loadStream("sounds/bass-loop.mp3")
-- channel 3
soundManager.sounds["heart"] = audio.loadSound("sounds/heart.mp3")
-- channel 4
soundManager.sounds["boom"] = audio.loadSound("sounds/boom.mp3")
-- channel 5
soundManager.sounds["end"] = audio.loadStream("sounds/end.mp3")

audio.reserveChannels( 5 )

function soundManager:play(name, options)
	local sound = self.sounds[name]

	-- make sure it play the sound correctly
	if (options and options.channel) then
		audio.stop( options.channel )
		audio.rewind( sound )
	end

	channel = audio.play(sound, options)
	audio.setVolume( 1, {channel=channel})
	return channel
end

return soundManager