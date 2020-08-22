local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

Component.requires = { }

function Component:initialize(gameObject, params)

    for k, v in pairs(params) do
        self["_" .. k] = v
    end

    local sheet = manada.isheet:get("weapons")
    local visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex(self._name))

    self._owner = gameObject                         

    self._weapon = manada.GameObject:new({ visual = visual, name = self._name, type = "weapon", gameObject:getPosition() })
    self._weapon:setAnchor(0, 0)
    
    gameObject:addEventListener("startAttack", self) -- События атаки владельца
    gameObject:addEventListener("stopAttack",  self)

    self:update()
end

function Component:update()
    self._weapon:setPosition(self._owner:getPosition())
    self._weapon:setRotation(self._owner:getRotation())
end

function Component:startAttack(params)
    -- Если объект уже атакует
    if self._timer then return end

    local weaponData = manada:getGameData("weapons")[self._name]

    self._timer = timer.performWithDelay(weaponData.rate, function()
        manada:getFactory("bullet"):create({ npc = self._owner, weapon = self._weapon, x = self._owner:getX(), y = self._owner:getY() })
    end, -1)
end

function Component:stopAttack()
    if self._timer then
        timer.cancel(self._timer)
        self._timer = nil
    end
end

function Component:pause()
    self:stopAttack()
end

function Component:getOwner()
    return self._owner
end

function Component:destroy()
    self:stopAttack()
    self._owner:removeEventListener("startAttack", self)
    self._owner:removeEventListener("stopAttack", self)
    self._owner = nil

    self._weapon:destroy()
    self._weapon = nil
end

return Component