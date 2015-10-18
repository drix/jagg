function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end

pcall(require, "luacov")    --measure code coverage, if luacov is present
lunatest = require("vendors.lunatest.lunatest")

-- Boards
lunatest.suite("unittests.board")
lunatest.suite("unittests.boardgame")

-- Game Controlers
lunatest.suite("unittests.gemboard")
lunatest.suite("unittests.gemgame")

-- Items
lunatest.suite("unittests.item")
lunatest.suite("unittests.gem")

print("-------------------------------")
return pcall(lunatest.run)