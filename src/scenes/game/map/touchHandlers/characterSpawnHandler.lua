local class = require("manada.libs.middleclass")

local Handler = class("CharacterSpawnHandler")

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

function Handler:handle(event)

    local parent = manada:getActiveMap():getDisplayGroup()
    local x, y = parent:contentToLocal(event.x, event.y)

    -- Спавн объекта при отпускании пальца
    if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart and x > 0 and y > 0 and x < parent.width and y < parent.height then
        return manada:addGameObject(self._spawnFactory, { parent = manada:getActiveMap():getDisplayGroup(), x = x, y = y, width = 128, height = 128 })
    end
end

return Handler
