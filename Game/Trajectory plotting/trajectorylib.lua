module(..., package.seeall)
 
 
--[[ references ]]--
 
-- The code in this listing was derived from this first URL:
-- http://hyperphysics.phy-astr.gsu.edu/hbase/traj.html
-- http://en.wikipedia.org/wiki/Trajectory_of_a_projectile
 
 
--[[ support functions ]]--
 
local function vxf( velocity, acceleration )
        return velocity * math.cos( acceleration * math.pi / 180 )
end
 
local function vyt( velocity, acceleration, time )
        return velocity * math.sin( acceleration * math.pi / 180 ) - 9.8 * time
end
 
local function yt( velocity, acceleration, time )
        return velocity * math.sin( acceleration * math.pi / 180 ) * time - 0.5 * 9.8 * time * time
end
 
 
--[[ worker functions ]]--
 
function totalRangeHeightFlightTime( v, ag )
        local h = vyt(v, ag, 0) * vyt(v, ag, 0) / (2 * 9.8)
        local t = 2 * vyt(v, ag, 0) / 9.8
        local r = v * v * math.sin( 2 * ag * math.pi / 180 ) / 9.8
        return r, h, t
end
 
function positionAtTime(v, ag, t)
        local vx = vxf(v,ag) -- horizontal velocity
        local x = vx * t -- horizontal distance
        local vy = vyt(v, ag, t) -- vertical velocity
        local y = yt(v, ag, t) -- height at time 't'
        
        return x, y, vx, vy
end
 
 
--[[ calculate trajectories ]]--
 
-- returns a collection of points determined as the trajectory of the object
function calcTrajectoryPoints( startX, startY, velocity, angle, iteration, flightmultiple )
        if (not iteration) then
                iteration = 0.1
        end
        
        local r, h, f = totalRangeHeightFlightTime(velocity, angle) -- total range, height and flight time
        local points = {}
        
        for t=0, f*flightmultiple, iteration do
                local x, y, vx, vy = positionAtTime(velocity, angle, t)
                points[ #points+1 ] = { x=x, y=y, time=t, velocityx=vx, velocityy=vy }
        end
        
        return points, r, h, f
end
 
-- http://answers.yahoo.com/question/index?qid=20080617223556AA8DD8M
function calcInitialVelocity( startX, startY, angle, force )
        return force * math.cos(angle), force * math.sin(angle)
end
 
 
--[[ area functions ]]--
 
function calcAreaOfCircle( radius )
        return math.pi * radius * radius
end