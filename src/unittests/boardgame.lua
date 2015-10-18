-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

module(..., package.seeall)

local boardgame = nil
local newboardgame = nil

function suite_setup()
	boardgame = require("core.boardgame")
end

function suite_teardown()
	boardgame = nil
end

function teardown()
	newboardgame:destroy()
	newboardgame = nil
end

function test_newboardgame()
	newboardgame = boardgame.new()	
	lunatest.assert_not_nil(newboardgame, "cound not load core.newboardgame (is nil).")
	--check properties
	lunatest.assert_equal(true, newboardgame.isPaused,  "boardgame should be paused.")
	lunatest.assert_equal(false, newboardgame.isStarted, "boardgame shouldnt be started.")
end

function test_boardgameStart()
	newboardgame = boardgame.new()
	lunatest.assert_equal(false, newboardgame.isStarted, "boardgame shouldnt be started.")
	
	newboardgame:start()
	lunatest.assert_equal(true, newboardgame.isStarted, "boardgame should be started.")
end

function test_boardgamePause()
	newboardgame = boardgame.new()
	lunatest.assert_equal(true, newboardgame.isPaused,  "boardgame should be paused.")
	
	newboardgame:start()
	lunatest.assert_equal(false, newboardgame.isPaused,  "boardgame shouldnt be paused.")
	
	newboardgame:pause()
	lunatest.assert_equal(true, newboardgame.isPaused,  "boardgame should be paused.")
end

function test_boardgameStop()
	newboardgame = boardgame.new()
	lunatest.assert_equal(true, newboardgame.isPaused,  "boardgame should be paused.")
	lunatest.assert_equal(false, newboardgame.isStarted, "boardgame shouldnt be started.")
	
	newboardgame:start()
	
	lunatest.assert_equal(true, newboardgame.isStarted, "boardgame should be started.")
	lunatest.assert_equal(false, newboardgame.isPaused,  "boardgame shouldnt be paused.")
	
	newboardgame:stop()
	
	lunatest.assert_equal(true, newboardgame.isPaused,  "boardgame should be paused.")
	lunatest.assert_equal(false, newboardgame.isStarted, "boardgame shouldnt be started.")
end
