local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

Component.requires = { "display" }

function Component:initialize( containerObject, params )

    params = params or {}
    self._containerObject = containerObject
    
end

function Component:update(dt)

    if self._containerObject:get( "display" ) and self._containerObject:get( "display" ):getObject().bodyType then
        self._containerObject:get( "display" ):getObject():setLinearVelocity( 10 * dt, 10 * dt )
    end

end

function Component:destroy()
    self._containerObject = nil
end

return Component