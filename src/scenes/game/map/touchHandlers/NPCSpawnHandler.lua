local class = require("manada.libs.middleclass")

local Handler = class("NPCSpawnHandler")

local ceil = math.ceil

function Handler:initialize(params)
    self._factory = params.factory
end

function Handler:handle(touch)

    local map = manada:getActiveMap()
    local i, j = ceil(touch.y / map:getCellSize()), ceil(touch.x / map:getCellSize())
    local cell = map:getCell(i, j)
        
    if cell and cell.type and cell.type == "free" then

        self._factory.params.x = touch.x
        self._factory.params.y = touch.y
        self._factory.params.parent = manada:getActiveMap():getDisplayGroup()

        return manada:addGameObject(self._factory.instance:create(self._factory.params))
    end
end

return Handler
