local class = require("manada.libs.middleclass")

local Component = class("Component")

local physics = require("physics")

Component.requires = { }

function Component:initialize(gameObject, params)

    self._gameObject = gameObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    self._currentRotation = gameObject:getRotation()
    self._turnRate = 0

    if gameObject:getVisual() then
        physics.addBody(gameObject:getVisual(), self._bodyType, self._params)
        gameObject:getVisual().isFixedRotation = true
    end

    gameObject:addEventListener("updatePhysics", function(event)
        self._currentRotation = event.currentRotation
        self._turnRate = event.turnRate
    end)
end

function Component:update(dt)
    self:_updateRotation()
    self:_updateMovement()
end

function Component:_updateRotation()

    local object = self._gameObject
    local vector = manada.math:vectorFromAngle(self._currentRotation)
    local angle = manada.math:limitedAngleBetweenVectors(
        { 
            x = object:getX(), 
            y = object:getY() 
        }, 
        { 
            x = object:getX() + vector.x, 
            y = object:getY() + vector.y 
        }, 
        object:getRotation(), self._turnRate * manada.time:delta())

    object:setRotation(angle)
end

function Component:_updateMovement()

    local object = self._gameObject
    local vector = manada.math:vectorFromAngle(object:getRotation())
    object:getVisual():setLinearVelocity(vector.x * 100, vector.y * 100)
end

function Component:destroy()
    self._gameObject:removeListener("updatePhysics")

    -- Безопасное удаление физического тела
    if self._gameObject:getState() ~= "destroyed" then
        physics.removeBody(self._gameObject:getVisual())
    end

    self._gameObject = nil
end

return Component