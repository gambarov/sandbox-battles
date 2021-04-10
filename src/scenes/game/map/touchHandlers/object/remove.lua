local class = require("manada.libs.middleclass")

local Handler = class("ObjectRemoveHandler")

local ceil = math.ceil

local function destroyObjectIn(touch)
    
    local gameObjects = manada:getGameObjects()

    for i = 1, #gameObjects, 1 do

        local object = gameObjects[i]

        if object:contains(touch) then
            object:destroy()
            object = nil
            return true
        end
    end

    return false
end

function Handler:handle(touch)  

    local map = touch.map

    if map then
        local i, j = ceil(touch.y / map:getCellSize()), ceil(touch.x / map:getCellSize())
        local cell = map:getCell(i, j)

        if cell and cell.type and cell.type ~= "wall" then
            if destroyObjectIn(touch) then
                map:setCell(i, j, { type = "free" })
            end
        end
    end

    return true
end

return Handler