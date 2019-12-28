local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

Component.requires = { "display" }

function Component:initialize( containerObject, params )

    params = params or {}
    self._containerObject = containerObject
    
end

function Component:update()

    if self._containerObject:get( "display" ):getObject() then
        self._containerObject:get( "display" ):getObject():setLinearVelocity( 10 * manada.time:delta(), 10 * manada.time:delta() )
    end

end

function Component:destroy()

    self._containerObject = nil

end

return Component