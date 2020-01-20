local class = require("manada.libs.middleclass")

local Factory = class("BulletFactory")

local PhysicsComponent  = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")

function Factory:initialize()
end

function Factory:create(params)
    -- Создаем объект пули
    local bullet = manada.GameObject:new(
    { 
        visual = display.newRect(params.owner:getParent(), params.x, params.y, 15, 10),
        name = "bullet"
    })
    bullet:setComponent("physics", PhysicsComponent, { bodyType = "dynamic", params = { density = 0 } })

    bullet:getVisual().isBullet = true
    bullet:getVisual().isSensor = true
    bullet:setRotation(params.owner:getRotation())
    
    local vector = manada.math:vectorFromAngle(params.owner:getRotation())
    local speed = 1000

    local xForce = vector.x * speed
    local yForce = vector.y * speed

    bullet:addEventListener("collision", 
    function(event)    
        -- body
        local object = event.other.gameObject

        if object and object:getName() == "barrier" then
            -- Удаляние объекта при столновении с препятсвием
            timer.performWithDelay(10, function() bullet:destroy() bullet = nil end)
        end
    end)

    bullet:getVisual():applyForce(xForce, yForce, bullet:getPosition())
    return bullet
end

return Factory