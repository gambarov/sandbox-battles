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
    self._parent = params.parent

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
        local x, y = self._parent:contentToLocal(event.x, event.y)
    
        -- Обработчик нажатия по карте
        if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart and x > 0 and y > 0 and x < self._parent.width and y < self._parent.height then
            return handler:handle({ x = x, y = y }) 
        end
    end

    self._parent:addEventListener("touch", self._touchHandler)
end

function Map:removeTouchHandler()
    if self._touchHandler then
        self._parent:removeEventListener("touch", self._touchHandler)
    end
    self._touchHandler = nil
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
    return self._parent
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

return Map