-- Created by @jusD3N

local class = require( "manada.libs.middleclass" )

-- Объявление класса
local Core = class( "Core" )

-- Сторонние библиотеки для работы
local visualMonitor = require("manada.libs.visualMonitor")

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

    self.Map = require( "manada.Map" )
    self.GameObject = require( "manada.GameObject" )

    if self.Debug then
        visualMonitor:new()
    end

    display.setStatusBar( display.HiddenStatusBar ) 

end

return 
{
    initialize = function ( self, params )
        manada = Core:new( params )
    end
}