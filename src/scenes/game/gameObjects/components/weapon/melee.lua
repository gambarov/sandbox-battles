local class = require("manada.libs.middleclass")

local Component = class("MeleeWeaponComponent")

function Component:initialize(gameObject, params)

    for k, v in pairs(params) do
        self["" .. k] = v
    end

    local visual = nil

    local sheet = manada.isheet:get("weapons")
    local frameIndex = sheet.info:getFrameIndex(self.name)    
    
    if frameIndex then
        visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex(self.name))
    end

    self.owner = gameObject

    self.weapon = manada.GameObject:new({ visual = visual, name = self.name, type = "weapon", gameObject:getX(), gameObject:getY() })
    self.weapon:setAnchor(0, 0)
    
    gameObject:getComponent("stats"):set("weapon", manada:getGameData("weapons")[self.name])

    gameObject:addEventListener("onWeaponUpdate", self)

    self:update()
end

function Component:update()
end

function Component:destroy()
end

return Component