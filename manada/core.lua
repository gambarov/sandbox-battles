local class = require( "manada.libs.middleclass" )

local Core = class( "Core" )

-- Сторонние библиотеки для работы
local visualMonitor = require("manada.libs.visualMonitor")

Core.plugins = {}

function Core:initialize( params )

    self._systems = {}
    self._plugins = {}

	local loadSystem = function( name )
		self[ name ] = require( "manada.systems." .. name ):new()
		self._systems[ #self._systems + 1 ] = self[ name ]
    end

    local loadPlugin = function( name )
        self.plugins[ name ] = require( "manada.plugins." .. name)
        self._plugins[ #self._plugins + 1 ] =  Core.plugins[ name ]
    end

    -- Загрузка всех систем, порядок загрузки имеет значение
    loadSystem( "utils" )
    loadSystem( "file"  )
    loadSystem( "sound" )

    -- Загрузка плагинов
    loadPlugin( "draggable" )

    visualMonitor:new()
    display.setStatusBar( display.HiddenStatusBar ) 

end

manada = Core:new()`