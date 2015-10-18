-------------------------------------------------------------------------
-- Created by Adriano Spadoni
-- alte_br@hotmail.com

-- CoronaSDK was used for this game.
-------------------------------------------------------------------------
require( "core.utils" )

local testEnabled = true

-- run unittest before run the game
if (testEnabled) then
	require( "main_test" )
	require( "main_game" ) 
else
-- run the game without unittest
	require( "main_game" ) 
end