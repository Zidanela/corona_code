-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Aim At Object Demo
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
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage
local thePlayer
local theSky

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = 320 -- smaller than actual to allow for overlay/frame
local screenHeight = 240 -- smaller than actual to allow for overlay/frame
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createPlayer
local createSky
local createTurret

local onShowHide

local onB

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	createCollisionCalculator()

	-- 2. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 3. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	local shipSize = 30
	local turretSize = 60
		
	theSky = createSky(centerX, centerY, screenWidth, screenHeight )
	thePlayer = createPlayer( centerX, centerY, shipSize, layers.content, theSky )

	local theTurret =	createTurret( centerX - screenWidth/4, screenBot, turretSize, layers.content, theSky )
	local theTurret2 =	createTurret( centerX + screenWidth/4, screenBot, turretSize, layers.content, theSky )

	ssk.component.aimAtObject( theTurret, thePlayer, 100 )
	ssk.component.aimAtObject( theTurret2, thePlayer, 16 )
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	thePlayer = nil
	theSky = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false
end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:dump()
end


createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

function createPlayer( x, y, size, contentLayer, inputObj )
	local player  = ssk.display.imageRect( contentLayer, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size,  },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC }, 
		{ {"mover_moveToTouchFixedRate", {inputObj = inputObj, moveSpeed = 150, easing = easing.linear} }, 
		  {"mover_faceTouchFixedRate", {inputObj = inputObj, aimSpeed = 0, easing = easing.linear} },
		} )
		
	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end

createTurret = function ( x, y, size, contentLayer, inputObj )
	local turret  = ssk.display.imageRect( contentLayer, x, y,imagesDir .. "simpleTurret.png",
		{ size = size,  },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
	return turret
end


onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		event.target:setText( "Hide Details" )
	end	
end


-- Movement/General Button Handlers
onB = function ( event )	
	thePlayer.x,thePlayer.y = centerX, centerY
	thePlayer.rotation = 0
end



return gameLogic