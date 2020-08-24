local class = require("manada.libs.middleclass")

local Component = class("AIControlComponent")

function Component:initialize(gameObject, params)

    params = params or {}
    self.gameObject = gameObject
end

function Component:update(dt)
    -- Имеется текущий противник
    if self.enemy then
        -- Если противник уничтожен или не находится в зоне видимости
        if self.enemy:isDestroyed() or not self:isInSight(self.enemy) then
            self.gameObject:dispatchEvent("updateWeapon", { phase = "stop" })
            self.enemy = nil
            return
        end
        
        local rotation = manada.math:angleBetweenVectors(self.gameObject:getPosition(), self.enemy:getPosition())
        local range = self.gameObject:getComponent("stats"):get("weapon").range
        local dist = manada.math:distanceBetween(self.gameObject:getPosition(), self.enemy:getPosition())
        local speedRate = 0
        -- Расстояние до врага больше дальности оружия
        if dist > range then
            speedRate = 1
        -- Противник приблизился слишком близко
        elseif dist < (range / 2) then
            speedRate = -0.75
        -- Расстояние до врага
        else
            speedRate = 0
        end

        self.gameObject:dispatchEvent("updatePhysics", { currentRotation = rotation, turnRate = 8, speedRate = speedRate })
        self.gameObject:dispatchEvent("updateWeapon", { phase = "start" })

    -- Свободное передвижение и поиск противника
    else
        self.gameObject:dispatchEvent("updatePhysics", { currentRotation = self.gameObject:getRotation() + 90 + manada.random:range(-2, 2), turnRate = 5, speedRate = 1 })
        self:scanForEnemy()
    end
end

function Component:isAlly(npc)
    -- Если объект не типа НПС
    if not npc or npc:getType() ~= "npc" then return true end
    -- Получаем союзников
    local allies = manada:getGameData("characters")[self.gameObject:getName()].allies

    for i = 1, #allies do
        if npc:getName() == allies[i] then
            return true
        end
    end

    return false
end

function Component:isInSight(object)
    if not object or object:isDestroyed() then
        return false
    end

    local hits = physics.rayCast(self.gameObject:getX(), self.gameObject:getY(), object:getX(), object:getY(), "sorted")

    for i = 1, #hits do
        if hits[i].object.gameObject then
            local gameObject = hits[i].object.gameObject
            -- Если между нами и объектом преграда, то он не находится в зоне видимости
            if gameObject:getType() == "barrier" then return false
            -- Объект найден и на пути не повстречался барьер
            elseif gameObject == object then return true end
        end
    end

    return false
end

function Component:scanForEnemy()

    local owner = self.gameObject
    local npcs = manada:getGameObjectsByType("npc")
    local minDist = math.max(display.pixelWidth, display.pixelHeight) * 2
    local enemy = nil

    for i = 1, #npcs do
        local npc = npcs[i]
        -- Если не союзник и в зоне видимости
        if not self:isAlly(npc) and self:isInSight(npc) then
            -- Поиск ближайшего из противников
            local dist = manada.math:distanceBetween(owner:getPosition(), npc:getPosition())
            if minDist > dist then
                minDist = dist
                enemy = npc
            end
        end
    end

    self.enemy = enemy
end

function Component:destroy()
    self.gameObject = nil
end

return Component