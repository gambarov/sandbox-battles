local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

Component.requires = { "physics" }

function Component:initialize( gameObject, params )

    params = params or {}
    self._gameObject = gameObject

    timer.performWithDelay(300, 
    function() 
        gameObject:dispatchEvent("attack")
    end, 10)
end

function Component:update(dt)
    local vector = manada.math:vectorFromAngle(self._gameObject:getRotation())
    self._gameObject:rotate(manada.random:range(-10, 10) / manada.random:range(1, 10))
    self._gameObject:getVisual():setLinearVelocity(vector.x * 35, vector.y * 35)
end

function Component:destroy()
    self._gameObject = nil
end

return Component