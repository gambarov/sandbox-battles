local class = require("manada.libs.middleclass")

local Handler = class("NPCSpawnHandler")

local ceil = math.ceil

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

function Handler:handle(event)
    -- Спавн объекта при отпускании пальца
    if event.phase == "ended" then

        local map = manada:getActiveMap()
        local i, j = ceil(event.y / map:getCellSize()), ceil(event.x / map:getCellSize())
        local cell = map:getCell(i, j)
        
        if cell and cell.type and cell.type == "free" then
            local size = manada:getActiveMap():getCellSize()
            return manada:addGameObject(self._spawnFactory, { parent = manada:getActiveMap():getDisplayGroup(), x = event.x, y = event.y, width = size, height = size })
        end
    end
end

return Handler
