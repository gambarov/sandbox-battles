local class = require("manada.libs.middleclass")

local Component = class("AIControlComponent")

local abs = math.abs

function Component:initialize(gameObject, params)

    params = params or {}
    self.gameObject = gameObject

    self.gameObject:addEventListener("collision", self)
end

function Component:update(dt)
    -- Имеется текущий противник
    if self.enemy then
        -- Если противник уничтожен или не находится в зоне видимости
        if self.enemy:isDestroyed() or not self:isInSight(self.enemy) then
            self.gameObject:dispatchEvent("onWeaponUpdate", { phase = "stop" })
            self.enemy = nil
            return
        end
        
        self:attackTo(self.enemy)
    -- Свободное передвижение и поиск противника
    else
        local rotation = self.gameObject:getRotation() + 90
        self.gameObject:dispatchEvent("onPhysicsUpdate", { currentRotation =  rotation + manada.random:range(-10, 10), turnRate = 2, speedRate = 1 })
        self:scanForEnemy()
    end
end

function Component:collision(event)
    local object = event.other.gameObject
    
    if object and not self.enemy then
        if object:getType() == "barrier"  then
            local from = { x = self.gameObject:getX(), y = self.gameObject:getY() }
            local to = { x = object:getX(), y = object:getY() }
            local vector = { x = to.x - from.x, y = to.y - from.y }
            
            local current = manada.math:normaliseAngle(self.gameObject:getRotation() + 90)
            local final = 0

            if abs(vector.x) > abs(vector.y) then
                if vector.x < 0 then
                    if current > -90 then
                        final = 15
                    else
                        final = 165
                    end
                else
                    if current < 90 then
                        final = -15
                    else
                        final = -165
                    end
                end
            else
                if vector.y < 0 then
                    if current < 0 then
                        final = -115
                    else
                        final = 115
                    end
                else
                    if (current < 180) and (current > 90) then
                        final = 75
                    else
                        final = 285
                    end
                end
            end

            self.gameObject:dispatchEvent("onPhysicsUpdate", { delay = 150, currentRotation = final, turnRate = 8 })

        elseif object:getType() == "npc" then
            if manada.random:range(1, 10) > 7 then
                local rotation = self.gameObject:getRotation() + manada.random:range(-135, 135)
                self.gameObject:dispatchEvent("onPhysicsUpdate", { delay = 150, currentRotation = rotation, turnRate = 8 })
            end
        end
    end
    
end

function Component:attackTo(npc)
    
    if not npc then return end

    self.enemy = npc

    local rotation = manada.math:angleBetweenVectors(self.gameObject:getPosition(), self.enemy:getPosition())
    local range = (self.gameObject:getComponent("stats"):get("weapon") or { range = 0 }).range
    local dist = manada.math:distanceBetween(self.gameObject:getPosition(), self.enemy:getPosition())
    local speedRate = 0

    -- Расстояние до врага больше дальности оружия, сближаемся
    if dist > range then
        speedRate = 1
    -- Противник приблизился слишком близко, отступаем
    elseif dist < (range / 2) then
        speedRate = -0.75
    -- Расстояние до врага оптимальное, стоим
    else
        speedRate = 0
    end

    self.gameObject:dispatchEvent("onPhysicsUpdate", { currentRotation = rotation, turnRate = 8, speedRate = speedRate })
    self.gameObject:dispatchEvent("onWeaponUpdate", { phase = "start" })
end

function Component:isAlly(npc)
    -- Если объект не типа НПС
    if not npc or npc:getType() ~= "npc" then return true end
    -- Получаем союзников
    local allies = manada:getGameData("npcs")[self.gameObject:getName()].allies

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

    if hits then
        for i = 1, #hits do
            if hits[i].object.gameObject then
                local gameObject = hits[i].object.gameObject
                -- Если между нами и объектом преграда, то он не находится в зоне видимости
                if gameObject:getType() == "barrier" then return false
                -- Объект найден и на пути не повстречался барьер
                elseif gameObject == object then return true end
            end
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