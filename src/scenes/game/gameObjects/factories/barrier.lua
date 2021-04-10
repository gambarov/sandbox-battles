local class = require("manada.libs.middleclass")

local Factory = class("BarrierFactory")

function Factory:initialize(params)
end

function Factory:create(params)
    -- Создаем новый игровой объект
    local sheet = manada.isheet:get("gameObjects")

    local barrier = display.newImage(params.group, sheet.image, sheet.info:getFrameIndex("BlockBox1"), params.x, params.y)
    barrier.width, barrier.height = params.width, params.height

    local gameObject = manada.GameObject:new({ parentGroup = params.group, visual = barrier, type = "barrier" })
    gameObject:setComponent("physics", manada:getComponent("general", "physics"), params.physics)
    return gameObject
end

return Factory