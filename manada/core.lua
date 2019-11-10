local class = require( "manada.exts.middleclass" )

local Core = class( "Core" )

Core.plugins = {}

function Core:initialize( params )

    self._systems = {}
    self._plugins = {}

	local loadSystem = function( name )
		self[ name ] = require( "manada.systems." .. name ):new()
		self._systems[ #self._systems + 1 ] = self[ name ]
    end

    local loadPlugin = function( name )
        Core.plugins[ name ] = require( "manada.plugins." .. name)
        self._plugins[ #self._plugins + 1 ] =  Core.plugins[ name ]
    end

    -- Загрузка всех систем, порядок загрузки имеет значение
    loadSystem( "utils" )
    loadSystem( "file"  )
    loadSystem( "sound" )

    -- Загрузка плагинов
    loadPlugin( "draggable" )

    require("manada.exts.visualMonitor"):new()
    display.setStatusBar( display.HiddenStatusBar ) 

end

manada = Core:new()