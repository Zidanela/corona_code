-- simple draggable fan demo 2
 
display.setStatusBar(display.HiddenStatusBar)
 
-- load libraries
require("mathlib")
require("physics")
 
-- setup world
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")
 
-- create floor for things to land on
local ground = display.newRect( 0, display.contentHeight-100, display.contentWidth, 100 )
ground:setFillColor( 0,255,0 )
physics.addBody( ground, "static", { friction=1, bounce=.1, density=1 } )
 
-- put all objects into this group to make them get affected by the fan
local affected = display.newGroup()
 
-- create objects to be affected by the fan
local crate = display.newRect( affected, 0,0,100,100 )
crate.x, crate.y = display.contentCenterX, display.contentCenterY
crate:setFillColor( 0,0,255 )
physics.addBody( crate, "dynamic", { friction=1, bounce=.3, density=1 } )
 
-- fan properties
local fan = nil -- the fan object (when the touch exists)
local power = 100 -- power (range) of the fan
local pulse = 250 -- milliseconds between fan applyForce pulses
local pulsetimer = nil -- while touch exists, this it the transition timer (cancelled when touch ends)
 
-- display the fan power (radius)
local pwr = display.newText( power, 0, 0, "Default", 100 )
pwr.x, pwr.y = 300, 50
 
local pls = display.newText( pulse, 0, 0, "Default", 100 )
pls:setTextColor( 0,0,255 )
pls.x, pls.y = display.contentWidth - 300, 50
 
-- increases fan power
local upbtn = display.newGroup()
upbtn.rect = display.newRect( upbtn, 0, 0, 100, 100 )
upbtn.rect:setFillColor( 0,255,0 )
upbtn.rect.x, upbtn.rect.y = 0, 0
upbtn.txt = display.newText( upbtn, "+", 0, 0, "Default", 100 )
upbtn.txt.x, upbtn.txt.y = 0, 0
upbtn.x, upbtn.y = 50, 50
 
function upbtn:tap( event )
        power = power + 5
        pwr.text = tostring(power)
        return true
end
upbtn:addEventListener( "tap", upbtn )
 
-- decreases fan power
local downbtn = display.newGroup()
downbtn.rect = display.newRect( downbtn, 0, 0, 100, 100 )
downbtn.rect:setFillColor( 255,0,0 )
downbtn.rect.x, downbtn.rect.y = 0, 0
downbtn.txt = display.newText( downbtn, "-", 0, 0, "Default", 100 )
downbtn.txt.x, downbtn.txt.y = 0, 0
downbtn.x, downbtn.y = 150, 50
 
function downbtn:tap( event )
        if (power > 5) then
                power = power - 5
        end
        pwr.text = tostring(power)
        return true
end
downbtn:addEventListener( "tap", downbtn )
 
-- increase pulse rate
local raisebtn = display.newGroup()
raisebtn.rect = display.newRect( raisebtn, 0, 0, 100, 100 )
raisebtn.rect:setFillColor( 0,255,0 )
raisebtn.rect.x, raisebtn.rect.y = 0, 0
raisebtn.txt = display.newText( raisebtn, "+", 0, 0, "Default", 100 )
raisebtn.txt.x, raisebtn.txt.y = 0, 0
raisebtn.x, raisebtn.y = display.contentWidth - 150, 50
 
function raisebtn:tap( event )
        pulse = pulse + 10
        pls.text = tostring(pulse)
        return true
end
raisebtn:addEventListener( "tap", raisebtn )
 
-- decreases pulse rate
local lowerbtn = display.newGroup()
lowerbtn.rect = display.newRect( lowerbtn, 0, 0, 100, 100 )
lowerbtn.rect:setFillColor( 255,0,0 )
lowerbtn.rect.x, lowerbtn.rect.y = 0, 0
lowerbtn.txt = display.newText( lowerbtn, "-", 0, 0, "Default", 100 )
lowerbtn.txt.x, lowerbtn.txt.y = 0, 0
lowerbtn.x, lowerbtn.y = display.contentWidth - 50, 50
 
function lowerbtn:tap( event )
        if (pulse > 10) then
                pulse = pulse - 10
        end
        pls.text = tostring(pulse)
        return true
end
lowerbtn:addEventListener( "tap", lowerbtn )
 
-- applies the fan's power using applyForce
-- we pulse the power so we don't need to use an enterFrame event
function doPowerPulse( event )
        fan.alpha = 0.5
        pulsetimer = transition.to( fan, { time=pulse, alpha=0, onComplete=doPowerPulse } )
 
        -- the actual push provided by the fan against the crate
        for i=1, affected.numChildren do
                local obj = affected[i]
                local dist = lengthOf( fan, obj )
                -- only apply the fan's force if the centre of the object is within the fan's range
                -- because the centres of the object and the fan is measured here, it is not necessary to make the fan a sensor
                if (power - dist > 0) then
                        local force = power - dist
                        local x, y = obj.x-fan.x, obj.y-fan.y
                        obj:applyForce( x*force, y*force, obj.x, obj.y )
                end
        end
end
 
-- create the fan when the touch starts, keep pulsing the applyForce until it ends
-- moves the fan around on 'moved' events
function touch( event )
        if (event.phase == "began") then
                fan = display.newCircle( event.x, event.y, power )
                doPowerPulse()
        elseif (event.phase == "moved") then
                fan.x, fan.y = event.x, event.y
        else
                if (pulsetimer) then
                        transition.cancel( pulsetimer )
                end
                pulsetimer = nil
                fan:removeSelf()
                fan = nil
        end
end
Runtime:addEventListener( "touch", touch )

