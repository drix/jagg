
-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

local item = {}
local item_mt = { __index = item }	-- metatable

-------------------------------------------------
-- PROPERTIES
-------------------------------------------------
local properties = {
	x = 0,
	y = 0,
	type = 0,
	needsDisplay = false,

	sprite  = nil,
	width   = 30,
	height  = 30,

	isFocus = false,
	isFixed = false,
	isPassthrough = false
}
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function item.new(object) -- constructor
	local self = copy(properties)
	if (object) then 
		fill(self, object)
	end
	return setmetatable( self, item_mt )
end

-------------------------------------------------------------------------
-- ITEMS
-------------------------------------------------------------------------

function item:draw(parent,x,y)
	x = x or self.x
	y = y or self.y
	if not (self.sprite) then
		self.sprite = display.newRect(x,y,self.width,self.height)
		self.sprite:setFillColor( 1,0,0,.3 )
		self.sprite.anchorX = 0
		self.sprite.anchorY = 0
		if (parent and parent.insert) then
			parent:insert(self.sprite)
		end
		self.needsDisplay = true
	else
		self.sprite.x = x 
		self.sprite.y = y
	end
end

function item:remove()
	if (self.sprite) then
		self.sprite:removeSelf()
	end
end

return item