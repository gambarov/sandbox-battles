local class = require( "manada.libs.middleclass" )

local Map = class( "Map" )

function Map:initialize( params )

    params = params or {}

    self._width = params.width or 10
    self._height = params.height or 15
    self._cellSize = params.cellSize or 128

    self._cells = {}
    self._group = params.parentGroup or display.newGroup()

    for i = 1, self._width do

        self._cells[i] = {}

        for j = 1, self._height do

            local rect = display.newRect(self._group, self._cellSize * j - self._cellSize / 2, self._cellSize * i - self._cellSize / 2, self._cellSize, self._cellSize)
            rect:setFillColor( 0.25, 0.25, 0.25 ) 
            rect:setStrokeColor( 1, 0, 0 )
            rect.strokeWidth = 4
            rect.alpha = 0.75
            self._cells[i][j] = { rect = rect, type = "floor" }

        end

    end

    self._group = manada.plugin:new( self._group, "draggable" )

end

function Map:getCells()
    return self._cells
end

function Map:getGroup()
    return self._group
end



return Map