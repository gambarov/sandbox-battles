local class = require("manada.libs.middleclass")

local Factory = class("BulletFactory")

function Factory:initialize()
end

function Factory:create(params)

    local bullets = {}

    local weaponData = manada:getGameData("weapons")[params.weapon:getName()]
    local bulletData = manada:getGameData("bullets")[weaponData.bullet]

    for i = 1, weaponData.count do
    
        local bullet = manada.GameObject:new(
        { 
            visual = display.newRect(params.weapon:getParent(), params.x, params.y, bulletData.w, bulletData.h),
            name = bulletData.name,
            type = "bullet"
        })
        bullet:setComponent("physics", manada:getComponent("general", "physics"), { bodyType = "dynamic", params = { density = 0.1 } })

        bullet:getVisual().isBullet = true
        bullet:getVisual().isSensor = true
        bullet:getVisual():setFillColor(unpack(bulletData.color))
        bullet:setAnchor(0, 0)
        
        bullet:setRotation(params.weapon:getRotation() + manada.random:range(-weaponData.spread, weaponData.spread))
        local vector = manada.math:vectorFromAngle(bullet:getRotation())

        -- Сдвиг пули к оружию
        bullet:setPosition(bullet:getX() + (vector.x * params.weapon:getWidth()) - (vector.y * 10), bullet:getY() + (vector.y * params.weapon:getWidth() + (vector.x * 10)))

        bullet:getVisual():applyForce(vector.x * bulletData.speed, vector.y * bulletData.speed, bullet:getPosition())

        local function onCollision(event)    
            -- body
            local object = event.other.gameObject

            if object:getType() == "barrier" then
                -- Удаление с задержкой из-за https://docs.coronalabs.com/api/library/physics/removeBody.html
                bullet:removeEventListener("collision", onCollision)
                timer.performWithDelay(5, function() if bullet then bullet:destroy() bullet = nil end end)

            elseif object:getType() == "npc" then
                local allies = manada:getGameData("characters")[params.npc:getName()].allies or {}

                for i = 1, #allies do
                    if object:getName() == allies[i] then
                        return true
                    end
                end

                object:getComponent("stats"):decrease("health", bulletData.damage)
                bullet:setAlpha(0)
                timer.performWithDelay(20, function() if bullet then bullet:destroy() bullet = nil end end)
            end
        end

        bullet:addEventListener("collision", onCollision)
        bullets[#bullets+1] = bullet
    end

    return manada:addGameObjects(bullets)
end

return Factory