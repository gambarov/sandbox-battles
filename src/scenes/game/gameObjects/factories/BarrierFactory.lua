local class = require("manada.libs.middleclass")

local Factory = class("BarrierFactory")

local PhysicsComponent          = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")
local DisplayComponent          = require("src.scenes.game.gameObjects.factories.components.DisplayComponent")

function Factory:initialize(params)
end

function Factory:create(params)
    local gameObject = manada.GameObject:new()
    gameObject:setComponent("display", DisplayComponent, { displayObject = params.displayObject  })
    gameObject:setComponent("physics", PhysicsComponent, { bodyType = "static" })
    return gameObject
end

return Factory