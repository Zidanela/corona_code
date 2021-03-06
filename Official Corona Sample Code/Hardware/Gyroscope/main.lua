-- Abstract: Gyroscope sample
--
-- Date: June 15, 2011
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: 
-- 		Demonstrates use of the gyroscope.
--		Displays gyroscope values on screen and moves objected based on values.
--
-- File dependencies: none
--
-- Target devices: iPhone and Android
--
-- Limitations: Gyroscope doesn't work on Simulator
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


-- Hide the status bar.
display.setStatusBar(display.HiddenStatusBar)

-- Draw X and Y axes.
xAxis = display.newLine(0, display.contentHeight / 2, display.contentWidth, display.contentHeight / 2)
xAxis:setColor( 0, 255, 255, 128 )
yAxis = display.newLine(display.contentWidth / 2, 0, display.contentWidth / 2, display.contentHeight)
yAxis:setColor( 0, 255, 255, 128 )

-- Displays App title
title = display.newText( "Gyroscope", 0, 20, "Verdana-Bold", 20 )
title.x = display.contentWidth / 2
title:setTextColor( 255, 255, 0 )

-- Notify the user if the device does not have a gyroscope.
if not system.hasEventSource("gyroscope") then
	msg = display.newText( "Gyroscope sensor not found!", 0, 55, "Verdana-Bold", 13 )
	msg.x = display.contentWidth / 2
	msg:setTextColor( 255, 0, 0 )
end


-----------------------------------------------------------
-- Create Text and Display Objects
-----------------------------------------------------------

-- Text parameters
local labelx = 50
local x = 220
local y = 95
local fontSize = 24

local frameUpdate = false					-- used to update our Text Color (once per frame)

local xHeaderLabel = display.newText( "x rotation = ", labelx, y, native.systemFont, fontSize ) 
xHeaderLabel:setTextColor(255,255,255)
local xValueLabel = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
xValueLabel:setTextColor(255,255,255)
y = y + 25
local yHeaderLabel = display.newText( "y rotation = ", labelx, y, native.systemFont, fontSize ) 
local yValueLabel = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
yHeaderLabel:setTextColor(255,255,255)
yValueLabel:setTextColor(255,255,255)
y = y + 25
local zHeaderLabel = display.newText( "z rotation = ", labelx, y, native.systemFont, fontSize ) 
local zValueLabel = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
zHeaderLabel:setTextColor(255,255,255)
zValueLabel:setTextColor(255,255,255)

-- Create an object that moves with gyroscope events.
local centerX = display.contentWidth / 2
local centerY = display.contentHeight / 2
target = display.newImage("target.png", true)
target.x = centerX
target.y = centerY


-----------------------------------------------------------
-- textMessage() --
-----------------------------------------------------------
-- v1.0
--
-- Create a message that is displayed for a few seconds.
-- Text is centered horizontally on the screen.
--
-- Enter:	str = text string
--			scrTime = time (in seconds) message stays on screen (0 = forever) -- defaults to 3 seconds
--			location = placement on the screen: "Top", "Middle", "Bottom" or number (y)
--			size = font size (defaults to 24)
--			color = font color (table) (defaults to white)
--
-- Returns:	text object (for removing or hiding later)
--
local textMessage = function( str, location, scrTime, size, color, font )

	local x, t
	
	size = tonumber(size) or 24
	color = color or {255, 255, 255}
	font = font or "Helvetica"

	-- Determine where to position the text on the screen
	if "string" == type(location) then
		if "Top" == location then
			x = display.contentHeight/4
		elseif "Bottom" == location then
			x = (display.contentHeight/4)*3
		else
			-- Assume middle location
			x = display.contentHeight/2
		end
	else
		-- Assume it's a number -- default to Middle if not
		x = tonumber(location) or display.contentHeight/2
	end
	
	scrTime = (tonumber(scrTime) or 3) * 1000		-- default to 3 seconds (3000) if no time given

	t = display.newText(str, 0, 0, font, size )
	t.x = display.contentWidth/2
	t.y = x
	t:setTextColor( color[1], color[2], color[3] )
	
	-- Time of 0 = keeps on screen forever (unless removed by calling routine)
	--
	if scrTime ~= 0 then
	
		-- Function called after screen delay to fade out and remove text message object
		local textMsgTimerEnd = function()
			transition.to( t, {time = 500, alpha = 0}, 
				function() t.removeSelf() end )
		end
	
		-- Keep the message on the screen for the specified time delay
		timer.performWithDelay( scrTime, textMsgTimerEnd )
	end
	
	return t		-- return our text object in case it's needed
	
end	-- textMessage()
-----------------------------------------------------------


-----------------------------------------------------------
-- Hardware Events
-----------------------------------------------------------

-- Display the Gyroscope Values
-- Update the text color once a frame based on sign of the value
local function xyzFormat( obj, value )

	obj.text = string.format( "%1.3f", value )
	
	-- Exit if not time to update text color
	if not frameUpdate then return end
	
	if value < 0.0 then
		-- Only update the text color if the value has changed
		if obj.positive ~= false then 
			obj:setTextColor( 255, 0, 0 )      -- red if negative
			obj.positive = false
			print("[---]")
		end
	else

		if obj.positive ~= true then 
			obj:setTextColor( 255, 255, 255)   -- white if postive
			obj.positive = true
			print("+++")
		end

	end
end


-- Called when a gyroscope measurement has been received.
local function onGyroscopeUpdate( event )

	-- Format and display the measurement values.
	xyzFormat(xValueLabel, event.xRotation)
	xyzFormat(yValueLabel, event.yRotation)
	xyzFormat(zValueLabel, event.zRotation)
	
	-- Move our object based on the measurement values.
	local nextX = target.x + event.yRotation
	local nextY = target.y + event.xRotation
	if nextX < 0 then
		nextX = 0
	elseif nextX > display.contentWidth then
		nextX = display.contentWidth
	end
	if nextY < 0 then
		nextY = 0
	elseif nextY > display.contentHeight then
		nextY = display.contentHeight
	end
	target.x = nextX
	target.y = nextY

	-- Rotate the object based based on the degrees rotated around the z-axis.
	local deltaRadians = event.zRotation * event.deltaTime
	local deltaDegrees = deltaRadians * (180 / math.pi)
	target:rotate(deltaDegrees)
end


-- Add gyroscope listeners, but only if the device has a gyroscope.
if system.hasEventSource("gyroscope") then
	Runtime:addEventListener("gyroscope", onGyroscopeUpdate)
end
