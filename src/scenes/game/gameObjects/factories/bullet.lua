local class = require("manada.libs.middleclass")

local Factory = class("BulletFactory")

function Factory:initialize()
end

function Factory:create(params)

    local bullets = {}

    local weapon = params.weapon
    local weaponData = manada:getGameData("weapons")[weapon.name]
    local bulletData = manada:getGameData("bullets")[weaponData.bullet]

    for i = 1, weaponData.count do
    
        local bullet = manada.GameObject:new(
        {
            parentGroup = params.npc:getParentGroup(),
            visual = display.newRect(params.x, params.y, bulletData.w, bulletData.h),
            name = bulletData.name,
            type = "bullet"
        })
        bullet:setComponent("physics", manada:getComponent("general", "physics"), bulletData.physics)

        bullet:getVisual().isBullet = true
        bullet:getVisual().isSensor = true
        bullet:getVisual():setFillColor(unpack(bulletData.color))
        bullet:setAnchor(0, 0)
        
        bullet:setRotation(weapon.rotation + manada.random:range(-weaponData.spread, weaponData.spread))
        local vector = manada.math:vectorFromAngle(bullet:getRotation())

        -- Сдвиг пули к оружию
        bullet:setPosition(
            bullet:getX() + (vector.x * weapon.width) - (vector.y * 10), 
            bullet:getY() + (vector.y * weapon.width + (vector.x * 10)))

        bullet:getVisual():applyForce(vector.x * bulletData.speed * manada.time:delta(), vector.y * bulletData.speed * manada.time:delta())

        local function onCollision(event)    
            -- body
            local object = event.other.gameObject
            
            if object and object:getType() == "npc" then
                -- Получаем список союзников текущего владельца (нпс)
                local allies = manada:getGameData("npcs")[params.npc:getName()].allies or {}

                for i = 1, #allies do
                    if object:getName() == allies[i] then
                        return true
                    end
                end

                object:dispatchEvent("onDamage", { value = bulletData.damage })
            end

            bullet:hide()
            bullet:removeEventListener("collision", onCollision)
            -- Удаление с задержкой из-за https://docs.coronalabs.com/api/library/physics/removeBody.html
            timer.performWithDelay(5, function() if bullet then bullet:destroy() bullet = nil end end)
        end

        bullet:addEventListener("collision", onCollision)
        bullets[#bullets+1] = bullet
    end

    return bullets
end

return Factory