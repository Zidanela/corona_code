local physics = require("physics")
physics.setDrawMode("hybrid")

local w1= math.floor(display.contentWidth)
local h1= math.floor(display.contentHeight)

-- Start Physics
physics.start()

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Create background rect
local bg = display.newRect( 0, 0, 320, 480 )
bg:setFillColor( 0, 127, 255)           

-- Create the border to prevent the liquid to fall
borderCollisionFilter = { categoryBits = 1, maskBits = 2 } -- collides with 2 only
borderBodyElement = { friction=0.1, bounce=0.1, filter=borderCollisionFilter }

local borderTop = display.newRect( 0, 0, 320, 1 )
borderTop:setFillColor( 0, 0, 0, 0)             
physics.addBody( borderTop, "static", borderBodyElement )

local borderBottom = display.newRect( 0, 479, 320, 1 )
borderBottom:setFillColor( 0, 0, 0, 0)  
physics.addBody( borderBottom, "static", borderBodyElement )

local borderLeft = display.newRect( 0, 1, 1, 480 )
borderLeft:setFillColor( 0, 0, 0, 0)    
physics.addBody( borderLeft, "static", borderBodyElement )

local borderRight = display.newRect( 319, 1, 1, 480 )
borderRight:setFillColor( 0, 0, 0, 0)   
physics.addBody( borderRight, "static", borderBodyElement )

-- Add anoter wall in the middle 
local wall = display.newRect( 60, 350, 140, 20 )
wall:setFillColor( 255, 255, 0)
wall.rotation=45
physics.addBody( wall, "static", borderBodyElement )

wall = display.newRect( 140, 250, 140, 20 )
wall:setFillColor( 255, 255, 0)
wall.rotation=-45
physics.addBody( wall, "static", borderBodyElement )

local onFrameUpdate = function( event ) 
	-- Redraw only if a collision has been detected
	if refreshImage == 1 then               
		-- Reset the flag 
		refreshImage = 0
	end
    drawCircle()
end

-------------------------------------------------------------------
-- Callback to global collision 
-------------------------------------------------------------------
local function onGlobalCollision( event )

	if (event.object1.myName~=nil and event.object2.myName~=nil) then
		-- A collision ended let's refresh the images
		if ( event.phase == "ended") then
			-- Only refresh if at least we have a collision 
			refreshImage = 1
		end
	end

end
-------------------------------------------------------------------
-- Callback to global accelerometer 
-------------------------------------------------------------------
local function onTilt( event )
	physics.setGravity( 10 * event.xGravity, -10 * event.yGravity )
end

-------------------------------------------------------------------
-- Callback to frame 
-------------------------------------------------------------------
local onTouchCallback = function( event )
	physics.setGravity( 0.05 * (event.x - 180), 0.05 * (event.y-240))
end
-------------------------------------------------------------------
-- Create event listeners
-------------------------------------------------------------------
Runtime:addEventListener( "enterFrame", onFrameUpdate )
Runtime:addEventListener( "collision", onGlobalCollision )
Runtime:addEventListener( "accelerometer", onTilt )
Runtime:addEventListener( "touch", onTouchCallback )

local xc = 200
local yc = 200
local r = 40
local pi = math.pi
local mp = 0.7417

local bezier = require('bezier')

function draw(xs, ys)
	local curve1 =  bezier:curve(xs, ys)
	local x1, y1 = curve1(0.0)
    local x2, y2 = curve1(0.01)
	local line1 = display.newLine(x1, y1, x2, y2)
	line1:setColor( 255, 0, 0, 255 )
	line1.width = 1

	for i=0.2, 1, 0.1 do
		local x, y = curve1(i)
		line1:append(x, y)
	end
    return line1
end

local ballsCollisionFilter = { categoryBits = 2, maskBits = 3 } -- collides with (2 & 1) only
local bparams = {friction=.1, bounce=0.5, density=1, radius=2, filter=ballsCollisionFilter}
-- clock wise
local ps = {}
ps[1] = {x=xc+r, y=yc} 
ps[2] = {x=xc+r*mp, y=yc+r*mp}
ps[3] = {x=xc, y=yc+r}
ps[4] = {x=xc-r*mp, y=yc+r*mp}
ps[5] = {x=xc-r, y=yc}
ps[6] = {x=xc-r*mp, y=yc-r*mp}
ps[7] = {x=xc, y=yc-r}
ps[8] = {x=xc+r*mp, y=yc-r*mp}

local segs = {}
function drawCircle()    
    for i, l in pairs(segs) do
        l:removeSelf()
    end
    segs = {}
    for i=1, #ps-1, 2 do
        local l = draw({ps[i].x, ps[i+1].x, ps[i+2].x}, {ps[i].y, ps[i+1].y, ps[i+2].y})
        table.insert(segs, l)
    end
end

for i=1, #ps do
    ps[i] = display.newCircle(ps[i].x, ps[i].y, 1)
    physics.addBody(ps[i], "dynamic", bparams)
end

table.insert(ps, ps[1]) -- set begin point as end point to form a circle

-- for i=1, #ps-1, 2 do
--     for j=i+2, #ps-1, 2 do
--         if j < #ps then
--             local p1 = ps[i]
--             local p2 = ps[j]
--             physics.newJoint("distance", p1, p2, p1.x, p1.y, p2.x, p2.y)
--         end
--     end
-- end

for i=1, #ps-1, 1 do
    for j=i+1, #ps-1, 1 do
        if j < #ps then
            local p1 = ps[i]
            local p2 = ps[j]
            physics.newJoint("distance", p1, p2, p1.x, p1.y, p2.x, p2.y)
        end
    end
end
