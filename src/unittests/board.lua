-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 03 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

module(..., package.seeall)
local board = nil
local newboard = nil

function suite_setup()
	board = require("core.board")
end

function suite_teardown()
	board = nil
end

function teardown()
	newboard:destroy()
	newboard = nil
end

function test_newboard()
	lunatest.assert_not_nil(board, "cound not load core.board (is nil).")
	
	--check properties
	newboard = board.new({col=2,row=2, tileWidth=30,tileHeight=30})
	lunatest.assert_not_nil(newboard, "cound not create a new core.board (is nil).")
	
	lunatest.assert_equal(2, newboard.col, "board instantiated with no colums.")
	lunatest.assert_equal(2, newboard.row, "board instantiated with no rows.")

	lunatest.assert_equal(30, newboard.tileWidth, "board.tileWidth with setted properlly.")
	lunatest.assert_equal(30, newboard.tileHeight, "board.tileHeight with setted properlly.")

	lunatest.assert_number(newboard.x,"board.x")
	lunatest.assert_number(newboard.y,"board.y")
end

function test_boardFill()
	newboard = board.new({col=2,row=2, tileWidth=30,tileHeight=30})	
	newboard:fill()
	lunatest.assert_not_nil(newboard.matrix, "board.matrix not setted properlly.")
	lunatest.assert_table(newboard.matrix, "board.matrix not setted properlly.")
	lunatest.assert_equal(4, #newboard.matrix, "board.matrix not setted properlly.")
end

function test_boardFillWithModel()
	newboard = board.new({model={1,1},col=2,types={{type=3},{type=4}}, tileWidth=30,tileHeight=30})	
	
	lunatest.assert_not_nil(newboard.model,"newboard.model not correctly")
	lunatest.assert_equal(2,#newboard.model,"newboard.model not correctly")
	
	newboard:fill({1,2,1,2})
	lunatest.assert_equal(4,#newboard.model,"newboard.model not correctly")
	lunatest.assert_equal(2,#newboard.types,"newboard.types not correctly")
	lunatest.assert_equal(3,newboard.types[1].type,"newboard.types not correctly")
	lunatest.assert_equal(4,newboard.types[2].type,"newboard.types not correctly")


	local item0 = newboard:getItemAtIndex(2)
	lunatest.assert_not_nil(item0, "getItemAtIndex fail")
	lunatest.assert_equal(4, item0.type,"item type not correctly")

	local item1 = newboard:getItemAtIndex(3)
	lunatest.assert_not_nil(item1, "getItemAtIndex fail")
	lunatest.assert_equal(3,item1.type,"item type not correctly")

	newboard:fill({1,1,2,1})

	local item3 = newboard:getItemAtIndex(3)
	lunatest.assert_not_nil(item3, "getItemAtIndex fail")
	lunatest.assert_equal(4,item3.type,"item type not correctly")
end

function test_boardDraw()
	newboard = board.new({col=2,row=2, x=100, y=100, tileWidth=30,tileHeight=30})	
	newboard:fill({1,1,2,1})
	
	newboard:draw()
	lunatest.assert_not_nil(newboard.view, "newboard.view not set properly.")
	lunatest.assert_equal(100,newboard.view.x, "newboard.view not setted properlly.")
	lunatest.assert_equal(100,newboard.view.y, "newboard.view not setted properlly.")
	lunatest.assert_equal(60,newboard.view.width, "newboard.view not setted properlly.")
	lunatest.assert_equal(60,newboard.view.height, "newboard.view not setted properlly.")
end


function test_boardRemoveItem()
	newboard = board.new({col=2,row=2, x=10, y=10, types={{type=1},{type=2}}, tileWidth=30,tileHeight=30})	
	newboard:fill({1,1,2,1})
	
	local g1 = newboard:getItemAtIndex(3)
	lunatest.assert_not_nil(g1, "board:getItemAtIndex didn't work")
	newboard:removeItem(g1)

	local g2 = newboard:getItemAtIndex(3)
	lunatest.assert_equal(newboard.EMPTY, g2, "board:getItemAtIndex didn't work")
end


function test_boardClear()
	newboard = board.new({col=2,row=2, x=10, y=10, tileWidth=30,tileHeight=30})	
	newboard:fill()
	local itemscount = #newboard.matrix
	lunatest.assert_not_nil(itemscount, "board:fill didn't fill")
	lunatest.assert_gt(0,itemscount,  "board:fill didn't fill")

	newboard:clear()
	lunatest.assert_not_equal(itemscount, #newboard.matrix,"board:clear didn't fill correctly")
end

function test_boardManipulateItems()
	newboard = board.new({model={1,1,2,1},col=2,types={{type=1},{type=2}}, tileWidth=30,tileHeight=30})	
	newboard:fill()
	lunatest.assert_not_nil(newboard.matrix, "newboard.matrix not setted properlly.")
	lunatest.assert_table(newboard.matrix, "newboard.matrix not setted properlly.")
	lunatest.assert_equal(4, #newboard.matrix, "newboard.matrix not setted properlly.")

	local item1 = newboard:getItemAtIndex(4)
	lunatest.assert_not_nil(item1, "getItemAtIndex fail")
	lunatest.assert_equal(1,item1.type,"item type not correctly")

	newboard:addItem({type=3})

	local item3 = newboard:getItemAtIndex(4)
	lunatest.assert_not_nil(item3, "addItem fail")
	lunatest.assert_equal(3,item3.type,"item type not correctly")

	local item4 = newboard:getItemAtIndex(2)
	lunatest.assert_not_nil(item4, "getItemAtIndex fail")
	lunatest.assert_equal(1,item4.type,"item type not correctly")

	newboard:moveFromIndexToIndex(4,2)

	local item5 = newboard:getItemAtIndex(2)
	lunatest.assert_not_nil(item5, "moveFromIndexToIndex fail")
	lunatest.assert_equal(3, item5.type,"item type not correctly")

	local item6 = newboard:getItemAtIndex(4)
	lunatest.assert_nil(item6.type, "moveFromIndexToIndex fail")

	newboard:swapFromIndexToIndex(4,1)

	local item7 = newboard:getItemAtIndex(1)
	lunatest.assert_nil(item7.type, "swapFromIndexToIndex fail")

	local item8 = newboard:getItemAtIndex(4)
	lunatest.assert_not_nil(item8, "swapFromIndexToIndex fail")
	lunatest.assert_equal(1, item8.type,"item type not correctly")

end
