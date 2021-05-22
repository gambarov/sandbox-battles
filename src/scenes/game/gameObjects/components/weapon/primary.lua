local class = require("manada.libs.middleclass")

local Component = class("PrimaryWeaponComponent")

function Component:initialize(gameObject, params)

    for k, v in pairs(params) do
        self["" .. k] = v
    end

    local sheet = manada.isheet:get("weapons")

    self.visual = display.newImage(gameObject:getLocalGroup(), sheet.image, sheet.info:getFrameIndex(self.name))
    self.visual.name = self.name
    self.owner = gameObject                         

    self.visual.anchorX, self.visual.anchorY = 0, 0
    
    gameObject:getComponent("stats"):set("weapon", manada:getGameData("weapons")[self.name])

    gameObject:addEventListener("onWeaponUpdate", self)

    self:update()
end

function Component:update()
    self.visual.x, self.visual.y = self.owner:getX(), self.owner:getY()
    self.visual.rotation = self.owner:getRotation()
end

function Component:onWeaponUpdate(event)
    -- Уникальный ID для таймера
    local timerID = "fireWeapon" .. self.owner:getID()
    local weaponData = manada:getGameData("weapons")[self.name]

    local function createBullet()
        manada:getFactory("bullet"):create({ npc = self.owner, weapon = self.visual, x = self.owner:getX(), y = self.owner:getY() })
    end

    if event.phase == "start" then
        -- Запускаем таймер только один раз
        if not manada.timer:get(timerID) then
            manada.timer:performWithDelay(weaponData.rate, createBullet, -1, timerID)
        end
    elseif event.phase == "pause" then
        manada.timer:pause(timerID)
    elseif event.phase == "resume" then
        manada.timer:resume(timerID)
    elseif event.phase == "stop" or event.phase == "cancel" then
        manada.timer:cancel(timerID)
    end
end

function Component:getOwner()
    return self.owner
end

function Component:getVisual()
    return self.visual
end

function Component:destroy()
    if self.owner:getComponent("stats") then
        self.owner:getComponent("stats"):remove("weapon")
    end

    self:onWeaponUpdate({ phase = "stop" })

    self.owner:removeEventListener("onWeaponUpdate", self)
    self.owner = nil

    self.visual:removeSelf()
    self.visual = nil
end

return Component