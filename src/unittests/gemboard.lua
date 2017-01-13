-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

module(..., package.seeall)

local gemboard = nil
local newgemboard = nil

function suite_setup()
	gemboard = require("core.gemboard")
end

function suite_teardown()
	gemboard = nil
end

function teardown()
	newgemboard:destroy()
	newgemboard = nil
end

function test_newGemboard()
	newgemboard = gemboard.new()	
	lunatest.assert_not_nil(newgemboard, "cound not load core.gemboard (is nil).")
	--check properties
	lunatest.assert_equal(3, newgemboard.minmatchs,  "No minmatchs.")
	lunatest.assert_not_nil(newgemboard.itemsForDisposal, "itemsForDisposal nil.")
end

function test_gemboardFill()
	newgemboard = gemboard.new({col=2,row=2})
	newgemboard:fill()
	lunatest.assert_not_nil(newgemboard.matrix, "newgemboard.matrix nil.")
	lunatest.assert_not_nil(4,#newgemboard.matrix, "newgemboard.matrix not right.")

end

function test_gemboardGetItemByXY()
	newgemboard = gemboard.new({model={1,1,2,1},col=2,types={{type=1},{type=2}},tileWidth=10,tileWidth=10})
	newgemboard:fill()
	newgemboard:draw()

	local gem1 = newgemboard:getItemByXY(newgemboard.tileWidth + newgemboard.x + 1,newgemboard.tileHeight + newgemboard.y + 1)
	lunatest.assert_not_nil(gem1, "gemboard:getItemByXY fail.")
	
	local gem2 = newgemboard:getItemAt(2,2)
	lunatest.assert_not_nil(gem2, "gemboard:getItemAt fail.")
	lunatest.assert_equal(gem2,gem1, "gemboard:getItemByXY fail.")
	
	local gem3 = newgemboard:getItemAtIndex(4)
	lunatest.assert_not_nil(gem3, "gemboard:getItemAtIndex fail.")
	lunatest.assert_equal(gem2,gem3, "gemboard:getItemAtIndex fail.")
end

function test_gemboardDisposeItems()
	newgemboard = gemboard.new({model={1,1,2,1},col=2,types={{type=1},{type=2}},tileWidth=10,tileWidth=10})
	newgemboard:fill()
	
	local gem1 = newgemboard:getItemAtIndex(3)
	lunatest.assert_not_nil(gem1, "gemboard:getItemAtIndex fail.")

	local dispose = {
		[1]={},		-- type 1, nothing to be disposed
		[2]={[1]=3} -- type 2, one item, at index 3 to be disposed
	}
	newgemboard:disposeItems(dispose,false)

	local gem3 = newgemboard:getItemAtIndex(3)
	lunatest.assert_nil(gem3, "gemboard:disposeItems fail.")
end
