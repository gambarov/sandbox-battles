local class = require("manada.libs.middleclass")

local Component = class("Component")

function Component:initialize(gameObject, params)
 
    self.gameObject = gameObject
    self.params = params.params or { density = 0.2, friction = 1, bounce = 0 }

    self.currentRotation = gameObject:getRotation() + 90   -- Угол, на который нужно повернуть объект
    self.turnRate = 0                                      -- Скорость вращения
    self.speedRate = 0

    self.stats = gameObject:getComponent("stats")

    physics.addBody(gameObject:getVisual(), params.bodyType or "dynamic", self.params)
    
    gameObject:getVisual().isFixedRotation = true
    gameObject:addEventListener("updatePhysics", self)
end

function Component:update(dt)
    self:updateRotation()
    self:updateMovement()

    if self.stats:get("health") <= 0 then
        self.gameObject:destroy()
    end
end

function Component:updatePhysics(event)

    local timerID = "updatePhysicsDelay" .. self.gameObject:getID()
    -- Если задержка уже есть, выходим
    if manada.timer:get(timerID) then 
        return 
    -- Добавление задержки для отклонения новых обновлений
    elseif event.delay then
        manada.timer:performWithDelay(event.delay, function() manada.timer:cancel(timerID) end, 1, timerID)
    end
    -- Обновление данных
    for k, v in pairs(event) do
        if self[k] then
            self[k] = v
        end
    end
end

function Component:updateRotation()
    local object = self.gameObject
    local vector = manada.math:vectorFromAngle(self.currentRotation)
    local angle = manada.math:limitedAngleBetweenVectors(
        { x = object:getX(), y = object:getY() }, 
        { x = object:getX() - vector.x, y = object:getY() - vector.y }, 
        object:getRotation(), 
        self.turnRate * manada.time:delta())

    object:setRotation(angle)
end

function Component:updateMovement()
    local vector = manada.math:vectorFromAngle(self.gameObject:getRotation())
    local weaponWeight = (self.stats:get("weapon") or { weight = 0 }).weight
    local moveSpeed = self.stats:get("moveSpeed", "original") - weaponWeight
    self.gameObject:getVisual():setLinearVelocity(vector.x * moveSpeed * self.speedRate, vector.y * moveSpeed * self.speedRate)
end

function Component:destroy()
    self.gameObject:removeEventListener("updatePhysics", self)
    physics.removeBody(self.gameObject:getVisual())
    self.gameObject = nil
    self.stats = nil
    self.params = nil
end

return Component