local class = require( "manada.libs.middleclass" )

-- Объявление класса
local Core = class( "Core" )

local remove = table.remove

Core.plugins = {}

function Core:initialize( params )

    params = params or {}
    params.systems = params.systems or {}   -- Параметры пользователя для систем

    self._systems = {}
    self._gameObjects = {}

	local loadSystem = function( name )
		self[ name ] = require( "manada.systems." .. name ):new( params.systems[ name ] or {} )
		self._systems[ #self._systems + 1 ] = self[ name ]
    end

    -- Загрузка всех систем
    loadSystem( "debug"    )
    loadSystem( "utils"    )
    loadSystem( "file"     )
    loadSystem( "sound"    )
    loadSystem( "time"     )
    loadSystem( "plugin"   )
    loadSystem( "isheet"   )
    loadSystem( "services" )
    loadSystem( "random"   )
    loadSystem( "camera"   )
    loadSystem( "data"     )
    loadSystem( "math"     )
    loadSystem( "timer"    )

    self.Map = require( "manada.Map" )
    self.GameObject = require( "manada.GameObject" )

    Runtime:addEventListener("enterFrame", self)
end

function Core:enterFrame(event)

    self.time:update(event)
    self.debug:update(event)
    self.camera:update(self.time:delta())

    for i = #self._gameObjects, 1, -1 do
        local gameObject = self._gameObjects[i] 

        if gameObject and gameObject["update"] then
            if gameObject:isDestroyed() then
                remove(self._gameObjects, i)
            elseif not self:isPaused() then
                gameObject:update(self.time:delta())
            end
        else
            remove(self._gameObjects, i)
        end
    end
end

function Core:pause()
    self._isPaused = true

    if physics then physics.pause() end

    local function pauseSystem(system)
        for i = 1, #system do
            local component = system[i]

            if component["pause"] then
                component:pause()
            end
        end
    end

    pauseSystem(self._gameObjects)
    pauseSystem(self._systems)
end

function Core:resume()
    self._isPaused = false

    if physics then physics.start() end

    local function resumeSystem(system)
        for i = 1, #system do
            local component = system[i]

            if component["resume"] then
                component:resume()
            end
        end
    end

    resumeSystem(self._gameObjects)
    resumeSystem(self._systems)
end

function Core:setGameMap(map)
    if self._gameMap then
        self._gameMap:destroy()
    end
    self._gameMap = map
end

function Core:getGameMap()
    return self._gameMap
end

function Core:addGameObject(gameObject)
    -- Попытка добавить не объект GameObject
    if not gameObject or not gameObject["getVisual"] then
        print("WARNING: manada.Core:addGameObject(): " .. "Attempt to add non-GameObject object (" .. type(gameObject) .. ")") 
        return false
    end

    self._gameObjects[#self._gameObjects + 1] = gameObject
    return gameObject
end

function Core:addGameObjects(gameObjects)
    -- Попытка добавить не таблицу
    if not type(gameObjects) == "table" then
        print("WARNING: manada.Core:addGameObjects(): " .. "Attempt to add non-GameObject objects to GameObject array (" .. type(gameObjects) .. ")")
        return false
    end

    for i = 1, #gameObjects do
        self:addGameObject(gameObjects[i])
    end

    return gameObjects
end

function Core:getGameObjects()
    return self._gameObjects
end

function Core:getGameObjectsByName(name)
    local gameObjects = {}

    for i = 1, #self._gameObjects, 1 do
        if self._gameObjects[i]:getName() == name then
            gameObjects[#gameObjects+1] = self._gameObjects[i]
        end
    end

    return gameObjects
end

function Core:getGameObjectsByType(type)
    local gameObjects = {}

    for i = 1, #self._gameObjects, 1 do
        if self._gameObjects[i]:getType() == type then
            gameObjects[#gameObjects+1] = self._gameObjects[i]
        end
    end

    return gameObjects
end

function Core:getGameObjectByID(id)
    for i = 1, #self._gameObjects do
        if self._gameObjects[i]:getID() == id then
            return self._gameObjects[i]
        end
    end

    return false
end

function Core:destroyAllGameObjects()
    for i = 1, #self._gameObjects do
        self._gameObjects[i]:destroy()
    end
end

function Core:togglePause()
    if self:isPaused() then
        self:resume()
    else
        self:pause()
    end
end

function Core:isPaused()
    return self._isPaused
end

return 
{
    initialize = function ( self, params )
        manada = Core:new( params )
        manada.data:load()
    end
}