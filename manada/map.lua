local class = require( "manada.libs.middleclass" )

local Map = class( "Map" )

Map.GeneratorsDir = "src.scenes.game.map.generators."

function Map:initialize( params )

    params = params or {}

    self._width = params.width
    self._height = params.height
    self._cellSize = params.cellSize
    self._parent = params.parent

    local generator = require(Map.GeneratorsDir .. params.generator)
    self._cells = generator:go(params)
end

function Map:getCell(x, y)
    if self._cells[x] then 
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

function Map:getCellSize()
    return self._cellSize
end

return Map