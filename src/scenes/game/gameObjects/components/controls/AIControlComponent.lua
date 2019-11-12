local class = require( "manada.libs.middleclass" )

local Component = class( "Component" )

function Component:initialize(displayObject, params)

    params = params or {}
    self._displayObject = displayObject
    
end

function Component:update()

    if self._displayObject then
        self._displayObject:setLinearVelocity( 30 * manada.time:delta(), 0 )
    end

end

function Component:destroy()

    self._displayObject = nil

end

return Component