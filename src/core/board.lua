
-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

local board = {}
local board_mt = { __index = board }	-- metatable

-------------------------------------------------
-- PROPERTIES
-------------------------------------------------
local properties = {
	x = 0,
	y = 0,
	view = nil,
	background = nil,
	col = 0, 
	row = 0,
	tileHeight = 30,
	tileWidth  = 30,
	matrix = {}, -- the board it self
	model  = nil,
	types  = {},
	EMPTY = {}
}

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function board.new(object) -- constructor
	local self = copy(properties)
	if (object) then
		fill(self, object)
	end
	return setmetatable( self, board_mt )
end

function board:fill(model, random)
	if (model) then self.model = model end
	-- add items based in a model
	if (self.model and #self.model) then
		self.row = math.ceil( #self.model / self.col )
		for i=1,#self.model do
			local itemtype = self.model[i]
			if (self.types and self.types[itemtype]) then
				self:addItemAtIndex(copy(self.types[itemtype]),i)
			else
				self:addItemAtIndex(self.EMPTY,i)
			end
		end
	else
		-- fill the board with empty items
		for i=#self.matrix,self.col*self.row do
			if (i > 0) then
				if (random) then
					self:createItem(i, true)
				else
					self:addItemAtIndex(self.EMPTY,i)
				end
			end
		end
	end
end

function board:clear()
	-- remove items
	for i,v in ipairs(self.matrix) do
		if (v and v.remove) then
			v:remove( )
		end
	end
	self.matrix = {}
end

function board:draw(parent)
    if not (self.view) then
    	self.view = display.newGroup()
    end
    self.view.x = self.x
    self.view.y = self.y
    self.view.width  = self.col*self.tileWidth
    self.view.height = self.row*self.tileHeight

    if not (self.background) then
    	self.background = display.newRect( 0, 0, self.col*self.tileWidth, self.row*self.tileHeight)
    	self.background:setFillColor( 0,0,0,.3 )
		self.background.anchorX = 0
		self.background.anchorY = 0
    	self.view:insert(self.background)
	end
	if (parent and parent.insert) then
		parent:insert(self.view)
	end

	-- draw items
	for i,v in ipairs(self.matrix) do
		if (v and v.draw) then
			local p = self:getPosition(i)
			v:draw(self.view, (p.col-1) * self.tileWidth, (p.row-1) * self.tileHeight )
		end
	end
end

function board:updated()
    print( "board:updated")
end

-------------------------------------------------------------------------
-- MANAGE ITEMS
-------------------------------------------------------------------------

-- find functions

function board:getItemAt(col, row)
	return self.matrix[self:getIndex(col,row)]
end

function board:getItemAtIndex(index)
	return self.matrix[index]
end

function board:getIndex(col,row)
	return col + (row-1) * self.col
end

function board:getPosition(index)
	return {
		col = ((index-1) % self.col) + 1, 
		row = math.floor((index-1) / self.col) + 1
	}
end

function board:getIndexOfItem(item)
	for i,v in ipairs(self.matrix) do
		if (self.matrix[i] == item) then return i end
	end
	return -1
end

-- add function 

function board:addItemAtIndex(item, index)
	self.matrix[index] = item
	local pos = self:getPosition(index)
	item.x = ((pos.col-1) * self.tileWidth) 
	item.y = ((pos.row-1) * self.tileHeight)
	item.needsDisplay = true
end

function board:addItemAt(item, col, row)
	local index = self:getIndex(col,row)
	return self:addItemAtIndex(item,index)
end

function board:addItem(item)
	local nextposition = math.min(#self.matrix+1,self.col*self.row)
	return self:addItemAtIndex(item,nextposition)
end

function board:createItem(index, addToBoard)
	local newitem = self.EMPTY
	if (self.types) then
		newitem = copy(self.types[math.random(1,math.max(1,#self.types))])
		local pos = self:getPosition(index)
		newitem:draw(self.view, ((pos.col-1) * self.tileWidth), ((pos.row-2) * self.tileHeight))
	end
	if (addToBoard) then
		self:addItemAtIndex(newitem, index)
	end
	return newitem
end

-- remove functions

function board:removeItemAtIndex(index)
	local item = self:getItemAtIndex(index)
	if (item and item.remove) then
		item:remove()
	end
	self:addItemAtIndex(self.EMPTY,index)
end

function board:removeItemAt(col, row)
	if (col and row and col <= self.col and row <= self.row) then
		self:removeItemAtIndex(self:getIndex(col,row))
	end
end

function board:removeItem(item)
	self:removeItemAtIndex(self:getIndexOfItem(item))
end

function board:removeItems(items)
	for i,v in ipairs(items) do
		self:removeItemAtIndex(v)
	end
end

-- move functions

function board:swapItems(item1, item2)
	local item1 = self:getItemAtIndex(i1)
	local item2 = self:getItemAtIndex(i2)
	self:addItemAtIndex(item1, i2)
	self:addItemAtIndex(item1, i2)
end

function board:moveItemTo(item, col, row)
	self:removeItemAt(item.col, item.row)
	self:addItemAt(item, col, row)
end

function board:swapFromIndexToIndex(i1,i2 )
	local item1 = self:getItemAtIndex(i1)
	local item2 = self:getItemAtIndex(i2)
	self:addItemAtIndex(item1, i2)
	self:addItemAtIndex(item2, i1)
end

function board:moveFromIndexToIndex(i1,i2 )
	local item1 = self:getItemAtIndex(i1)
	self:addItemAtIndex(item1, i2)
	self:addItemAtIndex(self.EMPTY, i1)
end

-------------------------------------------------------------------------
-- tears down
-------------------------------------------------------------------------
function board:destroy() -- needs improve
	if(self.view) then 
		self.view:removeSelf() 
	end
	self.view = nil
end

-------------------------------------------------------------------------
-- For debug
-------------------------------------------------------------------------
function board:print() -- for debug
	local text = "\n"
	if (self.matrix) then
		for i=1,#self.matrix do
			text = text .. " " .. ((self.matrix[i] and self.matrix[i].type) or "X")
			if (i % self.col == 0) then
				text = text .. "\n"
			end
		end
		print( "board:",#self.matrix ,text )
	else
		print( "board: Empty" )
	end
end

return board