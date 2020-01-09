local class = require("manada.libs.middleclass")

local Handler = class("BlockSpawnHandler")

local ceil = math.ceil

local function destroyBlockIn(x, y)
    
    local gameObjects = manada:getGameObjects()

    for i = 1, #gameObjects, 1 do

        local object = gameObjects[i]
        local visual = object:getDisplayObject()

        if visual.x == x and visual.y == y then
            object:destroy()
            object = nil
            visual = nil
            return true
        end
    end

    return false
end

function Handler:handle(event)  

    local map = manada:getActiveMap()

    if event.phase == "ended" then
        local i, j = ceil(event.y / map:getCellSize()), ceil(event.x / map:getCellSize())
        local cell = map:getCell(i, j)
        -- Преобразуем коорднаты точки касания в точные коорднаты клетки, которую коснулись
        local x, y = map:toCellPos(event.x, event.y)

        if cell and cell.type and cell.type == "barrier" then
            if destroyBlockIn(x, y) then
                print("block has been removed!")
                map:setCell(i, j, { type = "open" })
            else
                print("can't remove block")
            end
        end

        return true
    end
end

return Handler