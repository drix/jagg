-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com
-- 04 Jun 2014

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------

module(..., package.seeall)

local gem = nil
local newgem = nil

function suite_setup()
	gem = require("core.gem")
end

function suite_teardown()
	gem = nil
end

function teardown()
	newgem:remove()
	newgem = nil
end

function test_newgem()
	newgem = gem.new()	
	lunatest.assert_not_nil(newgem, "cound not load core.newgem (is nil).")
	--check properties
	lunatest.assert_equal(false, newgem.isFocus,  "property should be false")
	lunatest.assert_equal(false, newgem.isFixed, "property should be false")
	lunatest.assert_equal(false, newgem.isPassthrough, "property should be false")
	lunatest.assert_number(newgem.height, "property should be number")
	lunatest.assert_number(newgem.width, "property should be number")
	lunatest.assert_not_nil(newgem.type, "property type should not be nil")
end

function test_gemDraw()
	newgem = gem.new()
	lunatest.assert_nil(newgem.sprite, "property type should be nil")
	newgem:draw()
	lunatest.assert_not_nil(newgem.sprite, "property type should not be nil")
end

function test_gemRemove()
	newgem = gem.new()
	lunatest.assert_nil(newgem.sprite, "property type should be nil")
	newgem:draw()
	lunatest.assert_not_nil(newgem.sprite.parent, "property type should not be nil")
	newgem:remove()
	lunatest.assert_nil(newgem.sprite.parent, "property type should be nil")
end
