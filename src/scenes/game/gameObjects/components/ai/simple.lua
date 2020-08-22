local class = require("manada.libs.middleclass")

local Component = class("AIControlComponent")

Component.requires = {"physics"}

function Component:initialize(gameObject, params)

    params = params or {}
    self._gameObject = gameObject
    self._target = false
end

function Component:update(dt)
    self:_scanForEnemy()
    
    if self._gameObject and self._target then
        
        if self._target:isDestroyed() then
            self._gameObject:dispatchEvent("stopAttack")
            self._target = nil
            return
        end

        local rotation = manada.math:angleBetweenVectors({ x = self._gameObject:getX(), y = self._gameObject:getY() }, { x = self._target:getX(), y = self._target:getY() })
        self._gameObject:dispatchEvent("updatePhysics", { currentRotation = rotation })
        self._gameObject:dispatchEvent("startAttack")
    end
end

function Component:_scanForEnemy()

    local npcs = manada:getGameObjectsByType("npc")
    local allies = manada:getGameData("characters")[self._gameObject:getName()].allies

    for i = 1, #npcs do
        local npc = npcs[i]
        local isAlly = false

        if npc ~= self._gameObject then

            for j = 1, #allies do
                local ally = allies[j]

                if npc:getName() == ally then 
                    -- данный нпс - созник
                    isAlly = true
                end
            end

            if not isAlly then self._target = npc end
        end
    end

    return false
    -- for i = 135,225 do
    --     local vector = manada.math:vectorFromAngle((self._gameObject:getRotation() + i))
    --     local hits = physics.rayCast(
    --         self._gameObject:getX(), 
    --         self._gameObject:getY(), 
    --         self._gameObject:getX() - (vector.x * 500), 
    --         self._gameObject:getY() - (vector.y * 500), "closest")

    --     display.newLine(self._gameObject:getParent(), self._gameObject:getX(), 
    --     self._gameObject:getY(), 
    --     self._gameObject:getX() - (vector.x * 500), 
    --     self._gameObject:getY() - (vector.y * 500))

    --     if hits and hits[1].object.gameObject then
    --         local object = hits[1].object.gameObject
            
    --         if object:getType() == "npc" then
    --             print(here)
    --             local allies = manada:getGameData("characters")[self._gameObject:getName()].allies
    --             print(allies)
    --             for i = 1, #allies do
    --                 print(object:getName(), allies[i])
    --                 if object:getName() == allies[i] then
    --                     print(object:getName() .. " is ally!")
    --                     return
    --                 end
    --             end

    --             self._target = object
    --         end
    --     end
    -- end

end

function Component:destroy()
    self._gameObject = nil
end

return Component