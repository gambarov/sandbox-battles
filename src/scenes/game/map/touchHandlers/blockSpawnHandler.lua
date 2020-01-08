local class = require("manada.libs.middleclass")

local Handler = class("CharacterSpawnHandler")

local ceil = math.ceil

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

local function convertToCellPosition(x, y)
    local cellSize = manada:getActiveMap():getCellSize()
    local mx, my = x / cellSize, y / cellSize
    mx, my = ceil(mx), ceil(my)
    x, y = (mx * cellSize) - (cellSize / 2), (my * cellSize) - (cellSize / 2)
    return x, y
end 

function Handler:handle(event)

    local map = manada:getActiveMap()
    local parent = map:getDisplayGroup()
    local x, y = parent:contentToLocal(event.x, event.y)

    -- Спавн объекта при отпускании пальца
    if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart and x > 0 and y > 0 and x < parent.width and y < parent.height then
        -- Получение клетки в массиве
        local i, j = ceil(y / map:getCellSize()), ceil(x / map:getCellSize())
        local cell = map:getCell(i, j)
        -- Преобразуем коорднаты точки касания в точные коорднаты клетки, которую коснулись
        x, y = convertToCellPosition(x, y)
        
        -- Если клетка не занята, то спавним блок и занимаем клетку
        if cell and cell.type and cell.type == "open" then
            map:setCell(i, j, { type = "barrier" })
            manada:addGameObject(self._spawnFactory, { parent = manada:getActiveMap():getDisplayGroup(), x = x, y = y, width = 128, height = 128 })
        end

        return true
    end
end

return Handler