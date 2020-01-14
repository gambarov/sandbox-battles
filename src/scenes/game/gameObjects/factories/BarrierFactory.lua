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
    local sheet = manada.isheet:get("gameObjects")

    local barrier = display.newImage(params.parent, sheet.image, sheet.info:getFrameIndex("BlockBox1"), params.x, params.y)
    barrier.width, barrier.height = params.width, params.height

    gameObject:setComponent("display", DisplayComponent, { displayObject = barrier })
    gameObject:setComponent("physics", PhysicsComponent, { bodyType = "static" })

    sheet = nil

    return gameObject
end

return Factory