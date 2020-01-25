local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

local bulletFactory = require("src.scenes.game.gameObjects.factories.BulletFactory")

Component.requires = { }

function Component:initialize(gameObject, params)
    self._owner = gameObject

    local sheet = manada.isheet:get("gameObjects")

    self._weapon = manada.GameObject:new({ visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex("AK47"), self._owner:getPosition()) })
    self._weapon:setAnchor(0.275, 0)
    gameObject:addEventListener("attack", self) 
end

function Component:update()
    -- Оружие всегда находится с владельцем
    self._weapon:setPosition(self._owner:getPosition())
    self._weapon:setRotation(self._owner:getRotation() - 2)
end

function Component:attack()
    -- Спавн сняряда
    manada:addGameObject(bulletFactory, { owner = self._weapon, x = self._owner:getX(), y = self._owner:getY() })
end

function Component:destroy()
    self._owner:removeEventListener("attack", self)
    self._owner = nil

    self._weapon:destroy()
    self._weapon = nil
end

return Component