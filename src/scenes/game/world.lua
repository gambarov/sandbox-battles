local class = require( "manada.libs.middleclass" )

local World = class("World")

World._gameObjects = {}

function World:initializea(params)
end

function World:update(dt)
    -- Обновление/удаление игровых объектов
    for i = #self._gameObjects, 1, -1 do
        if self._gameObjects[i]:destroyed() then
            self._gameObjects[i] = nil
        else
            self._gameObjects:update(dt)
        end
    end
end

return World