local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

function Component:initialize( containerObject, params )

    params = params or {}

    assert(containerObject:get( "visual" ), "Physics component required visual component from container object")

    self._containerObject = containerObject
    
end

function Component:update()

    if self._containerObject:get( "visual" ):getVisual() then
        self._containerObject:get( "visual" ):getVisual():setLinearVelocity( 10 * manada.time:delta(), 10 * manada.time:delta() )
    end

end

function Component:destroy()

    self._containerObject = nil

end

return Component