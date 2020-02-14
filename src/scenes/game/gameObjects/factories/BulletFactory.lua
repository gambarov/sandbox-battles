local class = require("manada.libs.middleclass")

local Factory = class("BulletFactory")

function Factory:initialize()
end

function Factory:create(params)
    -- Создаем объект пули
    local bullet = manada.GameObject:new(
    { 
        visual = display.newRect(params.owner:getParent(), params.x, params.y, 12.5, 12.5),
        name = "bullet"
    })
    bullet:setComponent("physics", manada:getComponent("PhysicsComponent"), { bodyType = "dynamic", params = { density = 0.1 } })

    bullet:getVisual().isBullet = true
    bullet:getVisual().isSensor = true
    bullet:getVisual():setFillColor(1, 1, 0)
    
    local vector = manada.math:vectorFromAngle(params.owner:getRotation())
    local shift = { x = (25 * vector.y), y = (25 * vector.x) }

    -- Сдвиг пули к оружию
    bullet:setPosition(bullet:getX() - shift.x, bullet:getY() + shift.y)
    -- Еще один сдвиг поближе к дулу оружия
    bullet:setPosition(bullet:getX() + (vector.x * params.owner:getWidth() / 1.5), bullet:getY() + (vector.y * params.owner:getWidth() / 1.5))
    bullet:setRotation(params.owner:getRotation())

    local speed = 2000
    bullet:getVisual():applyForce(vector.x * speed, vector.y * speed, bullet:getPosition())

    local function onCollision(event)    
        -- body
        local object = event.other.gameObject

        if object and object:getName() == "barrier" then
            -- Удаление объекта при столновении с препятсвием
            bullet:removeEventListener("collision", onCollision)
            bullet:destroy()
            bullet = nil
        end
    end
    bullet:addEventListener("collision", onCollision)
    return bullet
end

return Factory