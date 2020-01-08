local class = require("manada.libs.middleclass")

local Factory = class("BarrierFactory")

local PhysicsComponent          = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")
local DisplayComponent          = require("src.scenes.game.gameObjects.factories.components.DisplayComponent")

local ceil = math.ceil

function Factory:initialize(params)
end

function Factory:create(params)
    -- Создаем новый игровой объект
    local gameObject = manada.GameObject:new()
    -- Координаты спавна объекта и размер клетки
    gameObject:setComponent("display", DisplayComponent, { displayObject = display.newRect(params.parent, params.x, params.y, params.width, params.height)  })
    gameObject:setComponent("physics", PhysicsComponent, { bodyType = "static" })
    return gameObject
end

return Factory