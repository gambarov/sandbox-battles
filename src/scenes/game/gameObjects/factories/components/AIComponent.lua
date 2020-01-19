local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

Component.requires = { }

function Component:initialize( gameObject, params )

    params = params or {}
    self._gameObject = gameObject

    timer.performWithDelay(300, 
    function() 
        gameObject:dispatchEvent("attack")
    end, 10)
end

function Component:update(dt)
end

function Component:destroy()
    self._gameObject = nil
end

return Component