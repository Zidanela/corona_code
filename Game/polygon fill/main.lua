-- particle room draw
 
-- http://alienryderflex.com/polygon/
-- http://alienryderflex.com/polygon_fill/
 
 
-- turn off status display bar
display.setStatusBar(display.HiddenStatusBar)
 
-- library loading
require("displayex")
require("mathlib")
 
-- groups
local background, fill, outline, dottop = display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup()
 
-- background
display.newRect(background, 0,0,display.contentWidth,display.contentHeight):setFillColor(30,30,60)
 
-- DISPLAY VALUES - change these values to alter the display
-- widthheight: the size of either a filled row (isperpixel=false) or a filled pixel (isperpixel=true)
-- isclosed: true to fill the surrounding area outside the polygon, false to fill the polygon
-- isperpixel: true to fill each pixel on each row separately, false to fill each row in one color (faster)
local widthheight, isclosed, isperpixel = 1, false, false
 
 
local points = {}
 
local dot = nil
 
function dotMove(event)
        dot.x, dot.y = event.x, event.y
 
        -- check for being within the polygon
        if (pointInPolygon( table.listToNamed(points,{'x','y'}), dot )) then
                dot:setFillColor( 0,255,0 )
        else
                dot:setFillColor( 255,0,0 )
        end
end
 
function convert( event )
        Runtime:removeEventListener("tap",tap)
 
        dot = display.newCircle( dottop, event.x, event.y, 20 )
        dot:setFillColor( 0,0,0 )
        Runtime:addEventListener("touch",dotMove)
 
        if (#points >= 6) then
                -- polygonFill( points, closed, perPixel, width, height )
                local p = polygonFill( table.listToNamed(points,{'x','y'}), isclosed, isperpixel, widthheight, widthheight )
                fill:insert(p)
        end
 
        return true
end
 
function drawLines( points )
        if (#points < 4) then return display.newCircle(points[1],points[2],15) end
 
        local group = display.newGroup()
        group.circle = display.newCircle(group,points[1],points[2],15)
        group.circle:addEventListener("tap",convert)
 
        local line = display.newLine( group, points[1], points[2], points[3], points[4] )
 
        if (#points > 4) then
                line:append( unpack( table.copy( table.range( points, 5, #points ), table.range( points, 1, 2 ) ) ) )
        end
 
        line.width = 5
        line.alpha = .5
 
        return group
end
 
function tap(event)
        points[ #points+1 ] = event.x
        points[ #points+1 ] = event.y
 
        if (lines) then
                if (lines.circle) then lines.circle:removeEventListener("tap",convert) end
                lines:removeSelf()
        end
        lines = drawLines( points )
        outline:insert( lines )
 
        return true
end
 
Runtime:addEventListener("tap",tap)

