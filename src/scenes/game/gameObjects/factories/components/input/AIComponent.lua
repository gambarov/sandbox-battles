local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

Component.requires = { "display" }

function Component:initialize( containerObject, params )

    params = params or {}
    self._containerObject = containerObject
    
end

function Component:update(dt)

    if self._containerObject:hasComponent("display") and self._containerObject:getDisplayObject().bodyType then
        self._containerObject:getDisplayObject():rotate(1 * dt)
    end

end

function Component:destroy()
    self._containerObject = nil
end

return Component