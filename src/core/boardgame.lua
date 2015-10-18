-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

local boardgame    = {}
local boardgame_mt = { __index = boardgame }	-- metatable

-------------------------------------------------
-- PROPERTIES
-------------------------------------------------
local properties = {
	isPaused  = true,
	isStarted = false,
	board = nil,
	itemOnFocus = nil,
}
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function boardgame.new(object) -- constructor
	local self = copy(properties)
	if (object) then
		fill(self, object)
	end
	return setmetatable( self, boardgame_mt )
end

function boardgame:reset() 
	self.isStarted = false
	self.isPaused  = true
	if (self.board) then
		self.board:clear()
	end
end

function boardgame:restart( )
	self:reset()
	self:start()
end

function boardgame:start() 
	self.isStarted = true
	self.isPaused  = false
end

function boardgame:stop() 
	self.isStarted = false
	self.isPaused  = true
	self.itemOnFocus = nil
end

function boardgame:pause() 
	self.isPaused = true
end

-- teardown
function boardgame:destroy() 
	self:stop()
	if (self.board) then
		self.board:destroy()
	end
end

return boardgame