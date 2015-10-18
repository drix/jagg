-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

-- Global gemsSheet, made global to save us loading and removing it each gem!
if not (_G.gemsSheet) then
	_G.gemsSheet = graphics.newImageSheet("images/gems.png", {height = 36, width = 36, numFrames = 5, sheetContentWidth = 180, sheetContentHeight = 36})
end

local super  = require("core.item")
local gem    = setmetatable( {}, {__index = super } )
local gem_mt = { __index = gem }	-- metatable

-------------------------------------------------
-- PROPERTIES
-------------------------------------------------
local properties = {
	joint = nil,
	sheet = _G.gemsSheet,
	type  = 1
}

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function gem.new(object) -- constructor
	local self = super.new(copy(properties))
	if (object) then
		fill(self, object)
	end
	return setmetatable( self, gem_mt )
end

function gem:draw(parent, x, y)
	x = x or self.x
	y = y or self.y
	if not (self.sprite) then
		self.sprite = display.newImageRect(gemsSheet, self.type, self.width, self.height)
		self.sprite.anchorX = 0
		self.sprite.anchorY = 0
		if (parent and parent.insert) then
			parent:insert(self.sprite)
		end
	end
	self.sprite.x = x 
	self.sprite.y = y
end

return gem