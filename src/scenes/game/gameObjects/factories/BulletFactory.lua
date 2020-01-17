local class = require("manada.libs.middleclass")

local Factory = class("BulletFactory")

local PhysicsComponent  = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")

function Factory:initialize()
end

function Factory:create(params)
    local visual = display.newCircle(params.owner:getParent(), params.x, params.y, 10)

    local bullet = manada.GameObject:new({ visual = visual })
    bullet:setComponent("physics", PhysicsComponent, { bodyType = "dynamic", params = { density = 0.1, friction = 0.0, bounce = 0.2 } })

    bullet:getVisual().isBullet = true
    bullet:getVisual().isSensor = true
    bullet:setRotation(params.owner:getRotation())
    
    local vector = manada.math:vectorFromAngle(params.owner:getRotation())
    local speed = 2000

    local dt = manada.time:delta()
    local xForce = vector.x * speed * dt
    local yForce = vector.y * speed * dt

    bullet:getVisual():applyForce(xForce, yForce, bullet:getX(), bullet:getY())
    return bullet
end

return Factory