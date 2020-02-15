local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

local bulletFactory = require("src.scenes.game.gameObjects.factories.BulletFactory")

Component.requires = { }

function Component:initialize(gameObject, params)

    for k, v in pairs(params) do
        self["_" .. k] = v
    end

    local sheet = manada.isheet:get("weapons")
    local visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex(self._name))

    self._weapon = manada.GameObject:new({ visual = visual, gameObject:getPosition() })
    self._weapon:setAnchor(0.125, 0)
    
    gameObject:addEventListener("attack", self) -- Событие атаки владельца
    self._owner = gameObject                    -- Запоминаем владельца
end

function Component:update()
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