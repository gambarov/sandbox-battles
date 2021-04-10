local class = require( "manada.libs.middleclass" )

local Map = class( "Map" )

local ceil = math.ceil

Map.GeneratorsDir = "src.scenes.game.map.generators."
Map.TouchHandlersDir = "src.scenes.game.map.touchHandlers."

function Map:initialize( params )

    params = params or {}

    self._width = params.width
    self._height = params.height
    self._cellSize = params.cellSize
    self._group = params.group
    self._maxNPCCount = (params.width * params.height) / 2

    local generator = require(Map.GeneratorsDir .. params.generator)
    self._cells = generator:go(params)
end

function Map:setTouchHandler(type, name, params)
    -- Удаляем предыдущий обработчик
    self:removeTouchHandler()
    -- Обработчик нажатия по полю
    local handler = manada:getMapTouchHandler(type, name):new(params)

    self._touchHandler = function(event) 
        -- Из глобальных координат в локальные
        local x, y = self._group:contentToLocal(event.x, event.y)
        local line, column = ceil(y / self:getCellSize()), ceil(x / self:getCellSize())
        local cell = self:getCell(line, column)

        -- Обработчик нажатия по карте
        if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart and x > 0 and y > 0 and x < self._group.width and y < self._group.height then
            return handler:handle({ map = self, cell = cell, x = x, y = y, line = line, column = column }) 
        end
    end

    self._group:addEventListener("touch", self._touchHandler)
end

function Map:removeTouchHandler()
    if self._touchHandler then
        self._group:removeEventListener("touch", self._touchHandler)
    end
    self._touchHandler = nil
end

function Map:getMaxNPCCount()
    return self._maxNPCCount
end

function Map:getCells()
    return self._cells
end

function Map:getCell(x, y)
    if self:getCells()[x] then 
        return self._cells[x][y]
    end
end

function Map:setCell(x, y, params)
    -- Пытаемся получить клетку
    local cell = self:getCell(x, y)

    if cell then
        for k, v in pairs(params) do
            cell[k] = v
        end

        self._cells[x][y] = cell
    end
end

function Map:getDisplayGroup()
    return self._group
end

function Map:getCellSize()
    return self._cellSize
end

function Map:toCellPos(x, y)

    if not x or not y then
        return false
    end 

    local mx, my = x / self._cellSize, y / self._cellSize
    mx, my = ceil(mx), ceil(my)
    x, y = (mx * self._cellSize) - (self._cellSize / 2), (my * self._cellSize) - (self._cellSize / 2)
    return x, y
end

function Map:destroy()
    self:removeTouchHandler()

    for i = 1, self._width do
        for j = 1, self._height do
            self._cells[i][j]:destroy()
            self._cells[i][j] = nil
        end
    end

    self._cells = nil
end

return Map