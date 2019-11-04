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

    self._group:addEventListener("touch", function (event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus( self._group, event.id )
            self._group.isFocus = true
            self._group.markX = self._group.x
            self._group.markY = self._group.y
          elseif self._group.isFocus then
            if event.phase == "moved" then
                self._group.x = event.x - event.xStart + self._group.markX
                self._group.y = event.y - event.yStart + self._group.markY
            elseif event.phase == "ended" or event.phase == "cancelled" then
              display.getCurrentStage():setFocus( self._group, nil )
              self._group.isFocus = false
            end
          end
          return true
    end)

end

function Map:getCells()
    return self._cells
end

function Map:getGroup()
    return self._group
end



return Map