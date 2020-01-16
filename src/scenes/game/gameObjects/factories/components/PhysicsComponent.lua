local class = require( "manada.libs.middleclass" )

local Component = class( "Component" )

local physics = require( "physics" )

Component.requires = { }

function Component:initialize( gameObject, params )

    self._gameObject = gameObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    physics.addBody(self._gameObject:getVisual(), self._bodyType, self._params)
    self._gameObject:getVisual().isFixedRotation = true
    -- self._gameObject:getDisplayObject().isSleepingAllowed = false
end

function Component:update(dt)
end

function Component:destroy()

    if self._gameObject:getVisual() then
        physics.removeBody(self._gameObject:getVisual())
    end
    
    self._gameObjectt = nil
end

return Component