local class = require("manada.libs.middleclass")

local Handler = class("BarrierSpawnHandler")

local ceil = math.ceil

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

function Handler:handle(touch)

    local map = manada:getActiveMap()

    -- Получение клетки в массиве
    local i, j = ceil(touch.y / map:getCellSize()), ceil(touch.x / map:getCellSize())
    local cell = map:getCell(i, j)
    -- Преобразуем коорднаты точки касания в точные коорднаты клетки, которую коснулись
    local x, y = map:toCellPos(touch.x, touch.y)
    
    -- Если клетка не занята, то спавним блок и занимаем клетку
    if cell and cell.type and cell.type == "free" then
        map:setCell(i, j, { type = "barrier" })
        self._spawnFactory:create( 
        { 
            parent = map:getDisplayGroup(), 
            x = x, y = y, 
            width = map:getCellSize(), 
            height = map:getCellSize() 
        })
    end

    return true
end

return Handler