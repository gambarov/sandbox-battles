local class = require("manada.libs.middleclass")

local Component = class("Component")

function Component:initialize(gameObject, params)

    self._gameObject = gameObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    if gameObject:getVisual() then
        physics.addBody(gameObject:getVisual(), self._bodyType, self._params)
        gameObject:getVisual().isFixedRotation = true
    end
end

function Component:update(dt)
end

function Component:destroy()
    physics.removeBody(self._gameObject:getVisual())
    self._gameObject = nil
end

return Component