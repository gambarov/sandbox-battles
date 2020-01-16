local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

Component.requires = { }

function Component:initialize(gameObject, params)
    self._owner = gameObject

    self._weapon = manada.GameObject:new({ visual = display.newRect(gameObject:getParent(), gameObject:getX(), gameObject:getY(), 145, 25) })
    self._weapon:setAnchor(0, 0)

    gameObject:getVisual():addEventListener("attack", self)
end

function Component:update()
    -- Оружие всегда находится с владельцем
    self._weapon:setPosition(self._owner:getPosition())
    self._weapon:setRotation(self._owner:getRotation())
end

function Component:attack()
    -- Спавн сняряда
    print("Game Object attacked!")
end

function Component:destroy()
    self._owner:getVisual():removeEventListener("attack", self)
    self._owner = nil

    self._weapon:destroy()
    self._weapon = nil
end

return Component