local class = require('cartel-framework.exts.middleclass')

local MapGenerator = class('MapGenerator')

function MapGenerator:initialize(params)

    params = params or {}
    self._width = params.width or 10
    self._height = params.height or 10
    self._cellSize = params.cellSize or 32

    self._cellsGroup = display.newGroup()
    self._cells = {}

    for y = 1, self._height do

        self._cells[y] = {}

        for x = 1, self._width do

            self._cells[y][x] = 0

            print(self._cellSize * x, self._cellSize * y)
            local rect = display.newRect(self._cellsGroup, self._cellSize * x, self._cellSize * y, self._cellSize, self._cellSize)
            rect:setFillColor(0.5)
            self._cells[y][x] = { object = rect, type = "floor" }

        end

    end

end

return MapGenerator