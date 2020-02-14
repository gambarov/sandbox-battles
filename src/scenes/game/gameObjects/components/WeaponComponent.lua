local class = require("manada.libs.middleclass")

local Component = class("WeaponComponent")

local bulletFactory = require("src.scenes.game.gameObjects.factories.BulletFactory")

Component.requires = { }

function Component:initialize(gameObject, params)
    -- Лист с изображениями оружий
    local sheet = manada.isheet:get("gameObjects")
    -- Получаем необходимое
    local visual = display.newImage(gameObject:getParent(), sheet.image, sheet.info:getFrameIndex("AK47"))
    visual.xScale, visual.yScale = gameObject:getVisual().xScale, gameObject:getVisual().yScale
    -- Игровой объект оружия
    self._weapon = manada.GameObject:new({ visual = visual, gameObject:getPosition() })
    self._weapon:setAnchor(0.275, 0)
    -- Событие атаки владельца
    gameObject:addEventListener("attack", self) 
    -- Запоминаем владельца
    self._owner = gameObject
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