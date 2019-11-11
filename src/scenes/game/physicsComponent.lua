local class = require( "manada.libs.middleclass" )

local Component = class( "Component" )

local physics = require( "physics" )

function Component:initialize(displayObject, params)

    params = params or {}

    self._displayObject = displayObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    physics.addBody(self._displayObject, self._bodyType, self._params)

end

function Component:update()
end

function Component:destroy()

    physics.removeBody(self._displayObject)
    self._displayObject = nil

end

return Component