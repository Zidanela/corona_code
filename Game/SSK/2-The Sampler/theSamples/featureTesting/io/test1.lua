-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #3 - (Nearly) Empty Shell
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables

-- Local Function & Callback Declarations
local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	local data = "Testing io."
	io.writeFile( data, "iotest.txt" )

	local data2 = io.readFile("iotest.txt" )

	print(data)
	print(data2)

	io.appendFile( "\nBogies", "iotest.txt" )
	io.appendFile( "\nBogies", "iotest.txt" )
	io.appendFile( "\nBogies", "iotest.txt" )
	io.appendFile( "\nBogies", "iotest.txt" )

	local data2 = io.readFile("iotest.txt" )
	print(data2)


end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
end


return gameLogic