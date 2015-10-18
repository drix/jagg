-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 04 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

module(..., package.seeall)

local item = nil
local newitem = nil

function suite_setup()
	item = require("core.item")
end

function suite_teardown()
	item = nil
end

function teardown()
	newitem:remove()
	newitem = nil
end

function test_newitem()
	newitem = item.new()	
	lunatest.assert_not_nil(newitem, "cound not load core.newitem (is nil).")
	--check properties
	lunatest.assert_equal(false, newitem.isFocus,  "property should be false")
	lunatest.assert_equal(false, newitem.isFixed, "property should be false")
	lunatest.assert_equal(false, newitem.isPassthrough, "property should be false")
	lunatest.assert_number(newitem.height, "property should be number")
	lunatest.assert_number(newitem.width, "property should be number")
	lunatest.assert_not_nil(newitem.type, "property type should not be nil")
end

function test_itemDraw()
	newitem = item.new()
	lunatest.assert_nil(newitem.sprite, "property type should be nil")
	newitem:draw()
	lunatest.assert_not_nil(newitem.sprite, "property type should not be nil")
end

function test_itemRemove()
	newitem = item.new()
	lunatest.assert_nil(newitem.sprite, "property type should be nil")
	newitem:draw()
	lunatest.assert_not_nil(newitem.sprite.parent, "property type should not be nil")
	newitem:remove()
	lunatest.assert_nil(newitem.sprite.parent, "property type should be nil")
end
