local class = require("manada.libs.middleclass")

local Generator = class("SimpleMapGenerator")

local function isEdge(i, j, width, height)
    return ( i == 1 or j == 1 or i == width or j == height )
end

function Generator:initialize(params)
end

function Generator:go(params)

    local cells = {}

    local sheet = manada.isheet:get("gameObjects")

    for i = 1, params.width do

        cells[i] = {}

        for j = 1, params.height do

            local x, y = params.cellSize * j - params.cellSize / 2, params.cellSize * i - params.cellSize / 2
            local rect = display.newImage(params.group, sheet.image, sheet.info:getFrameIndex("GroundTile" .. manada.random:range(1, 2) .. "C"), x, y)
            rect.width, rect.height = params.cellSize, params.cellSize

            cells[i][j] = { rect = rect, type = "free", destroy = function(self) if rect then rect:removeSelf() rect = nil end end }

            -- Спавн стен вокруг карты
            if isEdge(i, j, params.width, params.height) then
                local factoryParams = manada:getGameData("terrains")["Barrier"]
                factoryParams.group = params.group
                factoryParams.x = x factoryParams.y = y
                factoryParams.width, factoryParams.height = params.cellSize, params.cellSize
                local gameObject = manada:getFactory("barrier"):create(factoryParams)
                cells[i][j] = { rect = rect, gameObject = gameObject, type = "wall", 
                destroy = function(self) 
                    if rect then rect:removeSelf() rect = nil end 
                    if gameObject then gameObject:destroy() gameObject = nil end 
                end }
            end
        end
    end

    sheet = nil

    return cells
end

return Generator