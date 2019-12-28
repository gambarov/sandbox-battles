local class = require( "manada.libs.middleclass" )

local Component = class( "Component" )

local physics = require( "physics" )

Component.requires = { "display" }

function Component:initialize( containerObject, params )

    params = params or {}

    self._containerObject = containerObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    physics.addBody(self._containerObject:get( "display" ):getObject(), self._bodyType, self._params)

end

function Component:update()
end

function Component:destroy()

    physics.removeBody(self._containerObject:get( "display" ):getObject())
    self._containerObjectt = nil

end

return Component