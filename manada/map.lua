local class = require('manada.exts.middleclass')

local Map = class('Map')

function Map:initialize(params)

    params = params or {}

    self._width = params.width or 10
    self._height = params.height or 10
    self._cellSize = params.cellSize or 32

    self._cells = {}
    self._group = display.newGroup()

    for i = 1, self._width do

        self._cells[i] = {}

        for j = 1, self._height do

            local rect = display.newRect(self._group, self._cellSize * j - self._cellSize / 2, self._cellSize * i - self._cellSize / 2, self._cellSize, self._cellSize)
            rect:setFillColor( 1, 1, 0.8 ) 
            rect:setStrokeColor( 1, 0, 0 )
            rect.strokeWidth = 4
            self._cells[i][j] = { rect = rect, type = "floor" }

        end

    end

    self._group = manada.plugins.draggable:new(self._group)

end

function Map:getCells()
    return self._cells
end

function Map:getGroup()
    return self._group
end



return Map