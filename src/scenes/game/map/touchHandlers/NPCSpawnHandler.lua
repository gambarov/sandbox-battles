local class = require("manada.libs.middleclass")

local Handler = class("NPCSpawnHandler")

local ceil = math.ceil

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

function Handler:handle(touch)

    local map = manada:getActiveMap()
    local i, j = ceil(touch.y / map:getCellSize()), ceil(touch.x / map:getCellSize())
    local cell = map:getCell(i, j)
        
    if cell and cell.type and cell.type == "free" then

        local size = manada:getActiveMap():getCellSize()

        return manada:addGameObject(self._spawnFactory, 
        { 
            parent = manada:getActiveMap():getDisplayGroup(), 
            x = touch.x, 
            y = touch.y, 
            width = size, 
            height = size 
        })
    end
end

return Handler
