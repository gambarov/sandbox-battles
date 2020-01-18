local class = require("manada.libs.middleclass")

local Handler = class("CharacterSpawnHandler")

local ceil = math.ceil

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

function Handler:handle(event)

    local map = manada:getActiveMap()

    -- Спавн объекта при отпускании пальца
    if event.phase == "ended" then
        -- Получение клетки в массиве
        local i, j = ceil(event.ySpawn / map:getCellSize()), ceil(event.xSpawn / map:getCellSize())
        local cell = map:getCell(i, j)
        -- Преобразуем коорднаты точки касания в точные коорднаты клетки, которую коснулись
        local x, y = map:toCellPos(event.xSpawn, event.ySpawn)
        
        -- Если клетка не занята, то спавним блок и занимаем клетку
        if cell and cell.type and cell.type == "free" then
            map:setCell(i, j, { type = "barrier" })
            manada:addGameObject(self._spawnFactory, 
            { 
                parent = map:getDisplayGroup(), 
                x = x, y = y, 
                width = map:getCellSize(), 
                height = map:getCellSize() 
            })
        end

        return true
    end
end

return Handler