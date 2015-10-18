-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

module(..., package.seeall)

local gemgame = nil
local newgemgame = nil

function suite_setup()
	gemgame = require("core.gemgame")
end

function suite_teardown()
	gemgame = nil
end

function teardown()
	newgemgame:destroy()
	newgemgame = nil
end

function test_newGemgame()
	newgemgame = gemgame.new()	
	lunatest.assert_not_nil(newgemgame, "cound not load core.gemgame (is nil).")
	--check properties
	lunatest.assert_equal(true, newgemgame.isPaused,  "Gemgame should be paused.")
	lunatest.assert_equal(false, newgemgame.isStarted, "Gemgame shouldnt be started.")
end
