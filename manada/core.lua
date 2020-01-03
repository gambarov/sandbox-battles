-- Created by @jusD3N

local class = require( "manada.libs.middleclass" )

-- Объявление класса
local Core = class( "Core" )

-- Сторонние библиотеки для работы
local visualMonitor = require("manada.libs.visualMonitor")

local remove = table.remove

Core.plugins = {}
Core.Debug = true

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

    self.Map = require( "manada.Map" )
    self.GameObject = require( "manada.GameObject" )
 
    if self.Debug then
        visualMonitor:new()
    end

    display.setStatusBar( display.HiddenStatusBar ) 

    self._gameObjects = {}

    Runtime:addEventListener("enterFrame", self)

end

function Core:enterFrame(event)

    self.time:enterFrame(event)

    for i = #self._gameObjects, 1, -1 do

        if self._gameObjects[i] and self._gameObjects[i]["destroyed"] then

            if self._gameObjects[i]:destroyed() then
                local object = remove(self._gameObjects, i)
                object:destroy()
                object = nil
            else
                self._gameObjects[i]:update(self.time:delta())
            end
            
        end

    end

end

function Core:addGameObject(factory, params)
    self._gameObjects[#self._gameObjects + 1] = factory:create(params)
end

return 
{
    initialize = function ( self, params )
        manada = Core:new( params )
    end
}