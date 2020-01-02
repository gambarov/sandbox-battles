local class = require("manada.libs.middleclass")

local GameObjectController = class("GameObjectController")

function GameObjectController:initialize(params)
    self._gameObjects = {}
end

function GameObjectController:addGameObject(factory, params)
    self._gameObjects[#self._gameObjects + 1] = factory:create(params)
end

return GameObjectController