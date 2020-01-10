local class = require("manada.libs.middleclass")

local Handler = class("CharacterSpawnHandler")

function Handler:initialize(params)
    self._spawnFactory = params.factory
end

function Handler:handle(event)
    -- Спавн объекта при отпускании пальца
    if event.phase == "ended" then
        local size = manada:getActiveMap():getCellSize()
        return manada:addGameObject(self._spawnFactory, { parent = manada:getActiveMap():getDisplayGroup(), x = event.x, y = event.y, width = size, height = size })
    end
end

return Handler
