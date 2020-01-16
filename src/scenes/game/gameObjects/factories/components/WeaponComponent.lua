local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

Component.requires = { "display" }

function Component:initialize(gameObject, params)
    self._gameObject = gameObject
    gameObject:getDisplayObject():addEventListener("attack", self)
end

function Component:attack()
    print("Game Object attacked!")
end

function Component:destroy()
    self._gameObject:getDisplayObject():removeEventListener("attack", self)
    self._gameObject = nil
end

return Component