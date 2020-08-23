local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

Component.requires = { }

function Component:initialize(gameObject, params)

    for k, v in pairs(params) do
        self["" .. k] = v
    end

    local sheet = manada.isheet:get("weapons")
    local visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex(self.name))

    self.owner = gameObject                         

    self.weapon = manada.GameObject:new({ visual = visual, name = self.name, type = "weapon", gameObject:getX(), gameObject:getY() })
    self.weapon:setAnchor(0, 0)
    
    gameObject:addEventListener("startAttack", self) -- События атаки владельца
    gameObject:addEventListener("stopAttack",  self)

    self:update()
end

function Component:update()
    self.weapon:setPosition(self.owner:getX(), self.owner:getY())
    self.weapon:setRotation(self.owner:getRotation())
end

function Component:startAttack(params)
    -- Если объект уже атакует
    if self.timer then return end

    local weaponData = manada:getGameData("weapons")[self.name]

    self.timer = timer.performWithDelay(weaponData.rate, function()
        manada:getFactory("bullet"):create({ npc = self.owner, weapon = self.weapon, x = self.owner:getX(), y = self.owner:getY() })
    end, -1)
end

function Component:stopAttack()
    if self.timer then
        timer.cancel(self.timer)
        self.timer = nil
    end
end

function Component:pause()
    self:stopAttack()
end

function Component:getOwner()
    return self.owner
end

function Component:getWeapon()
    return self.weapon
end

function Component:destroy()
    self:stopAttack()
    self.owner:removeEventListener("startAttack", self)
    self.owner:removeEventListener("stopAttack", self)
    self.owner = nil

    self.weapon:destroy()
    self.weapon = nil
end

return Component