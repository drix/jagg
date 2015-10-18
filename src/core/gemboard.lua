-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

local super    = require("core.board")

local gemboard = setmetatable( {}, {__index = super } )
local gemboard_mt   = { __index = gemboard }	-- metatable

-------------------------------------------------
-- PROPERTIES
-------------------------------------------------
local properties = {
	minmatchs = 3,
	itemsForDisposal = {}
}

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function gemboard.new(object) -- constructor
	local self = super.new(copy(properties))
	if (object) then
		fill(self, object)
	end
	return setmetatable( self, gemboard_mt )
end

function gemboard:getItemByXY(x, y)
	local col = math.ceil( x / self.tileWidth  )
	local row = math.ceil( y / self.tileHeight )
	return self:getItemAt(col,row)
end

function gemboard:getIndexByXY(x, y)
	local col = math.ceil( x / self.tileWidth  )
	local row = math.ceil( y / self.tileHeight )
	return self:getIndex(col,row)
end

function gemboard:testForMatchs(minmatchs, stopimediatly)
	minmatchs = minmatchs or self.minmatchs
	local hasmatchs  = false
	local testing    = {}
	local lastitem   = nil
	local directions = {"row","col"}

	-- create a table for storage the matchs
	local matchs = {}
	for i,v in ipairs(self.types) do
		matchs[i] = {}
	end
	
	-- set a private function for set items for disposal
	local function setGemsForDisposal( gtype, tested )
		-- store the indexes for disposal by type
		for i,index in ipairs(tested) do
			matchs[gtype][#matchs[gtype]+1] = index
		end
		-- set flag to be returned
		hasmatchs = true
	end

	-- run trough the grid and set gems for disposal
	for j,direction in ipairs(directions) do
		for i = 1, #self.matrix do
			local index = i
			-- if checking verticaly
			if (direction == "row") then
				local n = ((i-1) * self.col)
				index = 1 + ( n % #self.matrix) + math.floor( n / #self.matrix ) 
			end

			-- add match to the list if last item was of equal type
			local g = self:getItemAtIndex(index)
			if (lastitem and g and lastitem == g.type) then
				testing[#testing+1] = index
			else
			-- if not check if the last group has enough matchs
				if (#testing >= minmatchs) then 
					if (stopimediatly) then return true, matchs end
					setGemsForDisposal(lastitem,testing)
				end
				testing = {index}
			end

			-- clean up to move to the next row or colum
			local position = self:getPosition(index)
			if (position[direction]==self[direction]) then
				if (#testing >= minmatchs) then 
					if (stopimediatly) then return true, matchs end
					setGemsForDisposal(lastitem,testing)
				end
				testing, lastitem = {}, nil
			else
				lastitem = g.type
			end
		end
	end
	return hasmatchs, matchs
end

function gemboard:settleGems()
	local haschanged = false
	-- run from the last item at the bottom looking for empty places
	for index = #self.matrix, 1, -1  do
		local g = self:getItemAtIndex(index)
		-- if find a empty field, move the whole colum down
		if (g == self.EMPTY) then
			for i2 = index, 1, (self.col * -1) do
				-- the first row, just create a new gem on top
				if (i2 <= self.col) then
					self:createItem(i2, true)
				else
				-- otherwise swap it
					self:swapFromIndexToIndex(i2,(i2-self.col))
				end
			end
			haschanged = true
		end
	end
	return haschanged
end

function gemboard:fill(...) 
	super.fill(self, ...)
	-- make sure there are no maches on initial board
	-- if has only one type it will always has matchs
	if (self.types and #self.types > 1) then
		local giveup = 100
   		local hasmatchs, disposal = self:testForMatchs()
		while (hasmatchs and giveup > 0) do
   			self:disposeItems(disposal, true)
			hasmatchs, disposal = self:testForMatchs()
   			giveup   = giveup - 1
   		end
	end
end

function gemboard:disposeItems(disposal, replace) 
   	for gtype, indexes in ipairs(disposal) do
   		for i, index in pairs(indexes) do
			self:removeItemAtIndex(index)
			assert(self:getItemAtIndex(index) == self.EMPTY)
   			if (replace) then
   				self:createItem(index, true)
   			end
		end
	end
end

return gemboard