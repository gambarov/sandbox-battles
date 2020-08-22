local class = require("manada.libs.middleclass")

local Component = class("Component")

local physics = require("physics")

Component.requires = { "stats" }

function Component:initialize(gameObject, params)
 
    self._gameObject = gameObject
    self._bodyType = params.bodyType or "dynamic"
    self._params = params.params or { density = 1.0, friction = 0.0, bounce = 0.2 }

    self._currentRotation = gameObject:getRotation() + 90   -- Угол, на который нужно повернуть объект
    self._turnRate = 3                                      -- Скорость вращения

    if gameObject:getVisual() then
        physics.addBody(gameObject:getVisual(), self._bodyType, self._params)
        gameObject:getVisual().isFixedRotation = true
    end

    gameObject:addEventListener("updatePhysics", self)
end

function Component:update(dt)
    self:_updateRotation()
    --self:_updateMovement()

    if self._gameObject:getComponent("stats"):get("health") <= 0 then
        self._gameObject:destroy()
    end
end

function Component:updatePhysics(event)
    self._currentRotation = event.currentRotation or self._currentRotation
    self._turnRate = event.turnRate or self._turnRate
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
            x = object:getX() - vector.x, 
            y = object:getY() - vector.y 
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
    self._gameObject:removeEventListener("updatePhysics", self)
    physics.removeBody(self._gameObject:getVisual())
    self._gameObject = nil
end

return Component