local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

Component.requires = { "display" }

function Component:initialize(gameObject, params)
    self._gameObject = gameObject
    self._visual = gameObject:getDisplayObject()

    self._weapon = display.newRect(self._visual.parent, self._visual.x, self._visual.y, 145, 25)
    self._weapon.anchorX, self._weapon.anchorY = 0, 0
    self._visual:addEventListener("attack", self)
end

function Component:update()
    -- Оружие всегда находится с владельцем
    self._weapon.x, self._weapon.y = self._visual.x, self._visual.y
    self._weapon.rotation = self._visual.rotation
end

function Component:attack()
    -- Спавн сняряда
    print("Game Object attacked!")
end

function Component:destroy()
    self._gameObject:getDisplayObject():removeEventListener("attack", self)
    self._gameObject = nil
end

return Component