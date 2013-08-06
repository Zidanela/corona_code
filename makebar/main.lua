function add(targ,obj,name,msg)
    if msg~=nil then print("> add/insert "..msg) end
    targ:insert(obj)
    targ[name]=obj
    end
function makeLoaderBar(w,h)
--    print("@ makeLoaderBar: w="..w..", h="..h..".")
    local sider = 1
    local g = display.newGroup() -- the main container for the loader object
    local bg = display.newRect(0,0,w,h) -- the background  bar
        bg:setFillColor(230,230,230)
        bg:setStrokeColor(140, 140, 140)
        bg.strokeWidth = 1
    local loader = display.newRect(0,0,w-(sider*2),h-(sider*2)) -- loader bar
        loader:setFillColor(147,189,227)
        loader:setStrokeColor(140, 140, 140)
        loader.strokeWidth = 1
-- // here comes the TRICK (see the description)
        loader:setReferencePoint(display.TopLeftReferencePoint) 
        loader.x = sider
        loader.y = sider
    add(g,bg,"bg")
    add(g,loader,"loader")
    sider = nil -- purge the vars to make Garbage Collector happy
    return g -- returning the loader object, ready as it's best
end
local TheLoader = makeLoaderBar(200,30)

TheLoader["loader"].width = 20 -- just a dumb number as the width of the bar
TheLoader["loader"].width = (TheLoader["bg"].width/100)*50 -- setting it to 50%.

