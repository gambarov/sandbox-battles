local class = require("manada.libs.middleclass")

local Factory = class("NPCFactory")

local PhysicsComponent  = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")
local AIComponent       = require("src.scenes.game.gameObjects.factories.components.input.AIComponent")
local DisplayComponent  = require("src.scenes.game.gameObjects.factories.components.DisplayComponent")

function Factory:initialize(params)
end

function Factory:create(params)
    local gameObject = manada.GameObject:new()
    local sheet      = manada.isheet:get("gameObjects")
    local soldier    = display.newImage(params.parent, sheet.image, sheet.info:getFrameIndex("Soldier"), params.x, params.y)
    local shape      = { -62,-81, 36,-69, 93,-18, 95,36, 22,32, -40,80, -88,29, -100,-43 }

    gameObject:setComponent("display", DisplayComponent, { displayObject = soldier })
    gameObject:setComponent("physics", PhysicsComponent, { bodyType = "dynamic", params = { shape = shape, density = 1.0, friction = 0.0, bounce = 0.2 } })
    gameObject:setComponent("input", AIComponent)

    return gameObject
end

return Factory