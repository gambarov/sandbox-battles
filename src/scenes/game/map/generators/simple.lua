local class = require("manada.libs.middleclass")

local Generator = class("SimpleMapGenerator")

function Generator:initialize(params)
end

function Generator:go(params)

    local cells = {}

    local sheet = manada.isheet:get("gameObjects")

    for i = 1, params.width do

        cells[i] = {}

        for j = 1, params.height do

            local rect = display.newImage(params.parent, sheet.image, 
            sheet.info:getFrameIndex("GroundTile" .. manada.random:range(1, 2) .. "A"),
            params.cellSize * j - params.cellSize / 2, 
            params.cellSize * i - params.cellSize / 2)
            rect.width, rect.height = params.cellSize, params.cellSize
            cells[i][j] = { object = rect, type = "open" }
        end
    end

    sheet = nil
    
    return cells
end

return Generator