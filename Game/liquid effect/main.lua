-------------------------------------------------------------------
--
--      Copyright 2011 Emilio Aguirre, All Rights Reserved.
--  www.emilioaguirre.com
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- This is a demo of a liquid simulation. 
-- Touch the screen to see the gravity changes, the liquid will go 
-- in the opposite direction.
-- 
-------------------------------------------------------------------
local physics = require("physics")
 
-- Define variables
local imgBuffer = {}            -- Image buffer
local w1= math.floor(display.contentWidth)
local h1= math.floor(display.contentHeight)
local refreshImage                      -- Flag to handle when to draw
local line={}                           -- Lines table
 
-- Start Physics
physics.start()
 
-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- Create background rect
local bg = display.newRect( 0, 0, 320, 480 )
bg:setFillColor( 0, 127, 255)           
 
-- Create the border to prevent the liquid to fall
borderCollisionFilter = { categoryBits = 1, maskBits = 6 } -- collides with (4 & 2) only
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
-------------------------------------------------------------------
-- Create 200 balls that will serve as the liquid elements
-------------------------------------------------------------------
local balls = {}
local ballsCollisionFilter = { categoryBits = 2, maskBits = 3 } -- collides with (2 & 1) only
local ballsBody = { density=1000, friction=0.0, bounce=0.1, radius=6, filter=ballsCollisionFilter }
 
local function spawn()
        ballsBody.radius=math.random(3,6)
        balls[#balls+1] = display.newCircle(160, 200,ballsBody.radius)
        balls[#balls]:setFillColor(0,0,100,200) -- To make the balls transparent add 0 as the fourth element.
        balls[#balls].myName = "ball"
        physics.addBody( balls[#balls], ballsBody )
end
local tm =  timer.performWithDelay(40, spawn,200)
 
-------------------------------------------------------------------
-- Draw a set of lines (like flood fill) depending if the pixel in
-- the image buffer is greater than a threshold. 
-------------------------------------------------------------------
function fill(img,w,h,y1,y2)
        local threshold = 22    -- Threshold (best results from 18 to 30)
        local st = 0                    -- Flag to indicate if a start has being found
        local x1,y1                     -- Start line
        local x2,y2                     -- End line
        local step = 1                  -- Step greater than 1 will lead to fast rendering
        local yw 
        local idx
        local startY, endY
        startY = y1 or 0
        endY = y2 or (h - 1)
        -- Traverse the rows of the image buffer
        for y=startY,endY,step do
                st = 0
                yw = y*w
                -- Traverse the columns of the image buffer
            for x=0,w-1,step do
                        idx = yw+x+1
                -- if item exist and is greater than threshold
                if img[idx] and img[idx]>threshold then
                                -- There is no start yet                                
                                if st == 0 then
                                        st = 1
                                        -- Now we have a start
                                        x1,y1 = x,y
                                        x2,y2 = x,y
                                else
                                        -- Grow then end of line with the current pixel
                                        x1,y1 = x,y
                                end             
                        else
                                -- Do we have a line?
                                if st == 1 then
                                        -- Yes draw it.
                                        line[#line+1] = display.newLine(x1,y1,x2,y2)
                                        line[#line].width = step 
                                        line[#line]:setColor( 0, 0, 100, 127 ) -- semi-transparent
                                        -- Clear the flag
                                        st = 0
                                end
                        end                
            end
            -- Check if a missing line needs to be drawn
            if st == 1 then
                        line[#line+1] = display.newLine(x1,y1,x2,y2)
                        line[#line].width = step 
                        line[#line]:setColor( 0, 0, 100, 127 ) -- semi-transparent
                end
        end
end             
 
-------------------------------------------------------------------
-- Draw a circle mask inside a image buffer
-------------------------------------------------------------------
local mask = {
0,0,0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0,0,0,
0,0,0,0,0,2,4,6,7,8,8,7,6,4,2,0,0,0,0,0,
0,0,0,0,4,6,9,11,12,13,13,12,11,9,6,4,0,0,0,0,
0,0,0,4,8,11,13,16,17,18,18,17,16,13,11,8,4,0,0,0,
0,0,4,8,11,15,18,20,22,23,23,22,20,18,15,11,8,4,0,0,
0,2,6,11,15,19,22,25,27,28,28,27,25,22,19,15,11,6,2,0,
0,4,9,13,18,22,26,29,32,33,33,32,29,26,22,18,13,9,4,0,
1,6,11,16,20,25,29,33,36,38,38,36,33,29,25,20,16,11,6,1,
2,7,12,17,22,27,32,36,40,43,43,40,36,32,27,22,17,12,7,2,
2,8,13,18,23,28,33,38,43,47,47,43,38,33,28,23,18,13,8,2,
2,8,13,18,23,28,33,38,43,47,47,43,38,33,28,23,18,13,8,2,
2,7,12,17,22,27,32,36,40,43,43,40,36,32,27,22,17,12,7,2,
1,6,11,16,20,25,29,33,36,38,38,36,33,29,25,20,16,11,6,1,
0,4,9,13,18,22,26,29,32,33,33,32,29,26,22,18,13,9,4,0,
0,2,6,11,15,19,22,25,27,28,28,27,25,22,19,15,11,6,2,0,
0,0,4,8,11,15,18,20,22,23,23,22,20,18,15,11,8,4,0,0,
0,0,0,4,8,11,13,16,17,18,18,17,16,13,11,8,4,0,0,0,
0,0,0,0,4,6,9,11,12,13,13,12,11,9,6,4,0,0,0,0,
0,0,0,0,0,2,4,6,7,8,8,7,6,4,2,0,0,0,0,0,
0,0,0,0,0,0,0,1,2,2,2,2,1,0,0,0,0,0,0,0
}
-------------------------------------------------------------------
-- Draw a mask circle over the image buffer
--
-- pix  - image buffer
-- w    - width of the image buffer 
-- h    - height of the image buffer
-------------------------------------------------------------------
function drawCircle(pix,w,h)
        local y,x,ny,nx,index,maskIdx,y9,nyw
        local ox        -- x of the physical object
        local oy        -- y of the physical object
        local floor = math.floor
        local minY=h
        local maxY=0
        for i = 1,#balls do
                ox = floor(balls[i].x)
                oy = floor(balls[i].y)
                if oy+10>maxY then maxY = oy+10 end
                if oy-9<minY then minY = oy-9 end
                for y=-9,10 do
                        y9 =(y+9)*20
                        ny = y+oy
                        nyw = ny*w
                        for x=-9,10 do
                                nx = x+ox
                                if (nx>0 and nx<=w and ny>0 and ny<=h) then
                                        index   = nyw+nx+1
                                        maskIdx = y9+x+10
                                        if pix[index] then
                                                pix[index] = (pix[index] + mask[maskIdx])
                                        else
                                                pix[index] = mask[maskIdx]
                                        end
                                end
                        end
                end
        end
        -- Just draw lines from range [minY,maxY], so in worst case it
        -- will draw all screen.
        return math.max(0,minY),math.min(maxY,h)
end
 
-------------------------------------------------------------------
-- Callback to frame 
-------------------------------------------------------------------
local onFrameUpdate = function( event )
 
        -- Redraw only if a collision has been detected
        if refreshImage == 1 then
                -- Clear the buffer image
                imgBuffer={}
                -- Remove all lines from display
                for _,v in pairs(line) do
                        v.parent:remove( v )
                end
                line={}
                -- Draw in the buffer some dots corresponding to the same position
                -- of the physical objects 
                local y1,y2 = drawCircle(imgBuffer,w1,h1)
        
                -- Fill the objects in the display according to the objects in the 
                -- image buffer.
                fill(imgBuffer,w1,h1,y1,y2)
                
                -- Reset the flag 
                refreshImage = 0
        end
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