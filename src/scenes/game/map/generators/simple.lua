local class = require("manada.libs.middleclass")

local Generator = class("SimpleMapGenerator")

function Generator:initialize(params)
end

function Generator:go(params)

    local cells = {}

    for i = 1, params.width do

        cells[i] = {}

        for j = 1, params.height do

            local rect = display.newRect(params.parent, 
            params.cellSize * j - params.cellSize / 2, 
            params.cellSize * i - params.cellSize / 2, 
            params.cellSize, params.cellSize)
            rect:setFillColor( 0.25, 0.25, 0.25 ) 
            rect:setStrokeColor( 1, 0, 0 )
            rect.strokeWidth = 4
            rect.alpha = 0.75
            cells[i][j] = { object = rect, type = "open" }
        end
    end

    return cells
end

return Generator