local class = require("manada.libs.middleclass")

local Factory = class("TestGOFactory")

local PhysicsComponent  = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")
local AIComponent       = require("src.scenes.game.gameObjects.factories.components.input.AIComponent")
local DisplayComponent  = require("src.scenes.game.gameObjects.factories.components.DisplayComponent")

function Factory:initialize(params)
end

function Factory:create(params)
    local gameObject = manada.GameObject:new()
    gameObject:setComponent("display", DisplayComponent, { displayObject = display.newRect(params.parent, params.x, params.y, params.width, params.height) })
    gameObject:setComponent("physics", PhysicsComponent)
    gameObject:setComponent("input", AIComponent)
    return gameObject
end

return Factory