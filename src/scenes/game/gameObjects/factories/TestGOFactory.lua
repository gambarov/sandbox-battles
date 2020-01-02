local class = require("manada.libs.middleclass")

local Factory = class("TestGOFactory")

local PhysicsComponent          = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")
local PlayerControlComponent    = require("src.scenes.game.gameObjects.factories.components.input.PlayerInputComponent")
local DisplayComponent          = require("src.scenes.game.gameObjects.factories.components.DisplayComponent")

function Factory:initialize(params)
end

function Factory:create(params)
    local gameObject = manada.GameObject:new()
    gameObject:setComponent("display", DisplayComponent, { displayObject = params.displayObject  })
    gameObject:setComponent("physics", PhysicsComponent)
    gameObject:setComponent("input", PlayerControlComponent)
    return gameObject
end

return Factory