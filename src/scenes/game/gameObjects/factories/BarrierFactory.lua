local class = require("manada.libs.middleclass")

local Factory = class("BarrierFactory")

local PhysicsComponent          = require("src.scenes.game.gameObjects.factories.components.PhysicsComponent")
local DisplayComponent          = require("src.scenes.game.gameObjects.factories.components.DisplayComponent")

local ceil = math.ceil

function Factory:initialize(params)
end

local function allowSpawn(x, y)

    local cellSize = manada:getActiveMap():getCellSize()
    local cell = manada:getActiveMap():getCell(y / cellSize, x / cellSize)

    if not cell or not cell.type or cell.type == "barrier" then
        return false
    end

    return true
end

local function getCellPosition(x, y)
    local cellSize = manada:getActiveMap():getCellSize()
    local mx, my = x / cellSize, y / cellSize
    mx, my = ceil(mx), ceil(my)
    x, y = (mx * cellSize) - (cellSize / 2), (my * cellSize) - (cellSize / 2)
    return x, y
end

function Factory:create(params)

    local gameObject = manada.GameObject:new()
    -- Координаты спавна объекта и размер клетки
    local x, y = getCellPosition(params.displayObject.x, params.displayObject.y)
    params.displayObject.x, params.displayObject.y = x, y
    gameObject:setComponent("display", DisplayComponent, { displayObject = params.displayObject  })

    -- if not allowSpawn(x, y) then
    --     print("Spawn object prohibited")
    --     gameObject:destroy()
    --     gameObject = nil
    --     return false
    -- end

    manada:getActiveMap():setCell( )
    gameObject:setComponent("physics", PhysicsComponent, { bodyType = "static" })
    return gameObject
end

return Factory