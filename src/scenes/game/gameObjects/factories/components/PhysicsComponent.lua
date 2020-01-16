local class = require( "manada.libs.middleclass" )

local Component = class( "Component" )

local physics = require( "physics" )

Component.requires = { "display" }

function Component:initialize( gameObject, params )

    self._gameObject = gameObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    physics.addBody(self._gameObject:getDisplayObject(), self._bodyType, self._params)
    self._gameObject:getDisplayObject().isFixedRotation = true
    -- self._gameObject:getDisplayObject().isSleepingAllowed = false
end

function Component:update(dt)
end

function Component:destroy()

    if self._gameObject:hasComponent("display") then
        physics.removeBody(self._gameObject:getDisplayObject())
    end
    
    self._gameObjectt = nil
end

return Component