local class = require( "manada.libs.middleclass" )

local Map = class( "Map" )

function Map:initialize( params )

    params = params or {}

    self._width = params.width or 10
    self._height = params.height or 15
    self._cellSize = params.cellSize or 128

    self._cells = {}
    self._parent = params.parent

    for i = 1, self._width do

        self._cells[i] = {}

        for j = 1, self._height do

            local rect = display.newRect(self._parent, 
            self._cellSize * j - self._cellSize / 2, 
            self._cellSize * i - self._cellSize / 2, 
            self._cellSize, self._cellSize)

            rect:setFillColor( 0.25, 0.25, 0.25 ) 
            rect:setStrokeColor( 1, 0, 0 )
            rect.strokeWidth = 4
            rect.alpha = 0.75
            self._cells[i][j] = { rect = rect, type = "open" }

        end

    end

end

return Map