-- Created by @jusD3N

local class = require( "manada.libs.middleclass" )

-- Объявление класса
local Core = class( "Core" )

local remove = table.remove

Core.plugins = {}

function Core:initialize( params )

    params = params or {}
    params.systems = params.systems or {}

    self._systems = {}

	local loadSystem = function( name )
		self[ name ] = require( "manada.systems." .. name ):new( params.systems[ name ] or {} )
		self._systems[ #self._systems + 1 ] = self[ name ]
    end

    -- Загрузка всех систем
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
    loadSystem( "debug"    )

    self.Map = require( "manada.Map" )
    self.GameObject = require( "manada.GameObject" )

    self._gameObjects = {}
    Runtime:addEventListener("enterFrame", self)
end

function Core:enterFrame(event)

    self.time:update(event)
    self.debug:update(event)
    self.camera:update(self.time:delta())

    for i = #self._gameObjects, 1, -1 do

        local gameObject = self._gameObjects[i] 

        if gameObject and gameObject["update"] and gameObject["destroyed"] then

            if gameObject:destroyed() then
                remove(self._gameObjects, i)
            else
                gameObject:update(self.time:delta())
            end
        else
            remove(self._gameObjects, i)
        end
    end
end

function Core:setActiveMap(map)
    self._activeMap = map
end

function Core:getActiveMap()
    return self._activeMap
end

function Core:addGameObject(factory, params)
    -- Попытка создать объект
    local object = factory:create(params)

    if object then
        self._gameObjects[#self._gameObjects + 1] = object
        return true
    end

    return false
end

function Core:getGameObjects()
    return self._gameObjects
end

return 
{
    initialize = function ( self, params )
        manada = Core:new( params )
    end
}