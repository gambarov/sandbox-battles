local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

function Component:initialize(gameObject, params)

    for k, v in pairs(params) do
        self["" .. k] = v
    end

    local sheet = manada.isheet:get("weapons")
    local visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex(self.name))

    self.owner = gameObject                         

    self.weapon = manada.GameObject:new({ visual = visual, name = self.name, type = "weapon", gameObject:getX(), gameObject:getY() })
    self.weapon:setAnchor(0, 0)
    
    gameObject:getComponent("stats"):set("weapon", manada:getGameData("weapons")[self.name])

    gameObject:addEventListener("updateWeapon", self) -- События атаки владельца

    self:update()
end

function Component:update()
    self.weapon:setPosition(self.owner:getX(), self.owner:getY())
    self.weapon:setRotation(self.owner:getRotation())
end

function Component:updateWeapon(params)

    local timerName = "fireWeapon" .. self.owner:getID()
    local weaponData = manada:getGameData("weapons")[self.name]

    local function bulletCreate()
        manada:getFactory("bullet"):create({ npc = self.owner, weapon = self.weapon, x = self.owner:getX(), y = self.owner:getY() })
    end

    if params.phase == "start" then
        if not manada.timer:get(timerName) then
            manada.timer:performWithDelay(weaponData.rate, bulletCreate, -1, timerName)
        end
    elseif params.phase == "pause" then
        manada.timer:pause(timerName)
    elseif params.phase == "resume" then
        manada.timer:resume(timerName)
    elseif params.phase == "stop" then
        manada.timer:cancel(timerName)
    end
end

function Component:getOwner()
    return self.owner
end

function Component:getWeapon()
    return self.weapon
end

function Component:destroy()
    if self.owner:getComponent("stats") then
        self.owner:getComponent("stats"):remove("weapon")
    end
    self:updateWeapon({ phase = "stop" })
    self.owner:removeEventListener("updateWeapon", self)
    self.owner = nil

    self.weapon:destroy()
    self.weapon = nil
end

return Component