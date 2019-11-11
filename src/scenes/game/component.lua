local class = require( "manada.libs.middleclass" )

local Component = class( "Component" )

function Component:initialize(instance)

    self._instance = instance
    
end

function Component:update()

    
    
end

function Component:destroy()
    self._instance = nil
end

return Component